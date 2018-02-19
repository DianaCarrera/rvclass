# rvclass: Implementation of different variants supervised classification algorithms based on regular vine copulas
Provides implementations of several R-vine copula-based learning methods for solving supervised classification tasks.

A n-dimensional R-vine distribution represents a multivariate distribution as a factorization of univariate margins and the R-vine copula. The R-vine copula represent the dependence structure and is given by a decomposition of bivariate pair-copulas.

The R-vine copula can be represented graphically by a set of nested trees where nodes are random variables and edges are bivariate copulas (both unconditional and conditional). 

The flexibility of the R-vine copula lies in the fact that pair-copulas of different families can be combined in the same graph. This property can be exploited to solve classification problems where the type of bivariate interactions show a great variability. 

We have applied R-vine classifiers to two real-world classification problems: The mind Reading [2,1] and dune classification Problem [3] (MRP and DCP respectively) reaching good classification results in both cases. 

We have tested this package with a maximum of 408 variables and 5 classes. In general, there are no restrictions for increasing the number of classes and variables, although we have not tried this yet.

[1] Huttunen, H.,Manninen, T., Kauppi, J.-P., Tohka, J.: Mind reading with regularized multinomial logistic regression. Mach. Vis. Appl. 24(6), 1311–1325 (2013).

[2] Klami, A., Ramkumar, P., Virtanen, S., Parkkonen, L., Hari, R., Kaski, S.: ICANN/PASCAL2 challenge: MEG mind reading. Overview and results. In: Klami, A. (ed.) Proceedings of ICANN/PASCAL2 Challenge: MEG Mind Reading, Aalto University Publication series SCIENCE + TECHNOLOGY, pp. 3–19. Aalto University (2011).

[3] Lourenço Bandeira, Jorge S. Marques, Jose Saraiva, and Pedro Pina. Advances in automated detection of sand
dunes on Mars. Earth Surface Processes and Landforms, 38(3):275–283, 2013.

## Installation Instructions

This package depends on the VinecopulaedasExtra package, the package can be installed with the following steps:

Install R packages: methods, copula, vines, copulaedas, copBasic from CRAN repository with commands:

```r
install.packages(methods_*.tar.gz)
```
or in a terminal

```r
cd "path where the package is"
R CMD INSTALL methods_*.tar.gz
```

The last version of the package VinecopulaedasExtra can be installed running the following commands:

```r
if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_github("DianaCarrera/VinecopulaedasExtra")
```
The package can also be installed using the tar.gz files in the root directory. First, download the `VinecopulaedasExtra_*.tar.gz` file and install it running:

```r
install.packages(path.tar.gz.file, reps=NULL)
```

where `path.tar.gz.file` refers to the path of the downloaded file. Note that these files may not be up to date.

The last version of the package rvclass can be installed running the following commands:

```r
if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_github("DianaCarrera/rvclass")
```
The package can also be installed using the tar.gz files in the root directory. First, download the `rvclass_*.tar.gz` file and install it running:

```r
install.packages(path.tar.gz.file, reps=NULL)
```

where `path.tar.gz.file` refers to the path of the downloaded file. Note that these files may not be up to date.


## How to cite rvclass
To reference this package, you can use the cite of the following paper.

```xml
@Article{Carrera2016,
author="Carrera, Diana
and Santana, Roberto
and Lozano, Jose A.",
title="Vine copula classifiers for the mind reading problem",
journal="Progress in Artificial Intelligence",
year="2016",
month="Nov",
day="01",
volume="5",
number="4",
pages="289--305",
issn="2192-6360",
doi="10.1007/s13748-016-0095-z",
url="https://doi.org/10.1007/s13748-016-0095-z"
}
```

## Usage

From each training labeled datasets (one per class), we learn one R-vine distribution. Then, the learned models are used to predict the probability of unlabeled instances. The class whose corresponding model has assigned the highest probability to the instance is selected as its class.
In general, a classification algorithm using rvclass can follows a workflow executed by the function rvClassifier(): rvSpecify(), rvLearn(), rvPredict(), rvValidate(), and rvEvaluate().
