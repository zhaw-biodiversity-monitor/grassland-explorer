# Color definitions
mycols <- list(
  drawing = list(
    rgba_string = "rgba(0, 51, 255, 1)",
    hex = "#0033FF"
  ),
  selected_polygon = list(
    rgba_string = "rgba(255, 48, 0, 1)",
    hex = "#ff3000"
  )
)

# Bivariate color palette
bivariate_palette <- c("#91BFDB", "#FFFFBF", "#FC8D59")

# Variables that need reversed color palette
reversed_palette_vars <- c("feuchtezahl", "reaktionszahl")

# Map configuration
map_config <- list(
  bounds = list(
    lng1 = 5.955902,
    lat1 = 45.81796,
    lng2 = 10.49206,
    lat2 = 47.80845
  ),
  base_groups = c("Pixelkarte grau", "Pixelkarte farbig", "Swissimage")
) 