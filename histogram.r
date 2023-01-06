#!/usr/bin/env Rscript
# usage : histogram.r [option] file
# to do : draw histogram (facet)

library("optparse")
library("ggplot2")


### set parameter

option_list <- list(
			make_option(c("-x", "--data"), type = "character"),
			make_option(c("-g", "--group"), type = "character"),
			make_option(c("-t", "--title"), type = "character"),
			make_option(c("-o", "--output"), type = "character"),
			make_option(c("--xmin"), type = "double", default = NA),
			make_option(c("--xmax"), type = "double", default = NA),
			make_option(c("--binsize"), type = "double")
)

parser <- OptionParser(option_list = option_list)
arguments <- parse_args(parser, positional_argument = 1)
opt <- arguments$options
file <- arguments$args

### load data

data <- read.csv(file, sep = "\t", header = T)

plot <- ggplot(data, aes_string(x = opt$data)) +
		geom_histogram(binwidth = opt$binsize, color = "black", fill = "white") +
		coord_cartesian(xlim = c(opt$xmin, opt$xmax))

if (!is.null(opt$group)) {
	plot <- plot + facet_grid(reformulate(".", opt$group))
}

if (!is.null(opt$output)) {
	ggsave(opt$output, width = 7, height = 7)
} else {
	ggsave(paste0(file, ".png"), width = 7, height = 7)
}
