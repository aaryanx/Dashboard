#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Dashboard"),
    navbarPage("Page",
        tabPanel("Risk Analytics",
                 # Sidebar input for VaR
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("tracker",
                                     "Choose a Stock or Index:",
                                     c("NIFTY50", "BANKNIFTY")
                         ),
                         numericInput("path",
                                      "Number of Paths to be simulated:",
                                      250,
                                      min=5,
                                      max=1000
                         ),
                         numericInput("count",
                                      "Number of Days to be forecasted:",
                                      30,
                                      min=5,
                                      max=60
                         ),
                         sliderInput("weight",
                                     "Weight: Historical <-> Implied",
                                     40,
                                     min=0,
                                     max=100
                                     )
                     ),
                     # Show a plot of the generated distribution
                     mainPanel(
                         tabsetPanel(
                             tabPanel("VaR",
                                      plotOutput("distPlot"),
                                      textOutput("var")
                             ),
                             tabPanel("Financials")
                         )
                         
                     )
            )
        ),
        tabPanel("Data")
    )
        
    )
)
