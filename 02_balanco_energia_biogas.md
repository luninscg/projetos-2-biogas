# Balanco de energia completo - codigestao e biogas

## Objetivo deste arquivo

Explicar, passo a passo, **quanta energia termica** o digestor precisa receber, **quanto calor** a reacao biologica libera, **quanto poder energetico** existe no biogas e **quanto de eletricidade e calor** um cogerador (CHP) pode entregar, sem violar conservacao de energia nem a termodinamica basica.

---

## 1. Conceitos (definicoes antes do uso)

### Calor sensivel

**Definicao:** Energia que entra ou sai de um corpo **sem** mudar de fase (sem virar vapor ou gelo). Ela so **aumenta ou diminui a temperatura**.

**Intuicao fisica:** E como aquecer agua na panela: enquanto ainda e liquida, o que voce coloca e calor sensivel. No digestor, a mistura entra mais fria e precisa ser levada a `35 degC`; a maior parte da demanda e sensivel.

### Calor latente

**Definicao:** Energia associada a **mudanca de fase** (fusao, vaporizacao, condensacao), a temperatura constante enquanto a fase muda.

**Intuicao fisica:** E o calor que vira "quebra de ligacao" entre moleculas, nao termometro subindo. Neste balanco **nao detalhamos** evaporacao ou condensacao; se no futuro houver secagem forte do digestato, o latente entra explicitamente.

### PCI (poder calorifico inferior)

**Definicao:** Energia liberada na combustao completa de um combustivel quando a **agua do produto fica como vapor** (nao se recupera o calor de condensar essa agua).

**Intuicao fisica:** E o que motores e queimadores "veem" na pratica. Aqui usamos `PCI metano = 35.8 MJ/Nm3` para traduzir volume de metano em energia quimica.

### CHP (cogeracao)

**Definicao:** Equipamento que **queima combustivel** (aqui, biogas) e produz **eletricidade** e **calor util** ao mesmo tempo (motor/gerador + recuperacao de calor).

**Intuicao fisica:** Nem toda energia do combustivel vira eletricidade (Segunda Lei); parte vira calor nos gases e na agua de arrefecimento. Por isso se falam **eficiencia eletrica** e **eficiencia termica** separadas.

### Biogas em condicoes normais (Nm3)

**Definicao:** Metro cubico de gas referido a **condicoes normais** de pressao e temperatura padrao do projeto (aqui, coerente com o balanco de massa).

**Intuicao fisica:** Volume de gas muda com T e P; `Nm3` permite comparar dias e projetos sem confundir expansao termica.

### Exotermico

**Definicao:** Processo que **libera calor** para os arredores.

**Intuicao fisica:** A digestao anaerobia libera pouco calor de reacao comparada a rotas aerobicas; mesmo assim, contamos esse termo porque **reduz** a demanda liquida de aquecimento.

---

## 2. Dados herdados do balanco de massa (entrada numerica)

| Grandeza | Simbolo / nome | Valor | Unidade |
|---|---|---:|---|
| Massa de entrada (mistura) | `M_entrada` | `102270` | kg/dia |
| Solidos volateis na entrada | `SV_entrada` | `5116.19` | kg/dia |
| Solidos volateis removidos (convertidos) | `SV_removido` | `2813.91` | kg/dia |
| Volume de biogas | `V_biogas` | `1688.34` | Nm3/dia |
| Volume de metano no biogas | `V_CH4` | `1046.77` | Nm3/dia |
| Volume de CO2 no biogas | `V_CO2` | `607.80` | Nm3/dia |
| Massa de CH4 no biogas | `m_CH4` | `747.2` | kg/dia |
| Massa de CO2 no biogas | `m_CO2` | `1193.1` | kg/dia |
| Volume util do reator | `V_reator` | `2000` | m3 |

**Hipotese de rastreio:** Os valores acima sao **a mesma base** do arquivo `01_balanco_massa_biogas.md`; arredondamentos de exibicao nao mudam a ordem de grandeza.

---

## 3. Premissas de energia (explicitas)

| Premissa | Valor | Unidade | Significado fisico |
|---|---:|---|---|
| Temperatura da mistura na entrada | `T_entrada = 20` | degC | Referencia de aquecimento da alimentacao |
| Temperatura de operacao do digestor | `T_digestor = 35` | degC | Regime mesofilico |
| Calor especifico da mistura | `Cp = 4.0` | kJ/(kg.K) | Quanto calor por kg para subir 1 K |
| Perdas termicas do reator (fracao do aquecimento) | `f_perda = 0.15` | - | Cobertura de perdas para ambiente, tubulacoes, imperfeicoes |
| PCI do metano (base Nm3) | `PCI_CH4 = 35.8` | MJ/Nm3 | Energia quimica por volume de CH4 |
| Eficiencia eletrica do CHP | `eta_el = 0.38` | - | Fracao da energia do biogas que vira eletricidade |
| Eficiencia termica do CHP | `eta_th = 0.42` | - | Fracao da energia do biogas recuperada como calor util |
| Consumo auxiliar | `f_aux = 0.05` | - | 5% da eletricidade bruta para bombas, controles, etc. |
| Calor de reacao anaerobia | `q_rx = 1.2` | MJ/kg SV removido | Calor **gerado** pela bioconversao (modelo simplificado) |

