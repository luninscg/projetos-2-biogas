# Balanco de massa: codigestao anaerobia para biogas

## 1. Titulo e objetivo

**Titulo:** Balanco de massa completo para producao de biogas por codigestao anaerobia em digestor mesofilico.

**Objetivo:** Quantificar, de forma didatica, as massas que entram na unidade (mistura aquosa de substratos), as massas que saem como biogas e como digestato, e verificar o encaixe com conservacao de massa e com particoes elementares (C, H, O, N, S) dentro das premissas adotadas.

**Definicao (codigestao anaerobia):** Mistura de dois ou mais substratos organicos alimentada a um reator **sem oxigenio dissolvido** (meio **anaerobio**), onde **microorganismos** decompoem a materia organica e liberam **biogas** (mistura gasosa rica em metano).

**Definicao (biogas):** Fluxo gasoso de saida contendo principalmente `CH4` e `CO2`, mais fracoes minoritarias.

**Definicao (digestato):** Mistura liquido-solido de saida do digestor, ainda com agua e solidos nao convertidos.

---

## 2. Base de calculo

**Definicao (base de calculo):** Referencia fixa de vazao ou tempo usada para escalar todos os resultados; aqui usamos `1 dia` e volume diario de alimentacao.

- **Vazao volumetrica total alimentada:** `Q_tot = 100` `m3/dia`
- **Horizonte:** `1` `dia` (todas as vazoes em `kg/dia` ou `m3/dia` sao por dia)

---

## 3. Premissas completas (tabelas)

**Definicao (densidade `rho`):** Massa por unidade de volume, `rho = m/V`, unidade `kg/m3`. Aqui trata-se da mistura de cada corrente de entrada como se fosse homogenea.

**Definicao (ST, solidos totais):** Fracao massica de materia seca suspensa ou dissolvida na corrente umida; aqui dada em `%` massa: `w_ST = ST% / 100` (adimensional).

**Definicao (SV, solidos volateis):** Parte dos solidos que pode ser oxidada a `550` `degC` em laboratorio (proxy da fracao **organica** dos solidos). Relacao `SV/ST` e a razao massica `SV` sobre `ST` (adimensional).

**Definicao (C/N):** Razao massica carbono/nitrogenio na materia organica (adimensional), util para avaliar **nutricao** da biomassa anaerobia.

**Definicao (TRH, tempo de retencao hidraulico):** Tempo medio que o liquido permanece no reator; para leito completamente misturado em regime estacionario, `TRH = V_reator / Q` com `V_reator` em `m3` e `Q` em `m3/dia`, logo `TRH` em `dia`.

**Definicao (eficiencia de remocao de SV, `eta_SV`):** Fracao da massa de `SV` na alimentacao que deixa de existir como `SV` no digestato por **conversao** (biogas, biomassa microbiana, produtos dissolvidos, etc.), adimensional.

**Definicao (rendimento de biogas, `Y_bg`):** Volume normal de biogas gerado por massa de `SV` removido, `Nm3/kgSV_removido`. **Nm3** significa metro cubico **normalizado** (referencia convencional para gases, aqui usamos a mesma convencao dos dados: volume molar seco padrao ligado a `22.414` `Nm3/kmol`).

**Definicao (composicao molar seca do biogas):** Fracoes em base **volumetrica** aproximam fracoes molares para gas ideal.

### Tabela A — Proporcoes volumetricas na alimentacao

| Substrato        | Simbolo | `V` (`m3/dia`) | Fracao volumetrica |
|------------------|---------|----------------|--------------------|
| Lodo de esgoto   | L       | `50`           | `0.50`             |
| Vinhaca          | V       | `30`           | `0.30`             |
| Residuo organico | R       | `20`           | `0.20`             |
| **Total**        | —       | **`100`**      | **`1.00`**         |

### Tabela B — Caracterizacao fisico-quimica por corrente

