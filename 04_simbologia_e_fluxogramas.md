# Simbologia e fluxogramas de processo (aplicacao: biogas por codigestao anaerobia)

Documento didatico para **Projetos Industriais II** (UFMS, Engenharia Quimica). **Contexto do caso:** producao de biogas por **codigestao anaerobia** de **lodo de esgoto**, **vinhaca** e **residuo organico**.

**Convencao linguistica:** texto em **portugues sem acento** (ASCII puro), como pedido.

---

## 1. Introducao

**Definicao (simbologia):** Conjunto de **simbolos graficos** e **regras de uso** que representam equipamentos, tubulacoes, fluidos e instrumentos em desenhos de processo.

**Definicao (fluxograma):** Representacao esquematica de um **processo quimico** (ou biologico-industrial), mostrando **etapas**, **equipamentos** e **correntes** (fluxos de materia, energia ou informacao) na ordem em que ocorrem.

**Por que isso importa em engenharia quimica?**

- **Comunicacao entre pessoas:** O mesmo desenho precisa ser lido por projetistas, operadores, seguranca, fornecedores e fiscalizacao.
- **Reducao de erro:** Se cada um desenhar "do jeito proprio", nasce ambiguidade (por exemplo: uma valvula de bloqueio confundida com valvula de controle).
- **Rastreabilidade:** Tags (`P-101`, `TIC-101`) ligam o desenho a listas de equipamentos, especificacoes e malhas de controle.
- **Seguranca e manutencao:** P&ID detalhado e onde se apoiam procedimentos de partida, parada e emergencia.

**Ideia central:** A **padronizacao** (normas ISA, NBR, ASME/ANSI, PIP) faz com que **qualquer engenheiro treinado** consiga ler o projeto **sem traduzir** um desenho particular.

---

## 2. Normas de referencia

**Definicao (norma):** Documento tecnico que fixa **requisitos** ou **convencoes** aceitas por um setor (empresa, associacao ou organismo nacional).

### ISA 5.1 (Instrumentation Symbols and Identification)

**O que e:** Norma da **ISA** (International Society of Automation) que padroniza **simbolos** e **identificacao** de instrumentos e funcoes de medicao/controle.

**Por que existe:** Sem regra comum, o mesmo circulo no desenho poderia significar medidor, controlador ou elemento final; a ISA 5.1 amarra **forma do simbolo** e **tag** (`FIC`, `LIT`, etc.).

### ISA 5.3 (Graphic Symbols for Distributed Control / Shared Display / Shared Control)

**O que e:** Complementa a familia ISA com **simbolos graficos** para funcoes de controle em sistemas **distribuidos** (telas de supervisao, logica digital).

**Por que existe:** Quando o "cerebro" do controle deixa de ser so um circulo no P&ID e vira **logica em controlador**, e preciso mostrar **funcao** e **arquitetura** de forma reconhecivel.

### NBR 6493 (Identificacao de tubulacoes)

**O que e:** Norma brasileira que recomenda **cores** e, em alguns contextos, **legendas** para identificar **fluidos** em tubulacao industrial.

**Por que existe:** Cor e um codigo rapido para o operador distinguir **agua**, **vapor**, **gas**, **acido**, **esgoto**, etc., reduzindo erro em manobra e emergencia.

### ASME/ANSI Y32.11 (Graphic Symbols for Process Flow Diagrams)

**O que e:** Referencia classica de **simbolos** para **diagramas de fluxo de processo** (equipamentos e alguns elementos de linha).

**Por que existe:** Harmoniza o "desenho de engenharia" entre empresas e paises, especialmente em projetos com fornecedores internacionais.

### PIP (Process Industry Practices)

**O que e:** Conjunto de **praticas** acordadas por um consorcio de empresas de **industria de processo** (detalhes de desenho, especificacoes, convencoes).

**Por que existe:** Vai alem do simbolo isolado: padroniza **como** montar pacotes de engenharia (folhas, detalhamento, consistencia entre PFD e P&ID).

---

## 3. Tipos de fluxogramas (do mais simples ao mais detalhado)

