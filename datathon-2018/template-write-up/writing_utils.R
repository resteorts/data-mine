# from https://stackoverflow.com/questions/13984470/possible-to-create-latex-multicolumns-in-xtable
#' Constructs a header i.e., groups for an xtable
#'
#' @param df a data.frame or matrix
#' @param grp_names the names of the groups
#' @param span where the groups span
#' @param align the alignment of the groups, defaults to center
#' @param draw_line if the group-names should be underlined
#'
#' @return a list that can be given to the \code{add.to.row} argument of the of \code{print.xtable}
#' @export
#'
#' @examples
#' library(xtable)
#' mx <- matrix(rnorm(16), ncol = 4) 
#' mx <- cbind(paste("Var", 1:4), mx)
#' colnames(mx) <- c("Var", rep(c("X", "Y"), 2))
#' 
#' addtorow <- construct_header(mx, c("", "Group A", "Group B"), span = c(1, 2, 2), "c")
#' print(xtable(mx), add.to.row = addtorow, include.rownames = F, hline.after = F)
construct_header <- function(df, grp_names, span, align = "c", draw_line = T) {
  if (length(align) == 1) align <- rep(align, length(grp_names))
  if (!all.equal(length(grp_names), length(span), length(align)))
    stop("grp_names and span have to have the same length!")
  
  if (ncol(df) < sum(span)) stop("Span has to be less or equal to the number of columns of df") 
  
  header <- mapply(function(s, a, grp) sprintf("\\multicolumn{%i}{%s}{%s}", s, a, grp),
                   span, align, grp_names)
  header <- paste(header, collapse = " & ")
  header <- paste0(header, " \\\\")
  
  if (draw_line) {
    # where do we span the lines:
    min_vals <- c(1, 1 + cumsum(span)[1:(length(span) - 1)])
    max_vals <- cumsum(span)
    line <- ifelse(grp_names == "", "", 
                   sprintf("\\cmidrule(lr){%i-%i}", min_vals, max_vals))
    line <- paste(line[line != ""], collapse = " ")
    
    header <- paste0(header, "  ", line, "\n  ")
  }
  
  addtorow <- list(pos = list(-1, -1, nrow(df)),
                   command = c("\\hline\n  ", header, "\\hline\n  "))
  return(addtorow)
}