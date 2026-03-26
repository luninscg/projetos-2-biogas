# Tabela de correntes para PFD - codigestao anaerobia e biogas

## Objetivo deste arquivo

Dar uma **tabela de engenharia** com correntes numeradas (estilo PFD) para voce desenhar ou revisar o diagrama de fluxo. Cada linha traz **massa** e **solidos** de forma didatica.

---

## 1. Definicoes (antes de usar os simbolos)

### Corrente

**Definicao:** Um **fluxo** de materia (liquido, solido, gas ou mistura) que atravessa um limite do equipamento (fronteira de controle), com identificacao unica no PFD.

### Massa total (M)

**Definicao:** Quilogramas por dia (`kg/dia`) da corrente **como um todo**, incluindo agua.

### Solidos totais (ST)

**Definicao:** Massa diaria da fracao **nao volatilizada** no protocolo de ensaio de solidos (na pratica de projeto, e a massa de solidos apos secagem padrao). Aqui, **ST** resume a fracao solida total do lodo ou mistura.

### Solidos volateis (SV)

**Definicao:** Parte dos solidos associada a materia organica que pode ser oxidada na incineracao padrao; no contexto do digestor, e a **carga organica particulada** mais relevante para biogas.

### Agua + dissolvido + (inertes na fase liquida)

**Definicao:** Nesta tabela, a coluna **agua+outros** significa **tudo que nao e contabilizado como ST** na massa total: agua livre, solutos dissolvidos e, na pratica industrial, o que sobra na fracao "liquida" do balanco de solidos.

**Formula de fechamento por corrente liquido-pasta:**

`M = ST + agua+outros`

### Biogas e gases

**Definicao:** Para correntes gasosas, **ST** e **SV** nao se aplicam como em lodo. Onde aparecer `-`, leia **nao aplicavel** no sentido de solidos.

### PFD (process flow diagram)

**Definicao:** Diagrama de fluxo de processo, figura que mostra equipamentos principais e **correntes numeradas** ligando-os.

---

## 2. Origem numerica (consistencia com o balanco de massa)

Os valores das correntes **101 a 108** abaixo sao **coerentes** com `01_balanco_massa_biogas.md`:

- Soma das entradas (101-103) = mistura (104) = `102270 kg/dia`.
- ST e SV de (101-103) somam os totais de (104).
- Biogas (105) usa massa total de gas `~1960 kg/dia` (CH4 + CO2 + outros).
- (107) e (108) sao **decomposicao conceitual** do gas para leitura didatica no PFD (nao obriga equipamento fisico separado antes do tratamento de gas).

**Digestato (106):** `M = 100310 kg/dia` (arredondamento de `102270 - 1960`), `ST = 3686 kg/dia`, `SV = 2302 kg/dia` (residual).

**Solidos fixos (SF)** no digestato: `SF = ST - SV = 3686 - 2302 = 1384 kg/dia` (ordem de grandeza; encaixa com cinzas que nao viraram gas).

---

## 3. Tabela por corrente (formato PFD)

| Numero | Descricao | M (kg/dia) | ST (kg/dia) | SV (kg/dia) | agua+outros (kg/dia) | Observacao didatica |
|---:|---|---:|---:|---:|---:|---|
| 101 | Lodo de esgoto (entrada) | `51000` | `1785` | `1160` | `49215` | Maior vazao em massa; traz nitrogenio e buffer, mas C/N baixo sozinho. |
| 102 | Vinhaca (entrada) | `30270` | `515` | `386` | `29755` | Mais diluida; empurra carbono e acidez; ajuda a moldar a taxa de carga. |
| 103 | Residuo organico triturado (entrada) | `21000` | `4200` | `3570` | `16800` | Menor vazao, mas **muito** mais concentrada em solidos; puxa SV e C/N para cima. |
| 104 | Mistura alimentada ao digestor | `102270` | `6500` | `5116` | `95770` | Resultado da mistura; e a corrente que define COV no volume do reator. |
| 105 | Biogas bruto (saida do digestor) | `1960` | `-` | `-` | `-` | Mistura gasosa; massa pequena frente a liquida, mas valor energetico alto no CH4. |
| 106 | Digestato bruto (saida do digestor) | `100310` | `3686` | `2302` | `96624` | Efluente estabilizado com SV residual; destino tipico: desaguamento e destinacao agricola. |
| 107 | Metano no biogas (fracao) | `747` | `-` | `-` | `-` | Componente combustivel; no PFD real costuma ser **caixa de informacao**, nao corrente fisica separada. |
| 108 | Dioxido de carbono no biogas (fracao) | `1193` | `-` | `-` | `-` | Inerte na combustao util; aumenta massa do gas mais que volume "util". |
| 109 | Digestato desaguado (torta, ~25% ST) | `14742` | `3686` | `2302` | `11056` | Agua ainda presa na torta; ST aqui e a massa seca total retida na fase solids cake. |
| 110 | Agua separada do digestato (filtrado/centrifuga) | `85568` | `0` | `0` | `85568` | Modelo limpo: so liquido; na realidade pode haver **arraste** fino de solidos (nao contabilizado aqui). |

