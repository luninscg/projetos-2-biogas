# PFD formal - Biogas por codigestao anaerobia

Este documento e o **diagrama de fluxo de processo (PFD)** formal do projeto, com **tags** de equipamento no padrao usual de engenharia (prefixo + numero). Serve para comunicar o fluxo de materia e energia sem entrar no detalhe de valvulas e instrumentacao (isso fica para o P&ID).

**Definicoes rapidas (antes de usar os termos):**
- `PFD`: desenho que mostra **equipamentos principais** e **correntes** (linhas de processo), com numeracao.
- `Tag`: codigo unico do equipamento (ex.: `D-101` = digestor numero 101).
- `Corrente`: fluxo de material ou energia entre dois pontos, identificado por numero (ex.: corrente `104`).
- `ST`: solidos totais (massa de fase solida + material suspensa, expressa em massa).
- `SV`: solidos volateis (fracao organica dos ST; o restante aproxima cinzas/minerais).

**Convencao de texto:** valores numericos e tags aparecem entre backticks quando citados no texto (ex.: `102270` kg/dia).

---

## 1. Lista de equipamentos

| Tag | Nome | Funcao principal | Tipo |
|---|---|---|---|
| TQ-101 | Tanque de mistura | Homogeneizar lodo + vinhaca + residuo | Tanque agitado, aberto |
| P-101 | Bomba de alimentacao | Transferir mistura para o trocador | Bomba centrifuga |
| TC-101 | Trocador de calor | Aquecer mistura de `20` a `35` degC | Casco-tubo ou espiral |
| D-101 | Digestor anaerobio | Conversao biologica (CSTR) | Cilindro vertical fechado |
| P-102 | Bomba de digestato | Transferir digestato para desaguamento | Bomba de cavidade progressiva |
| FP-101 | Filtro-prensa | Desaguar digestato a `25`% ST | Filtro-prensa de placas |
| MG-101 | Motor-gerador CHP | Converter biogas em eletricidade + calor | Motor a gas + gerador |
| TQ-102 | Tanque de biogas | Armazenamento intermediario de biogas | Gasometro de membrana |
| DS-101 | Dessulfurizador | Remover H2S do biogas | Torre de carvao ativado |
| TQ-103 | Tanque de NaOH | Correcao de pH | Tanque PEAD |

---

## 2. Lista de correntes

| Corrente | Descricao | De | Para | Fase | Massa (kg/dia) | T (degC) | P (atm) |
|---|---|---|---|---|---|---|---|
| 101 | Lodo de esgoto | Limite bateria | TQ-101 | Liquido/pasta | `51000` | `20` | `1.0` |
| 102 | Vinhaca | Limite bateria | TQ-101 | Liquido | `30270` | `20` | `1.0` |
| 103 | Residuo organico triturado | Limite bateria | TQ-101 | Pasta | `21000` | `20` | `1.0` |
| 104 | Mistura homogeneizada | TQ-101 | P-101 | Liquido/pasta | `102270` | `20` | `1.0` |
| 105 | Mistura bombeada | P-101 | TC-101 | Liquido/pasta | `102270` | `20` | `~2.0` |
| 106 | Mistura aquecida | TC-101 | D-101 | Liquido/pasta | `102270` | `35` | `~1.5` |
| 107 | Biogas bruto | D-101 (topo) | TQ-102 | Gas | `1984` | `35` | `1.02` |
| 108 | Biogas tratado | DS-101 | MG-101 | Gas | `~1960` | `35` | `1.0` |
| 109 | Digestato bruto | D-101 (fundo) | P-102 | Liquido/pasta | `100286` | `35` | `1.0` |
| 110 | Digestato bombeado | P-102 | FP-101 | Liquido/pasta | `100286` | `35` | `~2.0` |
| 111 | Torta desaguada | FP-101 | Destinacao | Solido umido | `14742` | `~30` | `1.0` |
| 112 | Filtrado | FP-101 | Tratamento | Liquido | `85544` | `~30` | `1.0` |
| 113 | Agua quente (utilidade) | Caldeira/CHP | TC-101 | Liquido | - | `80` | `~3.0` |
| 114 | Agua quente retorno | TC-101 | Caldeira/CHP | Liquido | - | `50` | `~2.5` |
| 115 | NaOH (correcao pH) | TQ-103 | D-101 | Liquido | variavel | `20` | `1.0` |
| 116 | Eletricidade | MG-101 | Rede/consumo | - | - | - | - |
| 117 | Calor recuperado | MG-101 | TC-101 | - | - | - | - |

