# Selecao de materiais de construcao - biogas por codigestao anaerobia

## 1. Introducao

**Por que a selecao de materiais e critica?** O **digestor anaerobio** e o conjunto de tubos, tanques e maquinas em contato com **lodo**, **biogas** e **vinhaca**. Esse ambiente nao e "neutro" como ar seco em temperatura ambiente: ha **agentes quimicos** e **mecanicos** que atacam metais, revestimentos e plasticos.

Em termos simples:

- **Corrosao** e a degradacao gradual de um metal (ou revestimento) por reacao quimica ou eletroquimica com o fluido ao redor.
- **Pitting** e um tipo localizado de corrosao ("pocos" na superficie), muito perigoso em vasos sob pressao.
- **Abrasao** e o desgaste mecanico por particulas solidas arrastadas no fluido (areia, fibras, graos finos).

Se o material for mal escolhido, o custo de **manutencao**, **parada de planta** e **vazamento** supera a economia inicial. Por isso, a engenharia combina **normas**, **experiencia de setor** e **mapa de riscos** (onde esta cada agente agressivo).

**Referencias gerais:** Towler e Sinnott (2012) - *Chemical Engineering Design*; Perry's Handbook; normas ASTM/ASME e orientacoes NACE para ambientes com **H2S**.

---

## 2. Agentes de corrosao e degradacao no processo

**H2S** (*sulfeto de hidrogenio*): gas incolor, toxico, com cheiro de ovo podre em baixas concentracoes; em solucao forma especies corrosivas para acos comuns.

**CO2 dissolvido**: ao se dissolver na fase liquida, abaixa o **pH** localmente e favorece corrosao em aco carbono sem protecao.

**Acidos organicos volateis (AOV)**: produtos da **acidogenese**; aumentam agressividade acida da fase liquida.

**Amonia (NH3)**: pode atacar **cobre** e ligas que o contenham (evitar em contato direto com fluidos ricos em amonia).

**Cloretos (`Cl-`)**: ions presentes se houver agua salobra ou residuos com sal; favorecem **pitting** em **inox `304`** em zonas com pouca oxigenacao.

**Solidos em suspensao**: causam **abrasao** em rotores de bombas, curvas de tubulacao e agitadores.

**pH acido (vinhaca)**: na entrada e no **tanque de mistura**, o meio pode ser mais acido; exige revestimento ou aco mais resistente.

| Agente | Onde aparece | Efeito | Gravidade |
|--------|--------------|--------|-----------|
| `H2S` (sulfeto de hidrogenio) | Biogas, headspace, fase liquida | Corrosao por sulfeto, pitting em aco carbono | Alta |
| `CO2` dissolvido | Fase liquida | Corrosao acida leve | Media |
| Acidos organicos volateis | Fase liquida (acidogenese) | Corrosao acida | Media |
| Amonia (`NH3`) | Fase liquida | Corrosao de cobre e ligas | Baixa-media |
| Cloretos | Fase liquida (se agua salobra) | Pitting em inox `304` | Media |
| Abrasao por solidos | Bombas, tubulacoes, agitadores | Desgaste mecanico | Alta em pontos especificos |
| pH acido (vinhaca) | Tanque de mistura, entrada | Ataque acido direto | Media |

---

## 3. Materiais candidatos

Para cada material abaixo: **o que e**, **pontos fortes**, **pontos fracos**, **onde usar** no projeto de codigestao.

### 3.1 Aco carbono (`ASTM A516 Gr.70` ou `A36`)

- **O que e**: liga ferro-carbono de baixo custo, amplamente soldavel e estrutural.
- **Pontos fortes**: **barato**, boa **resistencia mecanica**, **facil de soldar**, adequado a vasos e chapas grossas com projeto normatizado.
- **Pontos fracos**: **vulneravel** a `H2S` e acidos sem protecao; exige **revestimento interno** e/ou **inibicao** de corrosao por projeto (drenagem, evitar zonas mortas).
- **Onde usar**: **corpo do digestor** (com revestimento), **estruturas**, **suportes**, partes nao molhadas por biogas agressivo sem barreira.

### 3.2 Aco inox `304` (`AISI 304`)

- **O que e**: aco inoxidavel austenitico com cromo e niquel; forma pelicula passiva protetora.
- **Pontos fortes**: boa resistencia geral a muitos meios de processo em temperatura moderada.
- **Pontos fracos**: **pitting** por **cloretos**; `H2S` em **alta concentracao** ou com defeitos na passivacao pode ser problematico - avaliar caso a caso.
- **Onde usar**: **tanque de mistura** (se fluido e cloreto-baixo), **tubulacoes de processo** de menor criticidade.

### 3.3 Aco inox `316L` (`AISI 316L`)

