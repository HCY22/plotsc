#!/usr/bin/Rscript
# uasge : scatter_plot.r [options] file
# ex    : scatter_plot.r -x ht -y wt -g gender -r scatter_plot.txt

library("optparse")
library("ggplot2")
library("ggrepel")
library("ggpubr")


### set parameter

option_list <- list(
                    make_option(c("-x", "--data1"),  type = "character"),
		    make_option(c("-y", "--data2"),  type = "character"),
		    make_option(c("-g", "--group"),  type = "character"),
		    make_option(c("-t", "--title"),  type = "character"),
		    make_option(c("-l", "--label"),  type = "character"),
			make_option(c("-p", "--position"), type = "character", default = "top"),
		    make_option(c("-o", "--output"), type = "character"),
		    make_option(c("-r", "--regression"), action = "store_true")
		    )

parser    <- OptionParser(option_list=option_list)
arguments <- parse_args(parser, positional_arguments = 1)
opt       <- arguments$options
file      <- arguments$args

options(ggrepel.max.overlaps = Inf)


### load data

data <- read.csv(file, sep = "\t", header = T)


### scatter plot

plot <- ggplot(data, aes_string(x=opt$data1, y=opt$data2, color=opt$group, label=opt$label)) + geom_point(size = 1)

if (!is.null(opt$title)) { plot <- plot + ggtitle(opt$title) }
if (!is.null(opt$label)) { plot <- plot + geom_text_repel(size = 3) }

# regression with mutiple group
if (!is.null(opt$group) && !is.null(opt$regression)) {
	plot <- plot +
	geom_smooth(method = "lm", formula= y~x, se= F, size = .3) +
	stat_regline_equation(aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~~")), size = 3, label.y.npc = "top")

# regression with one group
} else if (!is.null(opt$regression)) {
	plot <- plot +
	geom_smooth(method = "lm", formula= y~x, se= F, size = .3, color = "black") +
	#stat_regline_equation(aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~~")), size = 3, color = "red", label.y.npc = "top")
	stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 3, color = "black", label.y.npc = opt$position)
}

# ouput

if (!is.null(opt$output)) {
        ggsave(opt$output, width = 4, height = 4)
} else {
        ggsave(paste0(file, ".png"), width = 4, height = 4)
}