### 3.1 Diagrama de blocos (BFD)

**Definicao (BFD - Block Flow Diagram):** Fluxograma em que **retangulos** representam **etapas** ou **plantas inteiras** e **setas** representam **fluxos** de materia ou energia, **sem** detalhar equipamentos internos.

**Quando usar:** Na **primeira etapa** do projeto, para alinhar **visao geral**, massas principais e destinos de produtos/subprodutos.

**BFD em texto (projeto biogas - codigestao):**

```
[Lodo] + [Vinhaca] + [Residuo]
            |
            v
    [Tanque de Mistura]
            |
            v
   [Digestor Anaerobio]
            |
    +-------+-------+
    v               v
 [Biogas]      [Digestato]
    |               |
    v               +------------------+
 [CHP/Cogeracao]                         |
    |                                    v
    +---> [Eletricidade] + [Calor]   [Desaguamento]
                                           |
                                   +-------+-------+
                                   v               v
                              [Torta]        [Filtrado]
```

**Leitura para leigo:** A mistura "cozinha" no digestor **sem oxigenio**; sai **gas** (biogas) e **liquido espesso** (digestato). O gas pode ir para **CHP** (cogeracao: eletricidade + calor). O digestato passa por **desaguamento** e separa **solido umido** (torta) e **liquido** (filtrado).

---

### 3.2 Fluxograma de Processo (PFD - Process Flow Diagram)

**Definicao (PFD):** Diagrama que mostra **equipamentos principais** com **simbolos padronizados**, **correntes numeradas** e, em geral, **condicoes representativas** (temperatura, pressao, vazao) em caixas de dados ou tabela.

**O que costuma conter:**

- **Equipamentos** com **tags** (`D-101`, `P-101`).
- **Correntes** com **numero** e **seta** (sentido do fluxo).
- **Tabela de correntes** (massa, composicao simplificada, fase).
- **Condicoes** tipicas: `T`, `P`, vazao.

**O que normalmente NAO vai no PFD:**

- Cada **valvula** manual de manutencao.
- **Instrumentacao** completa (malhas detalhadas).
- **Diametro** comercial de tubo e **schedule** (isso e mundo P&ID / especificacao).

**PFD completo em texto (fonte monoespacada sugerida: Consolas), com tags e correntes pedidas:**

```
                    +------------------+
  Corrente 101 ---->|                  |
  (Lodo)            |   TQ-101         |----+
                    | Tanque mistura   |    |
  Corrente 102 ---->|                  |    | Corrente 104
  (Vinhaca)         +------------------+    |(Mistura)
                           ^                  |
  Corrente 103 ------------+                  v
  (Residuo)                           +-------+-------+
                                      |   P-101       |
                                      | Bomba alim.   |
                                      +-------+-------+
                                              |
                                              v
                                      +-------+-------+
 Utilidade: agua quente               |   TC-101      |     Corrente 105
 (linha fina, ver/cinza por NBR) ---->| Trocador      |---->(Mistura aquecida)
                                      | aquecimento   |      T ~ 35 degC
                                      +-------+-------+
                                              |
                                              v
                                      +-------+-------+
                                      |   D-101       |
                                      | Digestor      |
                                      | (CSTR)        |
                                      +---+---+-------+
                                          |   |
                        Corrente 106      |   | Corrente 107
                        (Biogas bruto)    |   |(Digestato bruto)
                                          |   |
                                          v   v
                                      +---+---+-------+
                                      |   S-101       |
                                      | Sep. gas-liq. |
                                      | (headspace)   |
                                      +---+---+-------+
                                          |   |
                                          |   +------------------+
                                          |                      v
                                          |              +-------+-------+
                                          |              |   FP-101      |
                                          |              | Filtro-prensa |
                                          |              +---+---+-------+
                                          |                  |   |
                                          |      Corrente 109|   |Corrente 110
                                          |      (Torta)     |   |(Filtrado)
                                          v                  v   v
 Corrente 108 -----------------> +-------+-------+      (destino)
 (CH4 para CHP)                  |   MG-101        |
                                 | Motor-gerador   |
                                 | CHP             |
                                 +-------+-------+
                                     |         |
                                     v         v
                            [Eletricidade] [Calor util]

 Recirculacao (opcional no desenho fisico, tag pedida):

                                      +-------+
                                      | P-102 |
                                      | Bomba |
                                      | recirc|
                                      +-------+
                                         |
                                         +---- (retorno ao digestor / mistura)
```

