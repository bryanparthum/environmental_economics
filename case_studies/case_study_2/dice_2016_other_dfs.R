## The Dynamic Integrated Climate-Economy model (DICE2016)

##########################
#################  library
##########################

## Clear worksace
rm(list = ls())
gc()

## This function will check if a package is installed, and if not, install it
list.of.packages <- c('magrittr','tidyverse',
                      'ggplot2','ggrepel','wesanderson','scales')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
lapply(list.of.packages, library, character.only = TRUE)

##########################
############  define model
##########################

## time periods (5 years per period)
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
a4       = 5.07e-6   # Weitzman damage term
a5       = 6.754     # damage exponent Weitzman 2012

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

# parameters for long-run consistency of carbon cycle
b11 = 1 - b12
b21 = b12*mateq/mueq
b22 = 1 - b21 - b23
b32 = b23*mueq/mleq
b33 = 1 - b32

# further definitions of parameters
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
miu = (cpricebase/pbacktime)^(1/(expcost2-1))
miu[(tnopol+1):length(miu)] = limmiu

## function to run the model 
run_dice = function(perturbation_year=-1,damfun) {
  
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
    if (missing(damfun)) {
      damfrac[t] = a1*tatm[t]+a2*tatm[t]^a3
    }
    else if (damfun=="Weitzman") {
      damfrac[t] = (a1*tatm[t]+a2*tatm[t]^a3+a4*tatm[t]^a5)/(1+a1*tatm[t]+a2*tatm[t]^a3+a4*tatm[t]^a5)
    }
    
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
  return(c)
  
}

## function to get the scc
get_scc = function(perturbation_year,discount_rate=.03,damfun) {
  
  ## equation for damage fraction
  if (missing(damfun)) {
    c_base = run_dice()
    c_perturb = run_dice(perturbation_year)
  }
  else if (damfun=="Weitzman") {
    c_base = run_dice(damfun="Weitzman")
    c_perturb = run_dice(perturbation_year,damfun="Weitzman")
  }
  
  ## consumption differences
  c_diff = (c_base-c_perturb)[-(1:((perturbation_year-2015)/tstep))]

  ## make data
  data.frame(year = perturbation_year,
             scc  = sum(c_diff*tstep/(1+discount_rate)^(0:(length(c_diff)-1)*tstep)) * 1e12/1e9/5)
}

## function to get the scc path
get_scc_path = function(damfun, years = seq(2020, 2100, by = 5)) {
  if (missing(damfun)) {
    results = NULL
    for (year in years)
      results = rbind(results, get_scc(year))
    return(results)
  }
  else if (damfun=="Weitzman") {
    results = NULL
    for (year in years)
      results = rbind(results, get_scc(year, damfun = 'Weitzman'))
    return(results)
  }
}

##########################
###############  run model
##########################

## Nordhaus (2017) - DICE2016
results = 
  get_scc_path() %>%
  mutate(Damages = "Nordhaus (2017) \nDICE2016")

## Weitzman (2012)
results = 
  bind_rows(results,
            get_scc_path(damfun = 'Weitzman') %>%
              mutate(Damages = "Weitzman (2012)"))

## Howard and Sterner (2017)
## only market damages
a2 = 0.003181497
results = 
  bind_rows(results,
            get_scc_path() %>%
              mutate(Damages = "Howard and Sterner (2017) \nMarket Only"))

## market plus 25% adder for nonmarket
a2 = 0.003181497 * 1.25
results = rbind(results,
                get_scc_path() %>%
                  mutate(Damages = "Howard and Sterner (2017) \n+ 25% Nonmarket"))

## market and productivity
a2 = 0.003181497 + 0.003982305
results = 
  bind_rows(results,
            get_scc_path() %>%
              mutate(Damages = "Howard and Sterner (2017) \n+ Productivity"))

## market and productivity and catastrophic
a2 = 0.003181497 + 0.003622743 + 0.003982305
results = 
  bind_rows(results,
            get_scc_path() %>%
              mutate(Damages = "Howard and Sterner (2017) \n+ Productivity \n+ Catastrophic"))

## process
## inflate from 2010 dollars to 2020: https://apps.bea.gov/iTable/iTable.cfm?reqid=19&step=3&isuri=1&select_all_years=0&nipa_table_list=13&series=a&first_year=2010&last_year=2020&scale=-99&categories=survey&thetable=
inflator = 113.648/96.166
results %<>% mutate(scc = scc * inflator)

##########################
####################  plot
##########################

## plot
results$Damages  <- with(results, reorder(Damages, -scc))
results %>% 
  filter(year <= 2080) %>% 
  ggplot() +
  geom_line(aes(x     = year, 
                y     = scc, 
                color = Damages), 
            size  = 1) +
  geom_label_repel(aes(x     = case_when(year == 2075 ~ year, TRUE ~ NA_real_),
                       y     = scc,
                       color = Damages, 
                       label = Damages), 
                   size         = 3,
                   max.overlaps = 10,
                   nudge_x      = 10) +
  geom_segment(aes(x = 2020, xend = 2080, y = 0, yend = 0), color = NA, linetype = 'dashed', size = 0.3) +
  scale_x_continuous(breaks = seq(2020, 2080, 20), 
                     limits = c(2020, 2090)) +
  scale_y_continuous(breaks = seq(0, 1600, 200),
                     labels = scales::dollar_format()) +
  scale_color_manual(values = wes_palette(name = "BottleRocket1")) +
  labs(title = 'SC-CO2 Under DICE2016R Assumptions and 3% Constant Discount Rate',
       x     = "Emissions Year",
       y     = "SC-CO2 (2020$)") +
  theme_minimal() +
  theme(legend.position  = 'none',
        legend.title     = element_text(size=14, color='grey20'),
        legend.text      = element_text(size=14, color='grey20'),
        legend.key.size  = unit(0.75, 'cm'),
        legend.margin    = margin(0, 0, 0, 0),
        axis.title       = element_text(size=14),
        axis.text        = element_text(size=14),
        axis.line.x      = element_line(color = "black"),
        axis.ticks.x     = element_line(color = "black", size=1),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color='grey70', linetype="dotted"),
        panel.grid.minor = element_blank(),
        plot.caption     = element_text(size=11, hjust=0.5),
        plot.title       = element_text(size=14, hjust=0.5)) 

# ## export
# ggsave('scco2_plot.svg', width = 9, height = 6)

## end of script, have a great day.