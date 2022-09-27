## The Dynamic Integrated Climate-Economy model (DICE2016)

##########################
#################  library
##########################

# install.packages('tidyverse')
# install.packages('magrittr')
# library(tidyverse)
# library(magrittr)

##########################
############  define model
##########################

## time horizon (5 years per period)
time_horizon = 60

## availability of fossil fuels
fosslim  = 6000      # maximum cumulative extraction fossil fuels (gtc)

## time step
tstep    = 5         # years per period

## preferences
elasmu   = 1.45      # elasticity of marginal utility of consumption
prstp    = .015      # initial rate of social time preference per year

## population and technology
gama     = .300      # capital elasticity in production function
pop0     = 7403      # initial world population 2015 (millions)
popadj   = 0.134     # growth rate to calibrate to 2050 pop projection
popasym  = 11500     # asymptotic population (millions)
dk       = .100      # depreciation rate on capital (per year)
q0       = 105.5     # initial world gross output 2015 (trill 2010 usd)
k0       = 223       # initial capital value 2015 (trill 2010 usd)
a0       = 5.115     # initial level of total factor productivity
ga0      = 0.076     # initial growth rate for tfp per 5 years
dela     = 0.005     # decline rate of tfp per 5 years
s        = 0.2       # savings rate

## emissions parameters
gsigma1  = -0.0152   # initial growth of sigma (per year)
dsig     = -0.001    # decline rate of decarbonization (per period)
eland0   = 2.6       # carbon emissions from land 2015 (gtco2 per year)
deland   = .115      # decline rate of land emissions (per period)
e0       = 35.85     # industrial emissions 2015 (gtco2 per year)
miu0     = .03       # initial emissions control rate for base case 2015

## carbon cycle
## initial conditions
mat0     = 851       # initial concentration in atmosphere 2015 (gtc)
mu0      = 460       # initial concentration in upper strata 2015 (gtc)
ml0      = 1740      # initial concentration in lower strata 2015 (gtc)
mateq    = 588       # equilibrium concentration atmosphere  (gtc)
mueq     = 360       # equilibrium concentration in upper strata (gtc)
mleq     = 1720      # equilibrium concentration in lower strata (gtc)

## flow paramaters
b12      = .12       # carbon cycle transition matrix
b23      = 0.007     # carbon cycle transition matrix

## these are for declaration and are defined later
## b11      carbon cycle transition matrix
## b21      carbon cycle transition matrix
## b22      carbon cycle transition matrix
## b32      carbon cycle transition matrix
## b33      carbon cycle transition matrix
## sig0     carbon intensity 2010 (kgco2 per output 2005 usd 2010)

## climate model parameters
t2xco2   = 3.1       # equilibrium temp impact (oc per doubling co2)
fex0     = 0.5       # 2015 forcings of non-co2 ghg (wm-2)
fex1     = 1.0       # 2100 forcings of non-co2 ghg (wm-2)
tocean0  = .0068     # initial lower stratum temp change (c from 1900)
tatm0    = 0.85      # initial atmospheric temp change (c from 1900)
c1       = 0.1005    # climate equation coefficient for upper level
c3       = 0.088     # transfer coefficient upper to lower stratum
c4       = 0.025     # transfer coefficient for lower level
fco22x   = 3.6813    # forcings of equilibrium co2 doubling (wm-2)

## climate damage parameters
a1       = 0         # damage intercept
a2       = 0.00236   # damage quadratic term
a3       = 2.00      # damage exponent

## abatement cost
expcost2 = 2.6       # exponent of control cost function
pback    = 550       # cost of backstop 2010$ per tco2 2015
gback    = .025      # initial cost decline backstop cost per period
limmiu   = 1.2       # upper limit on control rate after 2150
tnopol   = 45        # period before which no emissions controls base
cprice0  = 2         # initial base carbon price (2010$ per tco2)
gcprice  = .02       # growth rate of base carbon price per year

## scaling and inessential parameters
## note that these are unnecessary for the calculations
## they ensure that mu of first period's consumption =1 and pv cons = pv utilty
scale1   = 0.0302455265681763   # multiplicative scaling coefficient
scale2   = -10993.704           # additive scaling coefficient

