#!/usr/bin/Rscript
# usage : barplot3d.r
# to do : draw 3d barplot

args   <- commandArgs(TRUE)
input  <- args[1]
output <- args[2]
title  <- args[3]

data    <- read.table(input,sep="\t",header=T,row.names=1, check.names=F)
freq.m  <- as.matrix(data)
sort.l  <- sort(freq.m,decreasing=T)
out.png <- paste(output,".png", sep="")
out.pdf <- paste(output,".pdf", sep="")
out.svg <- paste(output,".svg", sep="")

#==========================================parameter

#png(out.png,width=2160,height=1080)
pdf(out.pdf,width=16,height=9)
#svg(out.svg,width=16,height=9)

# bar and space size
bar.size=4
space.size=10
bs.s<-bar.size+space.size

# plot heigh
h.left=bs.s*10

# bar color
mypalatte = c("#A6CEE3","#FF7F00","#CCCCCC","#FFFB33","#377EB8","#B2DF8A","#09519C","#7F3B08","#666666","#A6761D","#323695","#006837")
col.bar = rev(rep(mypalatte, length.out=ncol(freq.m)))

# angle between xy
anglexy=30
sin.a=sin(anglexy/180*pi)
cos.a=cos(anglexy/180*pi)

# bar outline color and width
col.line="grey"
lwd.line=0.3

# grid color and width
col.bgrid="black";
lwd.bgrid=0.5
col.grid="grey";
lwd.grid=1
col.subgrid="#F0F0F0";
#col.subgrid="#BEBEBE";
lwd.subgrid=0.3

# text color, size and font style
col.lab="#252525"
cex.lab=1
font.lab=2 # 1 or 2 or 3 or 4

# distance between text and y-axis
ylab.pos=0.73

# get max freq and round down
l.f1=as.numeric(substr(sort.l[1],1,1))
l.h=nchar(trunc(sort.l[1]))
l.min=(l.f1+1)*10^(l.h-1)

#==========================================grid

# plot boundary (down, left, top, right)
par(mar=c(8.5,8.5,2,0))

# make an empty plot
plot(0,xlab=NA,ylab=NA,axes=F,xlim=c(0,bs.s*nrow(freq.m)+bs.s*cos.a*ncol(freq.m))*1.2,ylim=c(0,bs.s*(ncol(freq.m)*sin.a+10))*1.1)

# title, pos, size
title(title,line=-1.7,cex.main=2.5)

# draw left front column
#lines(c(0,0),c(0,h.left),col=col.grid,lwd=lwd.grid)

# draw left back column
#lines(c(ncol(freq.m)*bs.s*cos.a,ncol(freq.m)*bs.s*cos.a),c(ncol(freq.m)*bs.s*sin.a,ncol(freq.m)*bs.s*sin.a+h.left),col=col.grid,lwd=lwd.grid)

# right back column
x0=ncol(freq.m)*bs.s*cos.a+nrow(freq.m)*bs.s
y0=ncol(freq.m)*bs.s*sin.a
#lines(c(x0,x0),c(y0,y0+h.left),col=col.grid,lwd=lwd.grid)

# base
polygon(c(0,ncol(freq.m)*bs.s*cos.a,x0,nrow(freq.m)*bs.s),c(0,ncol(freq.m)*bs.s*sin.a,y0,0),col=NULL,border=NA)

# draw left subgrid
for(j in 0:50){
	x1=0
	y1=j*bs.s/5
	x2=x1+ncol(freq.m)*bs.s*cos.a
	y2=y1+ncol(freq.m)*bs.s*sin.a
	lines(c(x1,x2),c(y1,y2),col=col.subgrid,lwd=lwd.subgrid)
}

# draw back subgrid
for(j in 0:50){
	x1=ncol(freq.m)*bs.s*cos.a
	y1=j*bs.s/5+ncol(freq.m)*bs.s*sin.a
	x2=x1+bs.s*nrow(freq.m)
	y2=y1
	lines(c(x1,x2),c(y1,y2),col=col.subgrid,lwd=lwd.subgrid)
}

# draw left grid
for(j in 0:10){
	x1=0
	y1=j*bs.s
	x2=x1+ncol(freq.m)*bs.s*cos.a
	y2=y1+ncol(freq.m)*bs.s*sin.a
	lines(c(x1,x2),c(y1,y2),col=col.grid,lwd=lwd.grid)
}

# draw back grid
for(j in 0:10){
	x1=ncol(freq.m)*bs.s*cos.a
	y1=j*bs.s+ncol(freq.m)*bs.s*sin.a
	x2=x1+bs.s*nrow(freq.m)
	y2=y1
	lines(c(x1,x2),c(y1,y2),col=col.grid,lwd=lwd.grid)
}

#==========================================bar

