# Producao de Penicilina G

## Base do estudo

### Objetivo
Montar uma base didatica, mas tecnicamente rastreavel, para um balanco de massa e energia de producao de `Penicilina G` em escala conceitual.

### Base de calculo
`1000 kg de Penicilina G final seca`

### Escopo
O modelo cobre:

1. preparo do meio;
2. esterilizacao;
3. fermentacao fed-batch;
4. condicionamento do caldo;
5. remocao de biomassa;
6. extracao;
7. reextracao/purificacao;
8. cristalizacao;
9. filtracao;
10. secagem.

### O que este arquivo e
Este arquivo e uma base de pre-projeto para uso em planilha e dashboard.

### O que este arquivo nao e
Este arquivo nao substitui:

- dados reais de planta;
- projeto executivo;
- fechamento elementar rigoroso de C/H/O/N com dados experimentais;
- validacao laboratorial ou industrial.

## Referencias de processo usadas para as premissas

- `Aula 1 - Elaboração, dimensionamento e otimização.pdf`
- `Aula 2  - Simbologia e Tipos de fluxogramas.pdf`
- `Balanço de Massa e Energia_Profa.Janaína.pdf`
- `News-Medical - Penicillin Production`
- `Microbiology Notes - Penicillin: History, Structure, Production and Recovery`

## 1. Entendendo o processo como se fosse uma aula

## 1.1 O que e a Penicilina G

### Definicao simples
A Penicilina G e um antibiotico produzido por um fungo do genero `Penicillium`.

### Definicao tecnica
Ela e um metabolito secundario, ou seja, um composto que o microrganismo produz em uma fase especifica do cultivo, e nao como produto principal de crescimento.

### Por que isso importa
Isso muda completamente o projeto:

- primeiro o fungo cresce;
- depois ele passa a produzir mais penicilina;
- por isso, o controle de fermentacao e fundamental.

## 1.2 O que e um processo fermentativo

### Definicao simples
E um processo em que um microrganismo transforma nutrientes em biomassa, produto, calor e gases.

### Definicao tecnica
No caso da penicilina, o fungo consome fonte de carbono, fonte de nitrogenio, oxigenio e micronutrientes, gerando:

- biomassa;
- penicilina;
- CO2;
- agua metabolica;
- calor.

### O que guardar
No fermentador, nem toda materia-prima vira produto.
Uma parte vira:

- crescimento;
- manutencao celular;
- perdas metabolicas.

## 1.3 O que acontece depois da fermentacao

O produto sai diluido no caldo fermentado.
Por isso, depois e preciso:

- remover biomassa;
- acidificar;
- extrair com solvente;
- purificar;
- cristalizar;
- secar.

Em outras palavras:

- a fermentacao fabrica o antibiotico;
- o downstream recupera e purifica esse antibiotico.

## 2. Premissas principais do modelo

## 2.1 Premissas adotadas

Estas premissas sao didaticas e ajustaveis em Excel:

| Variavel | Simbolo | Valor base | Unidade |
|---|---:|---:|---|
| Produto final seco | `P_final` | 1000 | kg |
| Recuperacao remocao de biomassa | `eta_sep` | 0.995 | - |
| Recuperacao na extracao primaria | `eta_ext1` | 0.97 | - |
| Recuperacao na reextracao/purificacao | `eta_ext2` | 0.96 | - |
| Recuperacao na cristalizacao/filtracao | `eta_crist` | 0.98 | - |
| Recuperacao na secagem/manuseio final | `eta_dry` | 0.995 | - |
| Concentracao de penicilina no caldo | `C_penic` | 45 | kg/m3 |
| Densidade do caldo | `rho_broth` | 1030 | kg/m3 |
| Concentracao de biomassa seca no caldo | `C_x` | 18 | kg/m3 |
| Umidade do bolo cristalino antes da secagem | `Xw_cake` | 0.20 | frac. massica |
| Umidade residual no produto final | `Xw_final` | 0.01 | frac. massica |
| Temperatura inicial do meio | `T_in` | 25 | degC |
| Temperatura de esterilizacao | `T_ster` | 121 | degC |
| Temperatura de extracao | `T_ext` | 5 | degC |
| Calor especifico do caldo | `Cp_broth` | 4.0 | kJ/kg.K |
| Calor especifico medio do produto solido umido | `Cp_solid` | 1.6 | kJ/kg.K |
| Calor latente util do vapor | `lambda_steam` | 2130 | kJ/kg |
| Entalpia media de evaporacao na secagem | `lambda_dry` | 2500 | kJ/kg |
| Coeficiente de calor de fermentacao por kg de produto no caldo | `q_ferm` | 8000 | kJ/kg produto em caldo |

