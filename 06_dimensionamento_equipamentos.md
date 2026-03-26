# Dimensionamento de equipamentos - biogas por codigestao anaerobia

Documento de apoio ao projeto: estimativas de tamanho, potencia e materiais com base em balanco de massa/energia e correlacoes de engenharia. **Nivel de confiabilidade: B** (ordens de grandeza validas para estudo de viabilidade; detalhamento construtivo exige fornecedor e normas locais).

**Referencias:** Towler & Sinnott (2012), *Chemical Engineering Design*; Perry & Green, *Perry's Chemical Engineers' Handbook*; Metcalf & Eddy et al., *Wastewater Engineering: Treatment and Resource Recovery*; ASME BPVC Sec. VIII Div. 1 (espessura de pressao).

---

## Dados do projeto (balanco ja consolidado)

| Grandeza | Valor |
|----------|-------|
| Vazao total alimentacao | `100 m3/dia` = `4.167 m3/h` |
| Massa total entrada | `102270 kg/dia` |
| SV entrada | `5116 kg/dia` |
| SV removido | `2814 kg/dia` |
| Biogas | `1688 Nm3/dia` = `70.3 Nm3/h` |
| CH4 no biogas | `1047 Nm3/dia` |
| Massa biogas | `1984 kg/dia` |
| Digestato | `100286 kg/dia` |
| ST digestato | `3686 kg/dia` |
| TRH | `20 dias` |
| T operacao | `35 degC`; T entrada mistura | `20 degC` |
| Q aquecimento | `6136 MJ/dia` = `71.0 kW` (termico medio) |
| Q perdas | `920 MJ/dia` |
| Q reacao | `3377 MJ/dia` |
| Q demanda liquida | `3680 MJ/dia` = `42.6 kW` |
| Eletricidade liquida | `3758 kWh/dia` = `156.6 kW` (medio) |
| Calor CHP recuperavel | `15739 MJ/dia` |

---

## 1. Metodologia de dimensionamento

**Intuicao:** cada equipamento cumpre uma funcao (misturar, reagir, trocar calor, bombear, separar solido, queimar gas). O tamanho nao e "chute": liga-se a **vazao** ou **carga termica** atraves de uma equacao que expressa conservacao de massa, conservacao de energia ou uma **correlacao empirica** (coeficiente global de troca, tempo de contato, etc.).

**Procedimento padrao:**

1. **Definir a funcao** do equipamento no fluxograma do processo.
2. **Identificar a variavel de dimensionamento** (volume util, area de troca, vazao da bomba, potencia do motor, etc.).
3. **Aplicar a equacao fundamental** (ex.: `V = Q * t` para tempo de retencao, `Q = U * A * LMTD` para trocador).
4. **Adicionar margem de seguranca** (tipicamente `10%` a `20%`, mais em servicos com incrustacao ou variacao de carga).
5. **Especificar material** compativel com pH, `H2S`, abrasividade do lodo e norma de pressao.

**Significado fisico:** margens absorvem incerteza da composicao do substrato, fouling e paradas; nao substituem simulacao piloto ou laudo do fabricante.

---

## 2. Tanque de mistura (TQ-101)

### Funcao

Receber e homogeneizar os tres substratos antes da alimentacao ao digestor, reduzindo gradientes de concentracao e temperatura na entrada do reator.

### Dimensionamento

**Intuicao:** o volume util deve ser grande o suficiente para que a mistura "veja" o tanque durante um tempo fixo; quanto maior a vazao ou o tempo desejado, maior o tanque.

**Equacao:** `V_util = Q_tot * t_ret`

- Criterio: tempo de retencao no tanque `t_ret = 12 h` = `0.5 dia`
- Vazao total: `Q_tot = 100 m3/dia`
- Volume util: `V = 100 * 0.5 = 50 m3`
- Margem `20%`: `V_total = 50 * 1.2 = 60 m3`

**Geometria (cilindro vertical, H/D = 1.0):**

**Intuicao:** com altura igual ao diametro, o tanque e compacto e a mistura tende a ter caminho de circulacao simetrico; o volume fecha com `V = (pi/4) * D^2 * H`.

Com `H = D`: `V = (pi/4) * D^3` => `D = (4*V/pi)^(1/3)`

- `D = (4*60/3.1416)^(1/3) = 4.24 m` -> **adotar** `D = 4.3 m`, `H = 4.3 m`

**Agitacao:** agitador de helice; potencia tipica da ordem de `0.5 kW/m3` de volume agitado -> `~0.5 * 60 = 30 kW` (ordem de grandeza; projeto detalhado exige curva de viscosidade do lodo).

**Material:** aco carbono com revestimento epoxi ou PRFV (poliester reforcado com fibra de vidro), face a umidade e possivel corrosividade da matriz organica.

---

## 3. Digestor anaerobio (D-101)

