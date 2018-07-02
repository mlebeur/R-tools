
library("AnnotationDbi")
library("org.Mm.eg.db")

#Extract ensembl ID for all genes
symbolID <-
  mapIds(org.Mm.eg.db, #database selected, here Mus musculus
         keys=as.vector(as.character(Counts$X__1)), #input data (query), here gene symbol from the matrix row names
         column="SYMBOL", #output data (subject), here the ensembl ID (must be a value contain in columns(org.Mm.eg.db) result)
         keytype="ENSEMBL", #type of input data (query type), here gene symbol (must be a value contain in columns(org.Mm.eg.db) result)
         multiVals="first") #to select only the first results for each query


install.packages(c("shiny", "RColorBrewer", "lattice", "reshape2", "tabplot", "googleVis"))
source("http://bioconductor.org/biocLite.R")
biocLite("flowCore")


symbolID <-
  mapIds(org.Mm.eg.db, #database selected, here Mus musculus
         keys=as.vector(lib1.T.Treg.GFPpos.09122016_ATTACTCG.TAAGATTA_L003.sorted.counts[,1]), #input data (query), here gene symbol from the matrix row names
         column="SYMBOL", #output data (subject), here the ensembl ID (must be a value contain in columns(org.Mm.eg.db) result)
         keytype="ENSEMBL", #type of input data (query type), here gene symbol (must be a value contain in columns(org.Mm.eg.db) result)
         multiVals="first") #to select only the first results for each query
