
#### Link to play with the Dynamic Dashboard: [Live Demo of the Dynamic Dashboard](https://hosseinmousavi.shinyapps.io/dashboard/)

<img width="1456" alt="Screenshot 2023-06-12 at 12 36 10 PM" src="https://github.com/HosseinMousavi/Dynamic_Dashboard/assets/61721826/295a60dd-b4c5-4065-bf3d-096789096d72">

#### Link to play with the Dynamic Dashboard: [Live Demo of the Dynamic Dashboard](https://hosseinmousavi.shinyapps.io/dashboard/)

# Dynamic Dashboard for Gene Expression Data

This repository contains a Shiny application built in R that allows users to visualize gene expression data through various types of plots. The available plot types include scatter plots, box plots, histograms, and violin plots.

## Features
- **Flexible Visualization**: Users can select genes for the x and y axes and the type of plot they want to visualize.
- **Tissue Type Selection**: Users can select the tissue type for more specific visualizations.
- **Downloadable Plots**: The application allows users to download the generated plots for offline use or further analysis.

## Getting Started
1. Clone this repository to your local machine using:

git clone https://github.com/HosseinMousavi/Dynamic_Dashboard.git

2. Open the R project and install the required dependencies.

## Dependencies
This project requires the following R packages:

- shiny
- ggplot2
- dplyr
- gridExtra

You can install these packages in R with the following command:
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


