# Layout industrial e carta de processo - biogas (codigestao)

**Definicoes rapidas (antes dos termos tecnicos):**
- `Layout industrial`: arranjo fisico no terreno de equipamentos, edificacoes, vias e areas auxiliares.
- `Carta de processo`: sequencia textual das etapas do processo com equipamentos, entradas, saidas e tempos tipicos (complementa o PFD formal).
- `PFD`: diagrama de fluxo de processo com tags e correntes; neste projeto veja `04b_pfd_formal_biogas.md`.
- `NR-20`: norma brasileira de seguranca em instalacoes e armazenamento de inflamaveis (inclui distanciamentos e boas praticas).
- `NBR 17505`: norma ABNT sobre armazenamento seguro de liquidos inflamaveis e combustiveis (complementa criterios de afastamento).

**Convencao:** valores numericos, tags e nomes de norma citados no texto aparecem entre backticks quando sao dados de projeto.

---

## 1. Introducao

O `layout industrial` e o **arranjo fisico** dos equipamentos, edificacoes e areas auxiliares no terreno.

**Objetivos principais:**
- **Seguranca:** separar zonas inflamaveis (biogas, CHP) de circulacao de pessoas e edificacoes, em linha com `NR-20` e `NBR 17505`.
- **Acessibilidade:** permitir manutencao com guindaste, grua ou empilhadeira sem bloquear rotas de emergencia.
- **Fluxo logico de materiais:** reduzir cruzamento de caminhoes de residuo com saida de torta e com areas administrativas.
- **Economia de tubulacao:** aproximar digestor, gasometro e CHP sem violar distancias legais e de risco.

**Referencias:** Moran, S. (2015). *Process Plant Layout*; `NR-20`; `NBR 17505`; PFD `04b_pfd_formal_biogas.md`.

---

## 2. Criterios de projeto do layout

- **Fluxo unidirecional de materiais:** `recebimento` -> `pre-tratamento` -> `digestao` -> `desaguamento` -> `destinacao`, evitando retorno de veiculos sobre a mesma baia sem necessidade.
- **Distancias minimas de seguranca** (alinhamento conceitual com `NR-20` e `NBR 17505`; confirmar com projeto de incendio e ART local):
  - Entre equipamentos de processo pesado: `>= 3 m` (manutencao e escape de calor).
  - Zona de gas (`TQ-102`, `MG-101`, tubulacao de biogas tracada como zona controlada): `>= 15 m` de edificacoes habituais ou administrativas (ordem de grandeza de projeto; validar com laudo).
  - Area de trafego rodoviario: `>= 6 m` de largura util para manobra de caminhoes.
  - Estacao de controle / sala SCADA: `>= 20 m` da area de processo continuo com maior risco (digestor, prensa, zona de gas), quando possivel no terreno.
- **Acessibilidade para manutencao:** raio livre para montagem de agitadores, tampas de visita e troca de pacotes do `DS-101`.
- **Prevencao de contaminacao cruzada:** fluxo separado para residuo nao tratado vs digestato; higienizacao de pontos de contato.
- **Drenagem:** piso impermeavel e canaletas na area de processo liquido/pasta; tanques de contencao conforme legislacao ambiental.

---

## 3. Zonas da planta

| Zona | Area estimada (`m2`) | Equipamentos/funcoes |
|------|----------------------|----------------------|
| 1. Recebimento de residuos | `400` | Baia de descarga, balanca rodoviaria, `TQ-101` |
| 2. Pre-tratamento | `200` | Peneira rotativa, triturador |
| 3. Digestao | `600` | `D-101` (`12 m` diam), `TC-101`, `P-101`, `TQ-103` |
| 4. Biogas | `300` | `TQ-102`, `DS-101`, tubulacao de gas |
| 5. Cogeracao | `200` | `MG-101`, transformador, quadro eletrico |
| 6. Desaguamento | `300` | `FP-101`, `P-102`, cacamba de torta |
| 7. Utilidades | `150` | Compressor, casa de bombas, tanques auxiliares |
| 8. Controle e administracao | `100` | Sala de controle (SCADA), escritorio, vestiario |
| 9. Estacionamento e acessos | `400` | Portaria, estacionamento, vias internas |
| 10. Area de seguranca | `200` | Acesso emergencia, hidrantes, extintores |
| **TOTAL** | **`~2850`** | Terreno minimo sugerido: **`~3500 m2`** (folgas, futuro, cercas) |

**Significado fisico:** a soma `~2850 m2` e area **impraticavel aproximada**; o terreno `~3500 m2` absorve vias, raio de giro, zonas de protecao e expansao minima.

---

## 4. Layout em planta (texto ASCII)

**Leitura do desenho:** copie para editor monoespacado (ex.: Consolas). Escala aproximada: **grade `70 m` (leste-oeste) x `50 m` (norte-sul)**. `N` = norte no topo; entrada ao sul; `(@)` = digestor `D-101` (`~12 m` diam); distancias reais exigem prancha CAD e curvas de nivel.

