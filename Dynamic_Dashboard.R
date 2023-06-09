library(shiny)
library(ggplot2)
library(dplyr)
library(gridExtra)

# Load dataframe
load("~/Documents/NMSU_2023/GTEx/df_merged_subset.RData")

# Load the required data and perform any necessary preprocessing
df_combined <- na.omit(df_merged_subset)

# Convert sex to factor with labels "Male" and "Female"
df_combined$sex <- factor(df_combined$sex, levels = c(1,2), labels = c("Male", "Female"))

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .col-sm-4 {
        width: 20%;
      }
      .col-sm-8 {
        width: 80%;
      }
    "))
  ),
  titlePanel("Gene Plot Visualizer"),
  
  sidebarLayout(
    sidebarPanel(
      # Scatter Plot Controls
      selectInput("x_gene", 
                  "Gene for x-axis:",
                  choices = colnames(df_merged_subset),
                  selected = "ENSG00000092607"), # Set default gene
      selectInput("y_gene", 
                  "Gene for y-axis:",
                  choices = colnames(df_merged_subset),
                  selected = "ENSG00000170382"), # Set default gene
      # Box Plot Controls
      selectInput("tissueType", 
                  "Select Tissue Type:", 
                  choices = unique(df_merged_subset$tissueType),
                  selected = unique(df_merged_subset$tissueType)[1]),
      radioButtons("plot_type",
                   "Download Plot Type",
                   choices = c("Scatter Plot", "Box Plot", "Histogram", "Violin Plot", "All Plots"),
                   selected = "Scatter Plot"),
      downloadButton("download_plot",
                     "Download Plot")
    ),
    mainPanel(
      fluidRow(
        column(6, plotOutput("scatterPlot", height = "450px", width = "450px")),
        column(6, plotOutput("boxPlot", height = "450px", width = "450px"))
      ),
      fluidRow(
        column(6, plotOutput("histPlot", height = "450px", width = "450px")),
        column(6, plotOutput("violinPlot", height = "450px", width = "450px"))
      )
    )
  )
)

