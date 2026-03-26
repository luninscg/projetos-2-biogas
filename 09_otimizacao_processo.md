# Otimizacao do processo: biogas por codigestao anaerobia

## 1. Introducao

**Definicao (otimizacao de processo):** Procedimento para **encontrar** os valores das **variaveis de decisao** (o que o projeto pode mudar) que **maximizam** ou **minimizam** uma **funcao objetivo** (o que se quer melhorar), **respeitando restricoes** (limites fisicos, legais ou operacionais).

**Intuicao:** Pense em ajustar o "receita" da mistura e o tempo no reator como se ajustasse o fogo e o tempo de cozimento: da para melhorar o resultado, mas existe um ponto em que aumentar uma coisa piora outra (por exemplo, mais residuo organico aumenta biogas, mas pode estourar a **COV** ou desequilibrar o **pH**).

**Exemplos de objetivo:** maximizar producao de biogas (`Nm3/dia`); maximizar receita liquida (eletricidade menos custos); minimizar custo de descarte.

**Exemplos de restricao:** relacao **C/N** entre `20` e `30`; **COV** entre `1` e `4` `kgSV/(m3*dia)`; **pH** entre `6.8` e `7.4`.

**Referencias:** Towler, G.P.; Sinnott, R.K. (2012). *Chemical Engineering Design*; Chernicharo, C.A.L. (2007). *Principios do tratamento biologico de aguas residuarias*; UFPR (2024) e demais fontes citadas na base do projeto.

---

## 2. Variaveis de decisao

Sao grandezas que o **engenheiro altera no projeto** ou na operacao planejada:

| Variavel | Simbolo tipico | Comentario |
|---|---|---|
| Fracao volumetrica de lodo | `x_L` | Parte do volume diario total |
| Fracao volumetrica de vinhaca | `x_V` | Idem |
| Fracao volumetrica de residuo organico | `x_R` | Idem |
| Soma das fracoes | `x_L + x_V + x_R = 1` | Mistura completa do que entra |
| Tempo de retencao hidraulica | `TRH` | Tipico `15` a `30` `dias` em mesofilico |
| Temperatura do digestor | `T` | Ex.: `35` `degC` (mesofilico) vs `55` `degC` (termofilico) |
| Eficiencia de remocao de SV | `eta_SV` | Depende de `TRH`, `T`, mistura, inibicao |

**Definicao (TRH):** Tempo medio de permanencia do fluido no reator; em leito misto estacionario, `TRH = V_reator / Q_tot` com `V_reator` em `m3` e `Q_tot` em `m3/dia`.

**Definicao (eta_SV):** Fracao da massa de **solidos volateis** na alimentacao que e convertida (vai para biogas, biomassa, etc.), nao permanecendo como SV no efluente na mesma forma.

---

## 3. Funcao objetivo

**Opcao A - economica (exemplo):**

**Intuicao:** O processo so e "otimo" para o dono do negocio se o **saldo** (o que entra de dinheiro menos o que sai) for o melhor possivel dentro das restricoes.

**Formula ilustrativa:**

`Receita_liq = R_eletricidade - C_descarte - C_NaOH - C_manutencao`

(Outros termos podem entrar: carvao ativado, mao de obra, seguro, etc.)

**Opcao B - producao de biogas:**

**Intuicao:** Em estudo conceitual, as vezes maximiza-se diretamente o **volume de biogas** por dia, para depois amarrar com energia e economia.

**Objetivo:** maximizar `Q_bg` (`Nm3/dia`).

---

## 4. Restricoes (modelo linear nos fluxos, nao-linear na biologia)

| Restricao | Forma tipica |
|---|---|
| Relacao C/N da mistura | `20 <= (C/N)_mix <= 30` |
| Carga organica volumetrica (COV) | `1 <= COV <= 4` `kgSV/(m3*dia)` |
| pH no reator | `6.8 <= pH <= 7.4` |
| Balanco volumetrico da mistura | `x_L + x_V + x_R = 1` |
| Nao negatividade | `x_L`, `x_V`, `x_R >= 0` |

**Definicao (COV):** `COV = m_SV,in / V_reator`, com `m_SV,in` em `kg/dia` e `V_reator` em `m3`.

---

## 5. Analise de sensibilidade

**Premissa comum nesta secao:** `Q_tot = 100` `m3/dia`; densidades e fracoes **ST**, **SV/ST** e indices **C/N** por corrente **iguais** ao balanco de massa do projeto (arquivo `01_balanco_massa_biogas.md`).

**Formulas usadas (coerentes com a base):**

