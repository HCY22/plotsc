#!/usr/bin/Rscript
# usage : pca.r -g [group_file] [infile]
# to do : PCA plot

#  V S1 S2 S3 S4 ...  #  V group
# V1                  # V1     1
# V2                  # V2     1
# V3                  # V3     2
# V4                  # V4     2
#  :                  #  :


library("optparse")
library("FactoMineR")
library("factoextra")

### set parameter

option_list <- list(
			make_option(c("-g", "--group"),  type = "character"),
			make_option(c("-t", "--title"),  type = "character"),
			make_option(c("-o", "--output"), type = "character")
)

parser    <- OptionParser(option_list = option_list)
arguments <- parse_args(parser, positional_argument = 1)
opt       <- arguments$options
file      <- arguments$args

### load data

data <- read.csv(file, sep = "\t", header = T)


### calculate pca

if(!is.null(opt$group)) {
	map  <- read.csv(opt$group, sep = "\t", header =T)
	data <- merge(data, map, by.x = colnames(data)[1], by.y = colnames(map)[1])
	pca  <- PCA(data[,2:(ncol(data)-1)], graph =F)
	data$group <- factor(data$group)
	plot <- fviz_pca_ind(pca, label="none", habillage= data$group, addEllipses=T, invisible="quali", axes.linetype="blank", pointsize = 2) +
		labs(x = paste("PC1 (", format(pca$eig[1,2], digits=4), "%)", sep=""),
			 y = paste("PC2 (", format(pca$eig[2,2], digits=4), "%)", sep=""), title = "") + 
			theme(legend.text = element_text(size = 15), legend.title = element_text(size = 15)) + theme_classic()
} else {
	pca  <- PCA(data[,2:ncol(data)], graph =F)
	plot <- fviz_pca_ind(pca, label="none", invisible="quali", axes.linetype="blank", pointsize = 2) +
		labs(x = paste("PC1 (", format(pca$eig[1,2], digits=4), "%)", sep=""),
			 y = paste("PC2 (", format(pca$eig[2,2], digits=4), "%)", sep=""), title = "") + 
			theme(legend.text = element_text(size = 15), legend.title = element_text(size = 15)) + theme_classic()
}

### output

if(!is.null(opt$output)) {
	ggplot2::ggsave(opt$output)
} else {
	ggplot2::ggsave(paste0(file, ".png"))
}
