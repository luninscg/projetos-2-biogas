# Excel e Dashboard - Penicilina G

## Objetivo
Este arquivo traduz o estudo de `01_penicilina_g_balanco_massa_energia.md` para um formato de planilha e dashboard.

## 1. Estrutura recomendada do Excel

## Aba 1 - `Premissas`

| Celula | Parametro | Valor inicial |
|---|---|---:|
| B2 | Produto final seco, kg | 1000 |
| B3 | eta_sep | 0.995 |
| B4 | eta_ext1 | 0.97 |
| B5 | eta_ext2 | 0.96 |
| B6 | eta_crist | 0.98 |
| B7 | eta_dry | 0.995 |
| B8 | Titulo no caldo, kg/m3 | 45 |
| B9 | Densidade do caldo, kg/m3 | 1030 |
| B10 | Biomassa seca no caldo, kg/m3 | 18 |
| B11 | Umidade do bolo | 0.20 |
| B12 | Umidade final | 0.01 |
| B13 | T inicial, degC | 25 |
| B14 | T esterilizacao, degC | 121 |
| B15 | T extracao, degC | 5 |
| B16 | Cp caldo, kJ/kg.K | 4.0 |
| B17 | Cp solido umido, kJ/kg.K | 1.6 |
| B18 | lambda vapor, kJ/kg | 2130 |
| B19 | lambda secagem, kJ/kg | 2500 |
| B20 | q fermentacao, kJ/kg produto em caldo | 8000 |
| B21 | eficiencia util do vapor | 0.85 |

## Aba 2 - `Calculos_Produto`

| Celula | Descricao | Formula |
|---|---|---|
| B2 | eta_global | `=Premissas!B3*Premissas!B4*Premissas!B5*Premissas!B6*Premissas!B7` |
| B3 | Penicilina no caldo, kg | `=Premissas!B2/B2` |
| B4 | Volume de caldo, m3 | `=B3/Premissas!B8` |
| B5 | Massa de caldo, kg | `=B4*Premissas!B9` |
| B6 | Biomassa seca, kg | `=Premissas!B10*B4` |
| B7 | Torta umida removida, kg | `=B6/0.20` |

## Aba 3 - `Recuperacoes`

| Linha | Etapa | Produto entrada | Eficiencia | Produto saida | Perda |
|---|---|---|---|---|---|
| 2 | Caldo fermentado | `=Calculos_Produto!B3` | 1.000 | `=B2*C2` | `=B2-D2` |
| 3 | Separacao de biomassa | `=D2` | `=Premissas!B3` | `=B3*C3` | `=B3-D3` |
| 4 | Extracao primaria | `=D3` | `=Premissas!B4` | `=B4*C4` | `=B4-D4` |
| 5 | Reextracao/purificacao | `=D4` | `=Premissas!B5` | `=B5*C5` | `=B5-D5` |
| 6 | Cristalizacao/filtracao | `=D5` | `=Premissas!B6` | `=B6*C6` | `=B6-D6` |
| 7 | Secagem final | `=D6` | `=Premissas!B7` | `=B7*C7` | `=B7-D7` |

## Aba 4 - `Balanco_Massa`

Sugestao de colunas:

- Corrente
- Descricao
- Massa total, kg
- Agua, kg
- Penicilina, kg
- Biomassa, kg
- Solvente, kg
- Outros solidos, kg

Correntes minimas:

1. meio esterilizado;
2. caldo fermentado;
3. torta de biomassa;
4. filtrado para extracao;
5. extrato organico;
6. rafinado aquoso;
7. fase purificada;
8. cristais umidos;
9. produto seco;
10. efluentes e perdas.

## Aba 5 - `Balanco_Energia`

| Linha | Etapa | Massa, kg | Cp | Tin | Tout | Q sensivel, kJ | Q latente, kJ | Q total, kJ |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 2 | Esterilizacao | `=Calculos_Produto!B5` | `=Premissas!B16` | `=Premissas!B13` | `=Premissas!B14` | `=B2*C2*(E2-D2)` | 0 | `=G2+H2` |
| 3 | Resfriamento pos-esterilizacao | `=Calculos_Produto!B5` | `=Premissas!B16` | `=Premissas!B14` | `=Premissas!B13` | `=B3*C3*(D3-E3)` | 0 | `=G3+H3` |
| 4 | Fermentacao | `=Recuperacoes!B2` | 0 | 0 | 0 | 0 | 0 | `=Premissas!B20*Recuperacoes!D2` |
| 5 | Resfriamento para extracao | `=Calculos_Produto!B5-Calculos_Produto!B7` | `=Premissas!B16` | `=Premissas!B13` | `=Premissas!B15` | `=B5*C5*(D5-E5)` | 0 | `=G5+H5` |

## Aba 6 - `Secagem`

| Celula | Descricao | Formula |
|---|---|---|
| B2 | Solido seco antes do secador, kg | `=Recuperacoes!D6` |
| B3 | Massa total do bolo, kg | `=B2/(1-Premissas!B11)` |
| B4 | Agua no bolo, kg | `=B3-B2` |
| B5 | Massa final umida, kg | `=Premissas!B2/(1-Premissas!B12)` |
| B6 | Agua final residual, kg | `=B5-Premissas!B2` |
| B7 | Agua evaporada, kg | `=B4-B6` |
| B8 | Carga de secagem, kJ | `=B7*Premissas!B19` |

## 2. Dashboard recomendado

## Cartoes principais

- Produto final seco, kg
- Penicilina no caldo, kg
- Recuperacao global, %
- Volume de caldo, m3
- Biomassa seca gerada, kg
- Vapor de esterilizacao, kg
- Carga total de resfriamento, MJ
- Perda total de produto, kg

## Graficos

### Grafico 1 - Perdas por etapa
Tipo: barras

Fonte:

- eixo X: etapas da aba `Recuperacoes`
- eixo Y: coluna `Perda`

### Grafico 2 - Produto remanescente ao longo do processo
Tipo: linha

Fonte:

- etapas
- produto saida

### Grafico 3 - Cargas energeticas
Tipo: barras agrupadas

Fonte:

- etapas da aba `Balanco_Energia`
- coluna `Q total`

### Grafico 4 - Distribuicao simplificada das saidas
Tipo: pizza ou rosca

Componentes:

- produto seco
- biomassa removida
- agua evaporada na secagem
- perdas totais de produto

## 3. Indicadores que valem a pena acompanhar

| Indicador | Formula |
|---|---|
| Recuperacao global | `Produto final / Penicilina no caldo` |
| Perda global de produto | `1 - Recuperacao global` |
| m3 de caldo por kg de produto | `Volume de caldo / Produto final` |
| kg de biomassa por kg de produto | `Biomassa seca / Produto final` |
| kg vapor por kg produto | `Vapor de esterilizacao / Produto final` |
| MJ resfriamento por kg produto | `Carga de resfriamento / Produto final` |

## 4. Observacao importante

Esta estrutura e excelente para:

- estudo conceitual;
- sala de aula;
- apresentacao;
- dashboard de engenharia;
- comparacao de cenarios.

Para virar ferramenta de projeto mais rigorosa, o proximo passo e adicionar:

- composicao detalhada das correntes;
- balanco elementar da fermentacao;
- consumo de ar e geracao de CO2;
- reciclo de solvente;
- utilidades auxiliares;
- custos.