**Nota didatica:** No PFD real, `P-102` pode aparecer apenas se a estrategia de processo incluir **recirculacao** explicita; a tag fica reservada para consistencia com a lista de equipamentos.

---

### 3.3 Diagrama de Tubulacao e Instrumentacao (P&ID)

**Definicao (P&ID):** O desenho **mais detalhado** da planta de processo: mostra **tubos**, **valvulas**, **instrumentos**, **drenos**, **pontos de amostragem**, **seguranca** (PSV, por exemplo), e frequentemente **diametro** e **material**.

**Definicao (tag ISA - leitura geral):** Codigo alfanumerico que identifica **um instrumento** ou **laco de controle**. A **primeira letra** costuma indicar a **variavel medida**; as **letras seguintes** indicam **funcao**.

**Primeira letra (variavel medida) - uso comum:**

- `T` = temperatura (Temperature).
- `P` = pressao (Pressure).
- `F` = vazao (Flow).
- `L` = nivel (Level).
- `A` = analise (Analysis) - exemplo: `pH`, condutividade, analisador de gas.

**Letras seguintes (funcao) - exemplos:**

- `I` = indicador (Indicator): mostra valor para o operador.
- `C` = controlador (Controller): decide acao de controle (muitas vezes em DCS/PLC).
- `T` = transmissor (Transmitter): envia sinal medido (pode aparecer como segundo `T` em `AIT`).
- `A` = alarme (Alarm) quando usado em combinacoes como `AH`/`AL` em algumas folhas; aqui usamos `H`/`L` como sufixo de alarme.
- `H` / `L` em alarmes: **alto** / **baixo** (High / Low).

**Exemplos no digestor (como pedido):**

- `TIC-101` = controlador **indicador** de **temperatura** no digestor (malha tipica: modula utilidade de aquecimento).
- `PIC-101` = controlador **indicador** de **pressao** no **headspace** (espaco de gas acima do liquido).
- `FIC-101` = controlador **indicador** de **vazao** de **alimentacao**.
- `LIC-101` = controlador **indicador** de **nivel** no digestor.
- `AIT-101` = transmissor **indicador** de **analise** (`pH`) no digestor.
- `LAH-101` = **alarme** de **nivel alto** no digestor.
- `TAH-101` = **alarme** de **temperatura alta** no digestor.
- `PSV-101` = **valvula de seguranca** de **pressao** (Pressure Safety Valve) no digestor.

**Simbolos de equipamentos (descricao textual + "referencia visual" mental):**

- **Tanque:** retangulo com **topo plano** ou **topo conico**; linhas de entrada/saida nas laterais.
- **Reator CSTR (digestor agitado):** retangulo com simbolo de **agitador** (circulo com **seta** curva dentro) indicando mistura.
- **Trocador de calor:** dois **circulos** parcialmente **sobrepostos** (casco e tubos, estilo simplificado) **ou** retangulo com **chicanas** (representacao alternativa em algumas bibliotecas).
- **Bomba:** **circulo** com **triangulo** apontando sentido de bombeamento.
- **Compressor:** **circulo** com **setas** de entrada/saida (mais "denso" que bomba).
- **Valvula manual:** muitas vezes **losango** na linha; **valvula automatica** pode aparecer como losango com **atuador** (linha perpendicular ao eixo).
- **Filtro-prensa:** retangulo com **hachura** ou trama indicando **meio filtrante** / placas.

**Trecho de P&ID em texto - malha de temperatura do digestor (`TIC-101`):**

