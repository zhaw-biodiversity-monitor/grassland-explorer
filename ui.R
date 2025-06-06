
source("libraries.R")
source("utils.R")

gpkg_path <- "appdata/vectors.gpkg"
layers <- read_sf(gpkg_path, "layers_overview")
# todo: obsolte?
aggregation1 <- unique(layers$aggregation1)
aggregation1 <- aggregation1[aggregation1 != "layers"]

aggregation1 <- c("Hexagone (10x10km)" = "hex10","Hexagone (20x20km)" = "hex20","Biogeografische Regionen" = "BGR","Kantone"="kantone")
datasets <- c("Biodiversitätsmonitoring Schweiz" = "normallandschaft") # ,"tww","moore"



col_y_options <- c(
  "artenreichtum_gefasspflanzen",
  "artenreichtum_neophyten",
  "artenanteil_neophyten",
  "deckungsanteil_neophyten",
  "temperaturzahl",
  "kontinentalitatszahl",
  "feuchtezahl",
  "reaktionszahl",
  "nahrstoffzahl",
  "strategie_c",
  "strategie_r",
  "strategie_s"
)

names(col_y_options) <- clean_names(col_y_options)

# aggregation_layers <-
#   c(
#    "Hexagon 10km" = "grass_hex10km",
#    "Hexagon 5km" = "grass_hex5km",
#    "Hexagon 20km" = "grass_hex20km",
#    "Biogeografische Regionen" = "grass_biogreg",
#    "Kantone" = "grass_kantone",
#    "Kantone x Biogeografische Regionen" = "grass_kantone_biogreg",
#    "Biogeografische Regionen x Hexagon 10km" = "grass_hex10km_biogreg",
#    "Kantone x Hexagon 10km"= "grass_hex10km_kantone"
#     # "Biogeografische Regionen",
#    # "Kantone"
#   )

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$script(src = "myjs.js"),
  # Application title
  titlePanel("Grasland der Schweiz"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # sliderInput("hoehenstufe", "Höhenstufe:", min = 0, max = 3000, value = c(0,3000)),
      selectInput("datensatz", "Datensatz", datasets),
      selectInput(
        "aggregation",
        "Aggregation",
        aggregation1
      ),
      selectInput(
        "column_y",
        "Variable",
        col_y_options
      ),

      plotlyOutput("scatterplot"),
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
            leaflet::leafletOutput("map", height = 600)

      # tabsetPanel(
      # type = "tabs",
      # tabPanel("Map", leaflet::leafletOutput("map", height = 600)),
      # tabPanel("Legend", plotOutput("legend"))
      
    # )
    )
  )
))
