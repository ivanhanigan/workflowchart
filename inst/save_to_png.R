library(workflowchart)
# steps <- data.frame(name = c("do 1.1", "do 2.1", "do 3"), from = c("1", "2", "1.1, 2.1"), to = c("1.1", "2.1", "3"))
#steps
#nodes <- workflowchart(indat = steps, names_col = "name", in_col = "from", out_col = "to")
#, clusters_col = "CLUSTER", todo_col="STATUS")
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
  pos_col = "pos"
  ,
  clusters_col = "cluster"
)
DiagrammeR::grViz(nodes)
tmp <- DiagrammeR::grViz(nodes)
tmp <- DiagrammeRsvg::export_svg(tmp)
tmp <- charToRaw(tmp)
rsvg::rsvg_png(tmp, "mindmap_plan.png")
