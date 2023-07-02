'
indat = steps
names_col = "name" 
in_col = "from"
out_col = "to" 
desc_col = NULL
pos_col = "pos"
clusters_col = "cluster"
todo_col = NULL
nchar_to_snip = 40
sideways = F
'
workflowchart2 <- function (indat, names_col = NULL, in_col = NULL, out_col = NULL, 
    desc_col = NULL, clusters_col = NULL, todo_col = NULL, nchar_to_snip = 40, 
    pos_col = NULL,
    sideways = F) 
{
    if (is.null(names_col)) 
        stop("Names of the steps are needed")
    if (is.null(in_col)) 
        stop("Inputs are needed")
    if (is.null(out_col)) 
        stop("Outputs are needed")
    if (is.null(desc_col)) {
        print("Descriptions are strongly recommended, we're creating empty records for you")
        indat$descriptions <- ""
        desc_col <- "descriptions"
    }
    for (i in 1:ncol(indat)) {
        indat[, i] <- gsub("'", "", indat[, i])
    }
    if (!is.null(clusters_col)) {
        cluster_ids <- names(table(indat[, clusters_col]))
        for (cluster_i in cluster_ids) {
            if (cluster_i == cluster_ids[1]) {
                nodes_graph <- sprintf("subgraph cluster_%s {\n    label = \"%s\"\n    ", 
                  cluster_i, cluster_i)
            }
            else {
                nodes_graph <- paste(nodes_graph, sprintf("subgraph cluster_%s {\n    label = \"%s\"\n    ", 
                  cluster_i, cluster_i))
            }
            indat2 <- indat[indat[, clusters_col] == cluster_i, 
                ]
            for (i in 1:nrow(indat2)) {
              # i=1
                indat2[i, ]
                name <- indat2[i, names_col]
                inputs <- unlist(lapply(strsplit(indat2[i, in_col], ","), trimws))
                outputs <- unlist(lapply(strsplit(indat2[i, out_col], ","), trimws))
                desc <- indat2[i, desc_col]
                posi <- ifelse(!is.null(pos_col), paste0(",pos = \"", indat2[i, pos_col], "\""), "")
                if (nchar(name) > 140) 
                  print("that's a long name. consider shortening this")
                if (nchar(desc) > nchar_to_snip) 
                  desc <- paste(substr(desc, 1, nchar_to_snip), 
                    "[...]")
                name2paste <- paste("\"", name, "\"", sep = "")
                inputs <- paste("\"", inputs, "\"", sep = "")
                if(inputs == '\"DONTSHOW\"'){
                  inputs_listed <- ""
                } else {
                inputs_listed <- paste(inputs, name2paste, sep = " -> ", collapse = "\n")
                }
                
                outputs <- paste("\"", outputs, "\"", sep = "")
                outputs_listed <- paste(name2paste, outputs, 
                  sep = " -> ", collapse = "\n")
                if (!is.null(todo_col)) {
                  status <- indat2[i, todo_col]
                  strng <- sprintf("%s\n%s  [ shape=record, label=\"{{ { Name | Description | Status } | { %s | %s | %s } }}\" %s]\n%s\n\n", 
                    inputs_listed, name2paste, name, desc, status, posi,
                    outputs_listed)
                  if (!status %in% c("DONE", "WONTDO", "", NA)) {
                    strng <- gsub("shape=record,", "shape=record, style = \"filled\", color=\"indianred\",", 
                      strng)
                  }
                }
                else {
                  strng <- sprintf("%s\n%s  [ shape=record, label=\"{{ { Name | Description } | { %s | %s } }}\" %s]\n%s\n\n", 
                    inputs_listed, name2paste, name, desc, posi,
                    outputs_listed)
                }
                nodes_graph <- paste(nodes_graph, strng, "\n")
                if (nrow(indat2) == 1) 
                  break
            }
            nodes_graph <- paste(nodes_graph, "}\n\n")
        }
    } else {
        indat2 <- indat
        nodes_graph <- ""
        for (i in 1:nrow(indat2)) {
            indat2[i, ]
            name <- indat2[i, names_col]
            inputs <- unlist(lapply(strsplit(indat2[i, in_col], 
                ","), trimws))
            outputs <- unlist(lapply(strsplit(indat2[i, out_col], 
                ","), trimws))
            desc <- indat2[i, desc_col]
            posi <- ifelse(!is.null(pos_col), paste0(",pos = \"", indat2[i, pos_col], "\""), "")
            if (nchar(name) > 140) 
                print("that's a long name. consider shortening this")
            if (nchar(desc) > nchar_to_snip) 
                desc <- paste(substr(desc, 1, nchar_to_snip), 
                  "[...]")
            name2paste <- paste("\"", name, "\"", sep = "")
            inputs <- paste("\"", inputs, "\"", sep = "")
            if(inputs == '\"DONTSHOW\"'){
              inputs_listed <- ""
            } else {
              inputs_listed <- paste(inputs, name2paste, sep = " -> ", collapse = "\n")
            }
            outputs <- paste("\"", outputs, "\"", sep = "")
            outputs_listed <- paste(name2paste, outputs, sep = " -> ", collapse = "\n")
            # if(outputs == '\"DONTSHOW\"'){
            #   outputs_listed <- ""
            # } else {
            #   outputs_listed <- paste(name2paste, outputs, sep = " -> ", collapse = "\n")
            # }
            if (!is.null(todo_col)) {
                status <- indat2[i, todo_col]
                strng <- sprintf("%s\n%s  [ shape=record, label=\"{{ { Name | Description | Status } | { %s | %s | %s } }}\" %s]\n%s\n\n", 
                  inputs_listed, name2paste, name, desc, status, posi,
                  outputs_listed)
                if (!status %in% c("DONE", "WONTDO", "", NA)) {
                  strng <- gsub("shape=record,", "shape=record, style = \"filled\", color=\"indianred\",", 
                    strng)
                }
            } else {
                strng <- sprintf("%s\n%s  [ shape=record, label=\"{{ { Name | Description } | { %s | %s } }}\" %s]\n%s\n\n", 
                  inputs_listed, name2paste, name, desc, posi,
                  outputs_listed)
            }
            nodes_graph <- paste(nodes_graph, strng, "\n")
        }
    }
    nodes_graph <- paste("digraph transformations {\n\n", nodes_graph, 
        "}\n")
    if (sideways) {
        nodes_graph <- gsub("digraph transformations \\{", "digraph transformations \\{ rankdir=LR;", 
            nodes_graph)
        nodes_graph <- gsub("label=\"\\{\\{", "label=\"\\{", 
            nodes_graph)
        nodes_graph <- gsub("\\{\\{]", "\\{]", nodes_graph)
    }
    cat("# if you have positions then to run this graph use linux terminal\nsink(\"mindmap_plan.dot\")\ncat(nodes)\nsink()\nsystem(\"dot -Kneato -Tpng mindmap_plan.dot -o mindmap_plan.png\")")
    cat("# to run this graph\nsink(\"file_name.dot\")\ncat(nodes_object)\nsink()")
    cat("# If graphviz is installed and on linux\nsystem(\"dot -Tpdf file_name.dot -o file_name.pdf\")\nsystem(\"dot -Tpng file_name.dot -o file_name.png\")\n")
    cat("# if not\nDiagrammeR::grViz(\"file_name.dot\")\n")
    return(nodes_graph)
}