| Corrente | `rho` (`kg/m3`) | `ST%` | `SV/ST` | `C/N` (indice) | `pH` |
|----------|-----------------|-------|---------|----------------|------|
| L        | `1020`          | `3.5` | `0.65`  | `8`            | `6.8`|
| V        | `1009`          | `1.7` | `0.75`  | `25`           | `4.2`|
| R        | `1050`          | `20.0`| `0.85`  | `30`           | `5.5`|

### Tabela C — Composicao elementar da materia organica (`%` massa na base seca dos `SV`)

| Corrente | `C%`  | `H%` | `O%`  | `N%` | `S%` |
|----------|-------|------|-------|------|------|
| L        | `51.0`| `7.9`| `34.6`| `5.4`| `1.1`|
| V        | `43.0`| `6.5`| `46.0`| `3.5`| `1.0`|
| R        | `48.0`| `6.4`| `37.6`| `3.2`| `0.4`|

Soma por linha (checagem de plausibilidade): todas somam `100.0` `%` na base seca dos `SV`.

### Tabela D — Parametros operacionais

| Parametro | Simbolo | Valor | Unidade |
|-----------|---------|-------|---------|
| Temperatura do digestor | `T_reator` | `35` | `degC` |
| TRH | `theta` | `20` | `dia` |
| Eficiencia remocao SV | `eta_SV` | `0.55` | — |
| Rendimento biogas | `Y_bg` | `0.60` | `Nm3/kgSV_rem` |
| `CH4` (seco molar) | `y_CH4` | `0.62` | — |
| `CO2` (seco molar) | `y_CO2` | `0.36` | — |
| Outros gases (seco molar) | `y_out` | `0.02` | — |
| Temperatura da alimentacao | `T_feed` | `20` | `degC` |

### Tabela E — Constantes usadas (com significado)

| Grandeza | Simbolo | Valor | Unidade | Significado |
|----------|---------|-------|---------|-------------|
| Volume molar normal (referencia dos dados) | `V_m` | `22.414` | `Nm3/kmol` | Volume ocupado por `1` `kmol` de gas ideal na condicao normal implicita ao `Y_bg` e aos exemplos numericos fornecidos |
| Massa molar metano | `M_CH4` | `16` | `kg/kmol` | Metano |
| Massa molar dioxido de carbono | `M_CO2` | `44` | `kg/kmol` | Dioxido de carbono |
| Massa molar agua | `M_H2O` | `18` | `kg/kmol` | Agua |
| Massa atomica carbono | `M_C` | `12` | `kg/kmol` | Carbono elementar |

**Premissa adicional (outros `2%`):** Para fechamento **massico** do gas, ausencia de composicao detalhada. Adotamos **massa molar media** `M_out = 29` `kg/kmol` (valor intermediario tipo ar umido/seco para ordem de grandeza). Isso afeta apenas a massa total do gas minoritario e o fechamento massico global; **nao** altera `CH4` e `CO2` calculados pelas fracoes dadas.

---

## 4. Massas de entrada (`m = rho * V`)

**Ideia fisica:** Se a mistura de cada corrente tem densidade quase constante, massa por dia e produto `volume/dia * densidade`.

**Formula:** `m_i = rho_i * V_i`

| Corrente | Conta | `m_i` (`kg/dia`) |
|----------|-------|------------------|
| L | `m_L = 1020 * 50` | `51000` |
| V | `m_V = 1009 * 30` | `30270` |
| R | `m_R = 1050 * 20` | `21000` |
| Total | `m_in = m_L + m_V + m_R` | **`102270`** |

**Interpretacao:** Entram `102270` `kg/dia` de mistura umida total.

---

## 5. ST e SV na entrada

**Ideia fisica:** `ST` mede “quanto de materia seca” existe na corrente umida. `SV` mede “quanto dessa materia seca e organicamente reativa” (proxy).

**Formulas:**

- `m_ST,i = m_i * (ST%_i / 100)`
- `m_SV,i = m_ST,i * (SV/ST)_i`

