require(shiny)
require(shinythemes)
require(plyr)
require(httr)
require(googleAuthR)
require(RCurl)
require(xml2)
require(jsonlite)



server <- function(input, output) {

  ###################### private KEYS
  options("googleAuthR.webapp.client_id" = "http://380848655743-qv0engk8osllkdiruu88pbj7fnneou69.apps.googleusercontent.com")
  options("googleAuthR.webapp.client_secret" = "5Lip_I-eNY4k5gUh8bbuhNjO")
  
  
  ### define scope!
  options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
  
  #googleAuthR::gar_auth()
  service_token <- gar_auth_service(json_file="service_account_key.json")
  
  ############################################ helper!
  
  detectObject <- function(txt){
    
    
    ### create Request, following the API Docs.
    body= paste0('{  "requests": [    {   "image": { "content": "',txt,'" }, "features": [  { "type": "WEB_DETECTION", "maxResults": 2} ],  }    ],}')
    ## generate function call
    #print(body)
    
    simpleCall <- gar_api_generator(baseURI = "https://vision.googleapis.com/v1/images:annotate", http_header="POST" )
    ## set the request!
    pp <- simpleCall(the_body = body)
    ## obtain results.
    save(pp, file="json.RData") # tmp_dev
    #res <- pp$content$responses$labelAnnotations[[1]]
    res <- as.character(pp$content$responses$webDetection$bestGuessLabels[[1]])
    
    return(res)
  }

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

  output$res <- renderTable({
    
    if (is.null(input$files)){
      
      dff <- data.frame(x=1:5)
      return(dff)
      
    }else{
      
      args2 <- input$files
      
      
      txt <- base64Encode(readBin(args2$datapath, "raw", args2$size), "txt")
      print("Ciao")
      print(txt)
      dff <<- detectObject(txt)
      
      key <<- detectObject(txt)
      
      #save(key, file="key.RData")
      
      #print(dff)
      
      #return(dff[, c("description", "score")])
      return(dff)
    }
  })
  
    
# Render new photos -----------------------------------------------------------
  
  files <- eventReactive(input$bt_start, {
    
    doc <- xml2::read_xml(paste("http://daten.buergernetz.bz.it/services/kksSearch/collect/lichtbild/select?q=BE_it:(", key, ")%20", "(", key, ")", sep=""))
    
    nodeset <- xml2::xml_children(doc) # get top level nodeset
    ml <- xml2::as_list(nodeset[[2]])
    
    #as.character(ml[[1]][[3]]$str)
    len <- length(ml)
    ls_names <- list()
    for(i in 1:len){
      ls_names[[i]] <- as.character(ml[[i]][[3]]$str)
    }
    
    
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
