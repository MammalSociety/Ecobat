#load packages - not sure if necessary
library(shiny) 
library(rmarkdown) 
library(ggplot2)
library(knitr)
library(pander)
library(dplyr)
library(tidyr)
library(rcompanion)

shinyServer(function(input, output) {
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    
    data1 <- input$file #grabs uploaded file
    
    if (is.null(data1)) #if no data has been uploaded, main panel is empty
      return(NULL)
    
    data2 <- read.csv(data1$datapath, header=TRUE)
    data2 #if data has been uploaded, it reads it and then displays in the main panel
  })
  
  # this reactive output tells Shiny that once data has been uploaded it should display a   download button for the
  # Rmd report. If no data has been uploaded then the button will not appear.
  output$ui.download <- renderUI({
    if (is.null(input$file)) return() #if no data uploaded button is not present
    downloadButton("report", "Generate report")}) #if data uploaded button appears
  
  output$ui.download.helper <- renderUI({
    if (is.null(input$file)) return() #if no data uploaded, helper text associated with      the download button not present
    h5(helpText("Report may take a few minutes to generate; please be patient."))})
  #if data uploaded, helper text associated with the download button appears
  
  output$report <- downloadHandler(
    filename = "Ecobat Nightly Report.doc", #we want word document output
    
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "Nightly.Rmd") 
      file.copy("Nightly.Rmd", tempReport, overwrite = TRUE)
      
      #**CRUCIAL CODE
      # this code is responsible for passing the data to Rmd.
      dataa<-input$file #tells R Markdown where it can find data
      datab<-read.csv(dataa$datapath, header=TRUE) #tells Rmd where to read the data from
      author<-input$Author #tells Rmd what to use as Author
      #**END CRUCIAL CODE
      
      # Set up parameters to pass to Rmd document
      params <- list(n = datab, Author=author)
      
      word_document <- function(toc = FALSE,
                                toc_depth = 3,
                                fig_width = 5,
                                fig_height = 4,
                                fig_caption = TRUE,
                                df_print = "default",
                                smart = TRUE,
                                highlight = "default",
                                reference_docx = "stylesdoc.docx",
                                keep_md = FALSE,
                                md_extensions = NULL,
                                pandoc_args = NULL) {
        
        
        
        # reference docx
        args <- c(args, reference_doc_args("docx", reference_docx))
        
        
        
        saved_files_dir <- NULL
        pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir) {
          saved_files_dir <<- files_dir
          NULL
        }
        
        intermediates_generator <- function(...) {
          reference_intermediates_generator(saved_files_dir, ..., reference_docx)
        }
        
        # return output format
        output_format(
          knitr = knitr,
          pandoc = pandoc_options(to = "docx",
                                  from = from_rmarkdown(fig_caption, md_extensions),
                                  args = args),
          keep_md = keep_md,
          df_print = df_print,
          pre_processor = pre_processor,
          intermediates_generator = intermediates_generator
        )
      }
      
      reference_doc_args <- function(type, doc) {
        if (is.null(doc) || identical(doc, "default")) return()
        c(paste0("--reference-", if (pandoc2.0()) "doc" else {
          match.arg(type, c("docx", "odt", "doc"))
        }), pandoc_path_arg(doc))
      }
      
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, word_document(reference_docx = "stylesdoc.docx"),
                        output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv()))
                        
      
    })  
  
})

