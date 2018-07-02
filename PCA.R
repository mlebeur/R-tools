#! /usr/bin/Rscript

#http://factominer.free.fr/index_fr.html

###################################
#For interactive R shiny plots :
#http://factominer.free.fr/graphs/factoshiny-fr.html

library(Factoshiny)
library(FactoMineR)
data(decathlon)
res.pca = PCA(decathlon, quanti.sup=11:12,quali.sup=13)
library(Factoshiny)
resshiny = PCAshiny(res.pca) 

###################################
#For autamted report writing :
#http://factominer.free.fr/reporting/index_fr.html

library(FactoInvestigate)
library(FactoMineR)
data(decathlon)
res = PCA(decathlon, quanti.sup = 11:12, quali.sup=13, graph=FALSE)
Investigate(res) 
