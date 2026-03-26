# Entrega 2 - Dimensionamento, Materiais e Utilidades

**Disciplina:** (preencher)  
**Curso / periodo:** (preencher)  
**Equipe:** (preencher nomes e RAs)  
**Data de entrega:** `20/05/2026`  
**Peso na nota:** `25%`

---

## Sumario

1. Introducao  
2. Lista de equipamentos e PFD  
3. Dimensionamento dos equipamentos  
4. Selecao de materiais  
5. Utilidades e eficiencia energetica  
6. Verificacoes  
7. Conclusao  
Referencias  

---

## 1. Introducao

**Escopo desta entrega:** consolidar o **dimensionamento** dos equipamentos principais, a **selecao de materiais** face a corrosao e abrasao, e o **balanco de utilidades** (agua quente, eletricidade, agua industrial, `NaOH`, ar comprimido, carvao ativado no `DS-101`), com checagem de coerencia com o balanco de massa e de energia.

**Definicao (para leigo):** `dimensionamento` e calcular "tamanho" e potencia (volume do digestor, area do trocador, motor da bomba) a partir de vazoes e cargas termicas; `utilidades` sao tudo que o processo consome alem da materia-prima (agua, energia, ar, quimicos de apoio).

**Fontes de detalhamento no repositorio:** `04b_pfd_formal_biogas.md` (PFD e correntes), `06_dimensionamento_equipamentos.md`, `07_materiais_construcao.md`, `08_utilidades_eficiencia.md`.

---

## 2. Lista de equipamentos e PFD

O **PFD formal** lista as tags abaixo e as **correntes** `101` a `117` (massas, fases, temperaturas). O desenho em texto monoespacado no arquivo `04b_pfd_formal_biogas.md` mostra o fluxo: `TQ-101` -> `P-101` -> `TC-101` -> `D-101`; biogas `107` -> `TQ-102` -> `DS-101` -> `MG-101`; digestato `109` -> `P-102` -> `FP-101` -> torta `111` e filtrado `112`.

| Tag | Nome resumido |
|-----|----------------|
| `TQ-101` | Tanque de mistura |
| `P-101` | Bomba de alimentacao |
| `TC-101` | Trocador de calor (mistura) |
| `D-101` | Digestor CSTR |
| `P-102` | Bomba de digestato |
| `FP-101` | Filtro-prensa |
| `MG-101` | Motor-gerador CHP |
| `TQ-102` | Gasometro / buffer de biogas |
| `DS-101` | Dessulfurizador (`H2S`) |
| `TQ-103` | Tanque de `NaOH` |

**Leitura fisica:** o PFD e a "espinha dorsal" documental; esta entrega associa a cada tag numeros de tamanho e material.

---

## 3. Dimensionamento dos equipamentos

**Metodologia comum:** (1) definir funcao; (2) escolher **variavel de dimensionamento** (`V`, `A`, `Q`, `P`); (3) aplicar **formula** (conservacao de massa, energia ou correlacao); (4) **margem**; (5) **dimensao final** comercial ou construtiva.

### `TQ-101` - Tanque de mistura

- **Funcao:** homogeneizar lodo + vinhaca + residuo antes do digestor.  
- **Variavel:** volume util `V`.  
- **Formula:** `V_util = Q_tot * t_ret` com `Q_tot = 100 m3/dia` e `t_ret = 12 h` (`0.5 dia`).  
- **Calculo:** `V_util = 100 * 0.5 = 50 m3`; margem `20%` -> `V_total = 60 m3`.  
- **Geometria:** cilindro `H/D = 1` -> `D ~ 4.3 m`, `H ~ 4.3 m`.  
- **Potencia agitacao (ordem):** `~30 kW` (correlacao `~0.5 kW/m3` indicativa).  

### `P-101` - Bomba de alimentacao

- **Funcao:** enviar mistura ao `TC-101` vencendo perdas.  
- **Variavel:** vazao volumetrica `Q` e `dP`.  
- **Formula:** `W_hid = Q * dP`; `W_eixo = W_hid / eta`.  
- **Calculo:** `Q = 4.17 m3/h`; `dP ~ 2 bar` -> `W_hid ~ 0.23 kW`; `eta = 0.60` -> `~0.39 kW`; motor comercial `0.75 kW`.  
- **Margem:** embutida na escolha do motor padrao.  

