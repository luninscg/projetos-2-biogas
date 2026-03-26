# Variaveis de processo e de projeto no projeto de biogas por codigestao anaerobia

**Disciplina:** Projetos Industriais II  
**Curso:** Engenharia Quimica, UFMS  
**Contexto:** producao de biogas por codigestao anaerobia  

---

## 1. Introducao

**Grandeza** e qualquer quantidade que pode ser medida ou calculada (numero com unidade). Exemplos: metros, quilogramas, graus Celsius.

**Sistema** e o conjunto que escolhemos para estudar (por exemplo, o digestor e o que entra e sai dele). O que esta fora do sistema e o **meio externo**.

A diferenca fundamental e esta:

- **Variavel de processo** e uma grandeza que descreve o **estado** (como o sistema esta naquele instante) ou o **comportamento** do sistema **durante a operacao** (enquanto a planta funciona). Exemplos tipicos: temperatura, pressao, vazao, composicao, pH, nivel. Essas grandezas podem ser **medidas** (instrumentos), **controladas** (mantidas perto de um alvo) ou **manipuladas** (mudadas de proposito pelo operador ou pelo controlador).

- **Variavel de projeto** (em ingles, *design variable*) e uma grandeza definida na fase de **engenharia**, antes da construcao, que determina as **dimensoes** e as **especificacoes fisicas** dos equipamentos: volume, diametro, altura, espessura de parede, material, potencia instalada. Depois que o equipamento existe, esses valores **nao mudam com facilidade**; mudar costuma exigir reforma ou troca de equipamento.

- **Parametro de equipamento** e um valor que **caracteriza** o equipamento ou o fenomeno nele (nao e exatamente uma dimensao fisica "tamanho", mas descreve desempenho ou propriedade). Exemplos: eficiencia, coeficiente global de troca termica, rendimento. Parametros costumam vir de **catalogo**, **teste**, **literatura** ou **premissa** de projeto.

Em resumo: **processo** = o que flutua ou e ajustado na operacao; **projeto** = o que foi "congelado" no desenho da planta; **parametro** = numero que resume desempenho ou propriedade do equipamento ou do fluido.

---

## 2. Classificacao das variaveis

### 2.1 Por natureza

**Propriedade intensiva** (ou intensiva): nao depende da **quantidade** de materia que voce tem. Se voce divide a amostra ao meio, a intensiva permanece igual (na pratica, em condicoes uniformes). Exemplos: temperatura `T`, pressao `P`, pH, composicao (fracao molar ou massica), densidade `rho`.

**Propriedade extensiva** (ou extensiva): **depende** da quantidade. Se voce dobra a massa, a extensiva tende a dobrar (em sistemas simples). Exemplos: massa, volume total, vazao (volumetrica ou massica), energia.

**Intuicao:** intensiva descreve "como esta" em cada ponto; extensiva descreve "quanto ha" no fluxo ou no acumulo.

### 2.2 Por funcao no controle

**Malha de controle** e o conjunto sensor + controlador + atuador que tenta manter algo estavel.

- **Variavel manipulada (MV)** (*manipulated variable*): e o que o operador ou o controlador **muda de proposito** para influenciar o processo. Exemplo: abertura de valvula, rotacao de bomba, vazao de uma corrente de alimentacao.

- **Variavel controlada (CV)** (*controlled variable*): e o que queremos **manter** em um valor desejado. Exemplo: temperatura do digestor em `35` `degC`.

- **Variavel perturbacao (DV)** (*disturbance variable*): muda **sozinha** (clima, composicao da carga, falha upstream) e **perturba** o processo; o controle tenta compensar.

- **Set-point (SP)**: valor **desejado** da variavel controlada (o "alvo" do controlador).

### 2.3 Por fase do projeto

- **Variavel de processo (operacao):** descricao dinamica do funcionamento (medir, controlar, manipular).

- **Variavel de projeto (design/engenharia):** escolhas de tamanho e especificacao fixadas no projeto.

- **Parametro de equipamento:** numeros de desempenho ou propriedade associados a equipamento ou modelo.

---

## 3. Tabela completa de variaveis do projeto de biogas

Valores abaixo seguem a **base** do estudo de codigestao (ex.: `Q_tot = 100` `m3/dia`, `TRH = 20` `dias`, etc.). O simbolo `degC` significa grau Celsius. `Nm3` significa metro cubico normalizado (referencia padrao para gas). `ppm` significa partes por milhao. `ST` significa solidos totais; `SV` significa solidos volateis (materia organica biodegradavel na pratica de projeto). `COV` significa carga organica volumetrica (kg de SV por m3 de reator por dia).

### 3.1 Variaveis de processo

