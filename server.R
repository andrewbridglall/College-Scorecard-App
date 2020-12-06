# Final Project server


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$plotOption1 <- renderUI({
        
        if(input$graphtype=="Scatterplot")
        {
            
            #UI for scatter plot
            tagList(
                
                #Pick one major
                selectInput("majorOfInterest", "Pick a Major",
                            levels(as.factor(full_data$CIPDESC))),
                #Pick x axis
                selectInput("xvar", "Pick a Predictor Variable",
                            c("Admission Rate" = "Admission_Rate",
                              "Mean SAT Score" = "Mean_SAT_Score")), 
                            
                #Pick y axis
                selectInput("yvar", "Pick an Explanatory Variable",
                            c("Median Annual Earnings" = "Median_Annual_Earnings",
                              "Median Federal Debt" = "Median_Debt",
                              "Mean Federal Debt" = "Mean_Debt"))
                
            )
            
        }
        
        else if(input$graphtype=="Choropleth")
        {
            
            #UI for choropleth plot
                
            #Pick a Proportion
            selectInput("prop", "Pick a Proportion",
                        c("Proportion of public colleges" = "Public_Colleges",
                    
                          "Proportion of graduates earning above US average" = "Graduate_Earnings",
                          "Proportion of SAT scores above US 75th Percentile" = "SAT_Scores",
                          "Proportion of 6 year graduation rates above US average" = "Six_Yr_Graduation_Rate",
                          "Proportion of 4 year graduation rates above US average" = "Four_Yr_Graduation_Rate"))
                
                #"Private not-for-profit colleges" = "Private_NFP_Colleges",
            
            
            
        }
        
    })

    
    output$collegePlot <- renderPlotly({
        if(input$graphtype=="Scatterplot")
        {
            #plot scatterplot
            plot_data1 <- filter(full_data, CIPDESC %in% input$majorOfInterest)
            
            g <- ggplot(plot_data1, aes_string(x=input$xvar, y=input$yvar))+
                geom_point(aes(label=College),shape = 21, colour = "black", fill = "dodgerblue3", size = 3, stroke = 1)+
                labs(title=paste(input$yvar, "vs",input$xvar, "for\n", input$majorOfInterest), x=input$xvar, y=input$yvar)+
                theme_classic()
            ggplotly(g, tooltip =c("label", input$yvar, input$xvar))
            
            
            
        }
        else if(input$graphtype=="Choropleth")
        {
            #plot Choropleth
            g <- ggplot()+geom_polygon(data=usData,
                                       aes_string(x="long", y="lat",group ="group",fill=input$prop),color="black")+
                coord_map()+
                scale_fill_continuous(name=input$prop,low="lightblue",high="darkblue")+
                labs(x="",y="")+
                theme(legend.position = "bottom", panel.background = element_blank())
            #fill=eval(as.name(input$prop)))

            ggplotly(g)
                
        }
        
    })
    

})