### `TC-101` - Trocador de calor

- **Funcao:** aquecer mistura de `20 degC` a `35 degC`.  
- **Variavel:** area de troca `A`.  
- **Formula:** `Q = U * A * LMTD` (contracorrente).  
- **Calculo:** `Q = 6136 MJ/dia = 71.02 kW`; `LMTD ~ 37.0 K` com agua `80->50 degC`; `U = 800 W/(m2*K)` -> `A ~ 2.40 m2`; margem fouling `30%` -> **`A ~ 3.1 m2`**.  

### `D-101` - Digestor

- **Funcao:** digestao anaerobia mesofilica (`35 degC`), CSTR.  
- **Variavel:** volume util liquido `V_liq`.  
- **Formula:** `V_liq = Q_tot * TRH`.  
- **Calculo:** `V_liq = 100 * 20 = 2000 m3`; geometria `D = 12 m`, `H_liq ~ 18 m` (`H/D ~ 1.5`); `V_liq_real ~ 2036 m3` (aceitavel); `H_total ~ 21 m` com headspace.  
- **Margem conceitual:** `+15%` em volume total se integrar gas no mesmo casco (ver nota em `06_dimensionamento_equipamentos.md`).  
- **Agitacao:** `10` a `20 kW` (faixa `5-10 W/m3`).  

### `P-102` - Bomba de digestato

- **Funcao:** alimentar `FP-101`.  
- **Variavel:** `Q` a partir da massa `100286 kg/dia` e `rho ~ 1010 kg/m3`.  
- **Calculo:** `Q ~ 4.14 m3/h`; mesma logica de `dP` -> motor **`0.75 kW`**.  

### `FP-101` - Filtro-prensa

- **Funcao:** elevar ST da torta a `~25%`.  
- **Variavel:** area de filtracao e regime de batelada.  
- **Calculo:** `3` bateladas/dia, `~8 h` cada; massa por batelada `~33429 kg`; **area estimada `~100 m2`** (confirmar com fabricante).  

### `MG-101` - CHP

- **Funcao:** queimar biogas -> eletricidade + calor recuperado.  
- **Variavel:** potencia eletrica media liquida e grupo nominal.  
- **Calculo:** `3758 kWh/dia / 24 h = 156.6 kW` medio liquido -> referencia de projeto **`~157 kW`**; grupo nominal tipico **`~200 kW`**.  
- **Calor recuperavel:** `15739 MJ/dia` (`~182 kW` medio).  

### `TQ-102` - Gasometro

- **Funcao:** amortecer producao vs consumo de gas.  
- **Variavel:** volume de armazenamento `V_N`.  
- **Formula:** `V_N = Q_med * t_armazenar`.  
- **Calculo:** `1688 Nm3/dia` -> `70.3 Nm3/h`; `6 h` -> **`~422 Nm3`** (ordem `~420 m3`).  

### `DS-101` - Dessulfurizador

- **Funcao:** reduzir `H2S` antes do motor.  
- **Variavel:** volume de leito `V` com `EBCT`.  
- **Formula:** `V = Q * EBCT`.  
- **Calculo:** `Q = 70.3 Nm3/h`; `EBCT = 3 min` -> **`V ~ 3.5 m3`** de leito.  

### `TQ-103` - Tanque de `NaOH`

- **Funcao:** estoque de solucao para dosagem.  
- **Variavel:** volume util.  
- **Dimensao final:** **`1` a `2 m3`**, PEAD, reserva `7` a `14 dias` (calibrar com plano de dosagem).  

---

### Tabela resumo