```
UTILIDADE: AGUA QUENTE / VAPOR CONDENSAVEL (linha fina, cor por NBR 6493)
      |
      |                                +---------------------------+
      |                                |        D-101 (CSTR)       |
      +---[segmento de tubo]---+-------|  (liquido + headspace)    |
                                |       +---------------------------+
                                |                 ^
     +--------+                 |                 |
     | TC-101 |<----------------+-----------------+
     | casco/ |   linha de processo (grossa)
     | tubos  |   Corrente 105 -> digestor
     +---+----+
         ^
         |
    sinal 4-20 mA / Fieldbus (linha tracejada)
         |
    +----+-----+
    | TIC-101  |  SP = setpoint (ex.: 35 degC)
    | (DCS)    |
    +----+-----+
         |
         v
    saida para elemento final: valvula de modulacao na linha de **agua quente**
    que entra/sai do **TC-101** (aquece a corrente 104 -> 105)

    Instrumentos associados (mesmo desenho, outras linhas tracejadas):
    - TE-101: elemento sensor (termopar/PT100) no digestor **ou** na saida do TC-101
      (depende da estrategia; em aula, admita sensor no **liquido do digestor**)
    - TAH-101: alarme de temperatura alta (protege biologia e equipamento)
```

**Leitura para leigo:** O `TIC-101` compara **temperatura real** com **temperatura desejada**; se estiver frio demais, **abre** mais a valvula de utilidade no `TC-101` para **esquentar** a alimentacao (corrente `105`) antes do digestor.

---

## 4. Simbologia de tubulacao

**Definicao (linha de processo):** Desenho da **tubulacao** por onde passa o fluido principal da fabrica (alimentacao, produto, efluente de processo).

**Tipos de linha (convencao tipica de P&ID):**

- **Linha principal de processo:** **continua grossa** (destaque visual).
- **Linha de utilidades:** **continua fina** (vapor, agua de resfriamento, ar instrumento, nitrogenio inerte, quando nao e o "produto").
- **Linha de instrumentacao (sinal pneumatico/hidraulico antigo):** **tracejada** (hoje muitos projetos usam **tracejado** tambem para sinal eletrico; sempre ver **legenda da folha**).
- **Linha de sinal eletrico:** muitas vezes **tracejada com pontos** ou legenda `----/----` diferenciada; o importante e **nao confundir** tubo com fio.

**NBR 6493 - cores (referencia rapida + exemplo no projeto de biogas):**

| Fluido | Cor (convencao NBR 6493) | Exemplo no projeto |
|---|---|---|
| Agua | Verde | Agua de resfriamento de intercambiadores |
| Vapor / agua quente | Cinza-claro | Aquecimento do digestor via `TC-101` |
| Gas combustivel | Amarelo | Biogas (corrente `106`, `108`) |
| Acido / alcali | Laranja | Correcao de `pH` (dosagem de `NaOH`) |
| Ar comprimido | Azul | Instrumentacao pneumatica (se existir) |
| Esgoto / efluente | Marrom | Lodo (corrente `101`) e linhas de efluente bruto |

**Aviso de engenharia:** Em planta real, **tinta** pode descascar e **luz** pode distorcer cor; por isso norma e boa pratica exigem **etiqueta** com nome do fluido e sentido.

---

## 5. Tabela de correntes do PFD (aplicada ao projeto)

**Definicao (corrente numerada):** Identificador (`101`, `102`, ...) usado no PFD para ligar **setas** a uma **linha** da tabela.

**Hipoteses usadas nesta reproducao:**

- Massas em `kg/dia` para **ordem de grandeza** e **balanco global** coerente com o enunciado deste arquivo.
- Solidos (`ST`, `SV`) para correntes **liquido/pasta** seguem a mesma **estrutura didatica** de `03_tabela_correntes_pfd_biogas.md`, ajustando **massas** quando o gas total muda levemente (`~1984 kg/dia`).

**Fechamento rapido (conservacao de massa, visao global):**

`M_104 = M_101 + M_102 + M_103 = 51000 + 30270 + 21000 = 102270 kg/dia`

`M_105 = M_104` (mesma massa; mudanca principal e **T** e **energia termica**).