## 2.2 Justificativa das premissas

### Concentracao no caldo
Literatura de divulgacao tecnica moderna reporta titulos industriais na faixa de `40 a 50 g/L`, equivalente a `40 a 50 kg/m3`.

### Recuperacao global
Fontes de divulgacao tecnica apontam recuperacao moderna acima de `90%`.
Neste modelo, vamos separar essa recuperacao em varias etapas, o que e mais realista para planilha e dashboard.

### Temperaturas e pH
Valores tipicos de literatura:

- fermentacao: `24 a 26 degC`;
- pH de producao: `6.4 a 6.8`;
- extracao: caldo acidificado para `pH 2.0 a 2.5` e resfriado.

## 3. Balanco global de massa do produto

## 3.1 Ideia fisica
Se o produto se perde em varias etapas, entao a massa de penicilina presente no caldo precisa ser maior do que a massa final vendida.

## 3.2 Formula

Recuperacao global:

`eta_global = eta_sep * eta_ext1 * eta_ext2 * eta_crist * eta_dry`

Penicilina presente no caldo fermentado:

`P_broth = P_final / eta_global`

## 3.3 Calculo com as premissas

`eta_global = 0.995 * 0.97 * 0.96 * 0.98 * 0.995 = 0.9034`

`P_broth = 1000 / 0.9034 = 1106.9 kg`

### Interpretacao simples
Para vender `1000 kg` de penicilina seca, o fermentador precisa entregar aproximadamente `1106.9 kg` de penicilina no caldo, porque uma parte se perde ao longo da recuperacao.

## 4. Dimensionamento inicial do caldo fermentado

## 4.1 Ideia fisica
Se eu sei quanto produto ha no caldo e sei a concentracao do produto, entao descubro o volume do caldo.

## 4.2 Formula

`V_broth = P_broth / C_penic`

`M_broth = V_broth * rho_broth`

## 4.3 Calculo

`V_broth = 1106.9 / 45 = 24.60 m3`

`M_broth = 24.60 * 1030 = 25339.0 kg`

### Interpretacao simples
Para esta base de projeto, o processo precisa produzir cerca de `24.6 m3` de caldo fermentado, correspondendo a aproximadamente `25.34 t` de caldo.

## 5. Biomassa gerada e separacao solido-liquido

## 5.1 Ideia fisica
O caldo nao contem so penicilina. Ele contem grande quantidade de agua, biomassa fungica, sais, nutrientes residuais e impurezas.

## 5.2 Formula

Biomassa seca:

`M_x_dry = C_x * V_broth`

Se a torta removida tiver `20%` de solidos:

`M_cake_wet = M_x_dry / 0.20`

Agua arrastada com a torta:

`M_water_cake = M_cake_wet - M_x_dry`

## 5.3 Calculo

`M_x_dry = 18 * 24.60 = 442.8 kg`

`M_cake_wet = 442.8 / 0.20 = 2214.0 kg`

`M_water_cake = 2214.0 - 442.8 = 1771.2 kg`

### Interpretacao simples
O sistema de separacao retira aproximadamente:

- `442.8 kg` de biomassa seca;
- `2214.0 kg` de torta umida total.

## 5.4 Penicilina apos separacao

`P_after_sep = P_broth * eta_sep = 1106.9 * 0.995 = 1101.4 kg`

Perda nesta etapa:

`P_loss_sep = P_broth - P_after_sep = 5.5 kg`

## 6. Extracao primaria