**Intuicao:** Cada corrente traz uma massa umida por dia; sobre ela aplicam-se os solidos; sobre os solidos totais, a fracao volatil.

- `m_i = rho_i * V_i` com `V_i = x_i * Q_tot`
- `m_ST,i = m_i * (ST%_i / 100)`
- `m_SV,i = m_ST,i * (SV/ST)_i`
- `m_SV,in = sum_i m_SV,i`

**Intuicao:** O **C/N** da mistura (indice de catalogo) e puxado pelos substratos que mais contribuem em **SV**.

- `(C/N)_mix = sum_i (m_SV,i * (C/N)_i) / m_SV,in`

**Intuicao:** So uma parte do SV e destruida no reator; sobre essa parte aplica-se o rendimento volumetrico de biogas.

- `m_SV,rem = eta_SV * m_SV,in` (nesta secao 5.1 adota-se `eta_SV = 0.55` como no caso base)
- `Q_bg = Y_bg * m_SV,rem` com `Y_bg = 0.60` `Nm3/kgSV_rem`
- `Q_CH4 = y_CH4 * Q_bg` com `y_CH4 = 0.62`

### 5.1 Efeito da proporcao de mistura no C/N e no biogas

Volumes diarios: `V_i = 100 * x_i` (`m3/dia`).

| Cenario | x_L | x_V | x_R | V_L | V_V | V_R | m_SV,in (kg/dia) | (C/N)_mix | Q_bg (Nm3/dia) | Q_CH4 (Nm3/dia) | Obs |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Base | 0.50 | 0.30 | 0.20 | 50 | 30 | 20 | 5116.19 | 24.6 | 1688.34 | 1046.77 | Caso atual do balanco |
| + Lodo | 0.60 | 0.20 | 0.20 | 60 | 20 | 20 | 5218.55 | 23.9 | 1722.12 | 1066.71 | Mais lodo, menos vinhaca; SV sobe levemente |
| + Residuo | 0.40 | 0.20 | 0.40 | 40 | 20 | 40 | 8325.50 | 27.4 | 2747.42 | 1703.40 | Mais residuo, muito mais SV |
| + Vinhaca | 0.40 | 0.40 | 0.20 | 40 | 40 | 20 | 5012.79 | 25.4 | 1654.22 | 1025.62 | Mais vinhaca; SV cai vs base |
| Extremo | 0.30 | 0.30 | 0.40 | 30 | 30 | 40 | 8222.09 | 27.9 | 2713.29 | 1682.24 | Alto residuo; biogas alto, checar COV |

**Contas resumidas (Base):** ja no balanco: `m_SV,in = 5116.19` `kg/dia`; `m_SV,rem = 0.55 * 5116.19 = 2813.90` `kg/dia`; `Q_bg = 0.60 * 2813.90 = 1688.34` `Nm3/dia`; `Q_CH4 = 0.62 * 1688.34 = 1046.77` `Nm3/dia`.

**+ Lodo:** `m_L=61200`, `m_V=20180`, `m_R=21000`; `m_SV = 1391.25+257.30+3570 = 5218.55`; numerador C/N = `11130+6432.4+107100 = 124662.4`; `(C/N)_mix = 124662.4/5218.55 = 23.9`; `Q_bg = 0.60*(0.55*5218.55)= 1722.1` `Nm3/dia`.

**+ Residuo:** `m_SV = 928.20+257.30+7140 = 8325.50`; numerador = `7425.6+6432.4+214200 = 228058`; `(C/N)_mix = 27.4`; `Q_bg = 2747.4` `Nm3/dia`.

**+ Vinhaca:** `m_SV = 928.20+514.59+3570 = 5012.79`; numerador = `7425.6+12864.8+107100 = 127390`; `(C/N)_mix = 25.4`; `Q_bg = 1654.2` `Nm3/dia`.

**Extremo:** `m_SV = 696.15+385.94+7140 = 8222.09`; numerador = `5569.2+9648.6+214200 = 229418`; `(C/N)_mix = 27.9`; `Q_bg = 2713.3` `Nm3/dia`.

**COV (alerta):** com `V_reator = 2000` `m3` e `Q_tot = 100` `m3/dia` fixos, `COV = m_SV,in/2000`. No **Extremo**, `COV = 8222.09/2000 = 4.11` `kgSV/(m3*dia)`, **acima** do teto `4` adotado: exige **maior volume** (maior TRH) ou **menor** `Q_tot` para a mesma mistura.

### 5.2 Efeito do TRH

**Intuicao:** Mais tempo no reator tende a aumentar a conversao, mas o volume (e o CAPEX) cresce com `V = Q_tot * TRH`.

