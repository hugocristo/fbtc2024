# -----------------------------------------------------------
# 01-gera-lista-palavras.R - atualizado em 12/04/2024
# -----------------------------------------------------------
# FBTC 2014 - Kátia Cristina de Paula e Hugo Cristo Sant'Anna
# Universidade Federal do Espírito Santo
# Programa de Pós-Graduação em Psicologia
# https://github.com/hugocristo/fbtc2024
# -----------------------------------------------------------

remotes::install_github("hadley/emo")
library (readxl)
library (stringr)
library(emo)

banco <- read_xlsx("./dados/banco-completo-anonimo.xlsx")

# hapáx
remover.palavras <- c("da","das","de","do","dos",
                      "com","como","que","por","para",
                      "a","as","à","às","o","os","em","é","e","que",
                      "se","mas","um","uns",
                      "na","nas","no","nos",
                      "ou", "está", "seu", "sua", "seus", "suas",
                      "isso", "disso", "esse", "desse", "esses", "desses",
                      "essa", "dessa", "essas", "dessas",
                      "aquele", "aquela", "este", "estes")
remover.pontuacao <- c("\\“","\\”","\\?","\\!",
                       "\\:","\\,","\\.","\"",
                       "\\)","\\(","\\.\\.\\.",
                       "\\*","\\+","\\|")

# seleciona posts
posts <- banco$caption

# cria df com palavras dos posts
lista.palavras <- data.frame()

# laço pelos posts
for (t in 1:length(posts)) {
  
  cat("- Analisando post:",t,"\n")
  
  # se o post não estiver vazio
  if (!is.na(posts[t])) {
    # transforma hífen sozinho no início da linha em espaço (tópico)
    posts[t] <- str_replace_all(posts[t],"^\\-","")
    # remove traços isolados
    posts[t] <- str_replace_all(posts[t],"\\s\\-\\s"," ")
    # remove reticências
    posts[t] <- str_replace_all(posts[t],"…"," ")
    # remove caracteres bizarros e números
    posts[t] <- str_replace_all(posts[t],"[:digit:]|⠀|⬇|☡|—|___|✔|❤"," ")
    # remove quebras de linha
    posts[t] <- str_replace_all(posts[t],"\\r\\n"," ")
    # remove hapáx e emoji
    posts[t] <- str_replace_all(posts[t],str_c("\\b",remover.palavras,"\\b",collapse="|"),"")
    posts[t] <- str_remove_all(posts[t],str_c(remover.pontuacao,collapse="|"))
    # remove pontuação
    posts[t] <- str_remove_all(posts[t],str_c(remover.pontuacao,collapse="|"))
    # remove emojis (hadley/emo)
    posts[t] <- ji_replace_all(posts[t],"")
    # remove espaços duplos
    posts[t] <- str_squish(posts[t])
    # remove pontuação
    #posts[t] <- removePunctuation(posts[t])
    # caixa baixa e únicos
    posts[t] <- str_to_lower(posts[t],locale="pt")
    
    #cat("Resultado: ",posts[t],"\n------------------------\n")
    
    # quebra texto em palavras
    post <- str_split(posts[t],"\\s", simplify = TRUE)
    # importa para o df
    lista.palavras <- rbind(lista.palavras,data.frame("palavra"=as.character(post), stringsAsFactors = FALSE))
  }
}

# adiciona lista limpa como coluna do banco
banco$posts <- posts

# remove duplicadas
lista.palavras.unicas <- unique(lista.palavras$palavra)

# remove termos resultantes em branco
lista.palavras.unicas <- lista.palavras.unicas[-which(lista.palavras.unicas=="")]

# novo dataframe
lista.palavras.freq <- data.frame("palavra"=lista.palavras.unicas,"freq"=rep(0,length(lista.palavras.unicas)), stringsAsFactors = FALSE)

# laço pelo banco em busca das palavras identificadas
for (linha in 1:nrow(banco)) {
  # lista de palavras
  for (lista in 1:nrow(lista.palavras.freq)) {
    # palavra a ser varrida nos posts
    palavra <- lista.palavras.unicas[lista]
    # quantas ocorrências
    total <- str_count(banco$posts[linha],str_c("\\b",palavra,"\\b"))
    # se houver ocorrências
    if (!is.na(total)) {
      cat("- Calculando",nrow(lista.palavras.freq),"frequências no post",linha,"... \r")
      lista.palavras.freq$freq[lista] <- lista.palavras.freq$freq[lista] + total
    }
  }
}

# exporta lista de palavras
#write.csv2(lista.palavras.freq,"./dados/lista.palavras.csv")