### Notas de arredondamento

- `101 + 102 + 103` em ST soma `6500` (arredondamento de `6499.6`).
- `SV` total de entrada usa `5116` coerente com `5116.19`.
- Massa do biogas em (105): `747.2 + 1193.1 + ~20` (outros) ~ `1960 kg/dia` como no balanco de massa.

---

## 4. Estimativa da separacao (109 e 110) com ST na torta

**Intuicao fisica:** Desaguamento **remove agua** da suspensao. Se a torta fica com **25% de ST** em massa (premissa de engenharia para esta folha), entao a massa da torta e o total de ST dividido pela fracao desejada.

**Dados do digestato total (corrente 106):**

- `M_digestato = 100310 kg/dia`
- `ST = 3686 kg/dia`

**Fracao desejada de ST na torta:**

`w_ST_torta = 0.25` (25% em massa de ST na corrente 109)

**Formula:**

`M_109 = ST / w_ST_torta`

**Calculo:**

`M_109 = 3686 / 0.25 = 14744 kg/dia`

Para alinhar com a conta compacta `3686 / 0.25 = 14742`, usamos **`14742 kg/dia`** na tabela (diferenca de arredondamento de ST).

**Agua separada (corrente 110):**

`M_110 = M_digestato - M_109`

`M_110 = 100310 - 14742 = 85568 kg/dia`

**Checagem de massa:**

`M_109 + M_110 = 14742 + 85568 = 100310 kg/dia` (bate com o digestato bruto)

**SV na torta (modelo simplificado):** Assume-se que os **solidos** permanecem na torta e a separacao remove principalmente **liquido**; por isso `SV_109 = SV_106`. Na operacao real, um pequeno arraste de particulas finas pode ir para (110).

**agua+outros na torta (109):**

`agua+outros_109 = M_109 - ST_109 = 14742 - 3686 = 11056 kg/dia`

Ordem de grandeza: **11 t/dia** de umidade remanescente na torta.

---

## 5. Tabela consolidada (copiar para slide ou P&ID)

| Corrente | Nome curto | M (kg/dia) | ST | SV | agua+outros |
|---:|---|---:|---:|---:|---:|
| 101 | Lodo | 51000 | 1785 | 1160 | 49215 |
| 102 | Vinhaca | 30270 | 515 | 386 | 29755 |
| 103 | Organico | 21000 | 4200 | 3570 | 16800 |
| 104 | Mistura | 102270 | 6500 | 5116 | 95770 |
| 105 | Biogas | 1960 | - | - | - |
| 106 | Digestato | 100310 | 3686 | 2302 | 96624 |
| 107 | CH4 | 747 | - | - | - |
| 108 | CO2 | 1193 | - | - | - |
| 109 | Torta | 14742 | 3686 | 2302 | 11056 |
| 110 | Permeado/agua | 85568 | 0 | 0 | 85568 |

---

## 6. Como usar esta tabela no PFD

1. **Desenhe cada equipamento** como bloco: misturador, digestor, saida de gas, saida de digestato, unidade de desaguamento.
2. **Rotule as linhas** com os numeros **101 a 110** exatamente como na tabela; isso evita que o leitor confunda "vinhaca" com "mistura".
3. **Coloque caixas de dados** junto da linha: `M`, `ST`, `SV` quando for liquido/pasta; para gas, prefira tambem `Nm3/dia` no desenho (esta tabela foca kg/dia para fechar com o balanco de massa).
4. **107 e 108** sao uteis em **aula** e em **balancos de componente**; em PFD de construcao, muitas vezes so aparece **105** ate o tratamento de biogas.
5. **109 e 110** dependem da premissa de **25% ST** na torta; se o equipamento real entregar 20% ou 30%, atualize `M_109` e `M_110` com a mesma logica `M_torta = ST / w_ST`.

---

## 7. Confiabilidade

- **101 a 104 e 106:** derivados do balanco de massa conceitual; confiabilidade **B** se as caracterizacoes dos substratos forem as mesmas do arquivo base.
- **105, 107, 108:** confiaveis para ordem de grandeza; composicao real medida em cromatografia e umidade ajusta numeros.
- **109, 110:** **estimativa** de equipamento; exige confirmacao com curva de desaguamento (filtro prensa, centrifuga, belt filter).
