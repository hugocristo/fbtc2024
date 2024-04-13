# -----------------------------------------------------------
# 06-estatisticas.R - atualizado em 13/04/2024
# -----------------------------------------------------------
# FBTC 2014 - Kátia Cristina de Paula e Hugo Cristo Sant'Anna
# Universidade Federal do Espírito Santo
# Programa de Pós-Graduação em Psicologia
# https://github.com/hugocristo/fbtc2024
# -----------------------------------------------------------

library(ggplot2)
library(readxl)
library(stringr)

# corrige notação matemática
options(scipen=100, digits=4)

# importa banco completo
banco.completo <- read_xlsx("./dados/banco-completo-anonimo.xlsx")

# para calcular a soma dos likes
tapply(banco.completo$likesCount, banco.completo$ownerUsername, sum, simplify = TRUE)
likes.por.perfil <- as.data.frame(tapply(banco.completo$likesCount, banco.completo$ownerUsername, sum, simplify = TRUE))
colnames(likes.por.perfil) <- c("likes")

# para calcular a soma dos comentários 
tapply(banco.completo$commentsCount, banco.completo$ownerUsername, sum, simplify = TRUE)
comentarios.por.perfil <- data.frame(tapply(banco.completo$commentsCount, banco.completo$ownerUsername, sum, simplify = TRUE))
colnames(comentarios.por.perfil) <- c("comentarios")

# =====================================
# cria df para calcular correlações
# =====================================

# converte nomes das linhas em linhas
perfis <- row.names(comentarios.por.perfil)

# copia para novo df
estatisticas.por.perfil <- data.frame("perfis"=perfis)

# incluir likes e comentários
estatisticas.por.perfil$likes <- likes.por.perfil$likes
estatisticas.por.perfil$comentarios <- comentarios.por.perfil$comentarios
estatisticas.por.perfil$perfis <- as.factor(estatisticas.por.perfil$perfis)

# seguidores
seguidores.por.perfil <- read_xlsx('./dados/seguidores-por-perfil.xlsx')

# correlação (plotar e visualizar)
cor.test(estatisticas.por.perfil$likes, estatisticas.por.perfil$comentarios)

# testa correlação no banco completo
cor.test(banco.completo$likesCount, banco.completo$commentsCount)

# gera tabela de correlação de todos os perfis
tabela.correlacoes <- data.frame()
for (perfil in 1:length(unique(banco.completo$ownerUsername))) {
  
  # seleciona usuário da lista
  usuario <- unique(banco.completo$ownerUsername)[perfil]
  
  if (length(banco.completo[banco.completo$ownerUsername == usuario,]$likesCount) > 1) {
    
    # testa este usuário
    teste <- cor.test(banco.completo[banco.completo$ownerUsername == usuario,]$likesCount, 
                      banco.completo[banco.completo$ownerUsername == usuario,]$commentsCount)
    
    # registra resultado do teste
    tabela.correlacoes <- rbind(tabela.correlacoes, data.frame(
      "perfil"=usuario,
      "r"=teste$estimate,
      "ci_inf"=teste$conf.int[1],
      "ci_sup"=teste$conf.int[2],
      "p"=teste$p.value,
      stringsAsFactors = TRUE
    ))
  }
}

# gráfico dos intervalos de correlações com ggplot2
ggplot(data=tabela.correlacoes) + 
  geom_hline(aes(yintercept=0.5), linetype="dashed", colour="gray")+ 
  geom_segment(aes(x=perfil, y=ci_inf, xend=perfil, yend=ci_sup, colour=perfil)) + 
  geom_point(aes(x=perfil, y=r, colour=perfil)) + 
  geom_text(aes(x=perfil, y=r, label=ifelse(p < 0.05, str_c(round(r,2),"*"),round(r,2)), vjust=0), size=3, nudge_x=0.3) + 
  coord_flip() +
  xlab("Curtidas") + ylab("Comentários") + 
  labs(title="Correlação de Pearson (r) entre curtidas e comentários",subtitle="* p < 0.01")+
  theme_minimal() + 
  theme(
    legend.position = "none",
    axis.title.x = element_text(margin=margin(12,0,0,0,unit="pt")),
    axis.title.y = element_text(margin=margin(0,12,0,0,unit="pt"))
  )

# exporta tabela de correlações
#write.csv2(tabela.correlacoes,"./dados/tabela-correlacoes.csv")

# exporta estatísticas por perfil
#write.csv2(estatisticas.por.perfil,"./dados/estatisticas-por-perfil.csv")
