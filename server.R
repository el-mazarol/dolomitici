require(shiny)
require(shinythemes)


server <- function(input, output) {
 
  output$preImage <- renderImage({
    # When input$n is 3, filename is ./images/image3.jpeg
    filename <- "www/esempio.jpeg"
      
      # normalizePath(file.path('./images',
      #                                   paste('image', input$n, '.jpeg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste("Image number"))
    
  }, deleteFile = FALSE) 
 
}
