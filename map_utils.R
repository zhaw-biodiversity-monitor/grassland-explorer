source("config.R")

#' Initialize the base map
#' @return A leaflet map object
initialize_map <- function() {
  leaflet() |>
    addTiles(
      "https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-grau/default/current/3857/{z}/{x}/{y}.jpeg",
      group = "Pixelkarte grau"
    ) |>
    addTiles(
      "https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg",
      group = "Swissimage"
    ) |>
    addTiles(
      "https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg",
      group = "Pixelkarte farbig"
    ) |>
    addLayersControl(baseGroups = map_config$base_groups) |>
    fitBounds(
      map_config$bounds$lng1,
      map_config$bounds$lat1,
      map_config$bounds$lng2,
      map_config$bounds$lat2
    ) |>
    addDrawToolbar(
      polylineOptions = FALSE,
      polygonOptions = FALSE,
      circleOptions = FALSE,
      markerOptions = FALSE,
      circleMarkerOptions = FALSE,
      singleFeature = TRUE,
      rectangleOptions = drawRectangleOptions(
        shapeOptions = drawShapeOptions(
          color = as.character(mycols$drawing$hex),
          fill = FALSE,
          weight = 2
        )
      ),
      editOptions = editToolbarOptions()
    )
}

#' Create bivariate color matrix
#' @param palette Vector of colors
#' @param n_classes Number of classes
#' @param alpha_range Range of alpha values
#' @param var_name Name of the variable to check for reversed palette
#' @return Color matrix
create_bivariate_matrix <- function(palette, n_classes, alpha_range = c(.20, 0.95), var_name = NULL) {
  # Check if we need to reverse the palette
  if (!is.null(var_name) && var_name %in% reversed_palette_vars) {
    palette <- rev(palette)
  }
  bivariate_matrix_alpha(palette, n_classes, alpha_range)
} 