### Funcao

Reator tipo **CSTR** (reator continuamente agitado com mistura homogenea) onde ocorre a digestao anaerobia; o biogas acumula na zona de gas (headspace ou integracao com gasometro).

### Dimensionamento

**Intuicao:** em regime continuo, o tempo hidraulico medio no liquido e o **TRH** (tempo de retencao hidraulico); o volume util do liquido escala linearmente com vazao.

**Equacao:** `V_liquido = Q_tot * TRH`

- `V_util = 100 m3/dia * 20 dias = 2000 m3`
- Margem para **headspace** (gasometro integrado / expansao de gas): `+15%` -> `V_total_casco = 2000 * 1.15 = 2300 m3` (volume total englobando gas + liquido na concepcao de projeto; na pratica separa-se `V_liq` e `V_gas`)

**Geometria:** cilindro vertical com topo conico (coleta de gas).

Relacao **H/D** entre `1.5` e `2.0` e tipica em digestores para equilibrar altura util e custo de fundacao.

- Adotar **H/D = 1.5** na zona liquida: `H_liq = 1.5 * D`
- `V_liq = (pi/4) * D^2 * H_liq = (pi/4) * D^2 * 1.5D = 1.5 * (pi/4) * D^3`
- `D^3 = V_liq * 4 / (1.5 * pi) = 2000 * 4 / (1.5 * 3.1416) = 1697.65`
- `D = 1697.65^(1/3) = 11.93 m` -> **adotar** `D = 12.0 m`
- `H_liq = 1.5 * 12 = 18.0 m`
- `H_headspace ~ 3.0 m` (zona de gas)
- `H_total ~ 21.0 m`

**Verificacao:** `V_liq_real = (pi/4) * 12^2 * 18 = 2036 m3` (ligeiramente acima de `2000 m3` - aceitavel).

**Agitacao:** mecanica ou recirculacao de biogas; potencia tipica `5` a `10 W/m3` -> `2000 * (5 a 10) = 10` a `20 kW`.

**Isolamento:** la de rocha `100 mm` ou poliuretano expandido, para reduzir `Q_perdas` e estabilizar `35 degC`.

**Pressao interna:** ate `50 mbar` (`0.05 atm`) acima da atmosferica.

**Espessura de parede (estimativa ASME VIII Div. 1, cilindro):**

**Intuicao:** a tensao circunferencial tende a empurrar a parede para fora; a norma relaciona pressao, raio e tensao admissivel do material.

**Forma cilindrica:** `t = P * R / (S * E - 0.6 * P)`

- `P = 0.05 atm = 5.07 kPa` (usar unidades consistentes com `S`; aqui em MPa para `R` em mm: `P = 5.07e-3 MPa`)
- `R = 6.0 m = 6000 mm`
- `S = 137.9 MPa` (ASTM A516 Gr.70 a `~35 degC`, valor indicativo - confirmar na norma/projeto)
- `E = 0.85` (eficiencia de junte)

` t = 5.07e-3 * 6000 / (137.9 * 0.85 - 0.6 * 5.07e-3) ~ 0.26 mm `

**Minimo construtivo** tipico `6.35 mm` (`1/4 in`); **sobreespessura de corrosao** `+3 mm`; **adotar** `t = 10 mm` para rigidez, solda e vida util.

**Material:** aco carbono **ASTM A516 Gr.70** com revestimento epoxi interno; **aco inox 316L** na zona de gas rica em `H2S` se o projeto exigir.

---

## 4. Trocador de calor (TC-101)

### Funcao

Elevar a temperatura da mistura de `20 degC` para `35 degC` usando agua quente do CHP (cogeracao).

### Dimensionamento

**Intuicao:** a taxa de calor `Q` que deve atravessar a parede e proporcional a area `A` e a "forca motriz" termica media (LMTD), com fator `U` que agrupa resistencias termicas e conveccao.

**Carga termica (media continua):** `Q = 6136 MJ/dia = 71.02 kW` (alinhado a `6136 MJ/dia` e `71.0 kW` do balanco).

**Perfil termico adotado:**

- Fluido quente: agua `80 degC` -> `50 degC`
- Fluido frio: mistura `20 degC` -> `35 degC`

**LMTD (contracorrente):**

**Intuicao:** quando `DeltaT` muda ao longo do trocador, usa-se a media logaritmica para nao superestimar ou subestimar a troca.

` LMTD = (DeltaT1 - DeltaT2) / ln(DeltaT1 / DeltaT2) `

- `DeltaT1 = 80 - 35 = 45 degC`
- `DeltaT2 = 50 - 20 = 30 degC`
- `LMTD = (45 - 30) / ln(45/30) = 15 / 0.405 = 37.0 degC`

**Coeficiente global:** `U = 500` a `1500 W/(m2*K)` para agua/lodo; **adotar** `U = 800 W/(m2*K)` (conservador por viscosidade e fouling).