**Confiabilidade destas premissas:** `Cp` e perdas dependem de isolamento real e da umidade da mistura; `eta_el` e `eta_th` dependem do fabricante e do ponto de operacao; `q_rx` e ordem de grandeza, nao substituto de calorimetria.

---

## 4. Secoes obrigatorias do balanco

### 4.1 Calor para aquecer a alimentacao (calor sensivel)

**Intuicao fisica antes da formula:** Cada quilograma de mistura precisa "subir de degrau termico" de `20 degC` ate `35 degC`. Quanto maior a massa diaria e o `Cp`, maior a conta.

**Formula:**

`Q_aquec = M_entrada * Cp * (T_digestor - T_entrada)`

**Unidades:** `kg/dia * kJ/(kg.K) * K -> kJ/dia` (diferenca em degC igual a diferenca em K para deltas).

**Calculo:**

`Q_aquec = 102270 * 4.0 * (35 - 20) = 6136200 kJ/dia`

`Q_aquec = 6136200 / 1000 = 6136.2 MJ/dia`

**Significado fisico:** Sem essa energia (ou equivalente trocado com o meio), a alimentacao nao chega a `35 degC` sozinha na vazao dada.

---

### 4.2 Perdas termicas associadas ao aquecimento (modelo proporcional)

**Intuicao fisica antes da formula:** O reator perde calor para o ambiente. Aqui **nao** temos coeficiente global de transferencia nem area; usamos **15%** do calor de aquecimento como envelope de perdas.

**Formula:**

`Q_perdas = Q_aquec * f_perda`

**Calculo:**

`Q_perdas = 6136.2 * 0.15 = 920.4 MJ/dia`

**Significado fisico:** E energia que **sai** do sistema util e nao volta como trabalho ou produto.

---

### 4.3 Calor gerado pela reacao anaerobia (termo exotermico simplificado)

**Intuicao fisica antes da formula:** A conversao biologica libera um pouco de calor por kg de SV efetivamente removido. Esse termo **ajuda** a aquecer o sistema (reduz demanda liquida).

**Formula:**

`Q_reacao = q_rx * SV_removido`

**Calculo:**

`Q_reacao = 1.2 * 2813.91 = 3376.7 MJ/dia`

**Significado fisico:** Calor **entrando** no balanco de demanda como fonte interna (nao e PCI do biogas; e outro mecanismo).

---

### 4.4 Demanda termica total liquida (aquecimento + perdas - reacao)

**Intuicao fisica antes da formula:** Some o que precisa aquecer e as perdas; subtraia o calor gerado na biologia. O resultado e o que o processo **ainda precisa** suprir por utilidades se nada mais entrasse.

**Formula:**

`Q_demanda = Q_aquec + Q_perdas - Q_reacao`

**Calculo:**

`Q_demanda = 6136.2 + 920.4 - 3376.7 = 3679.9 MJ/dia`

**Checagem de plausibilidade:** `Q_demanda` e positivo e menor que `Q_aquec + Q_perdas`, coerente com reacao exotermica parcial.

---

### 4.5 Energia quimica no biogas (via metano e PCI)

**Intuicao fisica antes da formula:** O metano e o principal "combustivel" do biogas. Multiplicar volume de CH4 pelo PCI estima a energia quimica disponivel **se** queimarmos esse metano.

**Formula:**

`E_biogas = V_CH4 * PCI_CH4`

**Calculo:**

`E_biogas = 1046.77 * 35.8 = 37474.4 MJ/dia`

**Significado fisico:** Teto energetico **quimico** associado ao CH4 do dia; nao pressupoe ainda eficiencia de maquina.

**Nota de conservacao:** Este termo e **entrada de energia quimica** do lado do combustivel; o CO2 carrega entalpia de formacao, mas **nao** entra no PCI do CH4 da mesma forma; o modelo e operacional (combustao de CH4).

---

### 4.6 Eletricidade bruta do CHP

**Intuicao fisica antes da formula:** O motor/gerador nao converte toda a energia do combustivel em eletricidade; parte vira calor e irreversibilidades.

**Formula:**