# each y
for(j in ncol(freq.m):1){

# each x
for(i in 1:nrow(freq.m)){

	# z-axis ratio
	z_r=bs.s/(l.min/10)

	# each bar heigh
	h=z_r*freq.m[i,j]

	# calculate xy position (bar, grid)
	x1=(i-1)*bs.s+space.size/2+space.size/2*cos.a+(j-1)*bs.s*cos.a
	x2=x1+bar.size
	x3=x1+cos.a*bar.size
	x4=x3+bar.size
	y1=((j-1)*bs.s+space.size/2)*sin.a
	y2=y1
	y3=y1+sin.a*bar.size
	y4=y1+sin.a*bar.size

	x5=x1-space.size/2-space.size/2*cos.a
	x6=x5+space.size+bar.size
	x7=x5+(space.size+bar.size)*cos.a
	x8=x6+(space.size+bar.size)*cos.a
	y5=y1-space.size/2*sin.a
	y6=y5
	y7=y5+(space.size+bar.size)*sin.a
	y8=y7

	# draw base grid (front, left, right, back)
	#lines(c(x5,x6),c(y5,y6),col=col.bgrid,lwd=lwd.bgrid)
	#lines(c(x5,x7),c(y5,y7),col=col.bgrid,lwd=lwd.bgrid)
	#lines(c(x6,x8),c(y6,y8),col=col.bgrid,lwd=lwd.bgrid)
	#lines(c(x7,x8),c(y7,y8),col=col.bgrid,lwd=lwd.bgrid)

	# no freq
	#if(freq.m[i,j] == 0){ next }

	# draw bar line (front, left, right, back)
	lines(c(x1,x2),c(y1,y2),col=col.line,lwd=lwd.line)
	lines(c(x1,x3),c(y1,y3),col=col.line,lwd=lwd.line)
	lines(c(x2,x4),c(y2,y4),col=col.line,lwd=lwd.line)
	lines(c(x3,x4),c(y3,y4),col=col.line,lwd=lwd.line)
	lines(c(x1,x1),c(y1,y1+h),col=col.line,lwd=lwd.line)
	lines(c(x2,x2),c(y2,y2+h),col=col.line,lwd=lwd.line)
	lines(c(x3,x3),c(y3,y3+h),col=col.line,lwd=lwd.line)
	lines(c(x4,x4),c(y4,y4+h),col=col.line,lwd=lwd.line)
	lines(c(x1,x2),c(y1+h,y2+h),col=col.line,lwd=lwd.line)
	lines(c(x1,x3),c(y1+h,y3+h),col=col.line,lwd=lwd.line)
	lines(c(x2,x4),c(y2+h,y4+h),col=col.line,lwd=lwd.line)
	lines(c(x3,x4),c(y3+h,y4+h),col=col.line,lwd=lwd.line)

	# fill bar color (front, right, top)
	rect(x1,y1,x2,y2+h,col=col.bar[j],border=NA)
	polygon(c(x2,x4,x4,x2),c(y2,y4,y4+h,y2+h),col=col.bar[j],border=NA)
	polygon(c(x1,x2,x4,x3),c(y1+h,y2+h,y4+h,y3+h),col=col.bar[j],border=NA)

	# draw bar line on color block (front, left, right, back)
	lines(c(x1,x2),c(y1,y2),col=col.line,lwd=lwd.line)
	lines(c(x2,x4),c(y2,y4),col=col.line,lwd=lwd.line)
	lines(c(x1,x1),c(y1,y1+h),col=col.line,lwd=lwd.line)
	lines(c(x2,x2),c(y2,y2+h),col=col.line,lwd=lwd.line)
	lines(c(x4,x4),c(y4,y4+h),col=col.line,lwd=lwd.line)
	lines(c(x1,x2),c(y1+h,y2+h),col=col.line,lwd=lwd.line)
	lines(c(x1,x3),c(y1+h,y3+h),col=col.line,lwd=lwd.line)
	lines(c(x2,x4),c(y2+h,y4+h),col=col.line,lwd=lwd.line)
	lines(c(x3,x4),c(y3+h,y4+h),col=col.line,lwd=lwd.line)

}}

#==========================================text

# x-axis values
text(seq(0.5*bs.s,(nrow(freq.m))*bs.s,by=bs.s),rep(-0.2*bs.s,nrow(freq.m)),labels=rownames(freq.m),font=font.lab,col=col.lab,cex=cex.lab,xpd=T,srt=60,adj=1)

# y-axis values
x=seq(nrow(freq.m)*bs.s+0.5*bs.s*cos.a,nrow(freq.m)*bs.s+(ncol(freq.m)-0.5)*bs.s*cos.a,by=bs.s*cos.a)
y=seq(0.5*bs.s*sin.a,(ncol(freq.m)-0.5)*bs.s*sin.a,by=bs.s*sin.a)
text(x,y-1,pos=4,colnames(freq.m),font=font.lab,col=col.lab,offset=ylab.pos,cex=cex.lab)

# z-axis values
x=0
y=seq(0,h.left,by=bs.s)
#text(x,y,pos=2,paste(seq(0,l.min,by=l.min/10),"%"),font=font.lab,col=col.lab,cex=cex.lab)
text(x,y,pos=2,seq(0,l.min,by=l.min/10),font=font.lab,col=col.lab,cex=cex.lab)

# zlabel
text(0,h.left*7/10,pos=2,"%Frequency",font=font.lab,col=col.lab,cex=1.5,srt=90,xpd=T,offset=3)
while (!is.null(dev.list())) dev.off()
