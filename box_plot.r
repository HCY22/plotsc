#!/usr/bin/Rscript
# usage : box_plot.r [options] file
# ex    : box_plot.r -x gender -y age -l sample --xorder Male,Female -p t-test box_plot.txt
# tbd   : add p-value method option, set background as white (done)
# pvalue: [t-test, wilcox, anova, kruskal]

library("optparse")
library("ggplot2")
library("ggrepel")
library("ggpubr")


### set parameter

option_list <- list(
			make_option(c("-x", "--data1"),  type = "character"),
			make_option(c("-y", "--data2"),  type = "character"),
			make_option(c("-l", "--label"),  type = "character"),
			make_option(c("-t", "--title"),  type = "character"),
			make_option(c("-o", "--output"), type = "character"),
			make_option(c("-p", "--pvalue"), type = "character"),
			make_option("--xorder", type = "character")
)
                    
parser    <- OptionParser(option_list = option_list)
arguments <- parse_args(parser, positional_argument = 1)
opt       <- arguments$options
file      <- arguments$args


### load data

data <- read.csv(file, sep = "\t", header = T)

# customize order of x-axis

if (!is.null(opt$xorder)) {
	ord <- strsplit(opt$xorder, ",")[[1]]
	data[,opt$data1] <- factor(data[,opt$data1], levels = c(ord))
} else {
	data[,opt$data1] <- factor(data[,opt$data1])
}


### box plot

pos  <- position_jitter(width = .15, seed = 1)
plot <- ggplot(data, aes_string(x = opt$data1, y = opt$data2, label = opt$label)) +
	geom_boxplot(width=.5) +
	geom_point(position = pos, size = 1) +
	theme_classic()

# generate all possible combination
# and calculate p-value

if (!is.null(opt$pvalue)) {
	size <- 3
	options(warn = -1)
	if (opt$pvalue == "t-test") {
		comp <- levels(data[,opt$data1])
		comp <- combn(comp, 2, simplify = F)
		plot <- plot + stat_compare_means(comparisons = comp, paired = FALSE, method = "t.test", size = size)
	} else if (opt$pvalue == "wilcox") {
		comp <- levels(data[,opt$data1])
		comp <- combn(comp, 2, simplify = F)
		plot <- plot + stat_compare_means(comparisons = comp, paired = FALSE, method = "wilcox.test", size = size)
	} else if (opt$pvalue == "anova") {
		plot <- plot + stat_compare_means(method = "anova", size = size)
	} else if (opt$pvalue == "kruskal") {
		plot <- plot + stat_compare_means(method = "kruskal.test", size = size)
	} else {
		write("Undefined method in p-value.", stderr())
		write("Please use [t-test, wilcox, anova, kruskal] to calculate p-value.", stderr())
		quit(status=1)
	}
} 

if (!is.null(opt$label)) { plot <- plot + geom_label_repel(position = pos, size = 4) }
if (!is.null(opt$title)) { plot <- plot + ggtitle(opt$title) } 

if (!is.null(opt$output)) {
	ggsave(opt$output, width = 3, height = 4)
} else {
	ggsave(paste0(file, ".png"), width = 3, height = 4)
}