## 6.1 O que e esta etapa
Depois de remover biomassa, o filtrado e acidificado e resfriado para transferir a penicilina da fase aquosa para um solvente organico.

### Definicao simples
Extracao liquido-liquido e uma separacao baseada na preferencia do soluto por uma fase em vez da outra.

## 6.2 Formula

`P_after_ext1 = P_after_sep * eta_ext1`

`P_loss_ext1 = P_after_sep - P_after_ext1`

## 6.3 Calculo

`P_after_ext1 = 1101.4 * 0.97 = 1068.4 kg`

`P_loss_ext1 = 33.0 kg`

## 7. Reextracao / purificacao

## 7.1 Ideia fisica
O produto e transferido para uma fase mais limpa, reduzindo impurezas e preparando a cristalizacao.

## 7.2 Formula

`P_after_ext2 = P_after_ext1 * eta_ext2`

`P_loss_ext2 = P_after_ext1 - P_after_ext2`

## 7.3 Calculo

`P_after_ext2 = 1068.4 * 0.96 = 1025.7 kg`

`P_loss_ext2 = 42.7 kg`

## 8. Cristalizacao e filtracao

## 8.1 Ideia fisica
Aqui o produto deixa a forma dissolvida e passa para cristais recuperaveis por filtracao ou centrifugacao.

## 8.2 Formula

`P_after_crist = P_after_ext2 * eta_crist`

`P_loss_crist = P_after_ext2 - P_after_crist`

## 8.3 Calculo

`P_after_crist = 1025.7 * 0.98 = 1005.2 kg`

`P_loss_crist = 20.5 kg`

## 9. Secagem final

## 9.1 Ideia fisica
O bolo cristalino sai umido e precisa perder agua para virar produto estavel.

## 9.2 Produto seco apos secagem

`P_final_calc = P_after_crist * eta_dry`

`P_loss_dry = P_after_crist - P_final_calc`

## 9.3 Calculo

`P_final_calc = 1005.2 * 0.995 = 1000.1 kg`

`P_loss_dry = 5.0 kg`

### Interpretacao simples
O conjunto das premissas fecha praticamente a base desejada de `1000 kg`.

## 10. Fechamento das perdas de produto

| Etapa | Produto apos etapa (kg) | Perda na etapa (kg) |
|---|---:|---:|
| Caldo fermentado | 1106.9 | - |
| Separacao de biomassa | 1101.4 | 5.5 |
| Extracao primaria | 1068.4 | 33.0 |
| Reextracao/purificacao | 1025.7 | 42.7 |
| Cristalizacao/filtracao | 1005.2 | 20.5 |
| Secagem final | 1000.1 | 5.0 |

Perda total:

`P_loss_total = 1106.9 - 1000.1 = 106.8 kg`

## 11. Balanço global simplificado de massa do processo

## 11.1 O que entra

- agua de processo;
- nutrientes do meio;
- inóculo;
- ar / oxigenio;
- agentes de ajuste de pH;
- solvente de extracao;
- utilidades.

## 11.2 O que sai

- penicilina seca;
- biomassa residual;
- agua residual;
- solvente perdido;
- CO2 do sistema fermentativo;
- efluentes.

## 11.3 Fechamento importante
Para um balanco de massa realmente completo em nivel estequiometrico, seria necessario incluir:

- carbono do substrato;
- oxigenio consumido;
- CO2 gerado;
- nitrogenio assimilado;
- agua formada e evaporada.

### Regra de confiabilidade
Este arquivo entrega um fechamento robusto de processo e recuperacao.
O fechamento elementar completo deve ser feito em uma aba especifica de fermentacao.

## 12. Balanço de energia

## 12.1 Esterilizacao do meio

### Ideia fisica
Antes de inocular, o meio precisa ser esterilizado para evitar contaminacao.

### Formula

`Q_ster = M_broth * Cp_broth * (T_ster - T_in)`

### Calculo

`Q_ster = 25339.0 * 4.0 * (121 - 25) = 9730176 kJ`

`Q_ster = 9730.2 MJ`

