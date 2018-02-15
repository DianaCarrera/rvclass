##  Functions that implement the R-vine classification workflow.
##
##  Created by Diana, Roberto, and Jose Antonio on 08/02/2018.
##

#' R-vine Classification
#'
#' Lunch the R-vine classification workflow
#'
#' @param data a list of four elements: in the first position, it has the data matrices (dataTrain)
#'             for each class; in the second position, the test matrix (dataTest); in the third position,
#'             a list (N_train) with the sample size of each training matrix; and in the fourth position, 
#'             a list (N_test) with the sample size for each class in the test matrix. These matrices 
#'             and vectors must be organized by class from class 1 to \code{nc}.
#' @param n the number of variables (or classification features), i.e., the dimension of the problem.
#' @param prob a vector with the probability of each class.
#' @param vine a vector that specifies the type of vine copula per class.
#' @param copula a vector that specifies the copula families to be fitted in the vine of each class.
#' @param margin a vector that specifies the marginal family of each class.
#' @param tree a vector that specifies the number of trees in the vine of each class.
#' @param k the number of partitions of the k-fold crossvalidation.
#' @param nRuns the number of crossvalidation repetitions.
#' @return \code{predict}, \code{validateModel} A list with two elements: The first, \code{predict}, is 
#'         the confusion matrix with the prediction results in each fold. The second, \code{validateModel}, is 
#'         mean-confusion matrix, which is computed from confusion matrices in code{predict}.
#' @author DC
#'
#' @import copulaedasExtra
#'
#' @import stats
#' @rdname rvClassifier
#' @export rvClassifier  
#' @aliases rvClassifier
rvClassifier <- function(data, prob, n, vine, copula, margin, tree, k, nRuns)
{ 
      models <- rvSpecify(n, vine, margin, tree)
      trainModel <- rvLearn(data[[1]], models, copula)
      precModel <- rvPredict(trainModel,data[[2]], data[[4]], prob)
      evalM <- rvEvaluate(precModel, data[[4]])
      validatM <- rvValidate(data[[1]], n, data[[3]], k, nRuns, models, copula)

      return(list(evalM, validatM))
}


#' Model Specification
#' 
#' Specifies the configuration of the vine
#' 
#' @param n the number of variables.
#' @param vine a vector that specifies the type of vine copula per class. 
#' @param margin a vector that specifies the marginal family of each class.
#' @param tree a vector that specifies the number of trees in the vine of each class.
#' @return \code{vector} a list with the models (a model = vine + margins) that have been specified for each class.
#' @export rvSpecified
#' @aliases rvSpecified
rvSpecify <- function(n, vine, margin, tree)
{
   vector <- list()
   
   for (i in 1:length(vine)){

       n_copulas  <- tree[i]*(2*n-tree[i]-1)/2

       vector[[i]] <- c(n,
       rep(c(margin[i], NA), n),
       vine[i],
       tree[i],
       rep(c(NA, NA), n_copulas)
       ) 
    }  
    return(vector)  
}


#' Model Learning
#' 
#' Learn a vine for each class
#' 
#' @param data a list of matrices with the training set of each class.
#' @param models a list of vectors that specifies the type of vine, of marginal, number of trees that you want 
#'                to learn for each class. The value of models is the value of the rvSpecified function. 
#' @param copula a vector where specifying the copulas to be adjusted for each class.
#' @return \code{mvdvList} a vector that specifies the copula families of each class to be fitted in the 
#'         corresponding vine.
#' @export rvLearn
#' @aliases rvLearn
rvLearn <- function(data, models, copula)
{
    mvdvList <- list()

    for(i in 1:length(models)){
        candidateCopulas <- copula[[i]]
        selectCopulaFunction <- selectCopula(TRUE,candidateCopulas,COPULA_NONE)
        mvdvList[[i]] <- estimateMvdv(data[[i]], models[[i]], selectCopulaFunction) 
    }
    return (mvdvList)
}


