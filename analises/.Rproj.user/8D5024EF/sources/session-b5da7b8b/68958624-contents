# -----------------------------------------------------------
# 04-nuvem-hashtags.R - atualizado em 12/04/2024
# -----------------------------------------------------------
# FBTC 2014 - Kátia Cristina de Paula e Hugo Cristo Sant'Anna
# Universidade Federal do Espírito Santo
# Programa de Pós-Graduação em Psicologia
# https://github.com/hugocristo/fbtc2024
# -----------------------------------------------------------

library(wordcloud2)
library(readxl)

hashtags <- read_xlsx("./dados/hashtags-unicas.xlsx")

# wordcloud
wordcloud2(hashtags, size=0.5,ellipticity = 0.8,maxRotation = pi/6)