### Vapor teorico

`m_steam_theor = Q_ster / lambda_steam = 9730176 / 2130 = 4568.2 kg`

Se a eficiencia util do aquecimento for `85%`:

`m_steam_real = 4568.2 / 0.85 = 5374.3 kg`

### Interpretacao simples
Para esterilizar o meio desta base de projeto, seriam necessarios aproximadamente `5.37 t de vapor`.

## 12.2 Resfriamento do meio apos esterilizacao

### Formula

`Q_cool_after_ster = M_broth * Cp_broth * (T_ster - T_in)`

### Calculo

Igual ao aquecimento, em modulo:

`Q_cool_after_ster = 9730.2 MJ`

### Interpretacao
O mesmo tanto de energia que entrou para aquecer precisara ser removido para voltar a temperatura de fermentacao, desconsiderando perdas.

## 12.3 Resfriamento do fermentador durante a producao

### Ideia fisica
A fermentacao gera calor metabolico e precisa de remocao continua de calor.

### Formula

`Q_ferm = q_ferm * P_broth`

### Calculo

`Q_ferm = 8000 * 1106.9 = 8855200 kJ`

`Q_ferm = 8855.2 MJ`

### Interpretacao simples
Mesmo sem aquecer externamente, o fermentador exigira um sistema relevante de resfriamento por causa do metabolismo celular.

## 12.4 Resfriamento do filtrado para extracao

### Hipotese
O liquido que segue para extracao sai a `25 degC` e precisa ser resfriado a `5 degC`.

Massa liquida aproximada:

`M_liq_ext = M_broth - M_cake_wet = 25339.0 - 2214.0 = 23125.0 kg`

### Formula

`Q_chill = M_liq_ext * Cp_broth * (25 - 5)`

### Calculo

`Q_chill = 23125.0 * 4.0 * 20 = 1850000 kJ`

`Q_chill = 1850.0 MJ`

## 12.5 Secagem final

### Hipotese
O bolo cristalino contem `20%` de umidade antes da secagem.

Produto seco antes da secagem:

`M_dry_solid_before_dryer = P_after_crist = 1005.2 kg`

Massa total do bolo:

`M_wet_cake = M_dry_solid_before_dryer / (1 - Xw_cake)`

`M_wet_cake = 1005.2 / 0.80 = 1256.5 kg`

Agua na entrada do secador:

`M_water_in_dryer = 1256.5 - 1005.2 = 251.3 kg`

Se o produto final tiver `1%` de umidade em base umida:

`M_final_wet = P_final / (1 - Xw_final) = 1000 / 0.99 = 1010.1 kg`

Agua final residual:

`M_water_final = 1010.1 - 1000 = 10.1 kg`

Agua evaporada:

`M_water_evap = 251.3 - 10.1 = 241.2 kg`

### Carga termica de evaporacao

`Q_dry = M_water_evap * lambda_dry = 241.2 * 2500 = 603000 kJ`

`Q_dry = 603.0 MJ`

## 12.6 Resumo das cargas de energia

| Etapa | Carga (MJ) | Tipo |
|---|---:|---|
| Esterilizacao | 9730.2 | aquecimento |
| Resfriamento apos esterilizacao | 9730.2 | resfriamento |
| Remocao de calor da fermentacao | 8855.2 | resfriamento |
| Resfriamento para extracao | 1850.0 | resfriamento |
| Secagem | 603.0 | aquecimento |

### Leitura simples
As maiores demandas energeticas do processo estao em:

1. esterilizacao;
2. resfriamento pos-esterilizacao;
3. controle termico da fermentacao.

## 13. Estrutura pronta para Excel

## 13.1 Aba `Premissas`

Criar colunas:

- Parametro
- Simbolo
- Valor
- Unidade
- Fonte
- Observacao

## 13.2 Aba `Balanco_Massa`

Colunas recomendadas:

- Corrente
- Descricao
- Vazao total (kg)
- Agua (kg)
- Penicilina (kg)
- Biomassa seca (kg)
- Solvente (kg)
- Solidos dissolvidos / impurezas (kg)

