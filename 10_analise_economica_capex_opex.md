# Analise economica simplificada: CAPEX e OPEX (biogas / codigestao)

## 1. Introducao

**Definicao (CAPEX, Capital Expenditure):** Dinheiro gasto para **construir** e **instalar** a planta: equipamentos, obras civis, montagem, comissionamento. E **investimento fixo** que aparece no **ano zero** (ou ao longo da obra), nao e "conta de luz" mensal.

**Definicao (OPEX, Operational Expenditure):** Custos para **operar** a planta **a cada ano**: mao de obra, reagentes, energia comprada, manutencao, descarte, seguros, etc.

**Intuicao:** CAPEX e o **preco do carro**; OPEX e **combustivel, seguro e revisao**. Um projeto pode ter CAPEX alto e OPEX baixo, ou o contrario; por isso comparam-se **fluxos ao longo do tempo** (receita anual menos OPEX, desconto, payback, VPL).

**Referencias:** Towler & Sinnott (2012); Peters, M.S.; Timmerhaus, K.D.; West, R.E. (*Plant Design and Economics*); Blank, L.T.; Tarquin, A.J. (2010) (*Engenharia Economica*).

---

## 2. CAPEX - investimento fixo

### 2.1 Custo dos equipamentos (FOB)

**Intuicao:** FOB (*Free On Board*, a bordo no porto de origem) aqui e usado no sentido de **preco de equipamento** antes de frete, impostos e instalacao completa; na pratica brasileira misturam-se ICMS, instalacao e **fator de Lang**.

| Tag | Equipamento | Dimensao | Custo FOB estimado (R$) | Referencia |
|---|---|---|---|---|
| TQ-101 | Tanque mistura | 60 m3 | 80.000 | Estimativa |
| P-101 | Bomba cavidade progressiva | 0.75 kW | 15.000 | Catalogo |
| TC-101 | Trocador espiral | 3.1 m2 | 50.000 | Estimativa |
| D-101 | Digestor | 2300 m3 | 2.500.000 | Estimativa (concreto + revestimento) |
| P-102 | Bomba digestato | 0.75 kW | 15.000 | Catalogo |
| FP-101 | Filtro-prensa | 100 m2 | 300.000 | Catalogo |
| MG-101 | Motor-gerador | 200 kW | 600.000 | Fabricante |
| TQ-102 | Gasometro | 420 Nm3 | 150.000 | Estimativa |
| DS-101 | Dessulfurizador | 3.5 m3 | 40.000 | Estimativa |
| TQ-103 | Tanque NaOH | 2 m3 | 5.000 | Catalogo |
| - | Tubulacao, valvulas, instrumentacao | - | 400.000 | Estimativa |
| - | Eletrica e automacao | - | 200.000 | Estimativa |
| **TOTAL FOB** | - | - | **4.355.000** | - |

### 2.2 Fator de Lang

**Intuicao:** Instalar uma planta custa **varias vezes** o preco "de lista" dos equipamentos: tubos, fundacoes, pintura, mao de obra de montagem, engenharia.

**Formula:**

`I_instalado = C_FOB * F_Lang`

Para plantas de processamento **solido-liquido**, ordem de grandeza citada em Towler & Sinnott: `F_Lang ~ 3.6`.

**Conta:**

`I_instalado = 4.355.000 * 3.6 = 15.678.000` `R$`

### 2.3 Capital de giro

**Intuicao:** Mesmo com a obra pronta, e preciso **caixa** para comprar insumos e pagar contas ate o fluxo se estabilizar.

**Premissa:** `15%` do investimento fixo instalado.

`Capital_giro = 0.15 * 15.678.000 = 2.351.700` `R$`

(Arredondamento usual em relatorios: `~2.352.000` `R$`.)

### 2.4 Investimento total (CAPEX)

`CAPEX = I_instalado + Capital_giro = 15.678.000 + 2.352.000 = 18.030.000` `R$` (ordem de grandeza)

---

## 3. OPEX - custo operacional anual

| Item | Valor | Unidade | Custo anual (R$/ano) | Como calculou |
|---|---|---|---|---|
| Mao de obra (3 operadores + 1 supervisor) | 4 | pessoas | 480.000 | `4 * 10.000 * 12` |
| Eletricidade comprada | 0 | kWh/ano | 0 | Premissa: autossuficiente |
| NaOH | 100 kg/dia | kg/ano | 146.000 | `36500 kg/ano * R$ 4/kg` |
| Carvao ativado | 16 kg/dia | kg/ano | 87.600 | `5840 kg/ano * R$ 15/kg` |
| Agua industrial | 2.6 m3/dia | m3/ano | 9.490 | `949 m3/ano * R$ 10/m3` |
| Manutencao | 3% de I_instalado | - | 470.340 | `0.03 * 15.678.000` |
| Descarte digestato | 3686 kg ST/dia | kg ST/ano | 403.377 | `1.345.390 kg ST/ano * R$ 0,30/kg` |
| Seguro e impostos | 2% de I_instalado | - | 313.560 | `0.02 * 15.678.000` |
| **TOTAL OPEX** | - | - | **~1.910.367** | - |

**Nota:** Custos sao **ordens de grandeza**; tarifas reais de energia, reagentes e destino de lodo mudam por estado e contrato.

---

## 4. Receitas anuais

