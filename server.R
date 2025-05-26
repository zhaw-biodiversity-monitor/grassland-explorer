source("libraries.R")
source("utils.R")
source("config.R")
source("map_utils.R")
source("plot_utils.R")

grassland <- read_csv("appdata/normallandschaft.csv")

datasets <- c("normallandschaft")
names(datasets) <- datasets
dataset_list <- map(datasets, \(x)read_csv(file.path("appdata",paste0(x,".csv"))))

gpkg_path <- "appdata/vectors.gpkg"
geodata <- read_all_layers(gpkg_path, "layers_overview")

shinyServer(function(input, output) {
  output$map <- renderLeaflet({
    initialize_map()
  })

  geodata_i <- reactive({
    select_dataset(geodata, input$aggregation, input$datensatz)
  })

  dataset_i <- reactive({
    dataset_list[[input$datensatz]]
  })

  observe({
    geodata_i <- geodata_i()
    ycol <- geodata_i[[input$column_y]]
    n_obs <- geodata_i[["n"]]

    geodata_i$label <- paste(
      paste(input$column_y, round(ycol, 2), sep = ":"),
      paste("Anzahl Erhebungen", n_obs, sep = ":"),
      sep = "<br>"
    )

    n_classes <- 3
    fac_levels <- expand_grid(seq_len(n_classes), seq_len(n_classes)) |>
      apply(1, paste, collapse = "-")

    n_obs_interval <- classIntervals(n_obs, n_classes, "jenks")
    ycol_interval <- classIntervals(ycol, n_classes, "jenks")

    n_obs_grp <- findCols(n_obs_interval)
    ycol_grp <- findCols(ycol_interval)

    geodata_i$grp <- factor(paste(n_obs_grp, ycol_grp, sep = "-"), levels = fac_levels)

    bivariate_matrix <- create_bivariate_matrix(bivariate_palette, n_classes, var_name = input$column_y)
    legend_html <- create_legend(bivariate_matrix, clean_names(input$column_y))

    pal_col <- as.vector(bivariate_matrix)
    pal <- colorFactor(pal_col, levels = fac_levels, alpha = TRUE)

    leafletProxy("map", data = geodata_i) |>
      clearShapes() |>
      clearControls() |>
      addControl(legend_html, position = "bottomleft", className = "") |>
      addPolygons(
        fillColor = ~ pal(grp),
        color = ~ pal(grp),
        fillOpacity = 1,
        opacity = 0,
        label = ~ lapply(label, htmltools::HTML)
      )
  })

  observe({
    geodata_i <- geodata_i()
    selvec <- as.vector(geodata_i[, input$aggregation, drop = TRUE]) == selected_object()

    leafletProxy("map", data = geodata_i[selvec, ]) |>
      clearGroup("polygonselection") |>
      addPolygons(fillOpacity = 0, group = "polygonselection", color = mycols$selected_polygon$hex, fill = FALSE)
  })

  ranges <- reactive({
    all_features <- input$map_draw_all_features
    features <- all_features$features
    coords <- map(features, \(x)x$geometry$coordinates[[1]])
    map(coords, \(x) {
      x |>
        map(\(y)c(y[[1]], y[[2]])) |>
        do.call(rbind, args = _) |>
        apply(2, range)
    })
  })

  grassland_inbounds <- reactive({
    if (length(ranges()) > 0) {
      ranges <- ranges()[[1]]
      lat <- ranges[, 2]
      lng <- ranges[, 1]
      dataset_i() |>
        filter(
          lange > min(lng),
          lange < max(lng),
          breite > min(lat),
          breite < max(lat)
        )
    } else {
      dataset_i()[FALSE, ]
    }
  })

  selected_object <- reactiveVal("")
  observeEvent(input$map_shape_click, {
    loc_list <- input$map_shape_click
    geodata_i <- select_dataset(geodata, input$aggregation, input$datensatz)
    loc <- st_point(c(loc_list$lng, loc_list$lat)) |>
      st_sfc(crs = 4326)

    selected_object_str <- as.vector(geodata_i[loc, input$aggregation, drop = TRUE])
    selected_object(selected_object_str)
  })

  grassland_renamed <- reactive({
    dataset_i() |>
      rename(column_y = input$column_y) |>
      rename(agg = input$aggregation)
  })

  grassland_inbounds_renamed <- reactive({
    grassland_inbounds() |>
      rename(column_y = input$column_y) |>
      rename(agg = input$aggregation)
  })

  output$scatterplot <- renderPlotly({
    fig <- create_base_scatter(grassland_renamed(), "meereshohe", "column_y") |>
      add_trace(
        data = grassland_inbounds_renamed(),
        color = "",
        marker = list(
          color = "rgba(255,255,255,0)",
          line = list(color = mycols$drawing$rgba_string, width = 2)
        ),
        name = "in der Auswahl"
      )

    if (selected_object() != "") {
      grassland_inpolygon <- grassland_renamed()[grassland_renamed()$agg == selected_object(), ]
      fig <- fig |>
        add_trace(
          data = grassland_inpolygon,
          color = "",
          marker = list(
            color = "rgba(255,255,255,0)",
            line = list(color = mycols$selected_polygon$rgba_string, width = 2)
          ),
          name = "in polygon"
        )
    }

    fig |>
      layout(
        hovermode = FALSE,
        clickmode = "none",
        yaxis = list(title = paste0(clean_names(input$column_y))),
        xaxis = list(title = "Meereshöhe (m ü.M.)"),
        modebar = get_modebar_config()
      )
  })
})