## 13.3 Aba `Balanco_Energia`

Colunas recomendadas:

- Etapa
- Massa (kg)
- Cp (kJ/kg.K)
- Tin
- Tout
- DeltaT
- Q sensivel (kJ)
- Q latente (kJ)
- Q total (kJ)

## 13.4 Aba `Recuperacoes`

Colunas:

- Etapa
- Eficiencia
- Produto entrada
- Produto saida
- Perda
- Perda acumulada

## 13.5 Aba `Dashboard`

Indicadores recomendados:

- recuperacao global;
- penicilina no caldo;
- volume de fermentacao;
- biomassa gerada;
- perda total de produto;
- carga total de aquecimento;
- carga total de resfriamento;
- consumo de vapor por kg de produto;
- m3 de caldo por kg de produto.

Graficos recomendados:

- barras de perda por etapa;
- barras de carga energetica por etapa;
- pizza da distribuicao de saidas do processo;
- linha de produto restante ao longo das etapas.

## 14. Formulas prontas para Excel

Assumindo nomes definidos:

```text
eta_global = eta_sep*eta_ext1*eta_ext2*eta_crist*eta_dry
P_broth = P_final/eta_global
V_broth = P_broth/C_penic
M_broth = V_broth*rho_broth
M_x_dry = C_x*V_broth
M_cake_wet = M_x_dry/0.20
P_after_sep = P_broth*eta_sep
P_after_ext1 = P_after_sep*eta_ext1
P_after_ext2 = P_after_ext1*eta_ext2
P_after_crist = P_after_ext2*eta_crist
P_final_calc = P_after_crist*eta_dry
Q_ster = M_broth*Cp_broth*(T_ster-T_in)
Steam_real = (Q_ster/lambda_steam)/0.85
Q_ferm = q_ferm*P_broth
M_liq_ext = M_broth-M_cake_wet
Q_chill = M_liq_ext*Cp_broth*(25-5)
M_wet_cake = P_after_crist/(1-Xw_cake)
M_water_in_dryer = M_wet_cake-P_after_crist
M_final_wet = P_final/(1-Xw_final)
M_water_final = M_final_wet-P_final
M_water_evap = M_water_in_dryer-M_water_final
Q_dry = M_water_evap*lambda_dry
```

## 15. O que ainda falta para transformar isso em projeto mais realista

Para aumentar a confiabilidade do modelo, os proximos passos sao:

1. fechar a fermentacao em base estequiometrica de C/H/O/N;
2. definir composicao detalhada do meio;
3. definir taxas de aeracao e consumo de oxigenio;
4. modelar solvente fresco, solvente reciclado e perdas;
5. definir equipamentos e tempos de campanha;
6. converter para PFD e tabela de correntes.

## 16. Confiabilidade deste material

### Nivel de confiabilidade
`Nivel B - Boa confiabilidade para estudo conceitual`

### Por que nao e Nivel A ainda
Porque ainda faltam:

- dados reais de planta;
- propriedades reais do sistema;
- fechamento elementar completo;
- dados experimentais de rendimento fermentativo;
- estrategia real de reciclo de solvente e utilidades.

### O que ja e confiavel

- estrutura do processo;
- direcao dos balancos;
- raciocinio de recuperacao;
- estimativa de volume de caldo;
- estimativa de cargas principais de energia;
- arquitetura pronta para Excel e dashboard.

## 17. Resumo final em linguagem simples

Para produzir `1000 kg` de penicilina G seca, este modelo indica que:

- o fermentador precisa entregar cerca de `1107 kg` de penicilina no caldo;
- isso corresponde a cerca de `24.6 m3` de caldo fermentado;
- a biomassa removida e da ordem de `443 kg` seca;
- a maior parte das perdas de produto ocorre no downstream, especialmente em extracao e purificacao;
- as maiores cargas energeticas estao em esterilizacao, resfriamento do meio e controle termico da fermentacao.

Em outras palavras:
o processo nao e limitado apenas por "fazer o antibiotico", mas por conseguir recupera-lo bem e controlar a energia do sistema.
