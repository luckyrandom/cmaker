##' Simple template engine.
##'
##' A simple template engine that replace "@@var_name@@" by values
##' from settings.
##' @param template a character verctor storing the template.
##' @param settings the setting variables to be repalced.
##' @return the randered tempalte.
##' @author Chenliang Xu
template <- function(template, settings) {
  for(var in names(settings)) {
    template <- gsub(paste0("@@", var, "@@"),
                  settings[[var]],
                  template)
  }
  return(template)
}
