##########################
#################  library
##########################

## clear worksace
rm(list = ls())
gc()

## this function will check if a package is installed, and if not, install it
list.of.packages <- c('tidyverse', ## this packege is used for data manipulation and management
                      'MASS', 'pscl', ## these packages provides the statistical framework for the regressions
                      'AER') ## this package provides the underlying data
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
lapply(list.of.packages, library, character.only = TRUE)

##########################
##############  case study
##########################

## load data
data("RecreationDemand")

## poisson model:
## Cameron and Trivedi (1998), Table 6.11
## Ozuna and Gomez (1995), Table 2, col. 3
fm_pois <- glm(trips ~ ., data = RecreationDemand, family = poisson)
summary(fm_pois)
logLik(fm_pois)
coeftest(fm_pois, vcov = sandwich)

## negative binomial model:
## Cameron and Trivedi (1998), Table 6.11
## Ozuna and Gomez (1995), Table 2, col. 5
fm_nb <- glm.nb(trips ~ ., data = RecreationDemand)
summary(fm_nb)
coeftest(fm_nb, vcov = vcovOPG)

## zero inflated poisson:
## Cameron and Trivedi (1998), Table 6.11
fm_zip <- zeroinfl(trips ~  . | quality + income, data = RecreationDemand)
summary(fm_zip)

## hurdle models
## Cameron and Trivedi (1998), Table 6.13

## poisson-poisson
fm_hp <- hurdle(trips ~ ., data = RecreationDemand, dist = "poisson", zero = "poisson")
summary(fm_hp)

## negative binomial - negative binomial
fm_hnb <- hurdle(trips ~ ., data = RecreationDemand, dist = "negbin", zero = "negbin")
summary(fm_hnb)

## binomial - negative binomial == geo-negative binomial
fm_hgnb <- hurdle(trips ~ ., data = RecreationDemand, dist = "negbin")
summary(fm_hgnb)

## note: quasi-complete separation
with(RecreationDemand, table(trips > 0, userfee))
