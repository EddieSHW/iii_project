#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(plotly)
library(tidyverse)
library(DT)
library(leaflet)


df_main <- read_csv("taipei_map.csv") 
# df_main <- data.frame(df_main)
# df_main <- as.data.frame(df_main$year)
#df_main <- df_main[,2:31]
yearData <- read.table("city_case_count_new.csv", header=TRUE, sep = ',')
cityData <- read.table("citycasecountnewT_new.csv", header=TRUE, sep = ',', check.names = FALSE)
yearTypeData <- read.table("donuttableT_new.csv", header=TRUE, sep = ',', check.names = FALSE)
yearMonthData <- read.table("monthtime.csv", header=TRUE, sep = ',', check.names = FALSE)
yearHourData <- read.table("hour.csv", header=TRUE, sep = ',', check.names = FALSE)
cityTypeData <- read.table("cartype.csv", header=TRUE, sep = ',', check.names = FALSE)
cityMonthData <- read.table("month.csv", header=TRUE, sep = ',', check.names = FALSE)
cityHourData <- read.table("cityhour.csv", header=TRUE, sep = ',', check.names = FALSE)


#yearHeatData <- read.table("weekhour.csv", header=TRUE, sep = ',', check.names = FALSE)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$yearBar <- renderPlotly({
        # yearData$year <- unlist(yearData$year)
        yearSet <- as.character(input$year_set)
        f <- ggplot(cityData, aes(x=city, y=cityData[,yearSet])) + 
            geom_bar(stat = 'identity', fill = "#84b9cb") + 
            labs(x='City',y='Accidents',title='') +
            theme(axis.text.x = element_text(angle = 90)) +
            theme(plot.title=element_text(hjust = 0.5,face = "bold",size = 20,family = "A"))
        theme_void()
        ggplotly(f)
    
    })
    
    
    output$yearType <- renderPlotly({
        # yearData$year <- unlist(yearData$year)
        # yearSet <- as.character(input$year_set)
        
        
        
        # fig <- plot_ly(type='pie', labels=yearDonutData[,input$year_set], values=type, 
        #                textinfo='label+percent',
        #                insidetextorientation='radial')
        
        fig <- plot_ly(yearTypeData, labels = ~type, values = ~yearTypeData[,input$year_set], type = 'pie')
        fig <- fig %>% layout(title = '',
                              xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        fig
        
        
    })
    
    output$yearMonth <- renderPlotly({
        # yearData$year <- unlist(yearData$year)
        # yearSet <- as.character(input$year_set)
        fig <- plot_ly(yearMonthData, x = ~month, y = ~yearMonthData[,input$year_set],
                       type = 'scatter', mode = 'lines')
        fig <- fig %>% layout(title = '',
                                  xaxis = list(title = 'Month'),
                                  yaxis = list(title = 'Accidents'))
        
        fig
        
    })
    
    output$yearHour <- renderPlotly({
       
       
        
        
        fig <- plot_ly(yearHourData, x = ~hour, y = ~yearHourData[,input$year_set],
                       type = 'scatter', mode = 'lines')
        fig <- fig %>% layout(title = '',
                              xaxis = list(title = 'Hour'),
                              yaxis = list(title = 'Accidents'))
        fig
        
        
        # fig <- plot_ly(yearHeatData,
        #     x = c("a", "b", "c"), y = c("d", "e", "f"),
        #     z = m, type = "heatmap"
        # )
        # 
        # fig
        
        
    })
    
    
    
    
    output$cityBar <- renderPlotly({
        
        citySet <- as.character(input$city_set)
        # cityData <- as.character(cityData[1,])
        p <- ggplot(yearData, aes(x=year, y=yearData[,citySet])) +
            geom_bar(stat = 'identity', fill='#f2a0a1') +
            labs(x='Years',y='Accidents',title='')

        ggplotly(p)
        
        # fig <- plot_ly(yearData, x = ~year, y = ~yearData[,citySet],
        #                type = 'scatter', mode = 'lines')
        # 
        # fig
    })
    
    output$cityType <- renderPlotly({
        fig <- plot_ly(cityTypeData, labels = ~type, values = ~cityTypeData[,input$city_set], type = 'pie')
        fig <- fig %>% layout(title = '',
                              xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        fig
    })
    
    output$cityMonth <- renderPlotly({
        fig <- plot_ly(cityMonthData, x = ~month, y = ~cityMonthData[,input$city_set],
                       type = 'scatter', mode = 'lines')
        fig <- fig %>% layout(title = '',
                              xaxis = list(title = 'Month'),
                              yaxis = list(title = 'Accidents'))
        fig
    })
    
    output$cityHour <- renderPlotly({
        fig <- plot_ly(cityHourData, x = ~hour, y = ~cityHourData[,input$city_set],
                       type = 'scatter', mode = 'lines')
        fig <- fig %>% layout(title = '',
                              xaxis = list(title = 'Hour'),
                              yaxis = list(title = 'Accidents'))
        fig
    })
    
    pal <-
        colorFactor(pal = c("#c9171e", "#2ca9e1"),
                    domain = df_main$A1A2)
    output$map <- renderLeaflet({
        leaflet(df_main) %>%
            #addCircles(lng = ~ lon, lat = ~ lat) %>%
            addTiles() %>%
            addMarkers(
                data = df_main,
                lat =  ~ lat,
                lng =  ~ lon,
                #radius = 3,
                popup = ~ as.character(avg_flow),
                #color = ~ pal(A1A2),
                clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE,zoomToBoundsOnClick = TRUE)
                #stroke = FALSE,
                #fillOpacity = 0.8,
                
            ) %>%
            # addLegend(
            #     pal = pal,
            #     values = df_main$A1A2,
            #     title = "A1A2",
            #     opacity = 1,
            #     na.label = "Not Available"
            # ) %>%
            addEasyButton(easyButton(
                icon = "fa-crosshairs",
                title = "ME",
                onClick = JS("function(btn, map){ map.locate({setView: true}); }")
            ))
    })
})
