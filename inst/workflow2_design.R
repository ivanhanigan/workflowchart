# library(workflowchart)
# 
# 
source("R/workflowchart2.R")
steps <- data.frame(name = c("do 1.1", "do 2.1", "do 3", "do 3"),
                    from = c("DONTSHOW", "2", "1.1", "2.1"),
                    to = c("1.1", "2.1", "3", "3"),
                    pos = c("-10,-10!", "-10,-5!", "0,0!", "")
                    )
# knitr::kable(steps)
# write.csv(steps, "inst/mindmap_plan.csv", row.names = F)
steps <- read.csv("inst/mindmap_plan.csv", stringsAsFactors = T)
steps$desc <- "" #ifelse(is.na(steps$desc), "", steps$desc)
nodes <- workflowchart2(
  indat = steps
  , 
  names_col = "name"
  , 
  in_col = "from"
  , 
  out_col = "to"
  , 
  pos_col = "pos"
  )#, 
                        #desc_col = "desc")#,
                        #clusters_col = "cluster")
                        #,
                        #todo_col = "todo")
cat(nodes)
# 
# 
# DiagrammeR::grViz(nodes)
# ## but if you want positioning you need neato, which needs graphviz (not R-DiagrammeR)
# nodes <- 'digraph transformations {
# 
# "1" -> "do 1.1"
# "do 1.1"  [ shape=record, label="{{ { Name | Description } | { do 1.1 |  } }}", pos = "-10,-10!"] 
# "do 1.1" -> "1.1"
# 
#  
# "2" -> "do 2.1"
# "do 2.1"  [ shape=record, label="{{ { Name | Description } | { do 2.1 |  } }}", pos = "-5,-5!"] 
# "do 2.1" -> "2.1"
# 
#  
# "1.1" -> "do 3"
# "2.1" -> "do 3"
# "do 3"  [ shape=record, label="{{ { Name | Description } | { do 3 |  } }}", pos = "0,0!"] 
# "do 3" -> "3"
#  
# }'
## 
sink("mindmap_plan.dot")
cat(nodes)
sink()
system("dot -Kneato -Tpng mindmap_plan.dot -o mindmap_plan.png")
dir()
## browseURL("mindmap_plan.png")