### 5.1 Solidos totais (`ST`)

| Corrente | Conta | `m_ST,i` (`kg/dia`) |
|----------|-------|---------------------|
| L | `51000 * 0.035` | `1785.00` |
| V | `30270 * 0.017` | `514.59` |
| R | `21000 * 0.20` | `4200.00` |
| Total | soma | **`6499.59`** |

### 5.2 Solidos volateis (`SV`)

| Corrente | Conta | `m_SV,i` (`kg/dia`) |
|----------|-------|---------------------|
| L | `1785.00 * 0.65` | `1160.25` |
| V | `514.59 * 0.75` | `385.9425` |
| R | `4200.00 * 0.85` | `3570.00` |
| Total | soma | **`5116.1925`** |

Nos passos seguintes usamos **`m_SV,in = 5116.19` `kg/dia`** (arredondamento consistente com a lista de referencia).

**Interpretacao:** Dos `102270` `kg/dia` umidos, `6499.59` `kg/dia` sao solidos totais e `5116.19` `kg/dia` sao solidos volateis (organicos na convencao de laboratorio).

---

## 6. Relacao `C/N` da mistura (media ponderada por `SV`)

**Ideia fisica:** Cada substrato traz um **indice** `C/N` de catalogo. Para obter um **indice de mistura** ponderado pela massa de `SV` que cada um contribui, usamos media ponderada: substratos com mais `SV` puxam o indice para o seu valor.

**Formula:** `(C/N)_mix = sum_i ( m_SV,i * (C/N)_i ) / m_SV,in`

**Calculo:**

`num = 1160.25*8 + 385.9425*25 + 3570*30`
`num = 9282 + 9648.5625 + 107100 = 126030.5625`

`(C/N)_mix = 126030.5625 / 5116.1925 = 24.633...`

**Resultado:** `(C/N)_mix = 24.6` (adimensional), se arredondamos a uma casa.

**Nota didatica (coerencia):** Se calcularmos `C/N` **pela composicao elementar** dos `SV` (`C` total / `N` total na Secao 7), obtemos outro numero, porque o `C/N` da Tabela B e um **indice tipico** do substrato, nao necessariamente igual ao `C/N` estrito da analise elementar fornecida. Aqui seguimos o enunciado: **media ponderada por `SV`** dos indices `C/N` da Tabela B.

---

## 7. Fechamento elementar na entrada (por substrato e total)

**Ideia fisica:** A Tabela C diz “para cada `kg` de solido organico seco (`SV` seco), quantos `kg` sao C, H, O, N, S”. Na alimentacao umida, a massa de `SV` “como solido no balanco” e `m_SV,i`; aplicamos as fracoes elementares a essa massa.

**Formula (generica):** `m_E,i = m_SV,i * (E%_i / 100)` com `E` em `{C,H,O,N,S}`

**Unidade:** `kg/dia` de elemento.

### 7.1 Lodo (L)

- `m_C,L = 1160.25 * 0.510 = 591.7275`
- `m_H,L = 1160.25 * 0.079 = 91.65975`
- `m_O,L = 1160.25 * 0.346 = 401.4465`
- `m_N,L = 1160.25 * 0.054 = 62.6535`
- `m_S,L = 1160.25 * 0.011 = 12.76275`

### 7.2 Vinhaca (V)

- `m_C,V = 385.9425 * 0.430 = 165.955275`
- `m_H,V = 385.9425 * 0.065 = 25.0862625`
- `m_O,V = 385.9425 * 0.460 = 177.53355`
- `m_N,V = 385.9425 * 0.035 = 13.5079875`
- `m_S,V = 385.9425 * 0.010 = 3.859425`

### 7.3 Residuo (R)

- `m_C,R = 3570.00 * 0.480 = 1713.6`
- `m_H,R = 3570.00 * 0.064 = 228.48`
- `m_O,R = 3570.00 * 0.376 = 1342.32`
- `m_N,R = 3570.00 * 0.032 = 114.24`
- `m_S,R = 3570.00 * 0.004 = 14.28`

