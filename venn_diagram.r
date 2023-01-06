#!/usr/bin/Rscript
# usage  : venn_diagram.r file
# manual : https://cran.r-project.org/web/packages/ggVennDiagram/ggVennDiagram.pdf

library("ggVennDiagram")

args <- commandArgs(T)

data <- read.csv(args[1], sep="\t", header=T)

# convert to list and remove blank
#data <- lapply(data, function(x) x[!x %in% ""])

# convert to list using otu format
data <- lapply(data[2:ncol(data)], function(x) data[,1][!x %in% 0])

# venn diagram
plot <- ggVennDiagram(data, label_alpha=0) + 
	ggplot2::scale_fill_gradient(low = "#F4FAFE", high = "#4981BF")

ggplot2::ggsave(paste0(args[1], ".png"), width = 6, height = 6)