#' Model Prediction
#' 
#' Predict the class of each vector of features
#'
#' @param vineModel a list with the models learned for each class by the function \code{rvLearn}
#' @param testSet the test matrix that contains the test set of each class. These matrices are concateneted
#'                by the row axis (i.e., one matrix after the other).
#' @param N_test a list with the sample size of each test matrix (one per class).
#' @param prob a vector with the probability of each class.
#' @return \code{pred} a list with the class predicted for each row vector from the test matrix.
#' @export rvPredict
#' @aliases rvPredict
rvPredict <- function(vineModel,testSet, N_test, prob)
{
    eval <- list()
    
    for(i in 1:length(vineModel)){
        eval[[i]] <- dmvdv(vineModel[[i]], testSet) + log(prob[i])
    }
    
    class = 1:length(N_test)
    t <- sapply(N_test,'[[',1)
    N <- sum(t)
    prec <- rep(0, N)

    for(i in 1:N){
       a <- sapply(eval, function (x) x[i])
       prec[i] <- class[a == max(a)]
    }
    return (prec)
}




#' Model Validation
#' 
#' Validate the model through the crossvalidation method
#' 
#' @param data a list of matrices where each matrix is the training set of each class.
#' @param n the number of variables.
#' @param N_train a list with the sample size of each training matrix (one per class).
#' @param k the number of partitions of the k-fold crossvalidation.
#' @param nRuns the number of crossvalidation repetitions.
#' @param models a list of vectors that specifies the type of vines, types of margins, and the number of trees of 
#'               the vine of each class. The value of models is the value of the rvSpecified function.
#' @param copula a vector that specifies the copula families to be fitted in the vine of each class.
#' @return \code{confusionMatrix} a confusion matrix, which is the mean of the \code{nRuns} confusion 
#'         matrices obtained in each crossvalidation's fold.  
#' @export rvValidate
#' @aliases rvValidate
rvValidate <- function(data,n,N_train,k,nRuns, models, copula)
{
   factor = (k-1)/k        
   run = 1
   
   vineModel <- list()
   evalModel <- list()
   prec <- matrix(0,ncol= length(N_train), nrow = length(N_train))

   for(run in 1:nRuns){
      data_index <- rvIndexCV(data,factor, N_train, n)
      data_train <- data_index[[1]]
      data_test <- data_index[[2]]
      N_ndxp <- data_index[[3]]

      vineModel <- rvLearn(data_train, models, copula)
      evalModel <- rvPredict(vineModel, data_test, N_ndxp)

      prec <- prec + rvEvaluate(evalModel, N_ndxp)
   }
   confusionMatrix <- prec/nRuns
   return (confusionMatrix)
}



#' Model Evaluation
#' 
#' Calculate a confusion matrix in order to describe the performance of the vine classifier
#'
#' @param prec a list with the class predicted for each vector of the test set.
#' @param N_test a list with the sample size of each test matrix (one per class).
#' @return \code{confusionM} a confusion matrix.
#' @export rvEvaluate
#' @aliases rvEvaluate
rvEvaluate <- function(prec, N_test)
{   
    m <- length(N_test)
    confusionM <- matrix(0, ncol = m, nrow = m)
    cont <- 0
    leng <- N_test[[1]]

    for(i in 1:m)
    {   
        temp <- cont + 1
        for(j in temp:leng){
              confusionM[i,prec[j]] = confusionM[i,prec[j]] + 1
              print(j)
        }
        if (i < m){ 
            cont <- leng 
            leng <- leng + N_test[[i+1]]  
        }
    }
    return (confusionM)
}


# Utility function
rvIndexCV <- function(d, factor, N_train, nc, n){
     ndx        <- list()
     ne         <- list()
     ndxe       <- list()
     ndxp       <- list()
     N_ndxp     <- list()
     data_train <- list()
     data_test  <- matrix(nrow=0, ncol=n)

     for(i in 1:nc){
          ndx[[i]]    <- sort(runif(N_train[[i]], 0, 1), index.return=TRUE)[[2]]
          ne[[i]]     <- round(N_train[[i]]*factor)           # size training set
          ndxe[[i]]   <- ndx[[i]][1:ne[[i]]]       	   # training set indices
          ndxp[[i]]   <- ndx[[i]][(ne[[i]]+1):N_train[[i]]]   # test set indices
          N_ndxp[[i]] <- length(ndxp[[i]])
    
          # Training data set for each class
          data_train[[i]] <- d[[i]][ndxe[[i]],] 
          # Test data set
          data_test       <- rbind(data_test, d[[i]][ndxp[[i]], ])
     }
     return (list(data_train, data_test, N_ndxp))
}

#####