### 7.4 Totais na alimentacao (elementos associados aos `SV`)

| Elemento | Total (`kg/dia`) |
|----------|------------------|
| C | `591.7275 + 165.955275 + 1713.6 = 2471.282775` |
| H | `91.65975 + 25.0862625 + 228.48 = 345.2260125` |
| O | `401.4465 + 177.53355 + 1342.32 = 1921.30005` |
| N | `62.6535 + 13.5079875 + 114.24 = 190.4014875` |
| S | `12.76275 + 3.859425 + 14.28 = 30.902175` |

**Interpretacao:** Os elementos acima estao associados **aos `SV` medidos**. A agua da fase liquida e os **solidos fixos** (`SF = ST - SV`) nao receberam composicao elementar neste enunciado; portanto **nao** incluimos cinzas/minerais no fechamento elemental completo da corrente umida.

---

## 8. `SV` removidos

**Ideia fisica:** `eta_SV` diz que `55%` da massa de `SV` deixa de aparecer como `SV` no efluente, por conversao biologica.

**Formula:** `m_SV,rem = eta_SV * m_SV,in`

**Calculo:** `m_SV,rem = 0.55 * 5116.1925 = 2813.905875` `kg/dia`

**Resultado adotado:** **`m_SV,rem = 2813.91` `kg/dia`**

---

## 9. Producao de biogas (volume e massa, com `kmol`)

**Ideia fisica:** O dado `Y_bg` liga **organico removido** a **volume normal de gas**; depois separamos em especies pela fracao molar.

**Formulas:**

- `Q_bg = Y_bg * m_SV,rem`
- `Q_k = y_k * Q_bg` para `k` em `{CH4,CO2,out}`
- `n_k = Q_k / V_m`
- `m_k = n_k * M_k`

### 9.1 Volume total de biogas

`Q_bg = 0.60 * 2813.905875 = 1688.343525` `Nm3/dia`

**Adotado:** **`Q_bg = 1688.34` `Nm3/dia`**

### 9.2 Volumes por especie (seco)

- `Q_CH4 = 0.62 * 1688.343525 = 1046.7729855` → **`1046.77` `Nm3/dia`**
- `Q_CO2 = 0.36 * 1688.343525 = 607.803669` → **`607.80` `Nm3/dia`**
- `Q_out = 0.02 * 1688.343525 = 33.7668705` → **`33.77` `Nm3/dia`**

### 9.3 `kmol/dia` e massas

**Metano**

- `n_CH4 = 1046.7729855 / 22.414 = 46.701303...` `kmol/dia`
- `m_CH4 = 46.701303 * 16 = 747.220848...` `kg/dia`

**Adotado:** **`m_CH4 = 747.2` `kg/dia`**

**Dioxido de carbono**

- `n_CO2 = 607.803669 / 22.414 = 27.116518...` `kmol/dia`
- `m_CO2 = 27.116518 * 44 = 1193.126792...` `kg/dia`

**Adotado:** **`m_CO2 = 1193.1` `kg/dia`**

**Outros (premissa `M_out = 29` `kg/kmol`)**

- `n_out = 33.7668705 / 22.414 = 1.506507...` `kmol/dia`
- `m_out = 1.506507 * 29 = 43.6887` `kg/dia`

**Massa total de gas (para fechamento massico):**

`m_gas = 747.2208 + 1193.1268 + 43.6887 = 1984.0363` `kg/dia`

---

## 10. Distribuicao elementar no biogas (`C` no `CH4`, `C` no `CO2`, `H` no `CH4`)

**Ideia fisica:** Cada molecula leva atomos fixos; multiplicamos `kmol/dia` pela massa atomica/molar adequada.

**Formulas:**

