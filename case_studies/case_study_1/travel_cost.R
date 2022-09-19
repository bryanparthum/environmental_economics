##########################
#################  library
##########################

## clear worksace
rm(list = ls())
gc()

## this function will check if a package is installed, and if not, install it
list.of.packages <- c('tidyverse',    ## this package is used for data manipulation and management
                      'stargazer',    ## this package provides easy exporting of summary tables (statistics and regression tables) 
                      'MASS', 'pscl', ## these packages provides the statistical framework for the regressions
                      'AER')          ## this package provides the underlying data
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
lapply(list.of.packages, library, character.only = TRUE)

##########################
######## travel cost model
##########################

## load data
data("RecreationDemand")

## look at the help file. What are these data from? Copy the Description of the data into your response document. 
? RecreationDemand

## export summary statistics. Open the table, copy it to your response document, and answer the questions in the README file (on github).
stargazer(RecreationDemand, 
          title  = 'Table 1: Summary Statistics',
          digits = 1,
          type   = 'html',
          out    = 'travel_cost/output/summary_statistics.html')

## next, we will run a glm model. What is a glm model? 
## Copy the one-sentence Description of the model into your response document.
? glm

## run the model Poisson model:
pois <- glm(trips ~ costS + costC + costH + quality + ski + income + userfee, ## this line is the regression equation
            data   = RecreationDemand,                                        ## this line selects your data
            family = poisson)                                                 ## this line selects the link function, here, Poisson is used

## look at the summary output in your console
summary(pois)

## next, we will run a glm.nb model. What is a negative binomial model? 
## Copy the one-sentence Description of the model into your response document.
? glm.nb

## negative binomial model:
nb <- glm.nb(trips ~ costS + costC + costH + quality + ski + income + userfee, 
             data = RecreationDemand)

## look at the summary output in your console
summary(nb)

## next, we will run a zeroinfl model. What is a zero inflated model? 
## Copy the one-sentence Description of the model into your response document.
? zeroinfl

## zero inflated poisson:
zi <- zeroinfl(trips ~  costS + costC + costH + quality + ski + income + userfee | quality + income, 
               data = RecreationDemand)

## look at the summary output in your console
summary(zi)

## export summary statistics. Open the table, copy it to your response document, and answer the questions in the README file (on github).
stargazer(pois, ## the poisson model from above 
          nb,   ## the negative binomial model from above
          zi,   ## the zero-inflated model from above
          title  = 'Table 2: Travel Cost Regression Results',
          digits = 2,
          type   = 'html',
          out    = 'travel_cost/output/travel_cost_results.html')




## Optional: These are other regression specifications that can be used on these data. 
## Feel free to explore on your own, but they are not part of the case study.

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
