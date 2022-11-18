# Case Study #4 - Bivariate Mapping
This repository provides instructions and code to estimate a staple Integrated Assessment Model (IAM), the Dynamic Integrated Climate-Economy model (DICE). DICE was originally developed by by 2018 Nobel Laureate [William Nordhaus](https://en.wikipedia.org/wiki/William_Nordhaus) that integrates in the neoclassical economics, carbon cycle, climate science, and estimated impacts allowing the weighing of subjectively guessed costs and subjectively guessed benefits of taking steps to slow climate change.

The version of the model used in this repository is DICE2016R as outlined in "[Revisiting the social cost of carbon](case_studies/case_study_2/papers/Nordhaus_2017_PNAS-DICE2016.pdf)" (Nordhaus 2017). Parameters and functions are drawn directly from the GAMS code for DICE2016R. The model written here does not require any additional solvers as it is not a constrained optimization problem but, instead, a simple representation of the model geared towards first-time users.   

# Install R and RStudio
This case study requires the use of the *R* programming language. *R* is free and available for download [here](https://www.r-project.org/). While you can use *R* on it's own, downloading *RStudio* provides a welcoming environment (an integrated development environment, or IDE) that is useful for replication and allows use of the *Rmarkdown* functionality. It is free and available for download [here](https://www.rstudio.com/products/rstudio/).

# Optional: Install GitHub
*Github* is free and available for download [here](https://desktop.github.com/). *Github* is used to house this repository and by installing and using it to clone the repository one will simplify the replication procedure. However, you could also simply download a zipped file version of this repository, unzip in the desired location on your machine, and follow the replication procedures outlined below.

# Cloning the Repository
To clone or download this repository, navigate to the [main page of this repo](https://github.com/bryanparthum/environmental_economics) and click on the green "code" button in the top right corner of the page and follow the instructions (this will also provide you with an option to download a .zip file of the repository). Alternatively, navigate in the command line terminal to where you would like to clone the repository and then type: 

```
git clone https://github.com/bryanparthum/environmental_economics
```

If you chose to download a .zip file of the repository, simply unzip it to wherever you would like to have it and proceed with the following steps in that directory.

# The Bivariate Map
To get started with the replication (after installing *R*, *RStudio*, and cloning/downloading the repository), navigate in your file explorer (or equivalent) to `case_studies\case_study_4` and double click on (open) the markdown file `bivariate_mapping.Rmd`. This will prompt your machine to open the file in *RStudio*. This markdown document includes all the instructions and code to create a bivariate map. 

# License
The software code contained within this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). Any data and figures are made available under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) license.
