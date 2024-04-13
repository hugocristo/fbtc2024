# -----------------------------------------------------------
# 03-gera-lista-hashtags.R - atualizado em 12/04/2024
# -----------------------------------------------------------
# FBTC 2014 - Kátia Cristina de Paula e Hugo Cristo Sant'Anna
# Universidade Federal do Espírito Santo
# Programa de Pós-Graduação em Psicologia
# https://github.com/hugocristo/fbtc2024
# -----------------------------------------------------------

library (readxl)
library (stringr)

banco <- read_xlsx("./dados/banco-completo-anonimo.xlsx")

# data.frame para hashtags
hashtags <- data.frame()

# cria vetor linhas de todas as hashtags não vazias
for (coluna in 5:21) {
  quais.hashtags <- which(!is.na(banco[,coluna]))
  
  lista.hashtags <- banco[quais.hashtags,coluna]

  # adiciona ao banco
  for (h in 1:nrow(lista.hashtags)) {
    hashtags <- rbind(hashtags, data.frame(
      "hashtag"=as.character(lista.hashtags[h,1]),
      "freq"=0,
      stringsAsFactors = FALSE
    ))
  }
}

# remove duplicadas
hashtags.unicas <- hashtags[-which(duplicated(hashtags$hashtag)),]

# conta frequência
for (linha in 1:nrow(hashtags.unicas)) {
  # hashtag atual
  h <- hashtags.unicas$hashtag[linha]
  # verifica na lista completa
  total <- length(which(hashtags$hashtag == h))
  # informa
  cat("hashtag",h,"-",total,"\n")
  # adiciona frequência
  hashtags.unicas$freq[linha] <- total
}

# exibe resultado
View(hashtags.unicas)

# exporta banco como CSV
# write.csv2(hashtags.unicas,"./dados/hashtags-unicas.csv")