- `m_C,CH4 = n_CH4 * 12`
- `m_C,CO2 = n_CO2 * 12`
- `m_H,CH4 = n_CH4 * 4` (pois cada `CH4` tem `4` H)

**Calculos:**

- `m_C,CH4 = 46.701303 * 12 = 560.415636` `kg/dia`
- `m_C,CO2 = 27.116518 * 12 = 325.398216` `kg/dia`
- **Carbono total no gas (soma `C` em `CH4` e `CO2`):** `560.415636 + 325.398216 = 885.813852` `kg/dia`

- `m_H,CH4 = 46.701303 * 4 = 186.805212` `kg/dia`

**Oxigenio no `CO2` (util para Secao 12):**

- cada `CO2` tem `2` O: `m_O,CO2 = n_CO2 * 32 = 27.116518 * 32 = 867.728576` `kg/dia`

**Interpretacao:** Quase todo `C` do gas calculado esta em `CH4` e `CO2` nas fracoes dadas; a fracao `outros` foi tratada como massa sem detalhe atomico.

### 10.4 Restante elementar no digestato (`entrada` de elementos nos `SV` menos `saida` no biogas)

**Ideia fisica:** Somamos o que entra nos elementos associados aos `SV` e subtraimos o que sai no biogas nas especies que modelamos. O **restante** fica, na pratica, repartido entre **solido organico residual**, **solutos dissolvidos**, **biomassa** e **especies nao contabilizadas** no gas.

**Convencoes desta conta:**

- `C` no biogas: `m_C,gas = m_C,CH4 + m_C,CO2 = 885.813852` `kg/dia`
- `H` no biogas (modelo minimo): apenas `H` do `CH4`, `m_H,gas = m_H,CH4 = 186.805212` `kg/dia`
- `O` no biogas (modelo minimo): apenas `O` do `CO2`, `m_O,gas = m_O,CO2 = 867.728576` `kg/dia`
- `N` e `S` no biogas: **premissa** de ordem de grandeza **nulos** no volume gasoso (na pratica pode haver `NH3`, `H2S`, mas em massa muitas vezes pequeno frente ao liquido)

**Formulas:** `m_E,res = m_E,SV,in - m_E,gas` (com `m_E,gas = 0` quando nao ha especie gasosa modelada)

| Elemento | `m_E,SV,in` (`kg/dia`) | `m_E,gas` (`kg/dia`) | `m_E,res` (`kg/dia`) | Conta resumida |
|----------|------------------------|----------------------|----------------------|----------------|
| C | `2471.282775` | `885.813852` | **`1585.468923`** | `2471.282775 - 885.813852` |
| H | `345.2260125` | `186.805212` | **`158.4208005`** | `345.2260125 - 186.805212` |
| O | `1921.30005` | `867.728576` | **`1053.571474`** | `1921.30005 - 867.728576` |
| N | `190.4014875` | `0` | **`190.4014875`** | permanece no sistema |
| S | `30.902175` | `0` | **`30.902175`** | permanece no sistema |

**Interpretacao:** Os valores `m_E,res` **nao** sao iguais automaticamente aos elementos apenas no `SV` do digestato (`2302` `kg/dia`), porque parte do substrato convertido vira **agua**, **ions** e **gas dissolvido** sem passar pelo `SV` gravimetrico.

---

## 11. Estimativa de `H2O` metabolica gerada

**Ideia fisica:** Na digestao, hidrogenio e oxigenio do substrato podem formar agua (por exemplo, em etapas de acetogenese/sintrofia e rearranjos). Uma estimativa **grosseira** consiste em fechar **H** e **O** do substrato **removido** contra o que ja alocamos em `CH4`, `CO2` e, para `O`, tambem no `CO2`.

**Definicao (`H2O` metabolica, estimativa):** Massa de agua formada inferida por diferenca de balanco aproximado no subconjunto {H,O} do **SV removido**, assumindo que `N`, `S` nao viram agua e ignorando biomassa microbiana.

**Massa elementar no `SV` removido (proporcional):**

