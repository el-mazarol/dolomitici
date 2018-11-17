require(shiny)
require(shinythemes)


server <- function(input, output) {


# File imported -----------------------------------------------------------


  
  output$inputImage <- renderImage({
    # When input$n is 3, filename is ./images/image3.jpeg
    if(is.null(input$files)){
      filename <- "www/img_tmp.png"
      # Return a list containing the filename and alt text
      list(src = filename,
           alt = paste("Image number"))
    } else {
      filename <- input$files
      
      # Return a list containing the filename and alt text
      list(src = filename$datapath,
           alt = paste("Image number"))
    }
    
    
    # normalizePath(file.path('./images',
    #                                   paste('image', input$n, '.jpeg', sep='')))
    
    
    
    # filename <- filename$datapath
    # filename
    
  }, deleteFile = FALSE)
  
# Query new photos -----------------------------------------------------------
  
# Render new photos -----------------------------------------------------------
  
  files <- eventReactive(input$bt_start, {
    #files <- input$files
    #files$datapath <- gsub("\\\\", "/", files$datapath)
    
    files <- list()
    
    files[[1]] <- tempfile()
    download.file("https://cert.provinz.bz.it/services/kksSearch/image?file=LAV039-01048.jpg&mus=LAV", destfile = files[[1]])
    
    files[[2]] <- tempfile()
    download.file("https://cert.provinz.bz.it/services/kksSearch/image?file=LAV039-01049.jpg&mus=LAV", destfile = files[[2]])
    
    #files <- data.frame(datapath=files)
    
    #save(files, file="1file_url.RData") # tmp_dev
    
    files
  })
  
  output$images <- renderUI({
    if(is.null(input$files)) return(NULL)

    # ls <- list
    # ls[[1]] <- list(src = files()[[1]])
    # ls[[2]] <- list(src = files()[[2]])
    # 
    # imageOutput(ls)

    image_output_list <-
      #lapply(1:nrow(files()),
      lapply(1:length(files()),       
             function(i)
             {
               imagename = paste0("image", i)
               imageOutput(imagename)
             })

    do.call(tagList, image_output_list)
  })
  
  # output$images <- renderImage({
  #   ls <- list
  #   ls[[1]] <- list(src = files()[[1]])
  #   ls[[2]] <- list(src = files()[[2]])
  #   
  #   ls
  #   
  # }, deleteFile = FALSE)
  
  observe({
    if(is.null(input$files)) return(NULL)
    for (i in 1:length(files()))
    {
      print(i)
      local({
        my_i <- i
        imagename = paste0("image", my_i)
        print(imagename)
        output[[imagename]] <-
          renderImage({
            #list(src = files()$datapath[my_i],
            list(src = files()[[my_i]],
                 alt = "Image failed to render")
          }, deleteFile = FALSE)
      })
    }
  })


  
} # END Server
