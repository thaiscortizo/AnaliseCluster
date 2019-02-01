
################################################################
#                     ANÁLISE DE CLUSTER 
################################################################

is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1]) 

if(!is.installed("ggplot2"))
  install.packages("ggplot2", dep = TRUE)

if(!is.installed("cluster"))
  install.packages("cluster")

if(!is.installed("factoextra"))
  install.packages("factoextra")

if(!is.installed("nnet"))
  install.packages("nnet", dep = TRUE)

if(!is.installed("xlsx"))
  install.packages("xlsx")

if(!is.installed("lazyeval"))
  install.packages("lazyeval", dep = TRUE)

if(!is.installed("RCurl"))
  install.packages("RCurl", dep = TRUE)

if(!is.installed("fpc"))
  install.packages("fpc", dep = TRUE)

if(!is.installed("clValid"))
  install.packages("clValid", dep = TRUE)

library(magrittr)
library(formattable)
library(ggplot2)
library(cluster)
library(factoextra)
library(nnet)
library(ClustOfVar)
library(lazyeval)
library(fpc)
require(xlsx)
require(RCurl)

set.seed(1608)

head(dados_taxas)
str(dados_taxas)

# Retirando coluna das cidades pois não é numérica
dados2 <- dados_taxas[, -1]
head(dados2)

row.names(dados_taxas) <- dados_taxas$cidade
summary(dados2)

# Padronizando as variáveis pois as mesmas possuem dimensões diferentes
dados_padr <- scale(dados2)
head(dados_padr)

dist(dados_padr)

# Algoritmo HC com distancia euclidiana 
mun.hc.complete <- hclust(dist(dados_padr), method="complete")
mun.hc.single <- hclust(dist(dados_padr), method="single")

# Plotando
par(mfrow=c(1,3))
plot(mun.hc.complete, main="Complete Linkage", xlab="", sub="",
     cex=.9)
plot(mun.hc.single, main="Single Linkage", xlab="", sub="",
     cex=.9)

# Plotando diferente
par(mfrow=c(1,3))
plot(mun.hc.complete, main="Complete Linkage", xlab="", sub="",
     cex=.9, hang=-1)
plot(mun.hc.single, main="Single Linkage", xlab="", sub="",
     cex=.9, hang=-1)

# Com 4 cluster ligação completa e distância euclidiana
plot(mun.hc.complete, main="HC - Corte em 4 Clusters", xlab="", sub="",
     cex=.9, hang=-1)
abline(h=13, lty=2, lwd=2, col = "#E31A1C")

#
fit <- kmeans(dados_padr, 4) 
clusplot(dados_padr, fit$cluster, color=TRUE, shade=TRUE, labels=4, lines=0,main = "Clusters", xlab = "", ylab = "")


# Determinação do Número de Cluster ideal pela minimização da soma dos quadrados dos clusteres ou pelo auxílio
# visual de um dendrograma

wss <- (nrow(dados_padr)-1)*sum(apply(dados_padr,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(dados_padr,
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Número of Clusters",
     ylab="Soma dos quadrados dentro dos clusteres") 

# A soma dos quadrados dos clusters se mantém constante após o 4 segmento

dendo <- dados_padr %>% dist %>% hclust
plot(dendo)

# fixar uma seed para garantir a reproducibilidade da análise:
set.seed(123) 
# criar os clusteres
lista_clusteres <- kmeans(dados_padr, centers = 4)$cluster

# Resumo dos 4 clusters encontrados
cluster.summary <- function(data, groups) {
  x <- round(aggregate(data, list(groups), mean), 2)
  x$qtd <- as.numeric(table(groups))
  # colocar coluna de quantidade na segunda posição
  x <- x[, c(1, 6, 2, 3, 4, 5)]
  return(x)
}
(tabela <- cluster.summary(dados2, lista_clusteres))


colorir.valor <- function(x) ifelse(x >= mean(x), style(color = "green"), style(color = "red"))

nome_colunas <-  c("Cluster", "Quantidade Populacao", "Pib",
                   "Matr","veiculos", "motos)")

dados2$cluster <- lista_clusteres

write.csv2(dados2, file = 'dados4')
write.csv2(dados2, file ="C:\\Users\\tcortizo\\Documents\\Desafio Pleno\\dados4",row.names=FALSE)

head(dados2)