`m_E,rem = eta_SV * m_E,SV,in`

Com totais da Secao 7:

- `m_H,rem = 0.55 * 345.2260125 = 189.874306875` `kg/dia`
- `m_O,rem = 0.55 * 1921.30005 = 1056.7150275` `kg/dia`

**H alocado em `CH4`:** `m_H,CH4 = 186.805212` `kg/dia` (Secao 10)

**Premissa simplificadora:** `H_out` nos `outros` desprezivel.

**H “sobrando” para agua:**

`m_H,H2O,approx = m_H,rem - m_H,CH4 = 189.874306875 - 186.805212 = 3.069094875` `kg/dia`

Como em `H2O` a massa de H e `2/18` da massa de agua:

`m_H2O,from_H = m_H,H2O,approx * (18/2) = 3.069094875 * 9 = 27.621853875` `kg/dia`

**O alocado em `CO2`:** `m_O,CO2 = 867.728576` `kg/dia`

**O “restante” apos formar `CO2`:**

`m_O,rem - m_O,CO2 = 1056.7150275 - 867.728576 = 188.9864515` `kg/dia`

Se esse oxigenio formasse agua com hidrogenio, a massa de agua associada seria (cada `H2O` precisa de `16` `kg` O por `18` `kg` `H2O`):

`m_H2O,from_O = 188.9864515 * (18/16) = 212.6097526875` `kg/dia`

**Consistencia:** Os dois caminhos {H} e {O} **nao fecham igual** (`27.62` vs `212.61` `kg/dia`) porque o modelo `Y_bg` + composicao do gas **nao** e um modelo estequiometrico completo do substrato (falta `COD` balance, biomassa, `CO2` dissolvido, etc.). Reportamos entao um **intervalo indicativo** ou a media geometrica simples nao e justificada; o mais honesto e:

**Estimativa reportada (ordem de grandeza):** `H2O` metabolica esta entre **`~28` `kg/dia`** (limite pelo H removido menos H no `CH4`) e **`~213` `kg/dia`** (limite pelo O removido menos O no `CO2`), se aceitarmos as premissas acima.

**Interpretacao:** Serve para lembrar que **massa de agua do digestato nao e apenas “agua que entrou”**; ha geracao/consumo liquido no processo, mas o valor exato exige modelo estequiometrico ou dados experimentais.

---

## 12. Balanco de `O` consumido/liberado (visao qualitativa-numerica)

**Ideia fisica:** Oxigenio elementar do organico pode acabar em `CO2`, agua, grupos funcionais dissolvidos, etc. Sem todas as especies liquidas, fazemos um **balanco parcial** entre **O no `SV` removido** e **O no `CO2` gasoso**.

**Grandeza util:** `Delta_O_gas = m_O,rem - m_O,CO2`

**Calculo:** `Delta_O_gas = 1056.7150275 - 867.728576 = 188.9864515` `kg/dia`

**Interpretacao:** Ha `189` `kg/dia` de **O** do substrato removido que **nao** sai como `O` no `CO2` do biogas calculado; esse oxigenio tende a ir para **fase liquida** (`H2O`, alcool, acidos, bicarbonato) ou permanecer em materia organica nao mineralizada. Inverter o sinal depende da convencao “consumido/liberado”; aqui o recado fisico e: **o gas `CO2` nao esgota o oxigenio do organico degradado**.

---

## 13. Volume do reator e `COV` (checagem)

**Ideia fisica:** Em regime estacionario com alimentacao constante, o inventario de liquido no reator mantem-se e `TRH` relaciona volume util com vazao.

**Formula do volume:** `V_reator = Q_tot * theta`

**Calculo:** `V_reator = 100 * 20 = 2000` `m3`

**Definicao (`COV`, carga organica volumetrica em termos de `SV`):** Massa de `SV` alimentada por dia por volume de reator.

**Formula:** `COV_SV = m_SV,in / V_reator`

