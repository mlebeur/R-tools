#! /usr/bin/Rscript

#################################
#Create a dataset :
#################################
test = matrix(rnorm(200), 20, 10)
test[1:10, seq(1, 10, 2)] = test[1:10, seq(1, 10, 2)] + 3
test[11:20, seq(2, 10, 2)] = test[11:20, seq(2, 10, 2)] + 2
test[15:20, seq(2, 10, 2)] = test[15:20, seq(2, 10, 2)] + 4
colnames(test) = paste("Test", 1:10, sep = "")
rownames(test) = paste("Gene", 1:20, sep = "")

#################################
#Play with options :
#################################
pheatmap(test)

pheatmap(test, scale="row")

hmcols<-colorRampPalette(c("blue","white","red"))(3)
pheatmap(test, scale="row", color = hmcols)

hmcols<-colorRampPalette(c("blue","white","red"))(10)
pheatmap(test, scale="row", color = hmcols)

pheatmap(test, cellwidth = 15, cellheight = 12, main = "Example heatmap")

#################################
#Misibility problem with too much data :
#################################

test = matrix(rnorm(200), 500, 10)
test[1:250, seq(1, 10, 2)] = test[1:250, seq(1, 10, 2)] + 3
test[201:450, seq(2, 10, 2)] = test[201:450, seq(2, 10, 2)] + 2
test[401:500, seq(2, 10, 2)] = test[401:500, seq(2, 10, 2)] + 4
colnames(test) = paste("Test", 1:10, sep = "")
rownames(test) = paste("Gene", 1:500, sep = "")

pheatmap(test, cellwidth = 15, cellheight = 12, fontsize = 8, filename = "test.pdf")