`E_el_bruta = E_biogas * eta_el`

**Calculo:**

`E_el_bruta = 37474.4 * 0.38 = 14240.3 MJ/dia`

**Conversao para kWh (definicao):** `1 kWh = 3.6 MJ`, logo:

`E_el_bruta = 14240.3 / 3.6 = 3955.6 kWh/dia`

**Significado fisico:** Energia eletrica **antes** de consumos internos da planta.

---

### 4.7 Calor util recuperado no CHP

**Intuicao fisica antes da formula:** A cogeracao recupera calor (agua quente, vapor baixo, secador, etc.) com eficiencia propria.

**Formula:**

`Q_CHP = E_biogas * eta_th`

**Calculo:**

`Q_CHP = 37474.4 * 0.42 = 15739.2 MJ/dia`

**Significado fisico:** Calor **potencialmente** disponivel para processo (aquecimento do digestor, predio, pasteurizacao, etc.), dependendo de trocadores e pinch.

---

### 4.8 Excedente termico (CHP versus demanda)

**Intuicao fisica antes da formula:** Se o CHP entrega mais calor util que a demanda modelada, sobra excedente (ou precisa dissipar, ou outro uso).

**Formula:**

`Q_excedente = Q_CHP - Q_demanda`

**Calculo:**

`Q_excedente = 15739.2 - 3679.9 = 12059.3 MJ/dia`

**Significado fisico:** Indicativo de **folga termica** nesta versao de premissas; na planta real, integracao termica pode reduzir perdas ou aumentar recuperacao.

---

### 4.9 Consumo auxiliar de eletricidade

**Intuicao fisica antes da formula:** Bombas, sopradores, instrumentacao e perdas eletricas internas consomem parte do que foi gerado.

**Formula:**

`E_aux = f_aux * E_el_bruta_kWh`

**Calculo:**

`E_aux = 0.05 * 3955.6 = 197.8 kWh/dia`

---

### 4.10 Eletricidade liquida

**Intuicao fisica antes da formula:** O que sobra para exportar ou alimentar outras areas apos auxiliares.

**Formula:**

`E_el_liq = E_el_bruta_kWh - E_aux`

**Calculo:**

`E_el_liq = 3955.6 - 197.8 = 3757.8 kWh/dia`

---

## 5. Tabela resumo

| Item | Valor | Unidade |
|---|---:|---|
| `Q_aquec` | `6136.2` | MJ/dia |
| `Q_perdas` | `920.4` | MJ/dia |
| `Q_reacao` | `3376.7` | MJ/dia |
| `Q_demanda` | `3679.9` | MJ/dia |
| `E_biogas` (via CH4) | `37474.4` | MJ/dia |
| `E_el_bruta` | `14240.3` | MJ/dia (`3955.6` kWh/dia) |
| `Q_CHP` | `15739.2` | MJ/dia |
| `Q_excedente` | `12059.3` | MJ/dia |
| `E_aux` | `197.8` | kWh/dia |
| `E_el_liq` | `3757.8` | kWh/dia |

---

## 6. Confiabilidade

### Nivel sugerido

`B - bom para estudo conceitual e comparacao de cenarios`, desde que as premissas acima sejam aceitas.

### O que e forte

- Rastreio claro entre massa (SV removido, V_CH4) e energia (PCI, eficiencias).
- Separacao entre **demanda termica do digestor** e **oferta termica do CHP**.
- Nenhum passo assume criacao de energia alem do combustivel e do modelo de reacao.

### O que limita a certeza

- `Cp` real da mistura e umidade nao medidos aqui.
- Perdas de `15%` sao envelope, nao calculo de `U*A*deltaT`.
- `q_rx` e parametro de literatura/ordem de grandeza.
- PCI e composicao real do biogas (umidade, H2S, N2) podem desviar.
- CHP em carga parcial muda `eta_el` e `eta_th`.

### Como subir de nivel

- Medir temperaturas e vazoes reais; calibrar `Cp`.
- Folha de dados do cogerador; curva de eficiencia.
- Opcional: balanco elementar e entalpia de reacao mais detalhada (ainda respeitando conservacao).

---

## 7. Checagens rapidas (unidades e ordem de grandeza)

- `Q_aquec`: ordem `10^6 kJ/dia` para `10^5 kg/dia` e `DeltaT ~ 15 K` com `Cp ~ 4 kJ/kgK` e plausivel.
- `E_biogas`: `~1000 Nm3/dia` de CH4 com `PCI ~ 36 MJ/Nm3` da `~36000 MJ/dia`; resultado `37474.4` MJ/dia e coerente.
- `E_el_liq`: abaixo de `E_el_bruta` por exatamente `5%` de auxiliar, coerente com a premissa.
