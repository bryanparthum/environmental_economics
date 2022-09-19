# Case Study #1 - The Travel Cost Model
This repo provides instructions, code, and data to estimate a travel cost model from [Seller, Stoll, and Chavas (1985)](https://bryanparthum.github.io/environmental_economics/case_studies/travel_cost/Seller_et_al_1985_LandEcon-travel_cost.pdf).

# Install R and Rstudio (25 points)
As mentioned [above](#requirements), this case study requires the use of the *R* programming language. *R* is free and available for download [here](https://www.r-project.org/). While you can use *R* on it's own, downloading *RStudio* will provide you with a welcoming environment (an integrated development environment, or IDE) that is useful for replication. It is free and available for download [here](https://www.rstudio.com/products/rstudio/). 

**NOTE:** To get the 25 points for downloading and installing *R* and *RStudio*, you need to include a screenshot of your name typed into the *RStudio* console (e.g., "`Professor Parthum`" typed into the *Rstudio* console). Place this screenshot in your response document.

# Optional: Install GitHub (0 points)
*Github* is free and available for download [here](https://github.com/git-guides/install-git). *Github* is used to house this repository and by installing and using it to clone the repository one will simplify the replication procedure. However, you could also simply download a zipped file version of this repository, unzip in the desired location on your machine, and follow the replication procedures outlined below.

# Cloning the Repository (25 points)
Begin by either cloning this repository or downloading the zipped file. Cloning can be done from the [main page of this repo](https://github.com/bryanparthum/environmental_economics) by clicking on the green "code" button in the top right corner of the page and following those instructions (this will also provide you with an option to download a .zip file of the repository), or by navigating in the terminal to the desired location of the clone and then typing: 

```
git clone https://github.com/bryanparthum/environmental_economics
```

If you chose to download a .zip file of the repository, simply unzip it to wherever you would like to have it and proceed with the following steps in that directory.

**NOTE:** To get the 25 points for cloning/downloading the repository, you need to include a screenshot of where you successfully cloned/downloaded the repository. Place this screenshot in your response document.


**IMPORTANT NOTE ABOUT GRADING POINTS:** If you choose to stop at only downloading and installing *R* and *RStudio*, or cloning/downloading the repository (25 points for each of these tasks) you will need to provide proof by including a screen shot of you typing your name into the *RStudio* console and/or a screenshot of where you successfully cloned/downloaded the repository. If you continue on for the other 50 points (as you should) no need to provide these as it will be obvious that you made it this far.

# The Travel Cost Model 
To get started with the replication, simply navigate in your file explorer (or equivalent) to `case_studies/case_study_1` and double click on (open) the *RStudio* project `case_study_1.Rproj`. This should prompt your computer to open the project file that will now anchor all specified paths in any scripts (code) to be relative to the environment path—allowing all code inside the replication scripts to be executed without problems regardless of the machine. 

This code will estimate a travel cost model from [Seller, Stoll, and Chavas (1985)](https://bryanparthum.github.io/environmental_economics/case_studies/travel_cost/Seller_et_al_1985_LandEcon-travel_cost.pdf). Begin by opening up the replication code located in that same directory under `travel_cost`. The replication code is `travel_cost.R`. When you double click (open) it, the script should open in your already open *RStudio* environment. 

All remaining steps are included and documented in the code. Begin by running the function that will install the required packages. You can simply highlight all the lines (1 through 15) and hit the `Run` button at the top of the code editor, or use a keyboard shortcut and type `Ctrl + Enter` (on a Mac, type `Cmd + Return`). 

The Keyboard shortcuts are really handy for running the code line-by-line. Whatever line the cursor is on, regardless of where the cursor is on that line, can be run by simply typing `Ctrl + Enter` (on a Mac, type `Cmd + Return`). 

Progress through the code. Next, load the data with the line: 

```
data(RecreationData)
```
Explore what this dataset is by typing: 

```
? RecreationData
```

The question mark `?` is really useful in *R* whenever we want to access the help file for something. For example, typing `? library` will automatically bring you to the help file for loading packages.

Continue by answering the following questions in the text editor of your choice (Microsoft Word, markdown, Jupyter Notebook, etc.). Be sure to include all output in your document (summary statistics tables, regression output tables, etc.). 

1. (5 points) What are the data that you just loaded? Copy the `Description` from the help file that appeard after you typed `? RecreationDemand`. 

2. (5 points) Export the table of summary statistics from the data using the `stargazer` package (the command is already written in the script and exports the `html` table to `travel_cost\output\summary_statistics.html`). Copy and paste this table into your response document. 

    - (2 points) What was the total number of respondents (observations)? 
    - (2 points) What was the average number of trips taken? 
    - (2 points) What was the average cost of a trip to Sommerville Lake? (this is the `costS` variable) And the other two substitute lakes? (Conroe Lake = `costC` and Houston Lake = `costH`)

3. (5 points) Next, find out what the `glm` model is by typing `? glm`. What is a glm model? Copy the one-sentence Description of the model into your response document.

4. (10 points) You will estimate two other models as well. Find out what the negative binomial model is by typing `? glm.nb`. Find out what the zero inflated model is by typing `? zeroinfl`. Copy the one-sentence Description of each model into your response document.

5.  (5 points) Run the generalized linear model (`glm`), the negative binomial model (`glm.nb`), and the zero-inflated model (`zeroinfl`). Export the regression outputs to a `html` table using the `stargazer` package. Open the `travel_cost\output\travel_cost_results.html` file and copy and paste the table into your response document. This command is already included in the code. Using the table as your guide, answer the following questions: 
    
    - (5 points) What are the coefficients interpreted as? Recall, they are the partial derivatives of the utility function. 

    - (5 points) Are the coefficients on the cost variables as expected? Recall, `costS` is the own price (the price of visiting Sommerville Lake), and the other two cost variable `costC` and `costH` are the price of visiting the "substitute" lakes. 

    - (5 points) What is the marginal willingness to pay for lake quality at Sommerville Lake? Recall, this is the ratio of two coefficients (preference parameters). 
