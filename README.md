# Grassland Explorer

A Shiny application for exploring grassland data with interactive maps and visualizations.

## Project Structure

The project has been reorganized to improve maintainability and code organization:

### Configuration Files
- `config.R`: Contains all configuration values and constants
  - Color definitions for drawing and selection
  - Bivariate color palette
  - Map configuration (bounds and base groups)

### Utility Files
- `map_utils.R`: Map-related utility functions
  - `initialize_map()`: Creates and configures the base leaflet map
  - `create_bivariate_matrix()`: Generates bivariate color matrices for visualization

- `plot_utils.R`: Plot-related utility functions
  - `get_modebar_config()`: Configures the plotly modebar
  - `create_base_scatter()`: Creates base scatter plots

### Main Application Files
- `server.R`: Main Shiny server logic
  - Handles reactive data processing
  - Manages map interactions
  - Controls plot updates

## Recent Changes

The codebase has been refactored to improve:

1. **Code Organization**
   - Separated configuration into dedicated files
   - Created utility functions for common operations
   - Removed duplicated code

2. **Maintainability**
   - Improved code readability
   - Removed commented-out code
   - Simplified reactive expressions

3. **Modularity**
   - Map initialization is now a separate function
   - Plot creation is more modular
   - Configuration is centralized

## Usage

The application provides:
- Interactive map visualization
- Bivariate data analysis
- Scatter plot visualization
- Data filtering capabilities

## Dependencies

The application requires the following R packages:
- shiny
- leaflet
- plotly
- dplyr
- sf
- classInt 