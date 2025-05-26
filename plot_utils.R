source("config.R")

#' Configure plotly modebar
#' @return List of modebar configuration
get_modebar_config <- function() {
  list(
    remove = c(
      "autoScale2d", "autoscale", "editInChartStudio", "editinchartstudio",
      "hoverCompareCartesian", "hovercompare", "lasso", "lasso2d",
      "orbitRotation", "orbitrotation", "pan", "pan2d", "pan3d",
      "reset", "resetCameraDefault3d", "resetCameraLastSave3d",
      "resetGeo", "resetSankeyGroup", "resetScale2d", "resetViewMapbox",
      "resetViews", "resetcameradefault", "resetcameralastsave",
      "resetsankeygroup", "resetscale", "resetview", "resetviews",
      "select", "select2d", "sendDataToCloud", "senddatatocloud",
      "tableRotation", "tablerotation", "toImage", "toggleHover",
      "toggleSpikelines", "togglehover", "togglespikelines", "toimage",
      "zoom", "zoom2d", "zoom3d", "zoomIn2d", "zoomInGeo", "zoomInMapbox",
      "zoomOut2d", "zoomOutGeo", "zoomOutMapbox", "zoomin", "zoomout",
      "displaylogo"
    )
  )
}

#' Create base scatter plot
#' @param data Main dataset
#' @param x_var X variable name
#' @param y_var Y variable name
#' @return Plotly object
create_base_scatter <- function(data, x_var, y_var) {
  plot_ly(
    data,
    x = as.formula(paste0("~", x_var)),
    y = as.formula(paste0("~", y_var)),
    type = "scatter",
    mode = "markers",
    marker = list(color = "rgba(255, 182, 193, 1)"),
    name = "alle"
  )
} 