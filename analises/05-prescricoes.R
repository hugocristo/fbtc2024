# -----------------------------------------------------------
# 05-prescricoes.R - atualizado em 12/04/2024
# -----------------------------------------------------------
# FBTC 2014 - Kátia Cristina de Paula e Hugo Cristo Sant'Anna
# Universidade Federal do Espírito Santo
# Programa de Pós-Graduação em Psicologia
# https://github.com/hugocristo/fbtc2024
# -----------------------------------------------------------

library (readxl)
library (stringr)

# seleciona banco
banco <- read_xlsx("./dados/banco-completo-anonimo.xlsx")

# tranforma texto para minísculas
banco$caption <- str_to_lower(banco$caption, locale="pt")

# detecta ocorrências nos textos dos posts (não + 4 palavras)
frases.nao <- which(str_detect(banco$caption, "não\\s\\w{1,}\\s\\w{1,}\\s\\w{1,}"))

# limita colunas da análise (1-4)
frases.nao.texto <- banco[frases.nao,1:2]

# detecta prescrições nos posts
for (linha in 1:nrow(frases.nao.texto)) {
    prescricoes <- str_extract_all(frases.nao.texto$caption[linha], "não\\s\\w{1,}\\s\\w{1,}\\s\\w{1,}", simplify = TRUE)
    # prescrições do post
    for (p in 1:length(prescricoes)) {
      # adiciona coluna
      frases.nao.texto[linha,str_c("prescricao_",p)] <- prescricoes[p]
    }
}

# exibe resultado
View(frases.nao.texto)

# exporta banco como CSV
# write.csv2(frases.nao.texto,"./dados/prescricoes.csv")