## parameter definitions
## l[t]          level of population and labor
## al[t]         level of total factor productivity
## sigma[t]      co2-equivalent-emissions output ratio
## rr[t]         average utility social discount rate
## ga[t]         growth rate of productivity from
## forcoth[t]    exogenous forcing for other greenhouse gases
## gl[t]         growth rate of labor
## gcost1        growth of cost factor
## gsig[t]       change in sigma (cumulative improvement of energy efficiency)
## etree[t]      emissions from deforestation
## cumetree[t]   cumulative from land
## cost1[t]      adjusted cost for backstop
## lam           climate model parameter
## gfacpop[t]    growth factor population
## pbacktime[t]  backstop price
## optlrsav      optimal long-run savings rate used for transversality
## scc[t]        social cost of carbon
## cpricebase[t] carbon price in base case
## photel[t]     carbon price under no damages (hotelling rent condition)
## ppm[t]        atmospheric concentrations parts per million
## atfrac[t]     atmospheric share since 1850
## atfrac2010[t]     atmospheric share since 2010 ;

## parameters for long-run consistency of carbon cycle
b11 = 1 - b12
b21 = b12*mateq/mueq
b22 = 1 - b21 - b23
b32 = b23*mueq/mleq
b33 = 1 - b32

## further definitions of parameters
a20       = a2
sig0      = e0/(q0*(1-miu0))
lam       = fco22x/t2xco2
ga        = ga0*exp(-dela*5*(0:(time_horizon-1)))
etree     = eland0*(1-deland)^(0:(time_horizon-1))
forcoth   = array(fex0+(1/17)*(fex1-fex0),time_horizon)
forcoth[-(1:17)] = (fex1-fex0)
pbacktime = pback*(1-gback)^(0:(time_horizon-1))
l         = array(pop0,time_horizon)
al        = array(a0,time_horizon)
gsig      = array(gsigma1,time_horizon)
sigma     = array(sig0,time_horizon)
cumetree  = array(100,time_horizon)
cost1     = array(pback*sig0/expcost2/1000,time_horizon)

for (t in 2:time_horizon) {
  
  l[t]     = l[t-1]*(popasym/l[t-1])^popadj
  
  al[t]    = al[t-1]/(1-ga[t-1])
  
  gsig[t]  = gsig[t-1]*(1+dsig)^tstep
  
  sigma[t] = sigma[t-1]*exp(gsig[t-1]*tstep)
  
  cost1[t] = pbacktime[t]*sigma[t]/expcost2/1000
  
}

## set the baseline emission controls to match DICE2016 R2
cpricebase = cprice0*(1+gcprice)^((0:(time_horizon-1))*5)
miu        = (cpricebase/pbacktime)^(1/(expcost2-1))
miu[(tnopol+1):length(miu)] = limmiu

