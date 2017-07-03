#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Simple Polynomial Fitting Model Calculator"),
  
  # Sidebar with a slider input for number of bins 
  
    
    # Show a plot of the generated distribution
    
        tabsetPanel(
            tabPanel("Simple Calculator", 
                     sidebarLayout(
                         sidebarPanel(
                             numericInput("x", "x value", 0 ),
                             numericInput("y", "y value", 0),
                             actionButton("addPoint", "Add point"),
                             HTML('<hr style="color: #333!important;">'),
                             numericInput("deleteRow", "Row to delete", 1, min = 1),
                             actionButton("deleteButton", "Delete"),
                             HTML('<hr style="color: #333!important;">'),
                             numericInput("orderModel", "Model order", 1, min = 1, max = 5),
                             actionButton("calculateModel", "Create Model From Data")
                         ),
                     mainPanel(h3(verbatimTextOutput("modelEquation", placeholder = FALSE)),
                               h3(verbatimTextOutput("modelParameters", placeholder = FALSE)),
                               fluidRow(
                                   column(3,tableOutput("data")),
                                   column(9, plotOutput("modelPlot"))
                               )
                               ))),
            tabPanel("Documentation",
                     fluidPage(
                         includeHTML("documentation.html")
                     )
        )
    )
  ))