#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(reactable)
library(dplyr)
library(readr)
library(shinyWidgets)
library(arrow)

# Load the dataset
current_week_preds <- read_parquet("current_week_preds.parquet")

# Custom theme with background matching uploaded images
my_theme <- bs_theme(
  version = 5,
  bg = "#121212", # Matches the dark theme of the images
  fg = "#FFFFFF",
  primary = "#FF0000",
  secondary = "#000000",
  base_font = font_google("Inter"),
  heading_font = font_google("Roboto"),
  "navbar-bg" = "#121212",
  "navbar-dark-color" = "#FFFFFF",
  "navbar-dark-hover-color" = "#FF0000"
)

# UI
ui <- tagList(
  tags$head(
    # CSS to style the title and logo alignment
    tags$style(HTML("
      .navbar-brand {
        display: flex;
        align-items: center;
      }
      .navbar-brand img {
        margin-right: 10px; /* Space between logo and title */
        height: 40px; /* Adjust height of logo */
      }
    "))
  ),
  
  navbarPage(
    title = div(
      tags$img(src = "QB_Tool.png", alt = "Logo", height = "40px"), # Insert logo next to title
      "NFL QB Predictor"
    ),
    theme = my_theme,
    
    # Landing Page
    tabPanel(
      "Home",
      div(
        class = "container-fluid",
        style = "padding: 2rem; position: relative;",
        
        # Hero section
        div(
          class = "card",
          style = "background-color: #1e1e1e; border: 1px solid #FF0000; padding: 2rem; color: white;",
          div(
            class = "card-body text-center",
            h1("Welcome to NFL QB Predictor", class = "display-4 mb-4"),
            p(class = "lead",
              "Harness the power of advanced machine learning to predict NFL quarterback performance."
            )
          )
        ),
        
        # Features section
        div(
          class = "row",
          div(
            class = "col-md-4",
            div(
              class = "card h-100",
              style = "background-color: #FFFFFF; border: 1px solid #FF0000; color: black;",
              div(
                class = "card-body",
                h3("Advanced Analytics", class = "card-title text-danger"),
                p("Leveraging state-of-the-art machine learning models trained on historical NFL data.")
              )
            )
          ),
          div(
            class = "col-md-4",
            div(
              class = "card h-100",
              style = "background-color: #1e1e1e; border: 1px solid #FF0000; color: white;",
              div(
                class = "card-body",
                h3("Weekly Updates", class = "card-title text-danger"),
                p("Fresh predictions before every game, incorporating the latest player and team data.")
              )
            )
          ),
          div(
            class = "col-md-4",
            div(
              class = "card h-100",
              style = "background-color: #FFFFFF; border: 1px solid #FF0000; color: black;",
              div(
                class = "card-body",
                h3("Key Statistics", class = "card-title text-danger"),
                p("Accurate predictions for passing yards, touchdowns, interceptions, and more.")
              )
            )
          )
        )
      )
    ),
    
    # Predictions Page
    tabPanel(
      "Predictions",
      div(
        class = "container-fluid",
        style = "padding: 2rem;",
        sidebarLayout(
          # Sidebar
          sidebarPanel(
            style = "background-color: #121212; border: 1px solid #FF0000; padding: 1rem; color: #FFFFFF;",
            h4("Implied Probability Calculator"),
            p(
              "Enter American odds (positive or negative) to calculate the implied probability of the event.",
              style = "color: #FFFFFF;"
            ),
            textInput("american_odds", "American Odds:", ""),
            actionButton("calculate", "Calculate", style = "background-color: #FF0000; color: #FFFFFF;"),
            verbatimTextOutput("implied_prob"),
          ),
          # Main Panel
          mainPanel(
            div(
              class = "card",
              style = "background-color: #1e1e1e; border: 1px solid #FF0000;",
              div(
                class = "card-body",
                h2("Weekly QB Predictions", class = "mb-3", style = "color: white;"),
                p("Sort and filter predictions by clicking column headers or using the search box.", style = "color: white;")
              )
            ),
            reactableOutput("predictions_table")
          )
        )
      )
    )
  )
)

# Server
server <- function(input, output) {
  # Exclude unnecessary columns from current_week_preds
  qb_data <- current_week_preds %>%
    select(
      headshot_url,
      player_name,
      team,
      opponent,
      pred_pass_attempts,
      pred_completions,
      pred_passing_yards,
      pred_passing_tds,
      pred_interceptions,
      pred_rush_attempts,
      pred_rushing_yards,
      pred_rushing_tds
    )
  
  # Reactable Table
  output$predictions_table <- renderReactable({
    reactable(
      qb_data,
      theme = reactableTheme(
        backgroundColor = "#121212",
        borderColor = "#FF0000",
        stripedColor = "#1A1A1A",
        highlightColor = "#FF000022",
        cellPadding = "1rem",
        style = list(
          fontFamily = "Inter, sans-serif",
          color = "#FFFFFF"
        ),
        headerStyle = list(
          backgroundColor = "#000000",
          color = "#FFFFFF",
          "&:hover" = list(
            backgroundColor = "#FF0000"
          )
        ),
        inputStyle = list( # Styling for filter inputs
          backgroundColor = "#FFFFFF",
          color = "#000000",
          borderColor = "#FF0000"
        )
      ),
      columns = list(
        headshot_url = colDef(
          name = "Headshot",
          cell = function(value) {
            img(src = value, height = "70px", style = "border-radius: 50%;")
          },
          html = TRUE,
          filterable = FALSE,
          minWidth = 110
        ),
        player_name = colDef(name = "Name", filterable = TRUE, minWidth = 120),
        team = colDef(name = "Team", filterable = TRUE, minWidth = 100),
        opponent = colDef(name = "Opponent", filterable = TRUE, minWidth = 110),
        pred_pass_attempts = colDef(name = "Proj Pass Attempts", filterable = TRUE, minWidth = 110),
        pred_completions = colDef(name = "Proj CMP", filterable = TRUE, minWidth = 100),  # Changed name here
        pred_passing_yards = colDef(name = "Proj Passing Yards", filterable = TRUE, minWidth = 110),
        pred_passing_tds = colDef(name = "Proj Passing TDs", filterable = TRUE, minWidth = 110),
        pred_interceptions = colDef(name = "Proj INTs", filterable = TRUE, minWidth = 100),
        pred_rush_attempts = colDef(name = "Proj Rush Attempts", filterable = TRUE, minWidth = 110),
        pred_rushing_yards = colDef(name = "Proj Rushing Yards", filterable = TRUE, minWidth = 110),
        pred_rushing_tds = colDef(name = "Proj Rushing TDs", filterable = TRUE, minWidth = 110)
      ),
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      borderless = TRUE,
      defaultPageSize = 5, # Show all rows
      pagination = TRUE
    )
  })
  
  # Implied Probability Calculator
  output$implied_prob <- renderText({
    req(input$calculate)  # Ensure button is clicked
    odds <- as.numeric(input$american_odds)
    if (is.na(odds)) {
      return("Please enter a valid numeric American Odds.")
    }
    if (odds < 0) {
      prob <- abs(odds) / (abs(odds) + 100) * 100
    } else {
      prob <- 100 / (odds + 100) * 100
    }
    paste("Implied Probability:", round(prob, 2), "%")
  })
}

shinyApp(ui, server)
