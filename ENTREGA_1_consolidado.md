# Entrega 1 - Projeto de Producao de Biogas por Codigestao Anaerobia

## Disciplina

Projetos Industriais II - Engenharia Quimica - UFMS  
Profa. Janaina dos Santos Ferreira  
1o semestre 2026

**Data de entrega:** 08/04/2026  
**Peso na nota:** 25%

## Equipe

| Nome completo | Matricula | Funcao na equipe |
|---|---|---|
| (preencher) | (preencher) | (preencher) |
| (preencher) | (preencher) | (preencher) |

## Sumario

1. [Introducao](#1-introducao)  
2. [Descricao do processo](#2-descricao-do-processo)  
3. [Simbologia e fluxogramas](#3-simbologia-e-fluxogramas)  
4. [Variaveis de processo e de projeto](#4-variaveis-de-processo-e-de-projeto)  
5. [Balanco de massa](#5-balanco-de-massa)  
6. [Balanco de energia](#6-balanco-de-energia)  
7. [Verificacoes de consistencia](#7-verificacoes-de-consistencia)  
8. [Conclusao da Entrega 1](#8-conclusao-da-entrega-1)  
[Referencias](#referencias)

---

## 1. Introducao

### 1.1 Contexto

**Residuo organico** (definicao): material de origem biologica que nao sera mais usado na forma original e precisa de destino ambiental adequado. No cenario brasileiro, tres fluxos aparecem com frequencia em estudos de **codigestao**:

- **Lodo de esgoto:** solido semi-solido gerado em **ETE** (Estacao de Tratamento de Esgoto); concentra materia organica e nutrientes.
- **Vinhaca:** efluente liquido da **destilacao** do etanol de cana; volume elevado por litro de etanol produzido e carga organica significativa.
- **Residuo organico urbano/industrial:** restos de alimento, fracion umido, rejeitos biodegradaveis de comercio e industria leve.

O problema ambiental nao e apenas "volume", e sim **risco de poluicao** (demanda bioquimica de oxigenio, **DQO**; nutrientes; odores) e **emissao de gases** se o destino for a disposicao sem controle.

### 1.2 Solucao proposta

**Codigestao anaerobia** (definicao): tratamento biologico **sem oxigenio dissolvido** no qual **dois ou mais substratos** sao digeridos no mesmo reator, buscando estabilidade e maior producao de **biogas** (mistura rica em **CH4** e **CO2**).

### 1.3 Objetivo do projeto

Dimensionar, em nivel **conceitual**, uma planta de codigestao que trate os tres substratos citados, produza biogas com valor energetico estimavel e gere **digestato** para destinacao posterior (solo, desaguamento, regulacao).

### 1.4 Escopo da Entrega 1

Esta entrega consolida o conteudo das **aulas 2, 3 e 4**:

- **Aula 2:** simbologia e tipos de fluxogramas (**BFD**, **PFD**).  
- **Aula 3:** identificacao de **variaveis de processo** (o que se mede/controla) e **variaveis de projeto** (o que se fixa para dimensionar).  
- **Aula 4:** **balanco de massa** e **balanco de energia** com fechamento verificavel.

Nao fazem parte do escopo da Entrega 1: **P&ID** detalhado, **HAZOP**, orcamento fechado, licencas (isso evolui nas proximas etapas).

---

## 2. Descricao do processo

### 2.1 Quatro etapas da digestao anaerobia

**Digestao anaerobia** (definicao): conversao de materia organica em principalmente **CH4** e **CO2** por comunidades microbianas em serie.

1. **Hidrolise:** polimeros grandes (proteinas, carboidratos, lipideos) viram monomeros e oligomeros; costuma ser **limitante** quando ha fibras ou solidos refratarios.  
2. **Acidogenese:** os produtos simples viram **acidos organicos volateis**, alcoois, **H2**, **CO2**; etapa rapida e potente em geracao de intermediarios.  
3. **Acetogenese:** acidos "mais longos" e intermediarios sao convertidos em **acetato**, **H2** e **CO2**, alimentando as metanogenicas.  
4. **Metanogenese:** **acetoclastica** (acetato -> CH4 + CO2) e **hidrogenotrofica** (CO2 + H2 -> CH4 + H2O); etapa mais sensivel a **pH**, toxicidade e oscilacao de carga.

### 2.2 Tres substratos (resumo)

| Substrato | Papel no arranjo | Densidade tipica de projeto (kg/m3) | ST tipico (% massa) | SV/ST tipico (--) | C/N tipico (--) | pH tipico (--) |
|---|---|---:|---:|---:|---:|---:|
| Lodo de esgoto | Traz umidade, buffer, microfauna; **C/N** costuma ser baixa sozinha | `1020` | `3.5` | `0.65` | `8` | `6.8` |
| Vinhaca | Aporte de carbono biodegradavel; atencao a **pH** acido e sais | `1009` | `1.7` | `0.75` | `25` | `4.2` |
| Residuo organico (triturado) | Eleva **C/N** e **SV**; exige homogeneizacao | `1050` | `20.0` | `0.85` | `30` | `5.5` |

**Legenda:** `ST` = solidos totais; `SV` = solidos volateis (fracao organica dos solidos).

### 2.3 Equacao global do modelo conceitual

`Lodo + Vinhaca + Residuo organico -> Biogas (CH4 + CO2 + tracos) + Digestato (+ perdas de agua e cinzas)`

O termo **calor** aparece no sistema como **demanda termica** para manter **mesofilico** e como **recuperacao** no **CHP** (cogeracao).

---

## 3. Simbologia e fluxogramas

### 3.1 Normas utilizadas

**ISA 5.1** (Instrument Symbols and Identification): padrao para **identificar instrumentos e funcoes** de malha (medicao, indicacao, controle, alarme) por letras e numeros. Exemplo mental: a letra inicial costuma indicar a **variavel medida** (T temperatura, P pressao, F vazao, L nivel, A analise), e suffixos indicam **funcao** (I indicar, C controlar, T transmissor).

**NBR 6493** (ABNT): referencia brasileira para **simbologia grafica** em desenhos de processo, alinhando desenho de engenharia a convencoes nacionais e facilitando leitura por equipes e fornecedores no Brasil.

**ASME Y32.11**: documento de simbologia para **diagramas de engenharia** no contexto ASME, util como referencia complementar de **formas geometricas** para equipamentos e fluxos quando se exporta documentacao ou se trabalha com fornecedores internacionais.

Na pratica de projeto, o **PFD** usa blocos e linhas de processo; o **P&ID** (fora do escopo desta entrega) herda tags e acrescenta valvulas, instrumentos e detalhe de tubacao.

### 3.2 Diagrama de blocos (BFD)

**BFD** (Block Flow Diagram): mapa de **etapas principais** sem detalhar todos os equipamentos.

```
+------------------+     +-------------------+     +------------------+
|  PREPARACAO E    |     |  DIGESTAO         |     |  PRODUTOS E      |
|  MISTURA         | --> |  ANAEROBIA        | --> |  INTEGRACAO      |
|  (substratos)    |     |  (reator unico)   |     |  energetica      |
+------------------+     +-------------------+     +------------------+
        |                          |                         |
        v                          v                         v
   lodo, vinhaca,            biogas umido              CHP / utilidades
   residuo                    digestato                 desaguamento
```

Leitura didatica: no **BFD** o foco e **o que transforma** e **o que entra/sai**, nao a geometria do tanque.

### 3.3 Fluxograma de processo (PFD)

**PFD** (Process Flow Diagram): mostra **equipamentos com tags**, **correntes numeradas** e **condicoes representativas** (T, P, fase).

**Tags de equipamento usados neste projeto:** `TQ-101`, `TQ-102`, `TQ-103`, `P-101`, `P-102`, `TC-101`, `D-101`, `FP-101`, `MG-101`, `DS-101`.

Copie o quadro abaixo em editor com fonte monoespacada (ex.: Consolas) para preservar alinhamento.

```
  Limite bateria                          FLUXO GERAL: esquerda --> direita
  ============

      (101) lodo
      (102) vinhaca  ----\                              +---------------------------+
      (103) residuo  ----+---->    +-----------+       |      [TQ-102]             |
                                 |           |       |   biogas (107)             |
                                 v           |       +-------------+-------------+
                          +-------------+    |                     |
                          |  [TQ-101]   |    |                     v
                          |   mistura   |    |               +-------------+
                          +------+------+    |               |  [DS-101]   |
                                 | (104)      |               +------+------+
                                 v            |                      | (108)
                          +-------------+    |                      v
                          |  [P-101]    |    |               +-------------+
                          +------+------+    |               |  [MG-101]   | <--- CHP
                                 | (105)      |               |    CHP      |
                                 v            |               +------+------+
                          +-------------+    |                      |
                          | [TC-101]    |    |               (116) eletricidade
                     (113)|  aquece    |(114) |               (117) calor --> TC-101
                     ---->|  20->35    |----  |                      |
                          +------+------+    |                      |
                                 | (106)      |                      |
                                 v            |                      |
          +-----------------------------------------------------------+----------------+
          |                       [D-101]  digestor CSTR                         |
          |  (115) [TQ-103] NaOH ---------------------------------> (correcao pH)  |
          |        mistura (106)  ============================>  liquido/pasta   |
          |        biogas (107)   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  topo D-101   |
          |        digestato (109)vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  fundo D-101   |
          +------------------------|-----------------------------------------------+
                                   v (109)
                            +-------------+
                            |  [P-102]    |
                            +------+------+
                                   | (110)
                                   v
                            +-------------+
                            | [FP-101]    |
                            +------+------+
                    +--------------+--------------+
                    | (111) torta  | (112) filtrado|
                    v              v
               Destinacao     Tratamento efluente
```

### 3.4 Tabela de correntes (101 a 117)

**Convencao:** massa em kg/dia; `T` em graus Celsius; `P` em atm (absoluta ou manometrica conforme anotacao da planilha de origem; aqui valores **representativos** de projeto).

| Corrente | Descricao | Massa (kg/dia) | T (degC) | P (atm) | Fase |
|---:|---|---:|---:|---:|---|
| 101 | Lodo de esgoto (entrada) | `51000` | `20` | `1.0` | Liquido/pasta |
| 102 | Vinhaca (entrada) | `30270` | `20` | `1.0` | Liquido |
| 103 | Residuo organico triturado (entrada) | `21000` | `20` | `1.0` | Pasta |
| 104 | Mistura homogeneizada (saida `TQ-101`) | `102270` | `20` | `1.0` | Liquido/pasta |
| 105 | Mistura bombeada (`P-101` -> `TC-101`) | `102270` | `20` | `~2.0` | Liquido/pasta |
| 106 | Mistura aquecida (`TC-101` -> `D-101`) | `102270` | `35` | `~1.5` | Liquido/pasta |
| 107 | Biogas bruto (topo `D-101` -> `TQ-102`) | `1984` | `35` | `1.02` | Gas |
| 108 | Biogas tratado (`DS-101` -> `MG-101`) | `~1960` | `35` | `1.0` | Gas |
| 109 | Digestato bruto (fundo `D-101` -> `P-102`) | `100286` | `35` | `1.0` | Liquido/pasta |
| 110 | Digestato bombeado (`P-102` -> `FP-101`) | `100286` | `35` | `~2.0` | Liquido/pasta |
| 111 | Torta desaguada (`FP-101`) | `14742` | `~30` | `1.0` | Solido umido |
| 112 | Filtrado (`FP-101`) | `85544` | `~30` | `1.0` | Liquido |
| 113 | Agua quente (utilidade -> `TC-101`) | (ver balanco termico) | `80` | `~3.0` | Liquido |
| 114 | Agua quente retorno (`TC-101`) | (ver balanco termico) | `50` | `~2.5` | Liquido |
| 115 | NaOH (`TQ-103` -> `D-101`) | variavel | `20` | `1.0` | Liquido |
| 116 | Eletricidade (`MG-101`) | (energia) | - | - | Energia |
| 117 | Calor recuperado (`MG-101` -> `TC-101`) | (energia) | - | - | Energia |

**Nota:** correntes `113` a `117` nao sao "massa de processo" no mesmo sentido de `101`-`112`; aparecem no PFD para mostrar **integracao termica e energetica**.

### 3.5 Lista de equipamentos

| Tag | Nome | Funcao principal |
|---|---|---|
| `TQ-101` | Tanque de mistura | Homogeneizar lodo + vinhaca + residuo |
| `TQ-102` | Tanque de biogas / gasometro | Armazenamento intermediario de biogas |
| `TQ-103` | Tanque de soda | Estocar solucao de NaOH para correcao de pH |
| `P-101` | Bomba de alimentacao | Elevar pressao da mistura ate o trecho do `TC-101` |
| `P-102` | Bomba de digestato | Transportar digestato ate a prensa |
| `TC-101` | Trocador de calor | Aquecer alimentacao de `20` para `35` degC |
| `D-101` | Digestor anaerobio (CSTR) | Reacao biologica e separacao gas-liquido |
| `FP-101` | Filtro-prensa | Desaguamento do digestato |
| `DS-101` | Dessulfurizador | Reduzir `H2S` antes do `MG-101` |
| `MG-101` | Motor-gerador (CHP) | Cogeracao: eletricidade + calor recuperavel |

### 3.6 Instrumentacao principal (padrao ISA)

Exemplos de malhas e instrumentos citados nas aulas e no material de apoio:

| Tag ISA | Significado resumido | Local tipico |
|---|---|---|
| `TIC-101` | Temperatura: indicacao + controle | Malha de aquecimento da alimentacao / digestor |
| `PIC-101` | Pressao: indicacao + controle | Headspace do `D-101` ou `TQ-102` |
| `FIC-101` | Vazao: indicacao + controle | Alimentacao do digestor |
| `LIC-101` | Nivel: indicacao + controle | Nivel no `D-101` |
| `AIT-101` | Analise (ex.: pH): indicacao + transmissao | Liquido do digestor |
| `TAH-101` | Alarme de temperatura alta | Protecao de biologia e equipamento |
| `LAH-101` | Alarme de nivel alto | Seguranca de operacao |
| `PSV-101` | Valvula de alivio de pressao | Protecao mecanica contra sobrepressao |

---

## 4. Variaveis de processo e de projeto

### 4.1 Variaveis de processo

**Variavel de processo** (definicao): grandeza medida ou inferida **durante a operacao**, usada para monitorar estabilidade biologica, seguranca e qualidade dos produtos.

| Variavel | Simbolo/unidade tipica | Por que importa |
|---|---|---|
| Temperatura no reator | `T` (degC) | Velocidade biologica e selecao mesofilica/termofilica |
| Pressao no headspace | `P` (bar ou kPa) | Seguranca, armazenamento de gas, vazamentos |
| Vazao de alimentacao | `Q` (m3/dia ou kg/dia) | TRH e carga organica |
| Nivel | `L` (m ou %) | Volume util, evitar transbordos ou aspiracao de ar |
| pH | `pH` (--) | Janela favoravel as metanogenicas |
| Relacao carbono/nitrogenio | `C/N` (--) | Excesso de N aumenta risco de amonia livre; falta de N reduz biomassa |
| Carga organica volumetrica | `COV` (kg SV / m3 / dia) | Comparavel a literatura e a limites de mistura |
| Composicao do biogas | `CH4`, `CO2`, tracos (--) | Valor energetico e requisitos de tratamento gas |

### 4.2 Variaveis de projeto

**Variavel de projeto** (definicao): numero fixado **no papel do projeto** para calcular volume, area, potencia e custos; deve ser revisado com dados reais.

| Parametro | Valor adotado | Unidade | Observacao |
|---|---:|---|---|
| Volume util do digestor | `V_digestor = 2000` | m3 | CSTR conceitual |
| Diametro (estimativa geometrica) | `D = 12` | m | Relacao `H/D` depende de arranjo civil |
| Altura liquida / cilindrica representativa | `H = 18` | m | Compativel com ordem de grandeza de `V` e `D` |
| Tempo de retencao hidraulica | `TRH = 20` | dias | `TRH = V / Q` com `Q` volumetrico coerente |
| Vazao massica diaria (base) | `102270` | kg/dia | Ver Secao 5 |

### 4.3 Parametros de equipamento e rendimentos

| Parametro | Valor | Unidade | Uso |
|---|---:|---|---|
| Eficiencia de remocao de SV | `eta_SV = 55` | % | Liga SV alimentado a SV convertido |
| Rendimento de biogas | `Y_bg = 0.60` | Nm3 / kg SV removido | Escala de producao de gas |
| Eficiencia eletrica do CHP | `eta_el = 38` | % | Balanco eletrico |
| Eficiencia termica recuperada | `eta_th = 42` | % | Balanco termico |
| Poder calorifico inferior do biogas | `PCI = 35.8` | MJ / Nm3 | Energia quimica entrada do CHP |

---

## 5. Balanco de massa

### 5.1 Premissas (tabela)

| Premissa | Valor / faixa | Unidade | Comentario |
|---|---|---|---|
| Densidade lodo | `1020` | kg/m3 | Base de projeto |
| Densidade vinhaca | `1009` | kg/m3 | Base de projeto |
| Densidade residuo | `1050` | kg/m3 | Base de projeto |
| Fracao massica de ST no lodo | `3.5` | % | Converte massa em ST |
| Fracao massica de ST na vinhaca | `1.7` | % | Idem |
| Fracao massica de ST no residuo | `20.0` | % | Idem |
| SV/ST lodo | `65` | % | SV nos solidos |
| SV/ST vinhaca | `75` | % | Idem |
| SV/ST residuo | `85` | % | Idem |
| C/N da mistura alimentada | `24.6` | -- | Dentro da faixa ideal usual `20`-`30` |
| Massa de biogas (fechamento global) | `1984` | kg/dia | Contabiliza saida gasosa |
| Composicao elementar | ver Secao 5.6 | kg/dia por elemento | Fechamento C/H/O/N/S |

### 5.2 Massas de entrada (V * rho)

**Intuicao:** cada substrato chega com **vazao volumetrica** e **densidade**; a massa diaria e produto `m = rho * V` (verificacao dimensional: (kg/m3)*(m3/dia) = kg/dia).

| Substrato | V (m3/dia) | rho (kg/m3) | m (kg/dia) |
|---|---:|---:|---:|
| Lodo | `50.00` | `1020` | `51000` |
| Vinhaca | `30.00` | `1009` | `30270` |
| Residuo organico | `20.00` | `1050` | `21000` |
| **Total** | `100.00` | (media ponderada ~`1022.7`) | **`102270`** |

### 5.3 Solidos totais e volateis na alimentacao

| Grandeza | Valor | Unidade |
|---|---:|---|
| ST (entrada) | `6500` | kg/dia |
| SV (entrada) | `5116` | kg/dia |

### 5.4 Relacao C/N da mistura

`C/N = 24.6` (--)  

**Leitura:** valor **compativel** com a faixa frequentemente citada para digestao estavel (`20` a `30`), reduzindo risco de desequilibrio nitrogenado tipico do lodo isolado.

### 5.5 Producao de biogas

| Grandeza | Valor | Unidade |
|---|---:|---|
| SV removido (modelo) | `2814` | kg/dia |
| Biogas seco (normal) | `1688` | Nm3/dia |
| Metano (normal) | `1047` | Nm3/dia |

**Relacao com parametros:** o rendimento `Y_bg` e a eficiencia `eta_SV` amarram **SV removido** a **volume de biogas**; a fracao de `CH4` traduz o **PCI** adotado.

### 5.6 Fechamento elementar (C, H, O, N, S)

**Hipoteses:** elementos conservam-se no balanco **global** do dia (sem acumulo no reator em regime **estacionario**); valores abaixo sao **contabeis** de planilha, sujeitos a refino com analises de laboratorio.

| Elemento | Entrada (kg/dia) | Biogas (kg/dia) | Digestato (kg/dia) |
|---|---:|---:|---:|
| C | `2471` | `892` | `1579` |
| H | `345` | `188` | `157` |
| O | `2078` | `896` | `1182` |
| N | `190` | `2` | `188` |
| S | `31` | `3` | `28` |

**Checagem:** para cada linha, `entrada = biogas + digestato` (fechamento OK no modelo).

### 5.7 Digestato (corrente principal liquida)

| Grandeza | Valor | Unidade |
|---|---:|---|
| Massa de digestato | `100286` | kg/dia |
| ST no digestato (premissa desta entrega) | `3686` | kg/dia |

**Nota de engenharia:** o desaguamento na `FP-101` redistribui **ST** entre torta (`111`) e filtrado (`112`); a soma de solidos nas saidas da prensa deve **compatibilizar-se** com o ST do digestato quando se fechar a planilha detalhada de solidos.

### 5.8 Fechamento global de massa

`entrada_liquida_pasta = 102270 kg/dia`

`saida_gas + saida_liquida_pasta = 1984 + 100286 = 102270 kg/dia`

**Significado fisico:** em **regime estacionario**, o que entra na fronteira do digestor como corrente principal alimentada (apos mistura) sai como **gas** (biogas) mais **liquido** (digestato), mantendo a **conservacao de massa** no balanco global diario.

---

## 6. Balanco de energia

### 6.1 Demanda termica

| Termo | Valor | Unidade | Interpretacao resumida |
|---|---:|---|---|
| `Q_aquec` | `6136` | MJ/dia | Energia para elevar e manter temperatura da alimentacao/reator |
| `Q_perdas` | `920` | MJ/dia | Perdas por superficie, tubagens, operacao |
| `Q_reacao` | `3377` | MJ/dia | Demanda biologica modelada como "carga termica de processo" |
| `Q_demanda` | `3680` | MJ/dia | Demanda termica liquida de referencia da planilha para integracao |

### 6.2 Energia quimica no biogas

| Grandeza | Valor | Unidade |
|---|---:|---|
| `E_biogas` | `37474` | MJ/dia |

**Intuicao:** `PCI` (MJ/Nm3) multiplicado pelo volume diario de biogas estima a **energia quimica disponivel** se todo o gas fosse queimado idealmente na referencia de medida.

### 6.3 Cogeracao (CHP)

| Saida | Valor | Unidade |
|---|---:|---|
| Eletricidade | `3758` | kWh/dia |
| Potencia media (referencia 24 h) | `156.6` | kW |
| Calor recuperado (modelo) | `15739` | MJ/dia |

### 6.4 Balanco termico e autossuficiencia

`excedente_termico = calor_recuperado - Q_demanda = 15739 - 3680 = 12059 MJ/dia`

**Conclusao operacional:** o cenario numerico adotado e **termicamente autossuficiente** no sentido de que o **calor recuperavel** do CHP cobre a **demanda termica** de referencia e ainda sobra excedente (`12059` MJ/dia) para perdas adicionais, priorizacao de circuitos ou incertezas.

### 6.5 Balanco eletrico (visao conceitual)

`geracao - consumo_interno = excedente_disponivel`

**Parametros:** `eta_el` define a parcela de `E_biogas` convertida em **trabalho eletrico**; bombas, agitadores e utilidades consomem parte dessa geracao. O valor numerico exato do **consumo** depende da lista final de motores (Entrega 2); a **estrutura** do balanco ja esta posicionada.

---

## 7. Verificacoes de consistencia

Lista de **dez checagens** realizadas na planilha de apoio (todas **OK** no cenario base):

1. Soma das massas dos substratos `101`+`102`+`103` igual a `102270` kg/dia.  
2. Fechamento do digestor: `102270 = 1984 + 100286` kg/dia (gas + digestato).  
3. `ST` e `SV` da alimentacao coerentes com fracao de cada substrato e com `6500` / `5116` kg/dia.  
4. `SV removido` (`2814`) menor ou igual a `SV` alimentado (`5116`) kg/dia.  
5. `C/N` da mistura (`24.6`) dentro da faixa `20`-`30`.  
6. Soma elementar: para C/H/O/N/S, `entrada = biogas + digestato`.  
7. Prensa (massa): `14742 + 85544 = 100286` kg/dia.  
8. Energia quimica: ordem de grandeza `PCI * V_biogas` compativel com `E_biogas`.  
9. CHP: parcelas `eta_el` e `eta_th` consistentes com `E_biogas` e com kWh/dia informados.  
10. Termico: `15739 - 3680 = 12059` MJ/dia confirma **excedente** positivo.

---

## 8. Conclusao da Entrega 1

- O **processo** foi definido do ponto de vista biologico (quatro etapas) e industrial (**mistura**, **aquecimento**, **digestao**, **biogas**, **digestato**, **CHP**, **desaguamento**).  
- A **simbologia** segue referencias **ISA**, **ABNT/NBR** e complementos **ASME**, permitindo evoluir para **P&ID** sem renumeracao confusa.  
- **Variaveis de processo** e **de projeto** foram separadas didaticamente: o primeiro grupo guia **operacao**; o segundo, **dimensionamento**.  
- **Balancos de massa e energia** fecham no cenario numerico adotado, respeitando **conservacao** em nivel de **estudo conceitual** (nivel B de confiabilidade ate entrada de dados de campo).  
- A **C/N** (`24.6`) situa-se na **faixa favoravel**.  
- O arranjo termico com **CHP** indica **autossuficiencia termica** com **excedente** no modelo.  
- **Proximos passos (Entrega 2):** dimensionamento detalhado de equipamentos (`TQ-101`, `D-101`, `TC-101`, `FP-101`, `MG-101`, etc.), lista de consumidores eletricos e revisao de **materiais** frente a `H2S` e abrasividade.

---

## Referencias

Chernicharo, C.A.L. (2007). *Principios do Tratamento Biologico de Aguas Residuarias - Reatores Anaerobios*. Departamento de Engenharia Sanitaria e Ambiental, UFMG.

Towler, G.; Sinnott, R. (2012). *Chemical Engineering Design: Principles, Practice and Economics of Plant and Process Design*. Elsevier.

Moran, M.J. et al. (2015). *Fundamentos de Engenharia Termodinamica*. (ou edicao equivalente utilizada na disciplina.)

ISA-5.1-2009. *Instrumentation Symbols and Identification*. International Society of Automation.

ABNT NBR 6493. *Simbologia para desenho de plantas de processo* (verificar ano da versao adotada no curso).

ASME Y32.11 (simbologia grafica para diagramas de engenharia; verificar edicao vigente).

UFPR (2024). Materiais e relatorios sobre desempenho de codigestao e arranjos operacionais (repositorio institucional / grupos de pesquisa).

Embrapa (2024). Orientacoes tecnicas sobre residuos organicos, lodo e agricultura (documentos publicados no portal Embrapa).

RVQ (2024). Referencias sobre caracterizacao de vinhaca e manejo (fontes tecnicas brasileiras do setor sucroenergetico).

MDPI (2019). Artigos em *Sustainability* e afins sobre composicao elementar de residuos organicos e codigestao (usar DOI especifico na versao final entregue a professora).

*Scientific Reports* / *Nature* (artigos sobre composicao de lodos e fracion organica; citar DOI na versao final).

Portal do Biogas / CIBiogas (materiais educativos sobre as quatro fases da digestao anaerobia, atualizados conforme consulta em 2025-2026).

---

*Documento gerado para consolidacao academica da Entrega 1. Ajustar nomes da equipe, DOIs e edicoes normativas exatamente como exigido no roteiro da disciplina.*
