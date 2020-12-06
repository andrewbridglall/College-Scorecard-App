# Final_Project ui


shinyUI(fluidPage(

    # Application title
    titlePanel("College Scorecard Exploratory Application"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            radioButtons("graphtype","Pick a Graph Type", choices=list("Scatterplot", "Choropleth")),
            uiOutput("plotOption1")
            

        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("collegePlot"),
            br(),
            br(),
            p(strong("Description:"), "This application allows users to explore earnings and debt data
            for different majors at US colleges. Users can then visualize proportions such as college
            graduation rates per state. The data for this application was sourced from the
            US Department of Education", a ("College Scorecard.", href="https://collegescorecard.ed.gov/data/"),
            "The aim for this application is to better enable students and parents to identify locations, 
            universities and majors of study that match their long-term goals."),
            br(),
            p("Note: I am still working on the choropleth. It runs locally but does not yet run when deployed
              to the web app.")
            
        )
    )
))
