# library(workflowchart)
# 
# check if in working directory or not and move if needed
if(file.exists("inst")) setwd("inst")
source("../R/workflowchart2.R")
# steps <- data.frame(name = c("do 1.1", "do 2.1", "do 3", "do 3", "1.1"),
#                     from = c("1", "2", "1.1", "2.1", "do 1.1"),
#                     to = c("1.1", "2.1", "3", "3", "do 3"),
#                     pos = c("-10,-10!", "-10,-5!", "0,-10!", "0,-10!", "-5,-10!"),
#                     cluster = c("second", "first", "second", "second", "second")
#                     )
steps<-read.table(textConnection("name|from|to|pos|cluster|desc
do2.1|2|2.1|-10,-5!|first|
2.1|do2.1|do3|-5,-8!|first|
do1.1|1|1.1|-10,-10!|second|
do3|1.1|3|0,-10!|second|
do3|2.1|3|0,-10!|second|
1.1|do1.1|do3|-5,-10!|second|
3|do3|do3|2.5,-11.5!|second|
"),
                                   sep = "|",
                                   header = T)

 knitr::kable(steps)
# write.csv(steps, "mindmap_plan.csv", row.names = F)
# steps <- read.csv("mindmap_plan.csv", stringsAsFactors = T)
knitr::kable(steps)
steps$desc <- ifelse(is.na(steps$desc), "", steps$desc)
nodes <- workflowchart2(
  indat = steps
  , 
  names_col = "name"
  , 
  in_col = "from"
  , 
  out_col = "to"
 ,
 desc_col = "desc"
 ,
 pos_col = "pos")
 # ,
 # clusters_col = "cluster"
 # )#,
                        
                        #
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