`M_107 = M_104 - M_106 = 102270 - 1984 = 100286 kg/dia` (modelo sem acumulo).

`M_109 + M_110 = M_107` com `14742 + 85544 = 100286 kg/dia`.

| Numero | Descricao | M (kg/dia) | ST (kg/dia) | SV (kg/dia) | agua+outros (kg/dia) | Observacao didatica |
|---:|---|---:|---:|---:|---:|---|
| 101 | Lodo de esgoto (entrada) | `51000` | `1785` | `1160` | `49215` | Maior massa; traz buffer, mas sozinho costuma ter `C/N` desfavoravel. |
| 102 | Vinhaca (entrada) | `30270` | `515` | `386` | `29755` | Mais diluida; molda acidez e diluicao da carga. |
| 103 | Residuo organico triturado (entrada) | `21000` | `4200` | `3570` | `16800` | Menor vazao em massa total, mas **alta** carga organica particulada. |
| 104 | Mistura alimentada (saida `TQ-101`) | `102270` | `6500` | `5116` | `95770` | Corrente que define carga enviada ao digestor (antes do `TC-101`). |
| 105 | Mistura aquecida (saida `TC-101`) | `102270` | `6500` | `5116` | `95770` | Mesma massa que `104`; **T** tipica **35 degC** (mesofilico). |
| 106 | Biogas bruto (saida `S-101`, fase gas) | `1984` | `-` | `-` | `-` | Pequeno em massa, grande em **valor energetico** (depende de `CH4`). |
| 107 | Digestato bruto (saida liquida) | `100286` | `3686` | `2302` | `96600` | Efluente estabilizado; segue para `FP-101`. |
| 108 | `CH4` para `CHP` (recorte do gas) | `747` | `-` | `-` | `-` | Em PFD de construcao, pode ser **caixa de informacao** sobre `106`, nao linha fisica separada. |
| 109 | Torta desaguada (solido umido) | `14742` | `3686` | `2302` | `11056` | Premissa tipica de aula: solidos concentrados na torta; ajuste com curva real do filtro. |
| 110 | Filtrado (liquido separado) | `85544` | `0` | `0` | `85544` | Modelo limpo; operacao real pode ter **arraste** fino de solidos. |

**Checagem de plausibilidade:** `ST` e `SV` em `107` foram mantidos como na base `03_...` para **continuidade pedagogica**; `agua+outros` em `107` foi recalculado para fechar `M_107 = ST + agua+outros` com o novo total massico.

---

## 6. Lista de equipamentos com tags

**Definicao (tag de equipamento):** Codigo curto que identifica **um unico equipamento** na planta (ex.: `D-101`).

| Tag | Nome | Funcao | Material principal (exemplo) | Observacao |
|---|---|---|---|---|
| `TQ-101` | Tanque de mistura | Homogeneizar lodo + vinhaca + residuo; reduz variacao na alimentacao | Aco carbono com revestimento quimico (epoxi) ou inox | Tempo de residencia depende da estabilizacao desejada |
| `P-101` | Bomba de alimentacao | Elevar pressao para transporte e para o `TC-101` / digestor | Inox / fundicao (depende abrasividade) | `FIC-101` pode atuar na **velocidade** (inversor) ou recirculacao |
| `TC-101` | Trocador de calor | Aquecer corrente `104` -> `105` ate **~35 degC** | Placas inox ou casco/tubos | Utilidade: agua quente ou vapor com condensacao |
| `D-101` | Digestor anaerobio (`CSTR`) | Biodegradacao anaerobia; producao de biogas e digestato | Aco carbono + revestimento / concreto revestido | `CSTR` = reator agitado tipo tanque |
| `S-101` | Separador gas-liquido | Separa **headspace** / linha de gas da linha de liquido | Inox na parte molhada | Em plantas simples pode ser integrado ao desenho do digestor |
| `FP-101` | Filtro-prensa | Desaguamento: aumenta solidos na torta e reduz umidade | Aco inox em zonas corrosivas | Consumo de polimero e lavagem de panos afetam `109/110` |
| `MG-101` | Motor-gerador `CHP` | Queimar biogas com `CH4` e gerar **eletricidade** + **calor** | Pacote skid padronizado | Exige tratamento do gas se `H2S`/umidade for alta |
| `P-102` | Bomba de recirculacao | Recircular digestato/mistura para estabilizar `pH`/temperatura ou mistura | Inox | So entra no PFD se a estrategia de processo prever |