| Variavel | Simbolo | Valor nominal | Unidade | Tipo (CV/MV/DV) | Onde | Faixa aceitavel | Mini-resumo |
|----------|---------|---------------|---------|-----------------|------|-----------------|-------------|
| Temperatura do digestor | `T_dig` | `35` | `degC` | CV | Digestor `D-101` | `33`-`37` | Afeta atividade microbiana |
| Temperatura de entrada | `T_in` | `20` | `degC` | DV | Alimentacao | `15`-`30` | Depende do clima |
| pH do digestor | `pH` | `7.0` | adimensional | CV | `D-101` | `6.8`-`7.4` | Metanogenicas morrem fora da faixa |
| Vazao total alimentacao | `Q_tot` | `100` | `m3/dia` | MV | `P-101` | `80`-`120` | Base de calculo |
| Vazao de lodo | `Q_L` | `50` | `m3/dia` | MV | Corrente `101` | ajustavel | `50%` do total |
| Vazao de vinhaca | `Q_V` | `30` | `m3/dia` | MV | Corrente `102` | ajustavel | `30%` do total |
| Vazao de residuo | `Q_R` | `20` | `m3/dia` | MV | Corrente `103` | ajustavel | `20%` do total |
| Pressao do headspace | `P_head` | `~1.02` | `atm` | CV | `D-101` topo | `1.0`-`1.05` | Leve sobrepressao |
| Nivel do digestor | `L_dig` | `80` | `%` | CV | `D-101` | `70`-`90` | Garante volume util |
| Composicao SV entrada | `SV_in` | `5116` | `kg/dia` | DV | Mistura | variavel | Depende dos substratos |
| Relacao C/N | `CN` | `24.6` | adimensional | DV (resultado) | Mistura | `20`-`30` | Equilibrio nutricional |
| Producao de biogas | `Q_bg` | `1688` | `Nm3/dia` | resultado | `D-101` | variavel | Depende de `eta_SV` e `Y_bg` |
| Teor de CH4 | `y_CH4` | `62` | `%` | resultado | Biogas | `55`-`70` | Componente util |
| Concentracao de H2S | `[H2S]` | `<500` | `ppm` | DV | Biogas | `<200` desejavel | Corrosivo |
| COV | `COV` | `2.56` | `kgSV/m3.dia` | resultado | `D-101` | `1`-`4` | Carga do reator |

**Nota:** `Q_L + Q_V + Q_R` deve ser consistente com `Q_tot` na operacao (conservacao de volume para liquidos incompressiveis na aproximacao usada).

### 3.2 Variaveis de projeto (design)

| Variavel | Simbolo | Valor | Unidade | Equipamento | Como foi definida | Mini-resumo |
|----------|---------|-------|---------|-------------|-------------------|-------------|
| Volume util do digestor | `V_dig` | `2000` | `m3` | `D-101` | `V = Q * TRH` | `TRH = 20` `dias` x `100` `m3/dia` |
| Diametro do digestor | `D_dig` | `~12` | `m` | `D-101` | geometria `H/D` entre `1.5` e `2` | Cilindro vertical |
| Altura do digestor | `H_dig` | `~18` | `m` | `D-101` | `H/D ~ 1.5` | Inclui headspace |
| Espessura parede | `e_dig` | a calcular | `mm` | `D-101` | pressao interna + corrosao | `ASME VIII` |
| Volume tanque mistura | `V_TQ` | `~50` | `m3` | `TQ-101` | `0.5 * Q_tot` (`12` `h` retencao) | Pre-homogeneizacao |
| Area trocador calor | `A_TC` | a calcular | `m2` | `TC-101` | `Q = U * A * LMTD` | Aquecer de `20` a `35` `degC` |
| Potencia bomba alimentacao | `W_P101` | a calcular | `kW` | `P-101` | `W = Q * dP / eta` | Vencer perda de carga |
| Potencia CHP | `W_CHP` | `~157` | `kW` | `MG-101` | `E_liq / 24` `h` | Capacidade nominal |
| Capacidade filtro-prensa | `Cap_FP` | `~100286` | `kg/dia` | `FP-101` | vazao digestato | Desaguar a `25%` ST |
| TRH | `theta` | `20` | `dias` | `D-101` | premissa | Tempo de residencia |

**TRH** (*hydraulic retention time*, tempo de retencao hidraulico) e o tempo medio aproximado que o substrato permanece no digestor para a vazao e o volume uteis adotados.

### 3.3 Parametros de equipamento

| Parametro | Simbolo | Valor | Unidade | Equipamento | Fonte | Mini-resumo |
|-----------|---------|-------|---------|-------------|-------|-------------|
| Eficiencia remocao SV | `eta_SV` | `55` | `%` | `D-101` | UFPR `2024` | Desempenho biologico |
| Rendimento biogas | `Y_bg` | `0.60` | `Nm3/kgSV` | `D-101` | UFPR `2024` | Conversao |
| Eficiencia eletrica CHP | `eta_el` | `38` | `%` | `MG-101` | fabricante | Eletricidade / energia quimica |
| Eficiencia termica CHP | `eta_th` | `42` | `%` | `MG-101` | fabricante | Calor / energia quimica |
| Coeficiente global troca | `U` | `~1000` | `W/m2.K` | `TC-101` | agua/lodo | Troca termica |
| Eficiencia bomba | `eta_bomba` | `70` | `%` | `P-101` / `P-102` | tipico | Potencia util / consumida |
| PCI metano | `PCI` | `35.8` | `MJ/Nm3` | biogas | constante | Energia no combustivel |