## function to run the model 
run_dice = function(perturbation_year = -1) {
  
  ## definitions
  ## damfrac[t]      damages as fraction of gross output
  ## ygross[t]       gross world product gross of abatement and damages (trillions 2005 usd per year)
  ## ynet[t]         output net of damages equation (trillions 2005 usd per year)
  ## abatecost[t]    cost of emissions reductions  (trillions 2005 usd per year)
  ## y[t]            gross world product net of abatement and damages (trillions 2005 usd per year)
  ## i[t]            investment (trillions 2005 usd per year)
  ## c[t]            consumption (trillions 2005 us dollars per year)
  ## k[t]            capital stock (trillions 2005 us dollars)
  ## eind[t]         industrial emissions (gtco2 per year)
  ## e[t]            total co2 emissions (gtco2 per year)
  ## cca[t]          cumulative industrial carbon emissions (gtc)
  ## forc[t]         increase in radiative forcing (watts per m2 from 1900)
  ## mat[t]          carbon concentration increase in atmosphere (gtc from 1750)
  ## ml[t]           carbon concentration increase in lower oceans (gtc from 1750)
  ## mu[t]           carbon concentration increase in shallow oceans (gtc from 1750)
  ## tatm[t]         increase temperature of atmosphere (degrees c from 1900)
  ## tocean[t]       increase temperatureof lower oceans (degrees c from 1900)
  ## miu[t]          emission control rate ghgs
  
  ## intialize space for state variables and set starting values
  damfrac   = array(NA,      time_horizon)
  ygross    = array(NA,      time_horizon)
  ynet      = array(NA,      time_horizon)
  abatecost = array(NA,      time_horizon)
  y         = array(NA,      time_horizon)
  i         = array(NA,      time_horizon)
  c         = array(NA,      time_horizon)
  k         = array(k0,      time_horizon)
  eind      = array(NA,      time_horizon)
  e         = array(NA,      time_horizon)
  cca       = array(400,     time_horizon)
  forc      = array(NA,      time_horizon)
  mat       = array(mat0,    time_horizon)
  ml        = array(ml0,     time_horizon)
  mu        = array(mu0,     time_horizon)
  tatm      = array(tatm0,   time_horizon)
  tocean    = array(tocean0, time_horizon)
  
  ## the model
  for (t in 1:time_horizon) {
    
    ## equation for damage fraction
    damfrac[t] = a1*tatm[t]+a2*tatm[t]^a3
    
    ## output gross equation
    ygross[t] = (al[t]*(l[t]/1000)^(1-gama))*(k[t]^gama)
    
    ## output net of damages equation
    ynet[t] = ygross[t]*(1-damfrac[t])
    
    ## cost of emissions reductions equation
    abatecost[t] = ygross[t]*cost1[t]*miu[t]^expcost2
    
    # output net equation
    y[t] = ynet[t]-abatecost[t]
    
    ## savings rate equation
    i[t] = s*y[t]
    
    ## consumption equation
    c[t] = y[t]-i[t]
    
    ## capital balance equation
    k[t+1] = (1-dk)^tstep*k[t]+tstep*i[t]
    
    ## industrial emissions
    eind[t] = sigma[t]*ygross[t]*(1-(miu[t]))
    
    ## perturb emissions
    if (perturbation_year==(2015+t*tstep))
      eind[t] = eind[t]+1
    
    ## emissions equation
    e[t] = eind[t]+etree[t]
    
    ## cumulative industrial carbon emissions
    cca[t+1] = cca[t]+eind[t]*5/3.666
    
    ## atmospheric concentration equation
    mat[t+1] = mat[t]*b11+mu[t]*b21+e[t]*(5/3.666)
    
    ## lower ocean concentration
    ml[t+1] = ml[t]*b33+mu[t]*b23
    
    ## shallow ocean concentration
    mu[t+1] = mat[t]*b12+mu[t]*b22+ml[t]*b32
    
    ## radiative forcing equation
    forc[t+1] = fco22x*((log((mat[t+1]/588.000))/log(2)))+forcoth[t+1]
    
    ## temperature-climate equation for atmosphere
    tatm[t+1] = tatm[t]+c1*(forc[t+1]-(fco22x/t2xco2)*tatm[t]-c3*(tatm[t]-tocean[t]))
    
    ## temperature-climate equation for lower oceans
    tocean[t+1] = tocean[t]+c4*(tatm[t]-tocean[t])
    
  }
  
  ## return consumption
  return(list(consumption = c, gmst = tatm[1:60], gdp.loss = damfrac))
  
}

## function to get the scc
get_scc = function(perturbation_year, discount_rate = 0.02) {
  
  ## equation for damage fraction
  c_base = run_dice()
  c_perturb = run_dice(perturbation_year)
  
  ## consumption differences
  c_diff = (c_base$consumption-c_perturb$consumption)[-(1:((perturbation_year-2015)/tstep))]
  
  ## recover the scc
  tibble(year     = perturbation_year,
         scco2    = sum(c_diff*tstep/(1+discount_rate)^(0:(length(c_diff)-1)*tstep)) * 1e12/1e9/5) ## trillions to dollars, gigatonnes to tonne, divide by timestep
}

## function to get the scc path
get_scc_path = function(years = seq(2020, 2100, by = 10)) {
  results = tibble()
  for (year in years)
    results = 
      bind_rows(results, 
                get_scc(year))
  return(results)
}

##########################
###############  run model
##########################

## model is in 2010 USD, convert to 2020 USD using the annual BEA Table 1.1.9: https://apps.bea.gov/iTable/iTable.cfm?reqid=19&step=3&isuri=1&select_all_years=0&nipa_table_list=13&series=a&first_year=2020&last_year=2010&scale=-99&categories=survey&thetable=
pricelevel_2010_to_2020 = 113.648/96.166

## Nordhaus (2017) - DICE2016
results_02 = 
  get_scc_path() %>%
  mutate(scco2 = round(scco2 * pricelevel_2010_to_2020, 0),
         Damages = 'Nordhaus (2017) at 2%')

## end of script, have a great day.