```
                              N (topo)
    0    10   20   30   40   50   60   70 m
  +----+----+----+----+----+----+----+----+
50|                    [TQ-102]   [DS-101]     |  <- zona gas / tratamento gas
  |                      |          |         |     (afastar `>= 15 m` da adm)
  |                   +--+----------+--+      |
  |                   |     biogas      |     |
40|                   +--------+--------+     |
  |                            |              |
  |                       +----+----+         |
  |                       | MG-101 | CHP      |
  |                       +----+----+         |
  |                            |              |
  |    +-----------------------+--------+    |
30|    |            (@)                    |    |  <- D-101 centro (~12 m)
  |    |         D-101 CSTR              |    |
  |    |    TC-101  P-101  TQ-103       |    |
  |    +------------------+-------------+    |
  |           |                |             |
  |      +----+----+     +------+------+      |
20|      | FP-101  |     |  utilidades |      |  <- leste: desaguamento
  |      | P-102   |     | compressor|      |
  |      +----+----+     +-------------+      |
  |           |                               |
  |  [SCADA]  |   +----------+                |  <- sudoeste: controle
  |  controle |   | TQ-101   |                |     (afastado da zona gas)
10|     +-----+   | mistura  |                |
  |     |     |   +-----+----+                |
  |     | ADM |         |                     |
  |     +-----+   +-----+-----+               |
  |               | pre-trat  |               |
 0|               +-----+-----+               |
  |                     |                     |
  |   oooooooooooooooooooooooooooooooo        |  <- via perimetral ~6 m
  |   o  RECEB / BALANCA / BAIA    o        |
  |   oooooooooooooooooooooooooooooooo        |
  +----+----+----+----+----+----+----+----+
       ^                    ^
       PORTARIA          ESTACIONAMENTO
       (SUL)             caminhoes
```

**Coerencia com o processo:** substratos chegam ao sul, homogeneizam no `TQ-101`, seguem `P-101` -> `TC-101` -> `D-101` (PFD `04b`); biogas sobe para `TQ-102` -> `DS-101` -> `MG-101` ao norte; digestato vai a leste para `FP-101`.

---

## 5. Carta de processo simplificada

| Etapa | Equipamento(s) | Entrada | Saida | Tempo | Observacao |
|-------|------------------|---------|-------|-------|------------|
| 1. Recebimento | Balanca, baia | Caminhoes | Residuos pesados | `15 min/caminhao` | `3` a `5` caminhoes/dia (hipotese) |
| 2. Pre-tratamento | Peneira, triturador | Residuos | Residuo triturado | Continuo | Remover inertes |
| 3. Mistura | `TQ-101` | Lodo+vinhaca+residuo | Corrente `104` | `12 h` retencao | Agitacao continua |
| 4. Alimentacao | `P-101` | Corrente `104` | Corrente `105` | Continuo | `4.17 m3/h` |
| 5. Aquecimento | `TC-101` | Mistura `20 degC` | Mistura `35 degC` | Continuo | `71 kW` termico medio (balanco) |
| 6. Digestao | `D-101` | Mistura `35 degC` | Biogas + digestato | `20 dias` TRH | `2000 m3` util liquido |
| 7. Tratamento biogas | `DS-101` | Biogas bruto (`107`) | Biogas tratado (`108`) | Continuo | Remove `H2S` |
| 8. Cogeracao | `MG-101` | Biogas tratado | Eletricidade + calor | Continuo | `157 kW` eletrico liquido medio |
| 9. Desaguamento | `FP-101` | Digestato (`109`) | Torta `25%` ST + filtrado | `3` bateladas/dia | `~8 h` cada |
| 10. Destinacao | Cacamba | Torta (`111`) | Aterro/agricultura | Diario | `14.7 t/dia` torta |

**Dados e hipoteses:** vazoes e massas alinhadas a `04b_pfd_formal_biogas.md` e `06_dimensionamento_equipamentos.md`. Tempos de caminhao e bateladas sao **premissas operacionais** (Nivel C).

---

## 6. Fluxo de materiais

Diagrama textual (entradas e saidas principais do dia tipo; unidades consistentes com balanco de massa/energia do projeto):

```
ENTRADAS (massa/volume por dia, ordem de projeto)
  |
  +-- lodo .................. `51000 kg/dia` (`~51 t/dia`)
  +-- vinhaca ................ `30270 kg/dia` (`~30 t/dia`)
  +-- residuo organico ....... `21000 kg/dia` (`~21 t/dia`)
  +-- NaOH (dosagem) ......... `~100 kg/dia` (`~0.1 t/dia`; ver `08_utilidades_eficiencia.md`)
  +-- agua industrial ........ `~2.6 m3/dia` (selagem, lavagem, diluicao)
  |
  v
[ PROCESSO: mistura -> aquecimento -> digestao -> gas -> CHP -> prensa ]
  |
  +-- SAIDAS
        |
        +-- eletricidade liquida ... `3758 kWh/dia` (base `06_dimensionamento_equipamentos.md`)
        +-- torta (`111`) .......... `14742 kg/dia` (`~14.7 t/dia`)
        +-- filtrado (`112`) ....... `85544 kg/dia` (`~85.5 t/dia`)
        +-- emissoes ............... `CO2` da combustao no `MG-101` + ventilacoes controladas
```

**Conservacao de massa (checagem rapida):** entrada seca umida soma `102270 kg/dia` nas correntes `101+102+103` do PFD; gas `107` retira `1984 kg/dia` em massa gasosa; digestato `109` fecha com `100286 kg/dia` (`102270 - 1984`).

---

## 7. Confiabilidade

**Nivel C (conceitual / pre-layout):** distancias normativas e areas sao **guias de estudo**; o desenho definitivo exige planta topografica, compartimentacao de risco, SPDA, projeto de incendio e validacao com orgaos competentes.

**Referencias principais:** `NR-20`; `NBR 17505`; Moran, S. (2015); PFD `04b_pfd_formal_biogas.md`; dimensionamento `06_dimensionamento_equipamentos.md`.

---

*Documento em portugues ASCII para compatibilidade; tags e valores entre backticks conforme convencao do projeto.*
