#load packages - included all the ones required for the Rmd script to run too - not sure if necessary
library(shiny) # tell R which packages it's going to need to use
library(rmarkdown) # ggplot2, knitr, pander and plyr are called in the rmd code
library(ggplot2)
library(knitr)
library(pander)
library(plyr)
library(tidyr)
library(rcompanion)

ui<-(fluidPage( #fluidpage means page width determined by window size
  titlePanel("Ecobat Data Analysis"), #title of Shiny app
  sidebarLayout( #we want the layout with a sidebar and a main panel
    sidebarPanel( #options for sidepanel
      
      #*Input() functions,
      #*Output() functions
      
      fileInput(inputId = "file", label = "Upload CSV file", #upload field
                multiple = FALSE, #can only upload one file at a time
                accept = c( #these are the kinds of files it will accept
                  "text/csv",
                  "text/comma-separated-values, text/plain",
                  ".csv")),
      
      helpText("Default max. file size is 5MB"), #input decorations
      buttonLabel = "Browse...",
      placeholder = "No file selected",
      
      tags$br(), #adds a gap between two sections
      
      textInput(inputId = "Author", label = "Insert Author Name"), #input field for author name
      
      #scrapping these checkboxes for now but potential for checkboxes in future other shiny app
      #so leaving this code here so I can see how to code checkboxes
      #h5(helpText("Select the parameters below.")),
      #h5(helpText("If you uploaded weather data to Ecobat please check the 'Weather' box. If you uploaded temperature data to Ecobat please check the 'Temperature' box.")),
      #checkboxInput(inputId= "Weather", label = "Weather", value = FALSE),
      #checkboxInput(inputId= "Temperature", label = "Temperature", value = FALSE),
      
      tags$hr(), #adds a horizontal line
      uiOutput("ui.download"), # instead of conditionalPanel
      uiOutput("ui.download.helper"), #these two lines of code enable conditional appearance of download button
      #and helper text conditional on data having been uploaded
      tags$hr(), #adds a horizontal line
      h5("Developed by ", img(src= "ecobat-logo.png", heigth=100, width=100)) #gets it to display Ecobat logo
    ),
    mainPanel(
      uiOutput('contents') #display in main panel dependent on 'contents' in server.R
    )
  )
))
