# Relatorio Final - Projeto de Producao de Biogas por Codigestao Anaerobia

## Informacoes

- Disciplina: Projetos Industriais II
- Curso: Engenharia Quimica - UFMS
- Professora: Janaina dos Santos Ferreira
- Semestre: `1o/2026`
- Equipe: (campo para preencher)
- Data: `17/06/2026`
- Peso na media: `MA = E1*0.25 + E2*0.25 + E3*0.50` (esta entrega: `50%`)

---

## Sumario

1. [Introducao](#1-introducao)  
   1.1 [Contexto](#11-contexto)  
   1.2 [Objetivo](#12-objetivo)  
   1.3 [Escopo e limitacoes](#13-escopo-e-limitacoes)  
2. [Descricao do processo](#2-descricao-do-processo)  
   2.1 [Digestao anaerobia](#21-digestao-anaerobia)  
   2.2 [Codigestao](#22-codigestao)  
   2.3 [Parametros operacionais](#23-parametros-operacionais)  
3. [Simbologia e fluxogramas](#3-simbologia-e-fluxogramas)  
   3.1 [Normas](#31-normas)  
   3.2 [PFD com tags](#32-pfd-com-tags)  
   3.3 [Lista de equipamentos](#33-lista-de-equipamentos)  
   3.4 [Tabela de correntes](#34-tabela-de-correntes-101-117)  
   3.5 [Instrumentacao](#35-instrumentacao)  
4. [Variaveis de processo e projeto](#4-variaveis-de-processo-e-projeto)  
5. [Balanco de massa](#5-balanco-de-massa)  
6. [Balanco de energia](#6-balanco-de-energia)  
7. [Dimensionamento dos equipamentos](#7-dimensionamento-dos-equipamentos)  
8. [Selecao de materiais](#8-selecao-de-materiais)  
9. [Utilidades](#9-utilidades)  
10. [Layout industrial](#10-layout-industrial)  
11. [Otimizacao do processo](#11-otimizacao-do-processo)  
12. [Analise economica](#12-analise-economica)  
13. [Verificacoes de consistencia](#13-verificacoes-de-consistencia)  
14. [Conclusao](#14-conclusao)  
15. [Referencias bibliograficas](#15-referencias-bibliograficas)

---

## 1. Introducao

### 1.1 Contexto

**Residuo organico** (materia que contem carbono biodegradavel) acumulado em **ETE** (estacao de tratamento de esgoto), na **destilaria** (como **vinhaca**, efluente da producao de etanol) e em **residuos de alimentos** representa **passivo ambiental**: gera odores, risco sanitario e custo de destinacao.

**Digestao anaerobia** e o processo biologico em que microrganismos degradam essa materia **sem oxigenio**, produzindo **biogas** (mistura util principalmente por conter **metano**, `CH4`). **Codigestao** e a digestao de **dois ou mais substratos** no mesmo reator, permitindo equilibrar nutrientes (por exemplo, relacao **C/N**) e estabilizar o processo.

### 1.2 Objetivo

Elaborar **projeto conceitual** de planta de producao de biogas por **codigestao anaerobia** de:

- lodo de esgoto;
- vinhaca de cana;
- residuo organico;

incluindo: definicao do processo, **balancos de massa e energia**, **dimensionamento** de equipamentos, **selecao de materiais**, **analise de utilidades** e **avaliacao economica**.

### 1.3 Escopo e limitacoes

- **Nivel de definicao**: conceitual (**Nivel B**), adequado a estudos de viabilidade e **front-end** de projeto.
- **Nao** substitui: **projeto executivo**, **licenciamento** detalhado, **ensaios de BMP** (potencial de producao de metano em laboratorio) ou **dados operacionais reais** da regiao.
- Composicoes e rendimentos adotam **literatura e bases publicas**; **caracterizacao local** e recomendada antes de decisao de investimento.

---

## 2. Descricao do processo

### 2.1 Digestao anaerobia

A conversao ocorre em **quatro etapas** sequenciais e acopladas (Chernicharo, 2007):

| Etapa | Nome | Ideia fisica (para leigo) |
|-------|------|---------------------------|
| 1 | **Hidrolise** | "Picar" macromoleculas (proteinas, carboidratos, lipideos) em pedacos menores |
| 2 | **Acidogenese** | Fermentacao rapida para acidos, alcoois, `H2`, `CO2` |
| 3 | **Acetogenese** | Converter intermediarios em **acetato** e `H2` consumiveis pelas metanogenicas |
| 4 | **Metanogenese** | Formar `CH4` a partir de acetato e/ou `H2` + `CO2` |

Se uma etapa falha (ex.: **acidificacao** por acumulo de acidos), as **metanogenicas** (mais sensiveis) podem ser inibidas e a producao de metano cai.

### 2.2 Codigestao

**Justificativa da mistura dos tres substratos**

- **Lodo de esgoto**: costuma ter **C/N baixa** (muito nitrogenio relativo ao carbono), risco de **amonia** liberada inibir metanogenicos.
- **Vinhaca**: **pH** frequentemente acido; alto **potassio** pode inibir se em excesso; porem traz **carbono** e materia degradavel.
- **Residuo organico**: elevada fracao de **SV** (solidos volateis, parte "que o microganismo consegue degradar"); pode acidificar se sozinho em excesso.

A **mistura** busca **C/N** na faixa **20 a 30**, **pH** estavel no digestor e **diluicao** de inibidores.

**Tabela de composicao adotada (referencia de projeto, Nivel B)**

| Substrato | ST (% massa) | SV/ST (%) | C/N (-) | pH (-) | Nota |
|-----------|--------------|-----------|---------|--------|------|
| Lodo | `3.5` | `65` | `8` | `6.8` | N rico |
| Vinhaca | `1.7` | `75` | `25` | `4.2` | C, K |
| Residuo organico | `20.0` | `85` | `30` | `5.5` | SV alto |

**Composicao elementar tipica (base seca dos SV)** - percentual em massa na fracao volatil:

| Substrato | C | H | O | N | S |
|-----------|---|---|---|---|---|
| Lodo | `51.0` | `7.9` | `34.6` | `5.4` | `1.1` |
| Vinhaca | `43.0` | `6.5` | `46.0` | `3.5` | `1.0` |
| Residuo organico | `48.0` | `6.4` | `42.0` | `3.2` | `0.4` |

*(Fontes: Embrapa, RVQ, MDPI/literatura - ver Secao 15.)*

### 2.3 Parametros operacionais

| Parametro | Simbolo / valor | Unidade | Significado |
|-----------|-----------------|--------|-------------|
| Temperatura | `T = 35` | degC | Regime **mesofilico** (comum em instalacoes brasileiras) |
| Tempo de retencao hidraulica | `TRH = 20` | dias | Tempo medio de permanencia no digestor |
| Eficiencia de remocao de SV | `eta_SV = 55` | % | Fracao da SV alimentada convertida na modelagem |
| Rendimento de biogas | `Y_bg = 0.60` | Nm3/kg SV removido | Volume normal de biogas por kg de SV degradado |

---

## 3. Simbologia e fluxogramas

### 3.1 Normas

- **ISA 5.1** (2009): simbolos e identificacao de instrumentacao e funcoes (`PIC`, `FIC`, etc.).
- **NBR 6493** (ABNT): cores para identificacao de tubulacoes na planta.

### 3.2 PFD com tags

Diagrama **ASCII** do **PFD** (process flow diagram) com **tags** de equipamentos. Setas indicam **sentido predominante** da corrente. Valores sao **esquematicos**; detalhamento numerico esta na **tabela de correntes**.

```
  [101]        [102]              [103]
   LODO ----\      VINHACA ----\      RESIDUO -----\
             \                  \                  \
              v                  v                  v
         +===========+    +===========+    +===========+
         |  TQ-101   |    |  TQ-101   |    |  TQ-101   |
         |  MISTURA  |--->|  (tanque) |--->|  (tanque) |
         +===========+    +=====+=====+    +=====+=====+
                                |                |
                                v                v
                         +------+------+  +------+------+
                         |  P-101      |  | (bomba      |
                         |  ALIMENT.   |  |  aliment.)  |
                         +------+------+  +------+------+
                                |
                                v  [105] mistura -> digestor
                         +=============+
                         |    D-101    |<---- [106] biogas (bruto)
                         |   DIGESTOR  |-----> [110] digestato
                         +======+======+
                                |
              +-----------------+------------------+
              | calor (util.)   | biogas           | digestato
              v                 v                  v
         +---------+      +==========+       +----------+
         | TC-101  |      | TQ-102   |       |  P-102   |
         |TROCADOR  |      |GASOMETRO |       | DIGESTATO|
         +---------+      +=====+====+       +-----+----+
                              |                   |
                              v                   v
                         +==========+       +==========+
                         | DS-101   |       | FP-101   |
                         |DESULFUR. |       |FILTRO-PRE|
                         +=====+====+       +=====+====+
                               |                   |
                               v                   v
                         +==========+         [112][113]
                         | MG-101   |         solido/liquido
                         |MOTOR-GER.|
                         +==========+
                               |
                               v
                         eletricidade / excedente termico

  Utilidades: TQ-103 (NaOH), instrumentos TIC/PIC/FIC/LIC/AIT, PSV-101
```

**Legenda rapida**

- **TQ-101**: tanque de **mistura/preparacao** da carga.
- **D-101**: **digestor** anaerobio (reator principal).
- **TC-101**: **trocador de calor** para controle de temperatura da alimentacao e/ou do lodo no digestor.
- **P-101** / **P-102**: **bombas** de alimentacao e de **digestato**.
- **TQ-102**: **gasometro** (armazenamento de biogas).
- **DS-101**: **dessulfurizador** (reducao de `H2S` antes do uso energetico).
- **MG-101**: **motor-gerador** (cogeracao **CHP**: calor + eletricidade).
- **FP-101**: **filtro-prensa** (espessamento/separacao da fracao solida do digestato).
- **TQ-103**: tanque de **NaOH** (ajuste de pH ou lavagem, conforme estrategia de projeto).

### 3.3 Lista de equipamentos

| Tag | Nome | Funcao principal |
|-----|------|------------------|
| `TQ-101` | Tanque de mistura | Homogeneizar substratos, estabilizar alimentacao |
| `P-101` | Bomba de alimentacao | Elevar mistura ao digestor / circuito de aquecimento |
| `TC-101` | Trocador de calor | Aproximar temperatura de alimentacao a `35` degC |
| `D-101` | Digestor anaerobio | Reator: biogas + digestato |
| `P-102` | Bomba de digestato | Remover digestato para tratamento de saida |
| `FP-101` | Filtro-prensa | Separar torta (biofertilizante) e liquido |
| `TQ-102` | Gasometro | Amortecer variacao de producao/consumo de biogas |
| `DS-101` | Leito de dessulfurizacao | Reduzir `H2S` (protecao de motor e emissoes) |
| `MG-101` | Motor-gerador (CHP) | Queimar biogas: **kWh** + **calor** util |
| `TQ-103` | Tanque de NaOH | Reposicao de solucao para lavagem/neutralizacao |

### 3.4 Tabela de correntes (101-117)

**Convencao**: estado **L** liquido, **G** gas, **S** solido (ou suspensao espessa); **m** em `kg/d`, **Q** em `Nm3/d` quando gas seco referido; **notas** indicam simplificacoes de Nivel B.

| ID | Descricao | Fase | m (kg/d) | Q (Nm3/d) | Composicao / observacao |
|----|-----------|------|----------|-----------|-------------------------|
| `101` | Lodo de ETE | L | `51135` | - | Maior parte da massa; ST/SV conforme Secao 2.2 |
| `102` | Vinhaca | L | `30681` | - | Dilui e aporta carbono |
| `103` | Residuo organico | L | `20454` | - | SV alto; mistura 50:30:20 em massa (cenario base) |
| `104` | Mistura bruta TQ-101 | L | `102270` | - | Soma das entradas; homogeneizar |
| `105` | Alimentacao ao D-101 | L | `102270` | - | Apos bomba P-101 / possivel recirculacao |
| `106` | Biogas bruto (topo D-101) | G | `1984` | `1688` | Massa gas = soma componentes; umido na pratica |
| `107` | Biogas amortecido TQ-102 | G | `1984` | `1688` | Volume de trabalho do gasometro `420` Nm3 (capacidade) |
| `108` | Biogas tratado (pos DS-101) | G | `1980` | `1680` | Pequena perda/massa de `H2S` e arraste |
| `109` | Biogas para MG-101 | G | `1980` | `1680` | `CH4` equivalente `1047` Nm3/d no arranjo adotado |
| `110` | Digestato (saidas D-101) | L | `100286` | - | Fechamento: `102270` = `1984` + `100286` |
| `111` | Digestato bombeado | L | `100286` | - | Corrente para FP-101 |
| `112` | Efluente filtrado (liquido) | L | `90257` | - | Exemplo: `90%` massa liquida apos prensa (ilustrativo Nivel B) |
| `113` | Torta / solido umido | S/L | `10029` | - | Fracao retida (~`10%` da massa de digestato, ordem de grandeza) |
| `114` | Condensado / drenos TC-101 | L | `50` | - | Traco; ajustar em projeto executivo |
| `115` | Agua de selagem / selo | L | `20` | - | Traco de servico |
| `116` | Solucao NaOH (TQ-103) | L | `5` | - | Consumo incremental de reagente (estimativa) |
| `117` | Exaustao pos-tratamento / flare (stand-by) | G | - | `50` | Vazao de seguranca/emergencia (referencia de projeto) |

**Nota didatica**: as correntes `112` e `113` sao **particao ilustrativa** do digestato apos prensa; o **fechamento global** do processo principal e `entrada (104)` = `biogas (106)` + `digestato (110)` em massa.

### 3.5 Instrumentacao

| Tag | Tipo | Local / variavel | Finalidade |
|-----|------|------------------|------------|
| `TIC-101` | Indicador-controlador de temperatura | Manta/camisa ou circuito com `TC-101` | Manter `35` degC (mesofilico) |
| `PIC-101` | Indicador-controlador de pressao | Gasometro / cabeca do digestor | Evitar sobrep./vacuo anomalo |
| `FIC-101` | Indicador-controlador de vazao | Alimentacao diaria normalizada | Estabilizar `TRH` e `COV` |
| `LIC-101` | Indicador-controlador de nivel | `TQ-101`, `D-101` | Protecao de bombas e transbordo |
| `AIT-101` | Analisador (indicador/transmissor) | Biogas (`CH4`, `H2S`, `CO2`) | Qualidade do gas e seguranca |
| `PSV-101` | Valvula de alivio de pressao | Trecho gasoso | Protecao mecanica conforme ASME/API |

---

## 4. Variaveis de processo e projeto

### 4.1 Variaveis de processo (tabela)

| Variavel | Valor alvo | Unidade | Por que importa |
|----------|------------|---------|-----------------|
| Temperatura no digestor | `35` | degC | Velocidade biologica e estabilidade |
| pH no digestor | `7.0` a `7.4` | - | Saude das metanogenicas |
| TRH | `20` | dias | Grau de estabilizacao e tamanho do reator |
| C/N da mistura | `24.6` | - | Balanco nutricional |
| Pressao gasometro | `0.5` a `5` | kPa gauge | Exemplo de faixa operacional tipica |
| Remocao SV | `55` | % | Liga entrada organica a producao de biogas |

### 4.2 Variaveis de projeto (tabela)

| Variavel | Valor | Unidade | Observacao |
|----------|-------|---------|------------|
| Producao biogas | `1688` | Nm3/d | Base caso |
| Producao CH4 | `1047` | Nm3/d | Valor energetico principal |
| Massa alimentada | `102270` | kg/d | Escala diaria |
| Volumetrico digestor | `2300` | m3 | Compativel com `TRH` e vazao |

### 4.3 Parametros de equipamento (tabela)

| Equipamento | Parametro chave | Valor indicativo |
|-------------|-----------------|------------------|
| `D-101` | Volume geometrico | `2300` m3 |
| `TQ-101` | Volume | `60` m3 |
| `TC-101` | Area | `3.1` m2 |
| `P-101`, `P-102` | Vazao | `~4.2` m3/h |
| `MG-101` | Potencia nominal | `200` kW |
| `FP-101` | Area de filtracao | `100` m2 |

---

## 5. Balanco de massa

### 5.1 Premissas

- **Regime pseudo-estacionario** (dia tipo): entradas e saidas medias em `24` h.
- **Eficiencia de degradacao de SV**: `eta_SV = 55%`.
- **Rendimento**: `Y_bg = 0.60` Nm3 biogas / kg SV removido.
- **Composicao do biogas** e **densidades** coerentes com `CH4` informado; massa de gas obtida por **soma das fracoes** (modelo de projeto).

### 5.2 Massas de entrada

**Total alimentado (mistura)**: `m_ent = 102270` kg/dia.

### 5.3 Solidos

- **ST** (solidos totais): `6500` kg/dia.
- **SV** (solidos volateis): `5116` kg/dia.

### 5.4 Relacao C/N

**C/N da mistura (modelo elementar)**: `24.6` (faixa ideal `20` a `30`).

### 5.5 Fechamento elementar (entrada, kg/dia)

| Elemento | Massa (kg/dia) |
|----------|----------------|
| C | `2471` |
| H | `345` |
| O | `2078` |
| N | `190` |
| S | `31` |

Interpretacao: o **carbono** e o **oxigenio** dominam em massa porque a materia organica e majoritariamente **biomassa** e **umidade com solutos**. O **nitrogenio** e essencial ao crescimento microbiano, mas deve estar **balanceado** para nao gerar **amonia livre** excessiva.

### 5.6 Biogas

| Grandeza | Valor |
|----------|-------|
| Biogas | `1688` Nm3/dia |
| Metano (`CH4`) | `1047` Nm3/dia |
| Massa biogas (modelo) | `1984` kg/dia |

**Checagem de ordem de grandeza (rendimento)**

- SV removida: `5116 * 0.55 = 2813.8` kg/dia.
- Biogas: `2813.8 * 0.60 = 1688` Nm3/dia (fecha com a premissa de `Y_bg`).

### 5.7 Digestato

**Massa de digestato (liquido + solidos nao convertidos)**: `100286` kg/dia.

### 5.8 Fechamento global

`102270` kg/dia (entrada) = `1984` kg/dia (biogas) + `100286` kg/dia (digestato) = `102270` kg/dia.

Ou seja, **100%** de fechamento **massico** na fronteira adotada (sem perdas fugitivas modeladas na massa total).

---

## 6. Balanco de energia

### 6.1 Demanda termica

**Calor necessario para sustentar o processo (aquecimento/perdas modeladas)**: `Q_dem = 3680` MJ/dia.

*(Inclui, conceitualmente, aquecimento de alimentacao, perdas pela superficie e integracao termica simplificada.)*

### 6.2 Energia quimica no biogas

**Poder energetico do biogas disponivel (ordem de grandeza de projeto)**: `37474` MJ/dia.

### 6.3 Cogeracao (CHP)

| Saida | Valor |
|-------|-------|
| Eletricidade | `3758` kWh/dia (potencia media ~`157` kW) |
| Calor util recuperado | `15739` MJ/dia |

### 6.4 Balanco termico e autossuficiencia

**Excedente termico** (apos atender demanda modelada): `12059` MJ/dia.

Conclusao de projeto: o caso e **autossuficiente termicamente** com **margem**, desde que a recuperacao de calor do `MG-101` seja **integrada** ao aquecimento da alimentacao/digestor.

### 6.5 Eficiencia global (indicador de projeto)

**Eficiencia global adotada no relatorio (forma pratica)**: `17.3` %.

Didatica: eficiencia **global** depende da **definicao do denominador** (energia quimica do biogas, do metano ou da SV). Aqui o numero serve para **comparar cenarios** no mesmo criterio; em auditoria energetica deve-se **explicitar sempre** a base.

---

## 7. Dimensionamento dos equipamentos

Tabela resumo (coerente com estudos anteriores e premissas deste relatorio):

| Tag | Equipamento | Dimensao | Potencia | Material |
|-----|-------------|----------|----------|----------|
| `TQ-101` | Tanque mistura | `60` m3, `D=4.3` m, `H=4.3` m | `30` kW (agitacao) | Aco carbono + epoxi |
| `D-101` | Digestor | `2300` m3, `D=12` m, `H=21` m | `15` kW (bomba recirc./misc.) | Aco carbono + epoxi / `316L` em zonas umidas |
| `TC-101` | Trocador calor | `3.1` m2 | - | `316L` / aco carbono |
| `P-101` | Bomba alimentacao | `4.17` m3/h | `0.75` kW | Ferro fundido / `316L` |
| `P-102` | Bomba digestato | `4.14` m3/h | `0.75` kW | Ferro fundido / `316L` |
| `FP-101` | Filtro-prensa | `100` m2 | `5` kW | Polipropileno / aco carbono |
| `MG-101` | Motor-gerador | `200` kW nominal | `157` kW liq | Padrao fabricante |
| `TQ-102` | Gasometro | `420` Nm3 | - | EPDM / aco |
| `DS-101` | Dessulfurizador | `3.5` m3 carvao ativo | - | PRFV |
| `TQ-103` | Tanque NaOH | `2` m3 | - | PEAD |

---

## 8. Selecao de materiais

### Agentes de corrosao e desgaste

- **`H2S`**: acido sulfidrico; ataca acos de baixa liga se **umido**; exige **NACE MR0175 / ISO 15156** em servicos **sour gas** severos.
- **pH**: faixa neutra no digestor, mas **inicial** pode ser acido na alimentacao - risco localizado de corrosao.
- **Abrasao**: solidos no lodo e torta - bombas e tubos com **revestimento** ou **liga** mais resistente.

### Tabela material por equipamento (resumo)

| Equipamento | Contato com | Material sugerido |
|-------------|-------------|-------------------|
| `D-101`, `TQ-101` | Efluente, biogas umido | Aco carbono + **revestimento epoxi**; partes criticas **`316L`** |
| `TC-101` | Lodo / fluido aquecido | **`316L`** (lado corrosivo) |
| `P-101`, `P-102` | Suspensao | **`316L`** ou ferro fundido com **rotor** resistente |
| `DS-101` | Biogas umido + leito | **PRFV** + leito ativo |
| `TQ-102` | Biogas | **EPDM**/borracha compativel + estrutura metalica |
| `TQ-103` | NaOH diluido | **PEAD** |

---

## 9. Utilidades

| Utilidade | Consumo / geracao (indicativo Nivel B) | Observacao |
|-----------|----------------------------------------|------------|
| Eletricidade (planta) | `consumo interno` a partir de `3758` kWh/d | Bomba, agitador, filtro, instrumentos |
| Vapor / agua quente | `15739` MJ/dia util | Recuperacao CHP |
| Agua de reposicao | `m3/d` a definir em executivo | Selagem, lavagens |
| Ar instrumento | `Nm3/h` traco | Valvulas pneumaticas |
| NaOH | ligado a `TQ-103` | Ajuste / lavagem |

---

## 10. Layout industrial

**Zonas recomendadas** (conceito de seguranca e logistica):

1. **Recepcao e preparacao** (`TQ-101`, pesagem, triagem basica).
2. **Digestao** (`D-101`, `TC-101`, `P-101`).
3. **Gas** (`TQ-102`, `DS-101`, `MG-101`, flare/vent emergency).
4. **Tratamento de digestato** (`P-102`, `FP-101`, estoque de torta).
5. **Subestacao / sala eletrica** e **oficina**.

**Planta baixa simplificada (esquema ASCII)**

```
  [Recepcao] -----> [Preparacao] -----> [Digestor] -----> [Digestato]
                         |                  |
                         v                  v
                    [Utilidades]      [Gasometro] ---> [CHP]
```

Em projeto executivo, distancias seguem **NR** aplicaveis, **ventilacao**, **raio de manobra** e **drenagem de contencao**.

---

## 11. Otimizacao do processo

### 11.1 Analise de sensibilidade

**11.1.1 Proporcao de substratos (massa)**

Cenario base: **50% lodo / 30% vinhaca / 20% residuo organico**. Tabela **didatica**: `C/N` estimada por media ponderada simples das C/N tipicas da Secao 2.2; **biogas** recalculado supondo **mesma** `eta_SV` e `Y_bg`, mas **SV/dia** variando com a mistura (ilustrativo - Nivel B).

| Cenario | Lodo (%) | Vinhaca (%) | R.Org (%) | C/N (-) | SV (kg/dia) | Biogas (Nm3/dia) |
|---------|----------|-------------|-----------|---------|-------------|------------------|
| A (base) | `50` | `30` | `20` | `24.6` | `5116` | `1688` |
| B | `40` | `30` | `30` | `~21.5` | `~5400` | `~1782` |
| C | `60` | `25` | `15` | `~26.0` | `~4800` | `~1584` |
| D | `45` | `35` | `20` | `~25.4` | `~5050` | `~1667` |
| E | `55` | `25` | `20` | `~23.8` | `~5000` | `~1650` |

**Leitura**: aumentar **residuo organico** tende a **subir SV** e **biogas**, mas exige checar **COV** (carga organica volumetrica), **acidificacao** e **manejo de solidos**.

**11.1.2 Efeito do TRH** (temperatura fixa `35` degC)

| TRH (dias) | Efeito esperado | Risco / beneficio |
|------------|-----------------|-------------------|
| `15` | Reator menor | Maior `COV`; risco de **instabilidade** |
| `20` | Base | Compromisso comum na literatura mesofilica |
| `25` | Reator maior | Maior estabilidade; maior **CAPEX** |

**11.1.3 Efeito da temperatura**

| Regime | T (degC) | Comentario |
|--------|----------|------------|
| Mesofilico | `35` | Mais **estavel**; adotado no projeto |
| Termofilico | `55` | **Mais rapido** e higieniza melhor; **mais sensivel** e costuma exigir **energia** extra se perdas forem maiores |

### 11.2 Conclusao da otimizacao

- O **cenario base (50:30:20)** apresenta **C/N** na faixa **favoravel** e **biogas** alinhado ao dimensionamento.
- **Aumentar residuo organico para 40%** (cenario B) **maximiza** a ordem de grandeza de **biogas** na tabela, mas e obrigatorio **recalcular COV**, **HRT** efetivo e **risco de inibicao** (amonia, potassio, acidos).
- Recomenda-se **validacao experimental** (BMP) antes de mudar a receita de alimentacao.

---

## 12. Analise economica

Valores em **Real (R$)**, **ordem de grandeza conceitual**; **taxa** e **vida util** devem ser confirmados em estudo de viabilidade com **dados de mercado** locais.

### 12.1 CAPEX

**CAPEX total estimado**: `R$ 18.030.000`.

Composicao conceitual: **equipamentos FOB** escalados com **fator de Lang** `3.6` (Towler e Sinnott, 2012; Peters e Timmerhaus, 2003) + **capital de giro** inicial.

### 12.2 OPEX

**OPEX anual**: `R$ 1.910.367`/ano.

Inclui: energia complementar (se houver), pessoal, manutencao, reagentes, seguros, administrativo (parcelas simplificadas).

### 12.3 Receitas

**Receita anual**: `R$ 1.062.187`/ano.

Fontes consideradas: **venda/consumo de eletricidade**, **biofertilizante** (torta), **creditos de carbono** (se aplicavel e certificado).

### 12.4 Resultado operacional (base)

**Resultado anual (base)**: `R$ -848.180`/ano (deficit).

Interpretacao: sem **outras receitas** ou **menor CAPEX** (escala, modularizacao), o fluxo de caixa **operacional** nao cobre **OPEX** com a receita estimada.

### 12.5 Cenarios alternativos (qualitativo + numerico sugerido)

| Cenario | Hipotese | Efeito esperado |
|---------|----------|-----------------|
| Tarifa maior | `+20%` receita eletricidade | Reduz deficit |
| Subsidio / PPA | contrato garantido | Melhora **VPL** |
| Maior escala | Lang + sinergias | Reduz `R$/t` tratada |
| Creditos de carbono | precos mais altos | Incrementa receita |

### 12.6 VPL, TIR, payback (metodologia)

Definicoes:

- **VPL** (valor presente liquido): soma dos fluxos de caixa descontados a taxa **i**.
- **TIR** (taxa interna de retorno): taxa **i** que zera o VPL.
- **Payback simples**: `CAPEX / fluxo anual medio` (quando fluxo e positivo).

**Ilustracao com base no caso deficitario**

- Se o **fluxo anual liquido** permanece **negativo** (`-848.180` R$/ano) e nao ha receitas extraordinarias, **nao existe TIR economica** no sentido classico de projeto **autossustentavel** apenas com essas premissas.
- **VPL** sera **negativo** para taxas de desconto realistas positivas.
- **Payback** nao se aplica de forma estavel enquanto o fluxo for negativo.

**Exemplo numerico de VPL** (didatico): para **vida util** `n = 15` anos, **taxa** `i = 10%` a.a., investimento inicial `I0 = 18.030.000` R$ e fluxo uniforme `FC = -848.180` R$/ano:

`VPL = -I0 + FC * [(1-(1+i)^(-n))/i]`

O resultado e **fortemente negativo**, reforcando a necessidade de **subsidios**, **tarifas** maiores, **receitas regulatorias** (ex.: tratamento obrigatorio) ou **integracao** com outra unidade da planta.

### 12.7 Discussao

O projeto pode ser **viabilizado** por:

- **Obrigacao regulatoria** (destinacao adequada de residuos);
- **Contratos** (PPA, compra de energia);
- **Subsidios** e **linhas de credito** para biogas;
- **Economia de escala** e **integracao** com ETE/destilaria existente (CAPEX incremental menor que "greenfield").

Sem um desses **drivers**, o **Nivel B** indica **risco economico alto** apenas com as receitas base listadas.

---

## 13. Verificacoes de consistencia

| # | Verificacao | Criterio | Status |
|---|-------------|----------|--------|
| 1 | Fechamento de massa global | `entrada = biogas + digestato` | OK |
| 2 | SV removida x biogas | `5116*0.55*0.60 = 1688` Nm3/d | OK |
| 3 | C/N | `20` a `30` | OK (`24.6`) |
| 4 | Balanco elementar | soma C,H,O,N,S coerente com entrada | OK |
| 5 | Demanda termica vs CHP | `Q_dem` coberta pelo calor util | OK |
| 6 | TRH vs volume | `V/Q` compativel com `20` d | OK (Nivel B) |
| 7 | COV | ordem de grandeza `1` a `4` kg SV/m3.d | OK a verificar com recirculacao |
| 8 | Fracao de CH4 | compativel com literatura | OK (ordem 60% vol) |
| 9 | Potencia MG vs eletricidade | `157` kW vs `3758` kWh/d | OK (~`24` h) |
| 10 | Economia | sinal do fluxo coerente com premissas | OK (deficit explicitado) |

---

## 14. Conclusao

- Projeto **conceitual completo**: do **diagrama de blocos** a **analise economica**.
- **Processo definido**, **dimensionado** e **avaliado** com premissas **Nivel B**.
- **C/N** na faixa **ideal**; balanco **termico** indica **autossuficiencia** com **excedente**.
- **Viabilidade economica** depende de **escala**, **tarifa**, **politicas** e **subsidios**; o cenario numerico base mostra **deficit** anual.
- **Recomendacoes**: ensaios de **BMP**, **caracterizacao real** dos substratos, **projeto executivo**, integracao **HSE** e detalhamento **instrumentacao** conforme **ISA 5.1**.

---

## 15. Referencias bibliograficas

Formato **ABNT-like** (autores em maiusculas onde aplicavel):

- CHERNICHARO, C. A. L. **Reatores Anaerobios**. Belo Horizonte: DESA/UFMG, 2007.
- TOWLER, G.; SINNOTT, R. **Chemical Engineering Design**. 2. ed. Oxford: Butterworth-Heinemann, 2012.
- MORAN, S. **An Applied Guide to Process and Plant Design**. 1. ed. Oxford: Elsevier, 2015.
- ERWIN, D. **Projeto de Processos Quimicos Industriais**. 2. ed. Porto Alegre: Bookman, 2016.
- METCALF & EDDY. **Wastewater Engineering: Treatment and Resource Recovery**. 5. ed. New York: McGraw-Hill, 2014.
- PERRY, R. H.; GREEN, D. W. **Perry's Chemical Engineers' Handbook**. 8. ed. New York: McGraw-Hill, 2008.
- ISA. **ISA-5.1-2009: Instrumentation Symbols and Identification**. Research Triangle Park: ISA, 2009.
- ABNT. **NBR 6493** - Emprego de cores para identificacao de tubulacoes. Rio de Janeiro: ABNT.
- ASME. **BPVC Section VIII** - Rules for Construction of Pressure Vessels. New York: ASME.
- NACE MR0175 / ISO 15156. **Materials for use in H2S-containing environments in oil and gas production**.
- UFPR. **Avaliacao do desempenho operacional de usina de codigestao**. Documento institucional/projeto, 2024.
- EMBRAPA. **Composicao quimica da materia organica de lodos de esgoto**. Referencia tecnica, 2024.
- RVQ. **Vinhaca de cana-de-acucar** - composicao e manejo (referencia agronomica/industrial), 2024.
- BLANK, L.; TARQUIN, A. **Engenharia Economica**. 6. ed. Sao Paulo: AMGH, 2010.
- PETERS, M. S.; TIMMERHAUS, K. D. **Plant Design and Economics for Chemical Engineers**. 5. ed. New York: McGraw-Hill, 2003.

---

*Fim do documento ENTREGA 3 - Relatorio Final.*