| Tag | Equipamento | Dimensao principal | Potencia / servico | Material (resumo) |
|-----|-------------|--------------------|--------------------|-------------------|
| `TQ-101` | Tanque mistura | `V ~ 60 m3`, `D/H ~ 4.3 m` | `~30 kW` agitacao | Aco carbono + epoxi / PRFV |
| `P-101` | Bomba alimentacao | `~4.2 m3/h`, `dP ~ 2 bar` | `0.75 kW` | Fundido + rotor inox |
| `TC-101` | Trocador | `A ~ 3.1 m2` | `71 kW` termico (demanda lado mistura) | `316L` lado lodo; carbono agua |
| `D-101` | Digestor | `V_liq ~ 2000 m3`, `D 12 m`, `H_tot ~ 21 m` | `10-20 kW` mistura | A516 Gr.70 + epoxi; `316L` zona gas |
| `P-102` | Bomba digestato | `~4.1 m3/h` | `0.75 kW` | Inox `316L` |
| `FP-101` | Filtro-prensa | `~100 m2` (estimativa) | conforme OEM | PP + aco pintado |
| `MG-101` | CHP | pacote `~200 kW` nominal | `~157 kW` eletrico liquido medio | Pacote fabricante |
| `TQ-102` | Gasometro | `~420 m3` | - | EPDM / PVC |
| `DS-101` | Dessulfurizador | `V_leito ~ 3.5 m3` | - | Carbono + epoxi/PRFV |
| `TQ-103` | Tanque `NaOH` | `1-2 m3` | - | PEAD |

**Confiabilidade:** **Nivel B** (estudo de viabilidade); detalhe construtivo exige fornecedor e normas locais de pressao (`ASME VIII`).

---

## 4. Selecao de materiais

**Agentes de corrosao e desgaste no processo:**
- **pH acido** na vinhaca e na mistura antes da estabilizacao.  
- **`H2S`** no gas umido e dissolvido no liquido.  
- **Solidos abrasivos** no lodo e no digestato (bombas e prensa).  
- **`NaOH`** concentrado no estoque (`TQ-103`).  

**Materiais por equipamento (resumo alinhado a `07_materiais_construcao.md`):**

| Tag | Contato principal | Material / revestimento | Norma / nota |
|-----|-------------------|-------------------------|--------------|
| `TQ-101` | Mistura acida | Aco carbono + epoxi | ASTM chapas; revestimento compativel |
| `P-101` | Lodo abrasivo | Ferro fundido + rotor `316L` | ASTM inox |
| `TC-101` | Lodo / agua quente | Casco carbono, tubos `316L` | ASME VIII (vasos); ASTM inox |
| `D-101` | Liquido + headspace | A516 Gr.70 + epoxi; inox zona gas | ASME VIII; NACE orientativo p/ `H2S` |
| `P-102` | Digestato | `316L` | ASTM |
| `FP-101` | Digestato | Aco carbono + placas PP | - |
| `MG-101` | Biogas seco tratado | Pacote OEM | Especificacao fabricante |
| `TQ-102` / `DS-101` | Gas umido | Membrana EPDM/PVC; vaso epoxi | - |
| `TQ-103` | Soda | PEAD | compativel quimico |

**Normas citadas:** `ASTM` (materiais); `ASME BPVC Sec. VIII` (vasos de pressao); `NACE MR0175` / ISO 15156 (selecao para ambientes com `H2S` - confirmar escopo com laudo).

---

## 5. Utilidades e eficiencia energetica

### Balanco de utilidades (resumo)

| Utilidade | Consumo / demanda | Unidade | Fonte no projeto |
|-----------|-------------------|---------|------------------|
| Agua quente (digestor) | `3680` | `MJ/dia` demanda liquida | Recuperacao `MG-101` (`15739` `MJ/dia` disponivel) |
| Eletricidade interna | `1244` | `kWh/dia` | `MG-101` (geracao bruta `3956` `kWh/dia`) |
| Agua industrial | `2.6` | `m3/dia` | Rede |
| `NaOH` | `100` | `kg/dia` (cenario referencia) | Compra |
| Ar comprimido | `5` | `Nm3/h` | Compressor local (`~1 kW`) |
| Carvao ativado (`DS-101`) | `~16` | `kg/dia` (estimativa saturacao) | Compra / troca de leito |