- **O que e**: inox austenitico com **molibdenio** e carbono baixo (`L` = baixo carbono para solda).
- **Pontos fortes**: **excelente resistencia** a `H2S`, **cloretos** e muitos acidos em comparacao ao `304`.
- **Pontos fracos**: **mais caro** que `304`; ainda assim nao e "imune" a todos os meios (sempre checar concentracao, temperatura, velocidade).
- **Onde usar**: **zona de gas** do digestor (headspace / interfaces), **trocador de calor** (lado lodo), **rotores** e partes molhadas criticas de **bombas**.

### 3.4 PRFV (plastico reforcado com fibra de vidro)

- **O que e**: **polimero** (geralmente resina termofixa) reforcado com **fibra de vidro**; tambem chamado **GRP** em literatura anglofona.
- **Pontos fortes**: **imune** a grande parte da **corrosao quimica** de acidos/bases moderadas, **leve**.
- **Pontos fracos**: **limite termico** tipico da ordem de `~80 degC` (depende da resina); **baixa tolerancia** a **impacto** forte comparado ao aco; projeto deve considerar **rigidez** e **fadiga**.
- **Onde usar**: **tanque de mistura alternativo**, **tubulacoes de vinhaca**, **coluna/tanque de dessulfurizacao** quando o projeto permitir temperatura e pressao.

### 3.5 PEAD (polietileno de alta densidade)

- **O que e**: termoplastico com boa resistencia quimica e custo moderado.
- **Pontos fortes**: **resistente** a acidos e bases em muitas aplicacoes, **barato** em tubos/tanques tipo caixa.
- **Pontos fracos**: **nao** adequado a **pressao** elevada nem **temperatura** alta de processo; limites mecanicos menores que aco.
- **Onde usar**: **tanque de `NaOH`**, **tubulacoes de efluente** a baixa pressao.

### 3.6 Revestimentos

- **Epoxi**: barreira organica que **protege** aco carbono contra corrosao **leve/media** quando aplicada com **preparacao de superficie** correta (jateamento, espessura minima).
- **Borracha (`EPDM`)**: boa para **membranas** e aplicacoes com **umidade** e certa **flexibilidade**; atencao a compatibilidade quimica com hidrocarbonetos e solventes especificos.
- **Concreto armado revestido**: alternativa **economica** para **digestor** em algumas escalas; o **revestimento** (impermeabilizante, epoxi, telha de vidro) e o ponto critico da vida util.

---

## 4. Tabela de selecao por equipamento

A coluna **Tag** identifica o equipamento no **diagrama de fluxo** (P&ID). **Material corpo** e a casca principal; **material interno** inclui revestimento, rotor ou tubos trocador.

| Tag | Equipamento | Material corpo | Material interno | Justificativa |
|-----|-------------|----------------|------------------|---------------|
| `TQ-101` | Tanque mistura | Aco carbono | Rev. epoxi | pH acido da vinhaca; baixa pressao |
| `P-101` | Bomba alimentacao | Ferro fundido | Rotor inox `316L` | Abrasao do lodo |
| `TC-101` | Trocador de calor | Aco carbono (casco) | Inox `316L` (tubos) | `H2S` dissolvido no lodo |
| `D-101` | Digestor | Aco carbono (ou concreto) | Rev. epoxi + zona gas inox `316L` | `H2S` no headspace |
| `P-102` | Bomba digestato | Ferro fundido | Rotor inox `316L` | Abrasao + `H2S` |
| `FP-101` | Filtro-prensa | Aco carbono | Placas polipropileno | Contato com lodo |
| `MG-101` | Motor-gerador | Padrao fabricante | - | Biogas tratado (`H2S` removido) |
| `TQ-102` | Gasometro | Estrutura aco | Membrana `EPDM` | Biogas umido |
| `DS-101` | Dessulfurizador | PRFV ou aco+epoxi | Carvao ativado | `H2S` concentrado |
| `TQ-103` | Tanque `NaOH` | PEAD | - | `NaOH` `50%` |

---

## 5. Normas relevantes

- **`ASTM A516`**, **`A240`**, **`A312`**: especificacoes de chapas, chapas de revestimento inoxidavel e tubos de aco inoxidavel.
- **`ASME VIII`**: projeto de **vasos de pressao** (quando aplicavel ao digestor/gasometro sob pressao).
- **`NBR 7821`**: tanques **atmosfericos** verticais de aco - referencia util em contexto brasileiro.
- **`NACE MR0175` / `ISO 15156`**: selecao de materiais resistentes a **fissuracao por sulfetos** em ambientes com `H2S` (especialmente gas e alta pressao parcial).

---

## 6. Confiabilidade

**Nivel B** (documento de apoio a projeto conceitual / basico, com base em literatura de projeto e normas citadas).

**Referencias principais:** Towler e Sinnott (2012); Perry's Chemical Engineers' Handbook; documentacao NACE/`ISO 15156`; normas ASTM/ASME e ABNT quando aplicavel.
