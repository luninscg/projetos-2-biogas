# Utilidades e eficiencia energetica - projeto biogas (codigestao)

## 1. Introducao

Em **engenharia quimica**, **utilidades** sao todos os **insumos de apoio** que o processo consome ou os **fluxos auxiliares** que ele precisa, **alem** das **materias-primas** e dos **produtos principais**.

Exemplos tipicos:

- **Agua** (industrial, de resfriamento, de selagem).
- **Vapor** ou **agua quente** (aquecimento).
- **Eletricidade** (motores, agitadores, instrumentacao).
- **Ar comprimido** (pneumatica, sopros, limpeza).
- **Produtos quimicos** (`NaOH`, adsorventes).
- **Combustivel** (quando nao ha autossuficiencia termica).

No projeto de **codigestao anaerobia** com **CHP** (*combined heat and power*, cogeracao), parte das utilidades pode ser **suprida internamente** pelo proprio biogas - o que muda o **balanco economico** e o **balanco energetico**.

**Referencias gerais:** Towler e Sinnott (2012); Chernicharo (2007) - *Biological Wastewater Treatment*; Metcalf & Eddy - *Wastewater Engineering*.

---

## 2. Balanco de utilidades

### 2.1 Agua quente (aquecimento do digestor)

- **Demanda termica**: `Q_demanda = 3680 MJ/dia`, equivalente a uma potencia media de ordem de `42.6 kW` (pois `1 dia = 86400 s` e `3680e6 J / 86400 s ~= 42.6 kW`).
- **Fonte**: **calor recuperado do CHP** com disponibilidade da ordem de `15739 MJ/dia` (valores do balanco do projeto).
- **Excedente**: `12059 MJ/dia` (diferenca entre calor disponivel do CHP e demanda de aquecimento do digestor, na linha de raciocinio adotada).
- **Conclusao**: **nao** e necessaria **caldeira externa** dedicada a esse aquecimento, desde que o **recuperador** e o **controle de prioridade** (digestor vs outros usos) estejam bem definidos na engenharia de detalhe.

### 2.2 Eletricidade

**Consumo interno estimado** (potencias e regime de `h/dia` sao **hipoteses de dimensionamento**; validar em lista de cargas final):

| Equipamento | Potencia (`kW`) | Horas/dia | Consumo (`kWh/dia`) |
|-------------|-----------------|-----------|----------------------|
| Agitador `TQ-101` | `30` | `24` | `720` |
| Bomba `P-101` | `0.75` | `24` | `18` |
| Bomba `P-102` | `0.75` | `24` | `18` |
| Agitador `D-101` | `15` | `24` | `360` |
| Filtro-prensa `FP-101` | `5` | `16` | `80` |
| Instrumentacao / iluminacao | `2` | `24` | `48` |
| **TOTAL** | - | - | **`~1244`** |

- **Geracao CHP**: `3956 kWh/dia` (valor de base do projeto).
- **Consumo total interno**: `~1244 kWh/dia` (inclui auxiliares listados; pode haver **margem** para partidas, `VFDs`, etc.).
- **Excedente eletrico liquido** (ordem de grandeza): `3956 - 1244 = 2712 kWh/dia`.

**Nota didatica:** Um valor antigo de planilha do tipo `198 kWh/dia` (`~5%` do CHP) tende a **subestimar** o consumo real quando se somam **agitadores grandes** e **regime continuo**. Por isso o detalhamento por equipamento e preferivel para **lista de cargas** e **contrato de energia**.

### 2.3 Agua de processo

- **Selagem de bombas**: `~0.5 m3/dia`.
- **Lavagem de filtro-prensa**: `~2 m3/dia`.
- **Diluicao `NaOH`**: `~0.1 m3/dia`.
- **Total**: `~2.6 m3/dia`.
- **Fonte**: **rede de agua industrial** (qualidade e disponibilidade a confirmar com fornecimento local).

### 2.4 `NaOH` (correcao de pH)

- **Cenario de referencia:** vinhaca entra com **pH** da ordem de `4.2` e a **mistura final** desejada na faixa `pH ~6.5-7` (valores de projeto; dependem de **alcalinidade** e **tamponamento** da mistura).
- **Consumo tipico em literatura de campo:** `0.5-2.0 kg NaOH/m3` de mistura (forte dependencia da **alcalinidade natural** e do **acumulo de `VFA`**).
- **Valor adotado neste documento:** `1.0 kg/m3` - para uma base de `100 m3/dia` de mistura, resulta `100 kg/dia` de **`NaOH` solido**, ou da ordem de `200 L/dia` de solucao `50%` (massa especifica da solucao comercial ~ `1.52 kg/L` - refinar na especificacao de compra).

### 2.5 Ar comprimido

- **Instrumentacao pneumatica**: `~5 Nm3/h` (*normal metro cubico por hora*: referido a condicao padrao de referencia do fabricante).
- **Limpeza**: intermitente.
- **Compressor tipico**: da ordem de `1 kW` (confirmar curva de demanda e horas efectivas).

### 2.6 Carvao ativado (dessulfurizacao)