**Nota:** a demanda termica para o `TC-101` na linha completa do balanco aparece como `6136 MJ/dia` (`71 kW` medio); o uso **liquido** no digestor apos perdas e reacao e da ordem de `3680 MJ/dia` - ver `08_utilidades_eficiencia.md`.

### Consumo eletrico por equipamento (lista de cargas)

| Equipamento | `kW` | `h/dia` | `kWh/dia` |
|-------------|------|---------|-----------|
| Agitador `TQ-101` | `30` | `24` | `720` |
| `P-101` | `0.75` | `24` | `18` |
| `P-102` | `0.75` | `24` | `18` |
| Agitador `D-101` | `15` | `24` | `360` |
| `FP-101` | `5` | `16` | `80` |
| Instrumentacao / iluminacao | `2` | `24` | `48` |
| **Total** | - | - | **`1244`** |

### Eficiencia energetica global

**Definicao adotada:** `eta_global = (E_eletrica_liquida + E_calor_util_digestor) / E_organica_entrada`, com `E_organica` estimada por **DQO** e fator `~13.9 MJ/kg DQO` (Chernicharo, 2007).

**Resultado do projeto:** **`eta_global = 17.3%`** (ver passo a passo em `08_utilidades_eficiencia.md`).

### Tabela de fluxo energetico (`MJ/dia`, base `E_org = 77673`)

| Parcela | Valor | `%` de `E_org` |
|---------|-------|----------------|
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

**Significado fisico:** a soma das parcelas do balanco completo (incluindo perdas ao ambiente) deve respeitar **conservacao de energia**; a eficiencia `17.3%` mede apenas **formas uteis** escolhidas na definicao, nao "perda de energia do universo".

---

## 6. Verificacoes

- **Coerencia massa:** correntes `101+102+103` = `102270 kg/dia`; gas `107` = `1984 kg/dia`; digestato `109` = `100286 kg/dia`; prensa `111+112` fecha com `109` (PFD `04b`).  
- **Volume do digestor:** `V_liq = Q * TRH` -> `100 * 20 = 2000 m3`, compativel com geometria `D=12 m`, `H_liq~18 m`.  
- **Area do trocador:** `Q = U A LMTD` com `Q ~ 71 kW`, `LMTD ~ 37 K`, `U = 800 W/m2K` -> `A` na ordem de `2.4 m2` antes de margem; adotado `3.1 m2` cobre fouling.  
- **CHP:** `3758 kWh/dia` corresponde a `156.6 kW` medio; referencia de apresentacao **`157 kW`** coerente com arredondamento.  

---

## 7. Conclusao

Os equipamentos principais foram **dimensionados** com base em vazao `100 m3/dia`, `TRH = 20 dias`, carga termica de aquecimento e producao de biogas do balanco; **materiais** foram propostos contra `pH`, `H2S`, abrasao e soda; **utilidades** foram **balanceadas** com autoproducao via `MG-101` para eletricidade e calor.

**Proximos passos sugeridos (Entrega 3):** otimizacao de processo (cenarios de carga), **analise economica** (CAPEX/OPEX, VPL), sensibilidade da `DQO` e ensaios de filtrabilidade para a `FP-101`.

---

## Referencias

- Towler, G.; Sinnott, R. (2012). *Chemical Engineering Design: Principles, Practice and Economics of Plant and Process Design*.  
- Perry, R. H.; Green, D. W. *Perry's Chemical Engineers' Handbook*.  
- Metcalf & Eddy et al. *Wastewater Engineering: Treatment and Resource Recovery*.  
- ASME BPVC Section VIII (vasos de pressao).  
- NACE MR0175 / ISO 15156 (materiais em ambientes com `H2S` - aplicabilidade a confirmar).  
- Chernicharo, C. A. L. (2007). *Biological Wastewater Treatment Series, Vol. 4: Anaerobic Reactors*.  
- Arquivos do projeto: `04b_pfd_formal_biogas.md`, `06_dimensionamento_equipamentos.md`, `07_materiais_construcao.md`, `08_utilidades_eficiencia.md`.

---

*Texto em portugues ASCII. Preencher campos de disciplina e equipe no cabecalho antes da entrega.*
