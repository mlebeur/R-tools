#https://bioconductor.org/packages/release/bioc/vignettes/flowDensity/inst/doc/flowDensityVignette.pdf

#Do it once
#Install package
source("https://bioconductor.org/biocLite.R")
biocLite("flowAI")
biocLite("flowCore")

#Load functions and datasets
library("flowAI")
library(flowCore)


#Change current directory
mydir = choose.dir()
setwd(mydir)

#Select input file
myfilename = choose.files()
myfile <- exprs(read.FCS(myfilename, transformation = FALSE))
head(myfile)

#Select all fcs files in the directory
fcsfiles <- dir(".", pattern="*fcs$")

# In order to limit memory use, perform batch running 
GbLimit <- 0.1    # decide the limit in gigabyte for your batches of FCS files
size_fcs <- file.size(fcsfiles)/1024/1024/1024    # it calculates the size in gigabytes for each FCS file
groups <- ceiling(sum(size_fcs)/GbLimit)
cums <- cumsum(size_fcs)
batches <- cut(cums, groups) 


#Apply to all
for(i in 1:groups){
  flow_auto_qc(fcsfiles[which(batches == levels(batches)[i])], output = 0, fcs_highQ = "_hQC" , fcs_lowQ = "_lQC") 
}

?flow_auto_qc

#Apply interactive
?flow_iQC()
if (interactive()) flowAI::flow_iQC()

######################################

#https://bioconductor.org/packages/release/bioc/html/flowDensity.html
source("https://bioconductor.org/biocLite.R")
biocLite("flowDensity")
library("flowDensity")

#change directory and create one
setwd("resultsQC")
if (file.exists("nmRemove")){
  #setwd(file.path("./", "nmRemove"))
} else {
  dir.create(file.path("./", "nmRemove"))
  #setwd(file.path("./", "nmRemove"))
  
}

#Select all hQC fcs files in the directory
hQCfcsfiles <- dir(".", pattern="*_hQC.fcs$")

#Remove the margin events
for(i in hQCfcsfiles){
  print(i)
  mycurrentFCSfile = read.FCS(i)
  #all=colnames(mycurrentFCSfile)
  no.margin <- nmRemove(mycurrentFCSfile, c("FSC-A","SSC-A"),verbose=TRUE)
  #no.margin <- nmRemove(mycurrentFCSfile, all ,verbose=TRUE)
  write.FCS(no.margin,paste0("nmRemove/",i))
}
  
######################################
#https://bioconductor.org/packages/release/bioc/vignettes/openCyto/inst/doc/openCytoVignette.html


library(openCyto)
library(flowCore)
library(data.table)
library(mvtnorm)
library(grDevices)


#Select all hQC fcs files in the directory
nMRhQCfcsfiles <- dir("nmRemove", pattern="*_hQC.fcs$")

#read the FCS files into a flowSet (already tranform the data with linearize)
fs <- read.flowSet(nMRhQCfcsfiles, transformation = TRUE)

#loop through flowset and do the compensation for each flowFrame and return the compensated flowFrame,fsApply call will construct a new flowSet for you
fs_comp <- fsApply(fs,function(frame){ 
  comp <- keyword(frame)$SPILL
  new_frame <- compensate(frame,comp)
  new_frame })



#https://support.bioconductor.org/p/51931/

#chnls <- colnames(fs_comp)
#trans <- estimateLogicle(fs_comp[[1]], channels = chnls)
trans <- estimateLogicle(fs_comp[[1]], channels = c("FSC-A","SSC-A"))
gs <- transform(fs_comp, trans)


#Read gating hierachy
gtFile <- system.file("extdata/gating_template/tcell.csv", package = "openCyto")
gtFile = "tcell.csv2"
template<-gatingTemplate(paste0("../",gtFile))

#Gating
#gs <- GatingSet(fs_comp)
gs <- GatingSet(gs)
G<-gating(template,gs)
pdf("plotGatesbysample.pdf")
for(i in c(1:length(hQCfcsfiles))){
  plotGate(gs[[1]])
  plotGate(gs[[2]])
  plotGate(gs[[3]])
  plotGate(gs[[4]])
}
dev.off()


#Do a for loop

singlets <- getData(gs[[1]],"singlets")
singlets #still < 0


class(singlets)
#write.flowSet(gs,"test")
write.FCS(singlets,"test.fcs")

a = read.FCS("test.fcs")


if (file.exists("output")){
  #setwd(file.path("./", "output"))
} else {
  dir.create(file.path("./", "output"))
  #setwd(file.path("./", "output"))
  
}

#Write FCS files into output directory
for(i in c(1:length(hQCfcsfiles))){
  write.FCS(getData(gs[[i]],"singlets"),paste0("output/",hQCfcsfiles[i]))

}


#https://www.bioconductor.org/help/course-materials/2014/BioC2014/OpenCytoPracticalComponent.html
 