---

## 3. PFD em formato texto (monoespacado, estilo Consolas)

Copie para um editor com fonte monoespacada (ex.: Consolas, Courier New) para alinhar as caixas.

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
                          +------+------+    |               |  [MG-101]   | <--- CHP (sup. dir.)
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
          |                                                                        |
          |        mistura (106)  ============================>  liquido/pasta   |
          |                                                                        |
          |        biogas (107)   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  topo D-101    |
          |                                                                        |
          |        digestato (109)vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  fundo D-101   |
          +------------------------|-----------------------------------------------+
                                   |
                                   v (109)
                            +-------------+
                            |  [P-102]    |
                            +------+------+
                                   | (110)
                                   v
                            +-------------+                      desaguamento
                            | [FP-101]    |                      (inf. dir.)
                            +------+------+
                                   |
                    +--------------+--------------+
                    | (111) torta  | (112) filtrado|
                    v              v
               Destinacao     Tratamento efluente
```

**Leitura do desenho:**
- Entradas de substrato `(101)(102)(103)` convergem em `[TQ-101]`; a corrente `(104)` segue para `[P-101]`, `(105)`, `[TC-101]`, `(106)` e entra em `[D-101]`.
- O **biogas** sai pelo **topo** de `[D-101]` como `(107)`, passa por `[TQ-102]` e `[DS-101]`, e segue `(108)` para `[MG-101]` (CHP no canto superior direito do desenho).
- O **digestato** sai pelo **fundo** como `(109)`, vai a `[P-102]`, `(110)`, `[FP-101]`; as saidas sao `(111)` torta e `(112)` filtrado (desaguamento na parte inferior direita).
- Utilidades `(113)(114)` fecham o aquecimento no `[TC-101]`; `(115)` e a dosagem de NaOH; `(116)(117)` sao energia termica e eletrica do CHP.

---

## 4. Tabela resumo de correntes (formato planilha)

**Hipoteses usadas nesta tabela (para ST/SV onde nao estavam na lista de correntes):**
- Composicao de entrada alinhada ao arquivo base `00_base_biogas_codigestao.md`: lodo `ST=3,5`%, `SV/ST=65`%; vinhaca `ST=1,7`%, `SV/ST=75`%; residuo `ST=20`%, `SV/ST=85`%.
- Digestato `(109)(110)`: fechamento de solidos com a saida da prensa: torta `(111)` com `25`% ST; filtrado `(112)` com o restante de ST em massa, de forma que `ST111 + ST112 = ST109`.
- `SV` no digestato e nas saidas da prensa: valores **indicativos** (`SV/ST ~ 0,50` no digestato; torta com `SV/ST ~ 0,55`; filtrado com `SV/ST ~ 0,80` sobre os ST do filtrado). Ajuste apos caracterizacao de laboratorio.
- Correntes gasosas e utilidades: colunas de solidos como `-` (nao aplicavel no mesmo sentido de pasta liquida).

| Corrente | Massa total (kg/d) | ST (kg/d) | SV (kg/d) | Agua+outros (kg/d) | T (degC) | P (atm) | Fase | Observacao |
|---|---:|---:|---:|---:|---:|---|---|---|
| 101 | `51000` | `1785` | `1160` | `49215` | `20` | `1.0` | Liquido/pasta | ST/SV do base lodo |
| 102 | `30270` | `515` | `386` | `29755` | `20` | `1.0` | Liquido | ST/SV do base vinhaca |
| 103 | `21000` | `4200` | `3570` | `16800` | `20` | `1.0` | Pasta | ST/SV do base residuo |
| 104 | `102270` | `6500` | `5116` | `95770` | `20` | `1.0` | Liquido/pasta | Soma 101+102+103 |
| 105 | `102270` | `6500` | `5116` | `95770` | `20` | `~2.0` | Liquido/pasta | Igual a 104 (sem separacao) |
| 106 | `102270` | `6500` | `5116` | `95770` | `35` | `~1.5` | Liquido/pasta | Aquecida no TC-101 |
| 107 | `1984` | - | - | - | `35` | `1.02` | Gas | Massa gas; sem ST/SV tipo lodo |
| 108 | `~1960` | - | - | - | `35` | `1.0` | Gas | Perda de massa na dessulfurizacao |
| 109 | `100286` | `4200` | `2100` | `96086` | `35` | `1.0` | Liquido/pasta | `102270 - 1984`; ST/SV hipoteticos |
| 110 | `100286` | `4200` | `2100` | `96086` | `35` | `~2.0` | Liquido/pasta | Igual a 109 antes da prensa |
| 111 | `14742` | `3686` | `2027` | `11056` | `~30` | `1.0` | Solido umido | `25`% ST na torta; SV estimado |
| 112 | `85544` | `514` | `411` | `85030` | `~30` | `1.0` | Liquido | Fechamento ST com 111 |
| 113 | - | - | - | - | `80` | `~3.0` | Liquido | Vazao termica definida no balanco energetico |
| 114 | - | - | - | - | `50` | `~2.5` | Liquido | Retorno ao gerador de vapor / circuito |
| 115 | variavel | - | - | - | `20` | `1.0` | Liquido | Dosagem por pH; nao fechada nesta planilha |
| 116 | - | - | - | - | - | - | Energia | Potencia eletrica em kW (PFD nao fixa valor) |
| 117 | - | - | - | - | - | - | Energia | Duty termico para integracao com TC-101 |

**Checagens rapidas de plausibilidade:**
- `51000 + 30270 + 21000 = 102270` (corrente `104`).
- `102270 - 1984 = 100286` (digestato `109` frente ao gas `107`).
- `14742 + 85544 = 100286` (prensa).
- `ST111 + ST112 = 3686 + 514 = 4200` (igual a ST de `109` nesta hipotese).

---

## 5. Condicoes de contorno do projeto

- **Regime:** estacionario (operacao **continua**); vazoes e composicoes medias do dia representam o estado de projeto.
- **Base de escala:** `100` m3/dia de referencia de projeto (volume diario de referencia para dimensionamento; as massas da tabela de correntes sao a base massica coerente com o balanco apresentado).
- **Temperatura operacional:** `35` degC (**mesofilico**), conforme corrente `(106)` e interior de `[D-101]`.
- **Pressao:** predominio de **atmosferica** nas linhas liquidas abertas; **leve sobrepressao** no gas do digestor e no gasometro (ordem de `1,02` atm na corrente `107` como ordem de grandeza).

---

## 6. Como usar este PFD

Este PFD e a **base conceitual** para:

1. **Dimensionamento de equipamentos (Entrega 2):** cada `[tag]` vira um item com vazao masica/volumetrica de entrada e saida; o balanco global parte das correntes numeradas.
2. **Elaboracao do P&ID (aulas 7-8):** o P&ID **herda** os equipamentos e os numeros de corrente, e acrescenta valvulas, instrumentos (PI, TI, LIC, etc.) e detalhe de tubacao.
3. **Especificacao de materiais:** fases (acido/base, solidos abrasivos, H2S umido) guiam escolha de aco inox, PEAD, revestimentos, e classe de bomba.
4. **Analise de seguranca:** identificacao de inflamavel (biogas), confinamento, sobrepressao, derramamento de soda `(115)` e acesso mecanico (prensa, agitador).

Quando um dado nao estiver fixado no PFD (ex.: vazao exata de `113`/`114`, dose de `115`), trate como **lista de interface** com os proximos entregaveis (balanco energetico, P&ID, HAZOP).

---

## Referencia cruzada

- Base conceitual e definicoes: `00_base_biogas_codigestao.md`.
