#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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


ui <- dashboardPage(skin = "midnight",title="History of traffic accidents",
    
    dashboardHeader(title="Traffic Accidents in Taiwan", titleWidth = 300),
    dashboardSidebar(minified = TRUE,
        sidebarMenu(
            menuItem("By Year",tabName = "yearBoard",icon = icon("calendar")),
            menuItem("By City",tabName = "cityBoard",icon = icon("building")),
            menuItem("Map",tabName = "mapBoard",icon = icon("map-pin")),
            menuItem(text = "About Us", href = "http://taiwantrafficacc.herokuapp.com/1.html",icon = icon("angle-double-right"))
        )
       
    
    ),
    dashboardBody(
        tags$style(
            '
        @media (min-width: 768px){
          .sidebar-mini.sidebar-collapse .main-header .logo {
              width: 300px; 
          }
          .sidebar-mini.sidebar-collapse .main-header .navbar {
              margin-left: 300px;
          }
        }
        '
        ),
        tabItems( 
            tabItem(tabName = "yearBoard", 
                    
                    selectInput(
                        "year_set", 
                        "Select year:", 
                        choices = list("2018"=2018,"2019"=2019,"2020"=2020),
                        selected = "2018"
                    ),
                    box(title="Accidents in Cities", collapsible = TRUE, background="light-blue", plotlyOutput("yearBar")),
                    box(title="Types of Vehicle", collapsible = TRUE, background="light-blue", plotlyOutput("yearType")),
                    box(title="Month", collapsible = TRUE, background="light-blue", plotlyOutput("yearMonth")),
                    box(title="Hour", collapsible = TRUE, background="light-blue", plotlyOutput("yearHour"))
                    
            ),
            tabItem(tabName = "cityBoard", 
                    selectInput(
                        inputId = 'city_set',
                        label = "Choose a city:",
                        choices = list('Taipei City'='Taipei_City','New Taipei City'='New_Taipei_City','Keelung City'='Keelung_City',
                                       'Taoyuan City'='Taoyuan_City','Hsinchu County'='Hsinchu_County','Hsinchu City'='Hsinchu_City',
                                       'Miaoli County'='Miaoli_County','Taichung City'='Taichung_City','Changhua County'='Changhua_County',
                                       'Nantou County'='Nantou_County','Yunlin County'='Yunlin_County','Chiayi County'='Chiayi_County',
                                       'Chiayi City'='Chiayi_City','Tainan City'='Tainan_City','Kaohsiung City'='Kaohsiung_City',
                                       'Pingtung County'='Pingtung_County','Yilan County'='Yilan_County','Hualien County'='Hualien_County',
                                       'Taitung County'='Taitung_County','Penghu County'='Penghu_County','Lienchiang County'='Lienchiang_County', 
                                       'Kinmen County'='Kinmen_County')
                        
                    ),
                    box(title="Accidents in nearly 3 years",collapsible = TRUE, background="green", plotlyOutput("cityBar")),
                    box(title="Types of Vehicle",collapsible = TRUE, background="green", plotlyOutput("cityType")),
                    box(title="Month",collapsible = TRUE, background="green", plotlyOutput("cityMonth")),
                    box(title="Hour",collapsible = TRUE, background="green", plotlyOutput("cityHour")),
                    
                    
            ),
            tabItem(tabName = "mapBoard",
                    
                        selectInput(
                            inputId = 'citymap_set',
                            label = "Choose a city:",
                            choices = list('Taipei City'='TPE')
                        ),
                        box(title="Location of Accidents", width=12, height=12, leafletOutput("map", height = 700))
                    
                    
            )
        )
    ),controlbar = dashboardControlbar(),footer = dashboardFooter(),
)