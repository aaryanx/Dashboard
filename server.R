#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    montecarlo<-function(paths, count, weight)
    {
        address<-"d:/Git/Dashboard/"
        df<- read.csv(paste(address, "BankNifty.csv", sep=""), 1)
        df2<-data.frame("Date"=df['Date'], "Price"=df['Close'])
        for(i in 2:nrow(df))
        {
            df2[i, 'Returns']<-log(df[i, 'Close']/df[i-1, 'Close'])
        }
        df2<-df2[-c(1),]
        u<-mean(df2[,3])
        v<-var(df2[,3])
        std<-sd(df2[,3])
        n=nrow(df2)
        
        risk<-c(ncol=paths)
        price<-matrix(0, nrow=(count+1), ncol=paths)
        for(i in 1:paths)
        {
            price[1,i]<-df2[n,2]
            for(j in 2:(count+1))
            {
                price[j,i]<-price[j-1,i]*exp((u-(v/2))+std*qnorm(runif(1, 0, 1)))
            }
            risk[i]=quantile(price[,i], 0.05)
        }
        estrisk<-mean(risk)
        histrisk<-as.numeric(quantile(df[,5], 0.05))
        vrisk<-weight/100*estrisk+(100-weight)/100*histrisk
        return(list(price, vrisk))
    }
    
    output$distPlot <- renderPlot({
        pr<-matrix(unlist(montecarlo(input$path, input$count, input$weight)[1]), ncol=input$path, byrow = F)
        matplot(pr, main=paste(input$tracker, "Simulation", sep=" "), xlab="Day", ylab="Price",type="l")
    })

    output$var<-renderText({
        vr<-as.numeric(unlist(montecarlo(input$path, input$count, input$weight)[2]))
        paste("Lowest value of", input$tracker, "in next", input$count, "days=", round(vr, digits = 2), sep=" ")
    })

})
