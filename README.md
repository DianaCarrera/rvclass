# rvclass: Implementation of a supervised classification algorithm based on regular vine copulas
Provides implementations of several R-vine copula-based learning methods for solving supervised classification tasks.

A n-dimensional R-vine distribution represents a multivariate distribution as a factorization of univariate margins and the R-vine copula. The R-vine copula represent the dependence structure and is given by a decomposition of bivariate pair-copulas.

The R-vine copula can be represented graphically by a set of nested trees where nodes are random variables and edges are bivariate copulas (both unconditional and conditional). 

The flexibility of the R-vine copula lies in the fact that pair-copulas of different families can be combined in the same graph. This property can be exploited to solve classification problems where the type of bivariate interactions show a great variability. 

We have applied R-vine classifiers in two real-world classification problems: The mind Reading and dune classification Problem (MRP and DCP respectively) reaching good classification results in both cases. 

We have tested this package with a maximum of 408 variables and 5 classes. In general, there is no restrictions for increasing the number of classes and variables, although we have not tried this yet.


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

Install C library dml of github(“https://github.com/yasserglez/dml”)

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