**Area:** `A = Q / (U * LMTD) = 71020 / (800 * 37.0) = 2.40 m2`

Margem `30%` (fouling com lodo): `A = 2.40 * 1.3 = 3.1 m2`

**Tipo:** trocador espiral (melhor para lodos) ou casco-tubo com tubos largos.

**Material:** aco inox **316L** no lado lodo; aco carbono no lado agua.

---

## 5. Bombas (P-101 e P-102)

### P-101 - Bomba de alimentacao

**Intuicao:** a potencia hidraulica e o produto vazao vezes queda de pressao; o motor deve suprir perdas mecanicas e eficiencia reduzida em fluido nao newtoniano/abrasivo.

- Vazao: `Q = 100 m3/dia = 4.17 m3/h = 1.16 L/s`
- Pressao diferencial estimada: `~2 bar` (tubulacao, elevacao, TC-101)
- Potencia hidraulica: `W_hid = Q * dP = 1.16e-3 m3/s * 200000 Pa = 232 W = 0.23 kW`
- Eficiencia bomba (lodo): `eta = 0.60`
- Potencia eixo: `W = 0.23 / 0.60 = 0.39 kW`
- **Motor comercial:** `0.75 kW`
- Tipo: bomba de **cavidade progressiva**
- Material: corpo ferro fundido, rotor aco inox

### P-102 - Bomba de digestato

- Vazao massica: `100286 kg/dia`; densidade assumida `~1010 kg/m3` -> `Q ~ 99.3 m3/dia = 4.14 m3/h` (similar a P-101)
- Mesma logica de `dP` e eficiencia -> **motor** `0.75 kW`
- Material: **aco inox 316L** (exposicao a `H2S` dissolvido e corrosividade)

---

## 6. Filtro-prensa (FP-101)

### Funcao

Desaguar digestato de teor de solidos total baixo para torta mais seca (menor volume para destinacao).

### Dimensionamento

**Intuicao:** a prensa separa uma corrente rica em solidos (torta) e uma liquida (filtrado); o dimensionamento liga-se a massa de solidos a retirar e ao tempo de ciclo.

- Digestato: `100286 kg/dia`
- Concentrar ST de `~3.7%` para `~25%` (valores de projeto)
- Massa de torta (solidos na torta, ordem de projeto): `~14742 kg/dia`
- Filtrado: `~85544 kg/dia` (agua associada + finos, conforme balanco simplificado)
- Ciclo: `8 h` por batelada, `3` bateladas/dia
- Massa por batelada: `100286 / 3 ~ 33429 kg` (~`33 m3` se `rho ~ 1010 kg/m3`)

**Area de filtracao:** faixa tipica `50` a `200 m2`; **estimar** `~100 m2` para esta vazao (confirmar com fabricante e ensaio de filtrabilidade).

**Pressao de operacao:** `6` a `15 bar`

**Material:** placas polipropileno; estrutura aco carbono pintado.

---

## 7. Motor-gerador CHP (MG-101)

### Funcao

Queimar biogas em motor alternativo (adaptado de gas natural) gerando eletricidade e recuperando calor (agua quente para TC-101 e perdas).

### Dimensionamento

**Intuicao:** a potencia nominal do grupo deve cobrir a geracao media com folga para partida, degradacao e variacao do poder calorifico do gas.

- Combustivel: `1688 Nm3/dia` com `~62% CH4` (por `1047/1688`)
- Energia quimica no biogas (ordem de projeto, PCI dependente da composicao): `~37474 MJ/dia` (referencia interna ao balanco energetico)
- Potencia eletrica **bruta** (se disponivel no balanco): `3956 kWh/dia / 24 h = 164.8 kW`
- Potencia eletrica **liquida:** `3758 kWh/dia / 24 h = 156.6 kW`
- Potencia termica recuperavel: `15739 MJ/dia`; em kW medio: `P_kW = (MJ/dia) / 86.4` pois `1 kW` continuo por `24 h` equivale a `86.4 MJ/dia` -> `15739 / 86.4 ~ 182.2 kW`

**Selecao:** motor a gas **~200 kW** nominal (faixa comercial tipica em torno da potencia liquida + servicos auxiliares).

**Fabricantes tipicos:** Caterpillar, MWM, Cummins (lista nao exaustiva).

**Material:** conforme pacote do fabricante.

---

## 8. Gasometro / tanque de biogas (TQ-102)

### Funcao

Amortecer variacoes entre producao no digestor e consumo no CHP (buffer horario).

**Intuicao:** o volume deve cobrir algumas horas de producao a vazao media, para nao "starvar" o motor nem ventilar excedente em picos curtos.