**PCI** (*poder calorifico inferior*, *lower heating value*) e a energia liberada na combustao por unidade de volume (aqui referida ao metano em condicoes de referencia usadas no balanco).

---

## 4. Diagrama de relacao entre variaveis

Abaixo, **setas em texto** mostram **dependencia logica** de projeto (nao e equacao completa; e roteiro mental).

**Cadeia da alimentacao e da nutricao**

- `Q_tot` e proporcoes (`Q_L`, `Q_V`, `Q_R`) -> **massa** (e solidos) de entrada -> `ST` -> `SV` -> balanco elementar / composicao -> `CN`.

**Cadeia do biogas e da energia**

- `SV` + `eta_SV` -> **SV removido** -> `Y_bg` -> **producao de biogas** `Q_bg` -> fracao `y_CH4` -> uso de `PCI` (metano como referencia util) -> **energia quimica** disponivel -> `MG-101` com `eta_el` e `eta_th` -> **eletricidade** e **calor**.

**Cadeia do reator e da carga**

- `Q_tot` + `TRH` (`theta`) -> **volume util** `V_dig` -> com `SV_in` e `V_dig` -> **checagem** de `COV` (carga organica volumetrica).

**Cadeia termica**

- `T_in`, `T_dig` (set-point), **vazao** e **propriedades termicas** da mistura -> **taxa de aquecimento** necessaria (`Q` termico no sentido de potencia) -> **area** do trocador `A_TC` com `U` e `LMTD`.

---

## 5. Graus de liberdade

**Graus de liberdade** (em analise de processo) e o numero de **variaveis independentes** que precisamos **fixar** (escolher, especificar, medir) para que o problema fique **determinado**: ou seja, para que exista solucao unica (ou conjunto fechado de solucoes) compativel com as **equacoes** do modelo.

**Ideia simples:** se voce tem mais incognitas do que equacoes, falta informacao; se voce fixa demais, pode haver contradicao.

Forma generica:

`graus de liberdade = (numero de variaveis independentes) - (numero de equacoes independentes)`

Para o **digestor**, um conjunto tipico de variaveis de interesse inclui: `Q` (vazao), `T` (temperatura), `P` (pressao), **composicao** (incluindo `SV`, umidade, `CN`), `TRH`, e parametros como `eta_SV` e `Y_bg`.

As **equacoes** costumam vir de:

- **balanco de massa** (total e, se necessario, por componente);
- **balanco de energia** (temperatura, aquecimento, perdas);
- **cinetica / rendimento** (ligacao entre remocao de `SV` e producao de biogas).

Sem listar todas as equacoes explicitamente neste documento, a mensagem central e: **cada premissa** (`theta`, `eta_SV`, `Y_bg`, composicao de entrada, etc.) **consome graus de liberdade** ou **fecha** um balanco. Em Projetos II, o objetivo e sempre perguntar: *o que e dado, o que e calculado, o que e assumido?*

---

## 6. Confiabilidade e referencias

**Nivel de confiabilidade B (ordem de grandeza / estudo de viabilidade):** numeros de tabelas refletem **premissas de projeto**, dados de **literatura** ou **catalogo**, e **estimativas** tipicas. Nao substituem **ensaio piloto**, **caracterizacao** sistematica dos substratos locais nem **folha de dados** do fabricante. Sempre registrar **fonte** e **ano** quando usar coeficientes.

**Referencias academicas sugeridas (citacao padrao):**

- Towler, G.; Sinnott, R. **Chemical Engineering Design: Principles, Practice and Economics of Plant and Process Design**. 2. ed. Elsevier, 2012. (Metodologia de projeto, balancos, especificacao de equipamentos.)

- Moran, M. J. et al. **Fundamentos de Termodinamica para Engenharia**. (Ou edicao original em ingles *Fundamentals of Engineering Thermodynamics*, Wiley.) Livro-texto classico para balanco de energia e definicoes de eficiencia. Use a edicao adotada na biblioteca da UFMS; aqui: Moran, 2015 ou edicao equivalente.

- Green, D. W.; Perry, R. H. **Perry's Chemical Engineers' Handbook**. 9. ed. McGraw-Hill, 2018 (ou edicao disponivel). Consulta para propriedades, trocadores, bombas, correlacoes e ordens de grandeza.

**Referencias do caso (parametros biologicos):** valores `eta_SV`, `Y_bg` e nota "UFPR `2024`" indicam **estudo ou relatorio** usado como base no trabalho; em documento formal, trocar pela **referencia bibliografica completa** (autor, titulo, instituicao, ano, paginas).

---

*Documento didatico para Projetos Industriais II - codigestao anaerobia e biogas.*