| Receita | Quantidade | Preco | Valor anual (R$/ano) |
|---|---|---|---|
| Venda eletricidade | `2712 kWh/dia * 365 = 989.880` kWh/ano | R$ 0,75/kWh | 742.410 |
| Biofertilizante (torta) | `14.742 kg/dia * 365` | R$ 0,05/kg | 268.542 |
| Creditos de carbono (estimativa) | ver nota abaixo | - | 51.235 |
| **TOTAL RECEITAS** | - | - | **~1.062.187** |

**Nota creditos:** estimativa do tipo `~1047` `Nm3` `CH4/dia * 365 * fator tCO2eq/Nm3 * R$/tCO2`; fatores exatos dependem de metodologia (MRV) e mercado.

---

## 5. Fluxo de caixa simplificado

### 5.1 Premissas

- **Vida util:** `20` anos  
- **Taxa de desconto:** `i = 10%` a.a.  
- **Depreciacao linear:** `20` anos (contabil; nao substitui fluxo de caixa fiscal real)  
- **Ano 0:** saida de CAPEX  
- **Anos 1 a 20:** `Receitas - OPEX` por ano  

### 5.2 Resultado operacional anual (cenario base de precos)

**Formula:**

`Resultado = Receitas - OPEX`

**Conta:**

`Resultado = 1.062.187 - 1.910.367 = -848.180` `R$/ano`

### 5.3 Analise

**ATENCAO:** Com as premissas atuais, o projeto **nao** fecha positivo apenas com venda de eletricidade, torta e credito de carbono **modesto**. Isso e **comum** em biogas em ETE no Brasil quando se olha so "mercado de energia".

A viabilidade estrategica costuma depender de:

1. **Tarifa** de eletricidade mais alta (ou contrato especifico).  
2. **Creditos de carbono** mais expressivos e verificaveis.  
3. **Custo evitado** de destino alternativo do lodo (ex.: aterro, `R$ 200-500/t`).  
4. **Gate fee** (taxa por recebimento de residuo organico).  
5. **Subsidios** ou financiamento de longo prazo (linhas BNDES/FINEP, etc.).  

### 5.4 Cenario com custo evitado (aterro) e tarifa maior

**Premissa ilustrativa:** custo evitado de aterro para lodo `R$ 300/t` **ST** (converter unidades com cuidado no projeto real).

Se se contabilizar economia **analogamente** a linha de descarte ja usada na tabela (`R$ 0,30/kg ST` equivale a `R$ 300/t` ST):

`Economia = 3686 kg ST/dia * 365 * R$ 0,30/kg = 403.377` `R$/ano`

`Receita_total_ajustada = 1.062.187 + 403.377 = 1.465.564` `R$/ano`

`Resultado = 1.465.564 - 1.910.367 = -444.803` `R$/ano` (ainda negativo nesta estrutura de OPEX)

**Se tarifa eletricidade = R$ 1,50/kWh:**

`R_eletr = 989.880 * 1,50 = 1.484.820` `R$/ano`

`Receita_total = 1.484.820 + 268.542 + 51.235 + 403.377 = 2.207.974` `R$/ano`

`Resultado = 2.207.974 - 1.910.367 = +297.607` `R$/ano`

**Payback simples (sobre CAPEX total):**

`PB = 18.030.000 / 297.607 = 60.6` anos (ainda **inviavel** como investimento puramente privado sem outras receitas)

### 5.5 Indicadores economicos (cenario tarifa R$ 1,50/kWh + custo evitado)

**Fator de valor presente de anuidade** (serie uniforme de `n=20`, `i=10%`):

`PVFA = (1 - (1+i)^(-n)) / i = (1 - 1.1^(-20)) / 0.1 = 8.5136`

**VPL:**

`VPL = -CAPEX + Resultado_anual * PVFA`  
`VPL = -18.030.000 + 297.607 * 8.5136 = -18.030.000 + 2.533.709 = -15.496.291` `R$`

**Interpretacao:** VPL **negativo**: o projeto **nao** recupera o investimento a `10%` a.a. com esse fluxo sozinho.

**TIR:** **negativa** neste cenario simplificado (nao ha ano com fluxo positivo suficiente para pagar o CAPEX no sentido classico de TIR > i).

**Payback simples:** `> 60` anos.

### 5.6 Discussao honesta

Usinas de biogas em **ETE** frequentemente sao justificadas como:

- **Obrigacao** regulatoria de tratamento e destinacao adequada de lodo;  
- **Politica publica** ou financiamento subsidiado;  
- **Valor** de credito de carbono e **evitacao** de emissoes;  
- **Escala** maior (mais biogas por real de overhead fixo).

Na escala **conceitual** deste estudo, o arranjo funciona melhor como **tratamento de residuos com recuperacao energetica** do que como negocio **autossuficiente** apenas com venda de eletricidade a precos medios.

---

## 6. Tabela resumo

| Indicador | Valor |
|---|---|
| CAPEX total | R$ 18.030.000 |
| OPEX anual | R$ 1.910.367 |
| Receita anual (base) | R$ 1.062.187 |
| Resultado anual (base) | R$ -848.180 |
| Resultado com tarifa R$ 1,50/kWh + custo evitado | R$ +297.607 |
| Payback (melhor cenario da tabela) | > 60 anos |
| VPL (10%, 20 anos, mesmo cenario) | ~ -15,5 milhoes R$ |

---

## 7. Confiabilidade

**Nivel C:** precos FOB e fatores de Lang sao **ordens de grandeza**; insumos e tarifas variam; o fluxo **nao** inclui todas as linhas fiscais e financeiras (juros na obra, CAPEX parcelado, working capital detalhado).

**Referencias:** Towler & Sinnott (2012); Peters & Timmerhaus; Blank & Tarquin (2010).