server <- function(input, output) {
  # Scatter plot
  output$scatterPlot <- renderPlot({
    ggplot(df_merged_subset, aes_string(x = input$x_gene, y = input$y_gene)) +
      geom_point(alpha = 0.5, colour = "purple") +
      xlab(input$x_gene) +
      ylab(input$y_gene) +
      ggtitle("Scatterplot of Gene Expression Data")
  }, height = 350, width = 500)
  
  # Box plot
  output$boxPlot <- renderPlot({
    subset <- df_merged_subset[df_merged_subset$tissueType == input$tissueType, ]
    ggplot(subset, aes_string(x = 'interaction(tissueType, sex)', y = input$x_gene, fill = 'sex')) +
      geom_boxplot() +
      scale_fill_manual(values = c("blue", "red")) +
      xlab('Tissue Type and Sex') +
      ylab(input$x_gene) +
      ggtitle("Boxplot of Gene Expression Data by Tissue Type and Sex") +
      theme_minimal()
  }, height = 350, width = 500)
  
  # Histogram
  output$histPlot <- renderPlot({
    ggplot(df_combined, aes_string(x = input$x_gene)) +
      geom_histogram(binwidth = 1, fill = "gray", color = "black") +
      xlab(input$x_gene) +
      ggtitle("Histogram of Gene Expression Data") +
      theme_minimal()
  }, height = 350, width = 500)
  
  # Violin Plots
  output$violinPlot <- renderPlot({
    ggplot(df_merged_subset, aes_string(x = 'tissueType', y = input$x_gene, fill = 'sex')) +
      geom_violin() +
      scale_fill_manual(values = c("blue", "red")) +
      xlab('Tissue Type') +
      ylab(input$x_gene) +
      ggtitle("Violin Plot of Gene Expression Data by Tissue Type and Sex") +
      theme_minimal()
  }, height = 350, width = 500)
  
  # Download Plot
  output$download_plot <- downloadHandler(
    filename = function() {
      paste("gene_plot", Sys.Date(), ".pdf", sep="")
    },
    content = function(file) {
      pdf(file, width = 10, height = 10)
      
      if (input$plot_type == "All Plots") {
        scatterPlot <- ggplot(df_merged_subset, aes_string(x = input$x_gene, y = input$y_gene)) +
          geom_point(alpha = 0.5, colour = "purple") +
          xlab(input$x_gene) +
          ylab(input$y_gene) +
          ggtitle("Scatterplot of Gene Expression Data")
        
        subset <- df_merged_subset[df_merged_subset$tissueType == input$tissueType, ]
        boxPlot <- ggplot(subset, aes_string(x = 'interaction(tissueType, sex)', y = input$x_gene, fill = 'sex')) +
          geom_boxplot() +
          scale_fill_manual(values = c("blue", "red")) +
          xlab('Tissue Type and Sex') +
          ylab(input$x_gene) +
          ggtitle("Boxplot of Gene Expression Data by Tissue Type and Sex") +
          theme_minimal()
        
        histPlot <- ggplot(df_combined, aes_string(x = input$x_gene)) +
          geom_histogram(binwidth = 1, fill = "gray", color = "black") +
          xlab(input$x_gene) +
          ggtitle("Histogram of Gene Expression Data") +
          theme_minimal()
        
        violinPlot <- ggplot(df_merged_subset, aes_string(x = 'tissueType', y = input$x_gene, fill = 'sex')) +
          geom_violin() +
          scale_fill_manual(values = c("blue", "red")) +
          xlab('Tissue Type') +
          ylab(input$x_gene) +
          ggtitle("Violin Plot of Gene Expression Data by Tissue Type and Sex") +
          theme_minimal()
        
        grid.arrange(scatterPlot, boxPlot, histPlot, violinPlot, nrow = 2)
      }
      else {
        # Choose the plot you want to download
        switch(input$plot_type,
               "Scatter Plot" = {
                 scatterPlot <- ggplot(df_merged_subset, aes_string(x = input$x_gene, y = input$y_gene)) +
                   geom_point(alpha = 0.5, colour = "purple") +
                   xlab(input$x_gene) +
                   ylab(input$y_gene) +
                   ggtitle("Scatterplot of Gene Expression Data")
                 print(scatterPlot)
               },
               "Box Plot" = {
                 subset <- df_merged_subset[df_merged_subset$tissueType == input$tissueType, ]
                 boxPlot <- ggplot(subset, aes_string(x = 'interaction(tissueType, sex)', y = input$x_gene, fill = 'sex')) +
                   geom_boxplot() +
                   scale_fill_manual(values = c("blue", "red")) +
                   xlab('Tissue Type and Sex') +
                   ylab(input$x_gene) +
                   ggtitle("Boxplot of Gene Expression Data by Tissue Type and Sex") +
                   theme_minimal()
                 print(boxPlot)
               },
               "Histogram" = {
                 histPlot <- ggplot(df_combined, aes_string(x = input$x_gene)) +
                   geom_histogram(binwidth = 1, fill = "gray", color = "black") +
                   xlab(input$x_gene) +
                   ggtitle("Histogram of Gene Expression Data") +
                   theme_minimal()
                 print(histPlot)
               },
               "Violin Plot" = {
                 violinPlot <- ggplot(df_merged_subset, aes_string(x = 'tissueType', y = input$x_gene, fill = 'sex')) +
                   geom_violin() +
                   scale_fill_manual(values = c("blue", "red")) +
                   xlab('Tissue Type') +
                   ylab(input$x_gene) +
                   ggtitle("Violin Plot of Gene Expression Data by Tissue Type and Sex") +
                   theme_minimal()
                 print(violinPlot)
               }
        )
        
      }
      
      dev.off()
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