- **Consumo** depende da **concentracao de `H2S`** no biogas e da **capacidade** do adsorvente (ordem de grandeza frequentemente citada: `~150 g H2S/kg carvao`, **variavel** com umidade, leito, e fabricante).
- **Estimativa numerica:** se o biogas tem `1000 ppm` `H2S` e o fluxo molar/volumetrico do projeto implicar `~2.4 kg H2S/dia`, entao `2.4 / 0.15 ~= 16 kg` de **carvao consumido por dia** em regime de **saturacao** aproximada (na pratica, troca em **margem** antes do breakthrough).
- **Troca do leito:** tipicamente a cada `6-12 meses` em operacao continua, dependendo do **projeto do leito** e da **eficiencia** exigida a jusante do `MG-101`.

---

## 3. Eficiencia energetica global

### 3.1 Definicao

Define-se **eficiencia energetica global** `eta_global` como a razao entre a **energia util produzida** (eletricidade liquida + calor util efetivamente usado no processo) e a **energia quimica** estimada na **materia organica** de entrada:

`eta_global = (Energia util produzida) / (Energia quimica na materia organica de entrada)`.

A **energia quimica** na entrada e aqui **aproximada** pela correlacao **DQO-energia** (ver Chernicharo, 2007): trata-se de **hipotese** com incerteza; resultados devem ser revisados com **analises laboratoriais** e **BMP** (*biochemical methane potential*) quando possivel.

### 3.2 Calculo (base do projeto)

**Passo 1 - DQO da mistura (`kg DQO/dia`):**

Contribuicoes ilustrativas (fracoes e vazoes conforme planilha de base):

`(51000*30/1000 + 30270*30/1000 + 21000*150/1000) = 1530 + 908 + 3150 = 5588` `kg DQO/dia`.

**Passo 2 - Energia associada a DQO:**

Fator de referencia: `~13.9 MJ/kg DQO` (Chernicharo, 2007).

`E_org = 5588 * 13.9 = 77673` `MJ/dia`.

**Passo 3 - Energia util produzida:**

- **Eletricidade liquida:** `2712 kWh/dia * 3.6 MJ/kWh = 9763` `MJ/dia`.
- **Calor util usado** no digestor: `3680` `MJ/dia`.
- **Total util:** `9763 + 3680 = 13443` `MJ/dia`.

**Passo 4 - Eficiencia global:**

`eta_global = 13443 / 77673 = 0.173` - ou **`17.3%`**.

**Checagem de ordem de grandeza:** `E_org` ~ `77 GJ/dia`; util ~ `13 GJ/dia`; razao ~ `1/6`, coerente com `~17%`.

### 3.3 Comparacao

Para **digestao mesofilica** em escala real, valores globais na literatura de engenharia costumam cair muitas vezes na faixa **`15-25%`** quando se usa uma definicao semelhante (entrada organica vs saidas uteis eletricas+termicas). O valor **`17.3%`** e **plausivel**, mas permanece **Nivel B-** por depender do fator DQO-energia e da estabilidade da mistura.

### 3.4 Tabela de fluxo energetico

Valores em `MJ/dia`; percentuais referidos a `E_org = 77673` `MJ/dia` (`100%`). Algumas parcelas sao **modeladas** no balanco global do projeto (arredondamentos na tabela).

| Parcela | Valor (`MJ/dia`) | `%` da `E_org` |
|---------|------------------|----------------|
| Energia na materia organica | `77673` | `100.0` |
| Nao convertido (SV residual) | `~40198` | `51.8` |
| Biogas (PCI) | `37474` | `48.2` |
| Eletricidade bruta | `14240` | `18.3` |
| Calor CHP | `15739` | `20.3` |
| Perdas CHP | `7495` | `9.6` |
| Eletricidade consumida | `4479` | `5.8` |
| Eletricidade exportada | `9761` | `12.6` |
| Calor para digestor | `3680` | `4.7` |
| Excedente termico | `12059` | `15.5` |

**Leitura fisica:** grande parte da energia da biomassa **nao** vira eletricidade - vira **calor residual**, **biomassa bacteriana**, e **metano** com **perdas** de conversao no CHP. Isso **nao viola** conservacao de energia: a soma das parcelas do balanco completo (incluindo perdas para ambiente) deve fechar com a energia de entrada + entradas auxiliares menores.

---

## 4. Resumo de utilidades

| Utilidade | Consumo | Unidade | Fonte |
|-----------|---------|---------|-------|
| Agua quente | `3680` | `MJ/dia` | CHP (autossuficiente para esta demanda) |
| Eletricidade | `1244` | `kWh/dia` | CHP (sobra `~2712` `kWh/dia` na linha adotada) |
| Agua industrial | `2.6` | `m3/dia` | Rede |
| `NaOH` solido | `100` | `kg/dia` | Compra |
| Ar comprimido | `5` | `Nm3/h` | Compressor local |
| Carvao ativado | `16` | `kg/dia` | Compra (troca periodica do leito) |

---

## 5. Confiabilidade

**Nivel B-**: numeros coerentes com balanco preliminar e literatura de **DQO**, **CHP** e **utilidades**, sujeitos a:

- variacao da **DQO** e da **taxa de degradacao**;
- **perfil horario** real de cargas eletricas;
- **eficiencia** real do recuperador de calor e **perdas** termicas do digestor.

**Referencias:** Towler e Sinnott (2012); Chernicharo (2007); Metcalf & Eddy.
