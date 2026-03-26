# Base Inviolavel de Engenharia Quimica

## Objetivo
Este arquivo define o filtro minimo que deve ser aplicado a qualquer estudo, conta, simulacao, estimativa ou projeto em engenharia quimica.

A ideia principal e simples:

- uma conta so e aceita se ela fizer sentido fisico;
- um resultado so e aceito se respeitar as leis fundamentais;
- um numero nunca deve aparecer sem explicacao.

## 1. Principio de honestidade tecnica

### Definicao simples
Honestidade tecnica significa nao fingir certeza onde ela nao existe.

### Definicao tecnica
Todo resultado depende de dados, modelo, hipoteses e faixa de validade das propriedades usadas.

### O que isso significa na pratica

- nao existe "100% de certeza absoluta" sem dados completos e validacao experimental;
- existe, sim, um resultado muito confiavel, rastreavel e fisicamente coerente;
- se um dado faltar, isso deve ser dito claramente.

## 2. Leis inviolaveis

## 2.1 Conservacao da massa

### Definicao simples
Massa nao aparece do nada e nao desaparece do nada.

### Forma geral
Acumulacao = Entrada - Saida + Geracao - Consumo

### Como interpretar

- `Entrada`: tudo o que entra no sistema.
- `Saida`: tudo o que sai do sistema.
- `Acumulacao`: o que fica armazenado dentro do sistema.
- `Geracao/Consumo`: aparecem quando ha reacao quimica para cada especie, mas a massa total continua conservada.

### Regras obrigatorias

- em regime permanente, sem acumulacao total: entrada total = saida total;
- fracoes massicas nao podem ser negativas;
- a soma das fracoes deve fechar em 1, salvo arredondamento;
- nenhum balanco pode criar produto sem fonte de materia-prima.

## 2.2 Conservacao da energia

### Definicao simples
Energia nao surge nem desaparece; ela so muda de forma ou e transferida.

### Forma geral
Acumulacao = Entrada - Saida + Geracao - Consumo

### Como interpretar

- calor, trabalho e entalpia das correntes entram no balanco;
- aquecer um fluido exige fonte de energia;
- resfriar um fluido exige retirada de energia.

### Regras obrigatorias

- nao aceitar aquecimento sem fonte termica;
- nao aceitar resfriamento sem remocao de calor;
- nao aceitar equipamento que entrega trabalho sem receber energia;
- incluir calor de reacao quando ele for importante.

## 2.3 Primeira Lei da Termodinamica

### Definicao simples
E a lei da conservacao da energia aplicada a sistemas termicos e de processo.

### O que guardar
Se o resultado quebra a primeira lei, a conta esta errada.

## 2.4 Segunda Lei da Termodinamica

### Definicao simples
Todo processo real tem perdas e irreversibilidades.

### O que isso impede

- eficiencia de 100% em processo real;
- transferencia espontanea de calor do frio para o quente sem gasto externo;
- refrigeracao "de graça";
- separacao real com custo energetico zero.

### O que guardar
Se a conta ficou "boa demais para ser verdade", provavelmente esta errada.

## 2.5 Terceira Lei da Termodinamica

### Definicao simples
Nao se atinge o zero absoluto por processos reais finitos.

### Regra pratica
Temperatura absoluta negativa ou aproximacoes absurdas proximas a 0 K devem ser rejeitadas.

## 3. Filtros obrigatorios para qualquer calculo

## 3.1 Filtro dimensional

### Pergunta
As unidades fecham?

### Regra
Se a unidade final nao fizer sentido, o resultado nao pode ser aceito.

## 3.2 Filtro de ordem de grandeza

### Pergunta
O numero faz sentido para a escala do problema?

### Exemplos

- uma vazao de 1 kg/s pode ser razoavel para piloto, mas pequena para uma planta grande;
- uma carga termica de poucos kJ para aquecer dezenas de toneladas esta errada;
- uma pressao negativa absoluta esta fisicamente errada.

## 3.3 Filtro de plausibilidade fisica

### Regras

- vazao nao pode ser negativa sem convencao declarada;
- densidade nao pode ser negativa;
- eficiencia maior que 1 deve ser rejeitada, salvo definicao especial explicada;
- composicao fora do intervalo 0 a 1 deve ser rejeitada.

## 4. Estrutura minima de qualquer solucao

Todo problema deve ser resolvido nesta ordem:

1. objetivo do problema;
2. definicao do sistema;
3. base de calculo;
4. dados conhecidos;
5. hipoteses;
6. balanco de massa;
7. balanco de energia;
8. verificacao termodinamica;
9. verificacao de unidades;
10. verificacao de plausibilidade;
11. interpretacao do resultado;
12. classificacao da confiabilidade.

## 5. Como explicar qualquer conteudo

Todo conteudo tecnico deve seguir este padrao:

1. definicao simples;
2. definicao tecnica;
3. por que isso importa;
4. como aparece no processo;
5. formula ou regra;
6. exemplo interpretado;
7. erros comuns;
8. resumo final em linguagem simples.

## 6. Niveis de confiabilidade

## Nivel A - Muito alta confiabilidade

- dados claros;
- hipoteses claras;
- balancos fechados;
- unidades coerentes;
- resultado fisicamente plausivel.

## Nivel B - Boa confiabilidade

- pequenas simplificacoes;
- adequado para estudo conceitual e pre-projeto;
- sem violacoes fisicas.

## Nivel C - Confiabilidade limitada

- faltam dados importantes;
- resultado util apenas como estimativa inicial.

## Nivel D - Nao aceitavel

- viola massa;
- viola energia;
- viola termodinamica;
- viola unidades;
- gera resultado fisicamente absurdo.

## 7. Regra final

Nao aceitar:

- resposta sem explicacao;
- numero sem unidade;
- simulacao sem interpretacao;
- conta que fecha matematicamente, mas nao fecha fisicamente.

Aceitar apenas:

- resultado rastreavel;
- resultado explicado;
- resultado coerente com massa e energia;
- resultado coerente com a termodinamica;
- resultado com confiabilidade classificada.
