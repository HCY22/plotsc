#!/usr/bin/Rscript
# usage : bar_plot.r [option] file
# ex    : bar_plot.r -x sample -y count,count2 bar_plot.txt
# tbd   : two or more types of bars (e.g., -y count,count2) (done)

library("optparse")
library("ggplot2")
library("reshape2")

### set parameter

option_list <- list(
			make_option(c("-x", "--data1"), type = "character"),
			make_option(c("-y", "--data2"), type = "character"),
			make_option(c("-t", "--title"), type = "character"),
			make_option(c("-o", "--output"), type = "character")
)
                    
parser <- OptionParser(option_list = option_list)
arguments <- parse_args(parser, positional_argument = 1)
opt <- arguments$options
file <- arguments$args


### load data

data <- read.csv(file, sep = "\t", header = T)

# select data

cat  <- strsplit(opt$data2, ",")[[1]]
data <- data[c(opt$data1, cat)]

# melt data

data[,opt$data1] <- factor(data[,opt$data1], levels = data[,opt$data1])
data.mt <- melt(data, opt$data1, variable.name = "cat", value.name = "count")


### bar plot

fill <- switch(length(cat) > 1, "cat", NULL)
plot <- ggplot(data.mt, aes_string(x = opt$data1, y = "count", fill = fill)) +
	geom_bar(stat = "identity", position = position_dodge()) +
	scale_y_continuous(expand = c(0,0)) + 
	scale_fill_brewer(palette = "Set1") + theme_classic()

if (!is.null(opt$title)) { plot <- plot + ggtitle(opt$title) }

# only one type of bar

if (is.null(fill)) { plot <- plot + ylab(data.mt[,"cat"][1])}

#ggsave(paste0(file, ".png"), width = 3, height = 3)
if (!is.null(opt$output)) {
	ggsave(opt$output, width = 7, height = 7)
} else {
	ggsave(paste0(file, ".png"), width = 7, height = 7)
}
