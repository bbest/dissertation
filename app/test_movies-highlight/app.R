library(dplyr)
library(ggvis)
library(shiny)
library(ggplot2)
df <- data.frame(x=rnorm(10), y=rnorm(10), id=letters[1:10])

server <- function(input, output) {
  movie_tooltip <- function(x) {
    x$id
  }
  movie_tooltip2 <- function(x) {
    i <- which(df$id == x$id)
    isolate(values$stroke[i] <- ifelse(values$stroke[i] == 'Yes',
                                       values$stroke[i] <- 'No',
                                       values$stroke[i] <- 'Yes'))
    return(NULL)
  }
  values <- reactiveValues(stroke=rep('No',nrow(df)))
  vis <- reactive({
    df %>%
      ggvis(~x, ~y) %>% 
      layer_points(key := ~id, stroke = ~values$stroke)  %>%
      add_tooltip(movie_tooltip, "hover")  %>%
      add_tooltip(movie_tooltip2, "click")
  })
  vis %>% bind_shiny("plot1") 
}
ui <- fluidPage(
  ggvisOutput("plot1")
)
shinyApp(ui = ui, server = server) 