**COV:** `COV = m_SV,in / V_reator` com `m_SV,in = 5116.19` `kg/dia` fixo nesta tabela.

**Biogas:** `Q_bg = Y_bg * eta_SV * m_SV,in` com `Y_bg = 0.60` `Nm3/kgSV_rem`.

**Nota empirica:** Adota-se `eta_SV = 0.30 + 0.015*TRH` (em %) para `TRH` entre `10` e `30` `dias`, **mesofilico**, como **ilustracao**; valores reais exigem dados de campo ou bancada.

| TRH (dias) | V_reator (m3) | eta_SV (%) | Q_bg (Nm3/dia) | COV (kgSV/m3.dia) |
|---|---|---|---|---|
| 15 | 1500 | 45 | 1382.0 | 3.41 |
| 20 | 2000 | 55 | 1688.3 | 2.56 |
| 25 | 2500 | 62 | 1903.2 | 2.05 |
| 30 | 3000 | 67 | 2056.5 | 1.71 |

**Checagem (TRH=20):** `eta_SV = 0.30 + 0.015*20 = 0.55`; `Q_bg = 0.60 * 0.55 * 5116.19 = 1688.3` `Nm3/dia`.

### 5.3 Efeito da temperatura

**Intuicao:** **Termofilico** costuma permitir **maior** `eta_SV` e, as vezes, **maior** `Y_bg`, mas a **demanda termica** para manter `55` `degC` pode consumir boa parte do balanco energetico.

| Regime | T (degC) | eta_SV | Y_bg (Nm3/kgSV_rem) | Q_bg (Nm3/dia) | Q_aquec (MJ/dia) |
|---|---|---|---|---|---|
| Mesofilico | 35 | 0.55 | 0.60 | 1688.3 | 6136 |
| Termofilico | 55 | 0.65 | 0.65 | 2161.6 | 14318 |

**Conta termofilico:** `m_SV,rem = 0.65 * 5116.19 = 3325.5` `kg/dia`; `Q_bg = 0.65 * 3325.5 = 2161.6` `Nm3/dia`. Valores de `Q_aquec` conforme balanco termico do documento de utilidades (`08_utilidades_eficiencia.md`): ordem de grandeza **maior** no termofilico.

**Mensagem:** mais biogas, porem **muito** mais energia de aquecimento; **autossuficiencia termica** pode ficar comprometida sem CHP bem dimensionado ou substrato com temperatura de entrada alta.

### 5.4 Efeito da COV (trade-off com TRH)

**Intuicao:** Se voce **aumenta** a massa organica alimentada por dia (`m_SV,in`) **sem** aumentar `V_reator`, a **COV** sobe e, em modelo hidraulico simples, o **TRH** efetivo cai (`TRH = V/Q_tot`). Isso pode **reduzir** `eta_SV` e gerar **instabilidade** (acidificacao, inibicao).

**Trade-off em uma frase:** mais carga por volume acelera a "cozinha" em teor de taxa, mas **encurta** o tempo de contato e pode **cair** o rendimento por kg alimentado; o ponto otimo depende de **estabilidade** e **meta** (maximo biogas vs maximo conversao).

---

## 6. Ponto otimo sugerido (conceitual)

O cenario **Base** (`x_L:x_V:x_R = 0.50:0.30:0.20`, `TRH = 20` `dias`, `35` `degC`) e um **bom compromisso** entre C/N na faixa desejada, COV moderada (`~2.56` `kgSV/(m3*dia)` com `2000` `m3`) e producao de biogas alinhada ao balanco de referencia.

Se houver **disponibilidade** e logistica para mais residuo organico, aumentar `x_R` para `0.40` **aumenta** fortemente `Q_bg`, mas e **obrigatorio** recalcular `COV` e, se necessario, **V_reator** ou `Q_tot` para manter `COV <= 4` e pH estavel.

---

## 7. Conclusao

Na analise apresentada, as variaveis mais **sensiveis** ao resultado (biogas e restricoes) sao:

1. **Proporcao de residuo organico** (mais SV na alimentacao tende a mais biogas, mas empurra COV).
2. **TRH** via volume (mais tempo tende a mais conversao, mas reator maior).
3. **Temperatura** (termofilico pode elevar producao, mas eleva demanda termica).

---

## 8. Confiabilidade e referencias

**Nivel:** B- (modelo estatico, indices de C/N por catalogo, `eta_SV` e `Y_bg` fixos ou empiricos simples; nao substitui BMP, pilotagem ou dados reais da ETE).

**Referencias principais:** Towler & Sinnott (2012); Chernicharo (2007); UFPR (2024); balanco de massa interno `01_balanco_massa_biogas.md`.