**Calculo:** `COV_SV = 5116.1925 / 2000 = 2.55809625` `kgSV/(m3*dia)`

**Interpretacao:** Cada metro cubico de reator recebe cerca de `2.56` `kg` de `SV` por dia, valor tipicamente plausivel para digestao mesofilica, dependendo do tipo de reator e mistura (sempre confirmar com literatura de projeto).

---

## 14. Digestato: massa, `ST` residual, `SV` residual, `SF`

**Ideia fisica (modelo de solidos usado):** Partimos de `ST = SV + SF`, com `SF` **inerte** no balanco de `SV` (nao e `SV`). Quando `SV` e “removido”, assumimos que essa massa deixa o estoque de `SV` (vai para gas, liquido dissolvido, biomassa, etc.), enquanto `SF` da alimentacao permanece.

**Formulas:**

- `m_SF,in = m_ST,in - m_SV,in = 6499.59 - 5116.1925 = 1383.3975` `kg/dia`
- `m_SV,out = m_SV,in * (1 - eta_SV) = 5116.1925 * 0.45 = 2302.286625` `kg/dia`
- `m_ST,out = m_SF,in + m_SV,out = 1383.3975 + 2302.286625 = 3685.684125` `kg/dia`

**Massa total do digestato (fechamento massico simples gas + liquido):**

**Formula:** `m_digest = m_in - m_gas`

**Calculo:** `m_digest = 102270 - 1984.0363 = 100285.9637` `kg/dia`

**Fracao massica de solidos no digestato:**

`w_ST,out = m_ST,out / m_digest = 3685.684125 / 100285.9637 = 0.036751...` → **`3.68` `%` `ST`**

**Fracao massica de `SV` no digestato:**

`w_SV,out = m_SV,out / m_digest = 2302.286625 / 100285.9637 = 0.022956...` → **`2.30` `%` `SV`**

**`SF` no digestato:** Na ausencia de geracao de inorganicos, `m_SF,out = m_SF,in = 1383.3975` `kg/dia`

**Checagem interna:** `m_ST,out = m_SV,out + m_SF,out = 2302.286625 + 1383.3975 = 3685.684125` `kg/dia` (ok)

**Interpretacao:** O digestato continua sendo majoritariamente **agua**, com solidos totais cerca de `3.7` `%` massica.

---

## 15. Fechamento global de massa (`entrada = biogas + digestato`)

**Ideia fisica:** Conservacao de massa para o volume de controle estacionario: tudo que entra e sai como correntes principais deve somar.

**Formula:** `m_in = m_gas + m_digest`

**Calculo:**

`747.2208 + 1193.1268 + 43.6887 + 100285.9637 = 102270.0000` `kg/dia`

**Interpretacao:** Com a premissa de `M_out`, o fechamento **massico global** fecha na casa dos `0.01` `kg/dia` por arredondamentos intermediarios; conceitualmente **fecha**.

---

## 16. Tabela resumo numerica completa