- Producao media: `1688/24 = 70.3 Nm3/h`
- Armazenar `4` a `8 h`; adotar `6 h`: `V_N = 70.3 * 6 ~ 422 Nm3`
- A `~1.02 atm`, volume real ~`420 m3` (ordem de grandeza)

**Tipo:** membrana PVC/EPDM sobre estrutura metalica, ou integrado ao topo do digestor.

**Material:** membrana **EPDM** ou **PVC** reforcado.

---

## 9. Dessulfurizador (DS-101)

### Funcao

Reduzir `H2S` para **< 200 ppm** (ordem tipica para protecao de motor e pos-tratamento), antes do CHP.

**Tipo:** leito fixo com carvao ativado impregnado.

**Intuicao:** o gas deve permanecer tempo suficiente no leito para difusao e reacao adsorptiva; o volume do leito escala com vazao e **EBCT** (empty bed contact time - tempo de contato em leito vazio).

- `Q = 70.3 Nm3/h`
- `EBCT = 2` a `4 min`; adotar `3 min`
- Volume de leito: `V = Q * EBCT = (70.3/60) * 3 = 3.5 m3`

**Geometria indicativa:** diametro `~1.0 m`, altura de leito `~4.5 m` (ajustar `L/D` e queda de pressao com fabricante).

**Material:** aco carbono com epoxi ou PRFV.

---

## 10. Tanque de NaOH (TQ-103)

### Funcao

Armazenar solucao de **NaOH 50%** para correcao de pH na etapa de mistura ou digestao, conforme estrategia operacional.

- Volume: `1` a `2 m3` (reserva para `7` a `14 dias` de uso esperado - calibrar com plano de dosagem)

**Material:** **PEAD** (polietileno de alta densidade), compativel com hidroxido.

---

## 11. Tabela resumo de equipamentos

| Tag | Nome | Dimensao principal | Potencia | Material | Custo estimado (ordem) |
|-----|------|--------------------|----------|----------|-------------------------|
| TQ-101 | Tanque mistura | `V ~ 60 m3`, `D/H ~ 4.3 m` | `~30 kW` agitacao | Aco carbono + epoxi / PRFV | `0.1` a `0.3` MUSD |
| D-101 | Digestor CSTR | `V_liq ~ 2000 m3`, `D 12 m`, `H_tot ~ 21 m` | `10` a `20 kW` mistura | A516 Gr.70 + epoxi; 316L zona gas | `2` a `5` MUSD |
| TC-101 | Trocador calor | `A ~ 3.1 m2` | - (servico termico) | 316L / carbono | `0.05` a `0.15` MUSD |
| P-101 | Bomba alimentacao | `~4.2 m3/h`, `dP ~ 2 bar` | `0.75 kW` | Fundido + inox rotor | `0.01` a `0.03` MUSD |
| P-102 | Bomba digestato | `~4.1 m3/h` | `0.75 kW` | 316L | `0.02` a `0.04` MUSD |
| FP-101 | Filtro-prensa | `~100 m2` (estimativa) | conforme fabricante | PP + aco pintado | `0.2` a `0.6` MUSD |
| MG-101 | CHP | `~200 kW` nominal | `~157 kW` eletrico liquido medio | Pacote OEM | `0.4` a `1.0` MUSD |
| TQ-102 | Gasometro | `~420 m3` | - | EPDM/PVC | `0.05` a `0.2` MUSD |
| DS-101 | Dessulfurizador | `V_leito ~ 3.5 m3` | - | Carbono + epoxi/PRFV | `0.03` a `0.1` MUSD |
| TQ-103 | Tanque NaOH | `1` a `2 m3` | - | PEAD | `< 0.01` MUSD |

*Custos em milhoes de USD (MUSD) sao **ordens de grandeza** para estudos; variam com pais, prazos, INCC e pacote EPC.*

---

## 12. Confiabilidade

- **Nivel B:** adequado a **pre-estudo / conceitual** e comparacao de cenarios; incertezas principais: composicao real do biogas, filtrabilidade do digestor, `U` e fouling do TC-101, requisitos exatos do fabricante do CHP e normas locais de pressao e seguranca.
- **Fontes recomendadas para aprofundar:** Towler & Sinnott (2012); Perry & Green (*Perry's Handbook*); Metcalf & Eddy (tratamento de esgoto e lodos); ASME BPVC para vasos de pressao.

---

## Checagens rapidas (plausibilidade)

- **Massa:** digestato `~100286 kg/dia` coerente com entrada `102270` menos gas `1984` (ordem do balanco global).
- **Energia:** `Q_aquecimento` dimensiona TC-101 na mesma ordem do balanco (`~71 kW` medio).
- **Biogas:** `1688 Nm3/dia` e `70.3 Nm3/h` consistentes com buffer de `6 h` em `~422 Nm3`.

---

*Documento gerado para alinhamento com `00_base_biogas_codigestao.md` e balancos de massa/energia do projeto.*
