#' urlr
#'
#' Convert selected text into a url
#'
#' @return a markdown image link
#' @export
#' @importFrom rstudioapi getSourceEditorContext modifyRange
#'
urlr <- function() {
  
  adc <- rstudioapi::getSourceEditorContext()
  
  before_last_space <- '(\\s)(?!.*\\s)(.*?)$'
  after_last_space <- '^(.*?)(\\s)(?!.*\\s)'
  
  txt <- adc$selection[[1]]$text
  
  txt_last <- gsub(after_last_space,'',txt, perl = TRUE)
  txt_last <- ifelse(is_link(txt_last),txt_last,"# Error : selection is not an image link")
  
  content <- switch(as.character(strc(txt = txt)),
                    '0' = '[]()' ,
                    '-1' = {
                      if(is_link(txt_last)){
                        sprintf('(%s)[%s]',txt_last,txt_last)
                      }else{
                        sprintf('()[%s]',txt_last,txt_last)   
                      }
                    },
                    sprintf('(%s)[%s]',gsub(before_last_space,'',txt, perl = TRUE),txt_last)
  )
  
  rstudioapi::modifyRange(location = adc$selection[[1]]$range, text = content, id = adc$id)

}