| Grandeza | Simbolo | Valor | Unidade |
|----------|---------|-------|---------|
| Massa alimentada total | `m_in` | `102270` | `kg/dia` |
| `ST` alimentado | `m_ST,in` | `6499.59` | `kg/dia` |
| `SV` alimentado | `m_SV,in` | `5116.19` | `kg/dia` |
| Indice `C/N` (ponderado por `SV`, Tabela B) | `(C/N)_mix` | `24.6` | — |
| `SV` removido | `m_SV,rem` | `2813.91` | `kg/dia` |
| Biogas | `Q_bg` | `1688.34` | `Nm3/dia` |
| `CH4` | `Q_CH4` | `1046.77` | `Nm3/dia` |
| `CO2` | `Q_CO2` | `607.80` | `Nm3/dia` |
| Outros | `Q_out` | `33.77` | `Nm3/dia` |
| `n_CH4` | `n_CH4` | `46.701` | `kmol/dia` |
| `n_CO2` | `n_CO2` | `27.117` | `kmol/dia` |
| Massa `CH4` | `m_CH4` | `747.2` | `kg/dia` |
| Massa `CO2` | `m_CO2` | `1193.1` | `kg/dia` |
| Massa outros | `m_out` | `43.7` | `kg/dia` |
| Massa total gas | `m_gas` | `1984.0` | `kg/dia` |
| `C` no `CH4` | `m_C,CH4` | `560.42` | `kg/dia` |
| `C` no `CO2` | `m_C,CO2` | `325.40` | `kg/dia` |
| `H` no `CH4` | `m_H,CH4` | `186.81` | `kg/dia` |
| Volume reator | `V_reator` | `2000` | `m3` |
| `COV` (`SV`) | `COV_SV` | `2.56` | `kgSV/(m3*dia)` |
| `SV` no digestato | `m_SV,out` | `2302.29` | `kg/dia` |
| `ST` no digestato | `m_ST,out` | `3685.68` | `kg/dia` |
| `SF` no digestato | `m_SF,out` | `1383.40` | `kg/dia` |
| Massa digestato | `m_digest` | `100286` | `kg/dia` |
| Elementos no `SV` (entrada) | C;H;O;N;S | `2471.28`; `345.23`; `1921.30`; `190.40`; `30.90` | `kg/dia` |

---

## 17. Confiabilidade

**Dados e hipoteses:** Usamos densidades, `ST`, `SV/ST`, indices `C/N` e composicao elementar como **medias representativas**; variabilidade sazonal e amostragem nao aparecem.

**Fechamento elementar vs rendimento de gas:** O carbono que sai como `CH4`+`CO2` (`~885.8` `kg/dia`) **nao** iguala automaticamente `eta_SV` vezes o carbono total dos `SV` (`0.55 * 2471.28 = 1359.21` `kg/dia`). Isso mostra que o par `eta_SV` + `Y_bg` + composicao do biogas e um **conjunto de correlacoes operacionais**, nao um modelo estequiometrico fechado. Diferencas tipicas entram por: **biomassa microbiana**, **CO2 dissolvido** na fase liquida, **carbono dissolvido** (acidogenicos), e incerteza da fracao `outros`.

**Solidos fixos:** Cinzas e minerais existem, mas **nao** receberam analise elementar aqui; o fechamento elementar e **sobre a fracao organica (`SV`)**.

**`H2O` metabolica:** A Secao 11 mostrou **incoerencia entre balancos por H e por O** quando se usa apenas `CH4`/`CO2`; esperado se faltam especies liquidas.

**`M_out` dos `outros`:** Afeta `m_gas` e `m_digest`; escolher `M_out` diferente altera levemente o fechamento massico sem mudar `CH4`/`CO2` dados pelas fracoes.

**Ordem de grandeza:** Massa de gas (`~2` `%` da massa alimentada) e plausivel; solidos no digestato (`~3.7` `%`) tambem.

**Classificacao de confiabilidade:** **Media** para balanco massico global com premissas declaradas; **baixa a media** para balancos elementares finos sem medicao de fase liquida e sem taxa de sintese de biomassa.

---

## Apendice: elementos no digestato organico (ordem de grandeza)

**Ideia:** Para `C`, `H`, `O`, `N`, `S` associados ao `SV` **na saida**, um modelo linear simples supoe que a fracao elementar do `SV` residual e a mesma da mistura de entrada (na pratica muda, mas serve como referencia).

**Formula:** `m_E,SV,out = m_SV,out * (m_E,SV,in / m_SV,in)`

**Exemplo (`C`):** `m_C,SV,out = 2302.286625 * (2471.282775 / 5116.1925) = 1112.96` `kg/dia` (aprox.)

Comparando com `C` no gas (`885.81` `kg/dia`), ainda sobra carbono “nao alocado” se exigirmos que **todo** carbono removido aparecesse apenas em gas — reforca a nota da Secao 17.

---

*Fim do documento.*
