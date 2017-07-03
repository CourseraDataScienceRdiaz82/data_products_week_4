#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
values <- reactiveValues(capturedData = NULL)
values$capturedData <-data.frame(x=double(), y=double())

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  output$data <- renderTable(values$capturedData)
  output$modelEquation <- renderText("Model Equation : --")
  output$modelParameters <- renderText("Model Parameters : --")
  output$modelPlot <- renderPlot({
      
      plot(values$capturedData)
  })
  
  observeEvent(input$addPoint, {
      x_value <- {input$x}
      y_value <- {input$y}
      if (nrow(subset(values$capturedData, x==x_value & y==y_value))==0) {
          isolate(values$capturedData[nrow(values$capturedData) + 1,] <- c(x_value,y_value))
          output$data <- renderTable(values$capturedData, rownames = TRUE)
      } else {
          showModal(modalDialog(
              title = "Error",
              "This point is already added"
          ))
      }
  })
  
  observeEvent(input$deleteButton, {
      row_delete <- {input$deleteRow}
      if (nrow(values$capturedData)<row_delete || nrow(values$capturedData)==0){
          showModal(modalDialog(
              title = "Error",
              "This row does not exist"
          ))
      } else {
          values$capturedData <- values$capturedData[-c(row_delete),]
          if (nrow(values$capturedData)>0){
              rownames(values$capturedData) <- 1:nrow(values$capturedData)
          }
          output$data <- renderTable(values$capturedData, rownames = TRUE)
      }
  })
  
  observeEvent(input$calculateModel,{
      if (nrow(values$capturedData)>{input$orderModel}){
          model <- lm(values$capturedData$y ~ poly(values$capturedData$x,{input$orderModel}, raw=TRUE))
          output_string<- ""
          index<- 1
          for (index in seq_along(model$coefficients)){
              if (index==1)
                  output_string <- paste(output_string,"Intercept: ", model$coefficients[1],"\n", sep='')
              else if (index==2)
                  output_string <- paste(output_string,"X: ", model$coefficients[2],"\n", sep='')
              else
                  output_string <- paste(output_string, "X^",index-1,": ", model$coefficients[index],"\n", sep='')
          }
          
          output$modelEquation<-renderText(output_string)
          output$modelParameters<-renderText(paste("R Squared:",summary(model)$r.squared))
          
          output$modelPlot <- renderPlot({
              plot(values$capturedData)
              lines(sort(values$capturedData$x), fitted(model)[order(values$capturedData$x)], col='red', type='b') 
              #lines(values$capturedData$x,fitted(model), col='red')
          })
      } else{
          showModal(modalDialog(
              title = "Error",
              "There are less points than model order, please add more points"
          ))
      }
  })
  
})