---

## 7. Malhas de controle principais

**Definicao (malha de controle):** Conjunto **medicao -> decisao -> acao** que mantem uma variavel do processo perto de um **setpoint** (valor desejado).

### Temperatura do digestor (`TIC-101` -> valvula de agua quente no `TC-101`)

- **Medida:** temperatura do digestador (ou da alimentacao aquecida, conforme estrategia).
- **Manipulada:** vazao de utilidade quente no `TC-101`.
- **Por que importa:** microbiologia anaerobia e sensivel; faixa mesofilica (~`35 degC`) e tipica em aulas de projeto.

### `pH` do digestor (`AIC-101` -> dosagem de `NaOH`)

- **Medida:** `pH` (analise).
- **Manipulada:** vazao de **alcali** (`NaOH` diluido) na alimentacao ou no digestor.
- **Por que importa:** evita acidificacao que derruba a metanogenese.

**Nota:** No texto de tags exemplificamos `AIT-101`; a **malha fechada** completa aparece como `AIC-101` quando existe **controle automatico**.

### Nivel do digestor (`LIC-101` -> valvula de saida de digestato)

- **Medida:** nivel de liquido.
- **Manipulada:** saida de digestato para manter nivel estavel.
- **Por que importa:** nivel alto pode afogar separacao de gas; nivel baixo pode expor agitacao/vortex e entrada de ar (perigo e perda de anaerobiose).

### Vazao de alimentacao (`FIC-101` -> velocidade da bomba `P-101`)

- **Medida:** vazao massica ou volumetrica corrigida.
- **Manipulada:** **velocidade** do motor da `P-101` (inversor de frequencia) ou valvula de controle em serie.
- **Por que importa:** define **tempo de residencia** e carga organica diaria.

### Pressao do headspace (`PIC-101` -> valvula de biogas + `PSV-101`)

- **Medida:** pressao no gas acima do liquido.
- **Manipulada:** valvula de saida de biogas para consumo/queima/tocha (estrategia depende do projeto).
- **Seguranca:** `PSV-101` protege contra **sobrepressao** por disturbio de consumo ou bloqueio downstream.

---

## 8. Confiabilidade e referencias

**Classificacao de confiabilidade deste documento:** **Nivel B** (adequado para **projeto de disciplina** e **ordem de grandeza**, sujeito a caracterizacao experimental de substratos, ensaios batch/continuo e definicao de fornecedor).

**Referencias academicas e normativas sugeridas:**

- ISA. **ANSI/ISA-5.1-2009** (ou revisao vigente): *Instrumentation Symbols and Identification*.
- ISA. **ISA-5.3** (familia ISA para simbolos de funcoes de controle em sistemas distribuidos; ver edicao vigente adotada pela instituicao).
- ABNT. **NBR 6493**: identificacao de tubulacao por cor (aplicar edicao vigente).
- ASME/ANSI **Y32.11**: simbolos graficos para diagramas de fluxo de processo (consultar versao adotada no projeto).
- **PIP** practices (pacotes corporativos de engenharia de detalhamento; uso depende da empresa/EP).
- Towler, G.; Sinnott, R. **Chemical Engineering Design: Principles, Practice and Economics of Plant and Process Design**. 2. ed. Elsevier, **2012** (diagramas, especificacao e visao de projeto).
- Moran, S. **Process Plant Layout**. 2. ed. Elsevier, **2015** (organizacao fisica e leitura integrada de documentacao de projeto).

**Lembrete final:** Sempre confira a **legenda** da folha: pequenas variacoes entre empresas existem mesmo com norma; o documento oficial do seu trabalho e o **P&ID assinado** com legenda clara.
