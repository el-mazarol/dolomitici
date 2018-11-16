require(shiny)
require(shinythemes)


server <- function(input, output) {


# File imported -----------------------------------------------------------

  files <- eventReactive(input$bt_start, {
    #files <- input$files
    #files$datapath <- gsub("\\\\", "/", files$datapath)
    
    files <- tempfile()
    download.file("https://cert.provinz.bz.it/services/kksSearch/image?file=LAV039-01048.jpg&mus=LAV", destfile = files)
    
    #files <- data.frame(datapath=files)
    
    #save(files, file="1file_url.RData") # tmp_dev
    
    files
  })
  
  # output$images <- renderUI({
  #   if(is.null(input$files)) return(NULL)
  #   image_output_list <- 
  #     lapply(1:nrow(files()),
  #            function(i)
  #            {
  #              imagename = paste0("image", i)
  #              imageOutput(imagename)
  #            })
  #   
  #   do.call(tagList, image_output_list)
  # })
  
  output$images <- renderImage({
    list(src = files())
  }, deleteFile = FALSE)
  
  # observe({
  #   #if(is.null(input$files)) return(NULL)
  #   for (i in 1:nrow(files()))
  #   {
  #     print(i)
  #     local({
  #       my_i <- i
  #       imagename = paste0("image", my_i)
  #       print(imagename)
  #       output[[imagename]] <- 
  #         renderImage({
  #           list(src = files()$datapath[my_i],
  #                alt = "Image failed to render")
  #         }, deleteFile = FALSE)
  #     })
  #   }
  # })

# Query new photos


# Render new photos

  
} # END Server
