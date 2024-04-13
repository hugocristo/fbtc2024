# -----------------------------------------------------------
# 02-nuvem-palavras.R - atualizado em 12/04/2024
# -----------------------------------------------------------
# FBTC 2014 - Kátia Cristina de Paula e Hugo Cristo Sant'Anna
# Universidade Federal do Espírito Santo
# Programa de Pós-Graduação em Psicologia
# https://github.com/hugocristo/fbtc2024
# -----------------------------------------------------------

library (readxl)
library (wordcloud2)

banco <- read_xlsx("./dados/lista-palavras.xlsx")

# nuvem de palavras global
wordcloud2(banco, size=1.3, color='random-dark')

# nuvem de palavras com frequência > 15 (5% do total)
wordcloud2(banco[banco$frequencia > 15,], size=1, color='random-dark')
