[Live Demo of the Dynamic Dashboard](https://hosseinmousavi.shinyapps.io/dashboard/)

# Dynamic Dashboard for Gene Expression Data

This repository contains a Shiny application built in R that allows users to visualize gene expression data through various types of plots. The available plot types include scatter plots, box plots, histograms, and violin plots.

## Features
- **Flexible Visualization**: Users can select genes for the x and y axes and the type of plot they want to visualize.
- **Tissue Type Selection**: Users can select the tissue type for more specific visualizations.
- **Downloadable Plots**: The application allows users to download the generated plots for offline use or further analysis.

## Installation
Clone this repository to your local machine using https://github.com/HosseinMousavi/Dynamic_Dashboard.git
Open the R project and install the required dependencies.

## Dependencies
This project requires the following R packages:

- shiny
- ggplot2
- dplyr
- gridExtra

You can install these packages in R with:

```r
install.packages(c("shiny", "ggplot2", "dplyr", "gridExtra"))
```

## Usage
To run the Shiny application locally, use the following command in the R console:

```r
shiny::runApp('path/to/your/app')
```
Replace 'path/to/your/app' with the path to the directory containing the application files.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
