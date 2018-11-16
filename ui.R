require(shiny)
require(dygraphs)
require(shinythemes)
require(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("flatly"),
                list(tags$head(HTML('<link rel="icon", href="logo-DI-TAB.png",
                                    type="image/png" />'))),
                
                headerPanel(windowTitle="Argento Vivo Image Explorer",
                               img(src="logo.png", width="200", height="100" ) 
                              ),
                
                div(style="padding: 0px 0px; width: '100%'",
                    titlePanel(
                      title="Argento Vivo Image Explorer"
                    )
                ),
                
                tags$head(
                  tags$style(
                    HTML("
                         a, a:visited {
                         color: #3475b3;
                         font-weight: bold;
                         }
                         
                         a:hover {
                         text-decoration: underline;
                         color: #3475b3;
                         font-weight: bold;
                         }
                         
                         .btn-primary {
                         background-color: #1976D2;
                         border: #1976D2;
                         }
                         
                         .btn-primary:hover {
                         background-color: #1565C0;
                         border: #1565C0;
                         }"
      )
                    )
                    ),
      
      
      
      tabsetPanel(
        tabPanel("Image Search",
                 br(),
                 fluidRow(
                   column(
                     2,
                     wellPanel(
                       fileInput(inputId = 'files', 
                                 label = 'Select an Image',
                                 multiple = TRUE,
                                 accept=c('image/png', 'image/jpeg')) 
                     ),
                     actionButton("bt_start", "Start",
                                  class="btn-primary")
                     
                     
                   ),
                   column(
                     10,
                     uiOutput('images')
                   )
                 )
                 
        ),
        
        tabPanel("Manual Search",
                 br()
                 
        )
      ),
      
      br(),
      br(),
      br(),
      
      tags$footer(title="Titolo", align = "left", style = "
                  bottom:0;
                  position: fixed;
                  width:100%;
                  height:70px; /* Height of the footer */
                  color: #778998ff;
                  padding: 0px;
                  left: 0;
                  background-color: #F1F6F4;
                  z-index: 1000;
                  margin: 0;
                  border-left: none;
                  border-top: 1.5px solid #ccccccff;
                  overflow:auto;",
                  
                  HTML("
                       <br>
                       
                       <p align=\"center\" style=\"font-size: 100%; z-index: 1;\">
                       Supporto e segnalazioni:
                       <a href=\"mailto:andrea.ropele@alperia.eu?Subject=Segnalazione Data Insight - MB Macro View\" target=\"_top\">Send Mail
                       </a>
                       ")
                  
                  )
      
      #   # fluidRow(
      #   #   column(12,
      #            HTML("<div margin: 0; padding: 0;\">
      #               <br>
      #               
      # 							</p><h6 class=\"footer\">
      #   				 		 <span>
      #   				 		 <p align=\"center\" style=\"font-size: 110%;\">
      #   				 		 Supporto e segnalazioni:
      #   				 		 <a href=\"mailto:andrea.ropele@alperia.eu?Subject=Segnalazione Data Insight - MB Macro View\" target=\"_top\">Send Mail</a>
      #   				 		 
      #   				 		 </span>
      #   				 		</h6>
      #   				 		<p></p>
      #               </div>
      #   				 		 ")
      #     #        )
      #     # )
      #     # 
      #   
      
      
      )
