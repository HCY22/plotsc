#!/usr/bin/Rscript
# usage : pcoa_plot.r [option] distance_matrix
# to do : draw pcoa plot

library("ape")
library("ggplot2")
library("ggrepel")
library("optparse")


### set parameter

option_list <- list(
			make_option(c("-t", "--title"), type = "character"),
		    make_option(c("-g", "--group"), type = "character"),
		    make_option(c("-l", "--label"), action = "store_true")
		    )
                    
parser    <- OptionParser(option_list = option_list)
arguments <- parse_args(parser, positional_arguments = 1)
opt       <- arguments$options
file      <- arguments$args

options(ggrepel.max.overlaps = Inf)


### load data

data <- read.table(file, sep = "\t", header=T, row.names=1)

# convert to distance struct
data.dist <- as.dist(data)


### pcoa and plot

res <- pcoa(data.dist, correction="none")

# take the first two vectors
data <- res$vectors[,1:2]

if(!is.null(opt$group)) {
	map  <- read.csv(opt$group, sep = "\t", header =T)
	data <- merge(data, map, by.x = 0, by.y = colnames(map)[1])
} else {
	data <- cbind(Row.names=rownames(data), data.frame(data, row.names=NULL), group=0)
}

# pcoa eigenvalue
eig <- as.numeric(res$value[,1])

# plot
plot <- ggplot(data, aes(x = Axis.1, y = Axis.2, label = Row.names, color = group)) + geom_point(alpha=.7, size=2) +
	theme(legend.position="none") +
	labs(x=paste("PCoA 1 (", format(100 * eig[1] / sum(eig), digits=4), "%)", sep=""),
		 y=paste("PCoA 2 (", format(100 * eig[2] / sum(eig), digits=4), "%)", sep=""))

if (!is.null(opt$group)) { plot <- plot + stat_ellipse(level = 0.95)}
#if (!is.null(opt$group)) { plot <- plot + stat_ellipse(geom = "polygon", aes(fill = group), level = 0.95, alpha = 0.25) }
if (!is.null(opt$label)) { plot <- plot + geom_text_repel(size = 4) }
if (!is.null(opt$title)) { plot <- plot + ggtitle(opt$title) }

ggsave(paste0(file,".pcoa.png"))
