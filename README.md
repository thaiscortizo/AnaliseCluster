# AnaliseCluster

Passos que foram feitos para modelagem:
1) Para técnica de análise de cluster, não é recomendado que haja dependência temporal nos dados. Com isso, agrupei, utilizando média, as variáveis do dataset a fim de remover a dependência temporal.

2) Não é recomendado também que haja multicolinearidade nos dados para aplicação da modelagem. Com isso, foi retirada as variáveis que eram multicolineares. 

3) Havia alguns dados faltantes de algumas variáveis, então foi utilizado a métrica de inputação dos dados pela média a fim de não perder informação (removendo as linhas)

4) Como havia informações com escalas diferentes, pib em real, quantidade de população, porcentagem, optei por padronizar os dados

5) Optei também por utilizar variáveis de taxas ao invés da quantidade da população
