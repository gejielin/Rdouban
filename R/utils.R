###################################
## @u:url
## @fresh:refresh number

.refreshURL <- function(u, fresh = 15, ssl.verifypeer = TRUE,verbose = TRUE) {
  # p<-tryCatch(htmlParse(getURL(u)),error = function(e){NULL})
  p <- tryCatch(getURL(u,ssl.verifypeer=ssl.verifypeer), error = function(e) {
    print(e)
    return("NULL")
  })
  n = nchar(p)
  k = 1
  while (n < 500) {
    if (verbose == TRUE) {
      #cat("%%%%% 第 ", k, " 次重新请求URL:", u, ".....\n")
      cat("%%%%% \u7b2c ", k, " \u6b21\u91cd\u65b0\u8bf7\u6c42URL:", u, ".....\n")
    }
    p <- tryCatch(getURL(u,ssl.verifypeer=ssl.verifypeer), error = function(e) {
      print(e)
      return("NULL")
    })
    n = nchar(p)
    if (k > 3) {
      Sys.sleep(rnorm(k, 3))
    }
    if (k > fresh) {
      break
    }
    k = k + 1
  }
  if (verbose == TRUE) {
    if (!is.null(p) & k > 1) {
      ## cat("***** 第 ", k - 1, " 次请求成功！\n")
      cat("***** \u7b2c ", k - 1, " \u6b21\u8bf7\u6c42\u6210\u529f\uff01\n")
    }
  }
  if(ssl.verifypeer==FALSE){
    return(p)
  }
  else{
    p <- tryCatch(htmlParse(p), error = function(e) {
      print(e)
      return(NULL)
    })
    return(p)
  }
}
###################################
## @u:url
## @fresh:refresh number

.refreshForm<-function(u,fresh=10,verbose=TRUE){
  p<-tryCatch(htmlParse(postForm(u)),error = function(e){NULL})
  #p<-tryCatch(postForm(u),error = function(e){print(e);return("NULL")})
  n=nchar(p)
  k=1
  while(is.null(p)){
    if(verbose==TRUE){
      ## cat("%%%%% 第 ",k," 次重新请求URL:",u,".....\n")
      cat("%%%%% \u7b2c ",k," \u6b21\u91cd\u65b0\u8bf7\u6c42URL:",u,".....\n")
    }
    p<-tryCatch(htmlParse(postForm(u)),error = function(e){print(e);return(NULL)})
    #saveXML(p,file=paste0(k,gsub("http:|/|\\?","_",u),".html"))
    if(k>3){Sys.sleep(rnorm(k,3))}
    if(k>fresh) {break}
    k=k+1
  }
  if(verbose==TRUE){
    if(!is.null(p) & k>1){
      ##cat("***** 第 ",k-1," 次请求成功！\n")
      cat("***** \u7b2c ",k-1," \u6b21\u8bf7\u6c42\u6210\u529f\uff01\n")
    }
  }
  #saveXML(p,file=paste0(k,gsub("http:|/|\\?","_",u),".html"))
  return(p)
}