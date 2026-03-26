# Producao de Biogas por Codigestao Anaerobia

## O que voce vai aprender neste arquivo

Este arquivo e a base de tudo.
Ele explica, do zero absoluto, cada conceito necessario para entender o projeto de producao de biogas a partir da codigestao anaerobia de:
- lodo de esgoto;
- vinhaca de cana-de-acucar;
- residuo organico.

Se voce nunca estudou o tema antes, comece por aqui. Nenhuma formula aparece sem antes ter sua intuicao fisica explicada.

---

## 1. O que e biogas

### Definicao simples
Biogas e um gas que aparece quando a materia organica se decompoe sem contato com o ar.

### Definicao tecnica
Biogas e uma mistura gasosa produzida pela degradacao anaerobia (sem oxigenio) de compostos organicos por um consorcio de microrganismos. Seus principais componentes sao:

| Componente | Formula | Fracao tipica | Papel |
|---|---|---|---|
| Metano | CH4 | 50-70% vol | Combustivel; e o componente util |
| Dioxido de carbono | CO2 | 30-50% vol | Inerte; dilui o biogas |
| Sulfeto de hidrogenio | H2S | tracos | Corrosivo; precisa ser removido |
| Vapor de agua | H2O | tracos | Presente como umidade |
| Outros | NH3, H2, N2 | tracos | Desprezaveis em volume |

### Por que isso importa para o projeto
O metano e um combustivel. Ele pode ser:
- queimado para gerar calor;
- usado em motores para gerar eletricidade;
- purificado para virar biometano (substitui gas natural).

A quantidade de metano produzida determina o valor energetico e economico do projeto.

### Referencia
Chernicharo, C.A.L. (2007). Reatores Anaerobios. DESA/UFMG.
Portal do Biogas (2024). Biodigestao Anaerobia - As 4 fases.

---

## 2. O que e digestao anaerobia

### Definicao simples
E o processo biologico em que microrganismos "comem" materia organica na ausencia de oxigenio e produzem biogas como "respiro".

### Definicao tecnica
Digestao anaerobia e a conversao bioquimica de compostos organicos complexos em metano e dioxido de carbono, mediada por um consorcio de microrganismos que operam em quatro etapas sequenciais e interdependentes.

### Analogia para leigo
Pense assim: quando voce deixa comida estragando num recipiente fechado, sem ar, ela fermenta e libera gases. A digestao anaerobia e esse processo, so que controlado dentro de um reator industrial, com temperatura, pH e alimentacao ajustados.

### Diferenca fundamental para a digestao aerobia
- `Aerobia` (com oxigenio): os microrganismos convertem materia organica em CO2 + agua + calor. Nao produz combustivel.
- `Anaerobia` (sem oxigenio): os microrganismos convertem materia organica em CH4 + CO2 + digestato. Produz combustivel.

---

## 3. As quatro etapas da digestao anaerobia

Este e o coracao do processo. Cada etapa depende da anterior. Se uma falha, todas as seguintes sao afetadas.

## 3.1 Hidrolise

### O que acontece em linguagem simples
Moleculas grandes e complexas sao quebradas em moleculas menores. E como picar a comida antes de mastigar.

### O que entra
- proteinas (cadeias de aminoacidos);
- carboidratos (amido, celulose, hemicelulose);
- lipideos (gorduras e oleos).

### O que sai
- aminoacidos;
- acucares simples (glicose, xilose);
- acidos graxos de cadeia longa;
- glicerol.

### Como funciona
Bacterias hidroliticas liberam enzimas extracelulares (proteases, celulases, lipases) que cortam as ligacoes quimicas dos polimeros.

### Por que importa para o nosso projeto
A hidrolise costuma ser a `etapa limitante` quando o substrato contem muitos solidos dificeis de digerir, como fibras do lodo de esgoto e cascas de frutas. Isso significa que a velocidade do processo inteiro depende da velocidade desta etapa.

### Referencia
Chernicharo (2007); Portal Energia e Biogas (2024).

## 3.2 Acidogenese (Fermentacao)

### O que acontece
Os compostos simples da hidrolise sao transformados em acidos organicos volateis, alcools, hidrogenio e CO2.

### O que entra
Aminoacidos, acucares simples, acidos graxos.

### O que sai
- acido acetico (CH3COOH);
- acido propionico (C2H5COOH);
- acido butirico (C3H7COOH);
- etanol;
- H2, CO2.

### Detalhe importante
Este grupo de bacterias (acidogenicas) e o mais numeroso no reator: representa cerca de `90%` da populacao microbiana.

### Por que importa
Se esta etapa for muito rapida em relacao a metanogenese, os acidos se acumulam, o pH cai, e o processo "azeda" (acidificacao). E um dos modos de falha mais comuns.

### Referencia
Casa das Ciencias (2020). Digestao Anaerobia.

## 3.3 Acetogenese

### O que acontece
Os acidos e alcools da fase anterior sao convertidos em `acetato` (CH3COO-), `hidrogenio` (H2) e `CO2`.

### Por que essa etapa existe
Os microrganismos metanogenicos (da etapa 4) nao conseguem "comer" acido propionico ou butirico diretamente. Eles precisam de acetato ou H2. A acetogenese faz essa "traducao".

### Detalhe tecnico critico
As bacterias acetogenicas sao sensiveis ao acumulo de H2. Se H2 se acumula, a reacao para (termodinamicamente desfavoravel). Isso mostra que o equilibrio entre as etapas e delicado: as metanogenicas precisam consumir o H2 para que as acetogenicas consigam trabalhar.

### Referencia
Chernicharo (2007).

## 3.4 Metanogenese

### O que acontece
Acetato, H2 e CO2 sao finalmente convertidos em metano.

### Duas rotas principais

1. `Metanogenese acetoclastica`:
   CH3COOH -> CH4 + CO2
   Responsavel por cerca de `70%` do metano produzido.

2. `Metanogenese hidrogenotrofica`:
   CO2 + 4 H2 -> CH4 + 2 H2O
   Responsavel por cerca de `30%` do metano produzido.

### Detalhe critico
Os microrganismos metanogenicos sao arqueias (nao sao bacterias comuns). Eles sao os mais sensiveis do processo:
- pH ideal: `6.8 a 7.4`;
- nao toleram oxigenio;
- nao toleram excesso de acidos volateis;
- nao toleram compostos toxicos (metais pesados, antibioticos).

Se as metanogenicas morrem, o processo inteiro para de produzir metano.

### Referencia
Portal do Biogas (2024); Chernicharo (2007).

---

## 4. O que e codigestao anaerobia

### Definicao simples
E digerir dois ou mais tipos de residuos juntos no mesmo reator.

### Definicao tecnica
Codigestao anaerobia e o tratamento simultaneo de dois ou mais substratos organicos em um unico digestor, visando:
- equilibrar a relacao C/N;
- diluir compostos inibidores;
- aumentar o rendimento de biogas;
- melhorar a estabilidade do processo.

### Por que codigestao e nao mono-digestao

| Substrato | Problema se digerido sozinho |
|---|---|
| Lodo de esgoto | C/N muito baixa (~8); pode gerar excesso de amonia |
| Vinhaca | pH muito acido (3.5-5.0); potassio alto; pode inibir |
| Residuo organico | Variavel; pode acidificar muito rapido |

Misturando, um compensa a fraqueza do outro. O lodo traz nitrogenio, a vinhaca e o residuo trazem carbono.

### Referencia
Repositorio UFRJ - Codigestao de vinhaca e lodo de esgoto para producao de biometano.
UNESP - Codigestao anaerobia de vinhaca e lodo aumenta estabilidade e producao de metano.
UFPR (2024) - Avaliacao do desempenho operacional de usina de codigestao.

---

## 5. Os tres substratos do nosso projeto

## 5.1 Lodo de esgoto

### O que e
Residuo solido e semi-solido gerado no tratamento de esgoto domestico em estacoes de tratamento de esgoto (ETE).

### Composicao tipica (base brasileira)

| Parametro | Valor adotado | Faixa literatura | Unidade | Referencia |
|---|---|---|---|---|
| Densidade | 1020 | 1010-1030 | kg/m3 | PROSAB |
| Solidos totais (ST) | 3.5 | 2-5 | % massa | Embrapa (2024) |
| Solidos volateis (SV/ST) | 65 | 50-70 | % dos ST | Embrapa |
| DQO | 30000 | 15000-40000 | mg/L | Literatura |
| Relacao C/N | 8 | 6-12 | - | Literatura |
| pH | 6.8 | 6.0-7.5 | - | PROSAB |

### Composicao elementar tipica do lodo (base seca dos SV)

| Elemento | % em massa (base SV) | Referencia |
|---|---|---|
| Carbono (C) | 51.0 | Nature/Scientific Reports |
| Hidrogenio (H) | 7.9 | Nature/Scientific Reports |
| Oxigenio (O) | 34.6 | Nature/Scientific Reports |
| Nitrogenio (N) | 5.4 | Nature/Scientific Reports |
| Enxofre (S) | 1.1 | Nature/Scientific Reports |

### Por que a relacao C/N baixa e um problema
A faixa ideal para digestao anaerobia e C/N entre 20 e 30. Lodo sozinho tem C/N de 6 a 12: muito nitrogenio e pouco carbono. Isso gera excesso de amonia (NH3), que e toxica para as metanogenicas.

## 5.2 Vinhaca

### O que e
Efluente liquido gerado na destilacao do etanol de cana-de-acucar. Para cada litro de etanol, sao gerados de `10 a 15 litros` de vinhaca.

### Composicao tipica

| Parametro | Valor adotado | Faixa | Unidade | Referencia |
|---|---|---|---|---|
| Densidade | 1009 | 1005-1015 | kg/m3 | RVQ (2024) |
| Solidos totais (ST) | 1.7 | 1.0-3.0 | % massa | RVQ (2024) |
| Solidos volateis (SV/ST) | 75 | 65-85 | % dos ST | Literatura |
| DQO | 30000 | 15000-65000 | mg/L | Literatura |
| Relacao C/N | 25 | 15-35 | - | Literatura |
| pH | 4.2 | 3.5-5.0 | - | Cadernos UniFOA |
| Potassio | 4000 | 2000-8000 | mg/L | Sebrae / RVQ |

### Composicao elementar tipica da vinhaca (base seca dos SV)

| Elemento | % em massa (base SV) | Referencia |
|---|---|---|
| Carbono (C) | 43.0 | Estimativa de literatura |
| Hidrogenio (H) | 6.5 | Estimativa de literatura |
| Oxigenio (O) | 46.0 | Estimativa de literatura |
| Nitrogenio (N) | 3.5 | Estimativa de literatura |
| Enxofre (S) | 1.0 | Estimativa de literatura |

### Vantagem na codigestao
Rica em carbono e materia organica facilmente degradavel, equilibra a C/N baixa do lodo.

### Cuidado
O pH acido e o alto teor de potassio podem inibir o processo se a proporcao nao for bem controlada.

## 5.3 Residuo organico

### O que e
Residuos biodegradaveis de origem domestica, comercial ou agroindustrial: restos de alimento, cascas, frutas, verduras, gorduras.

### Composicao tipica

| Parametro | Valor adotado | Faixa | Unidade | Referencia |
|---|---|---|---|---|
| Densidade | 1050 | 1020-1080 | kg/m3 | Literatura |
| Solidos totais (ST) | 20.0 | 15-30 | % massa | Literatura |
| Solidos volateis (SV/ST) | 85 | 80-95 | % dos ST | Literatura |
| DQO | 150000 | 80000-200000 | mg/L | Literatura |
| Relacao C/N | 30 | 15-40 | - | Literatura |
| pH | 5.5 | 4.0-6.5 | - | - |

### Composicao elementar tipica do residuo organico (base seca dos SV)

| Elemento | % em massa (base SV) | Referencia |
|---|---|---|
| Carbono (C) | 48.0 | MDPI Sustainability (2019) |
| Hidrogenio (H) | 6.4 | MDPI Sustainability (2019) |
| Oxigenio (O) | 42.0 | MDPI Sustainability (2019), ajustado por diferenca |
| Nitrogenio (N) | 3.2 | MDPI Sustainability (2019) |
| Enxofre (S) | 0.4 | MDPI Sustainability (2019) |

---

## 6. Relacao C/N: por que ela e tao importante

### Definicao simples
E a proporcao entre carbono e nitrogenio na alimentacao do digestor.

### Definicao tecnica
Razao massica (ou molar) entre carbono organico total e nitrogenio total na mistura de substratos de entrada.

### Regra fundamental
- C/N < 15: excesso de nitrogenio -> acumulo de amonia -> inibicao das metanogenicas.
- C/N > 40: falta de nitrogenio -> crescimento microbiano insuficiente -> processo muito lento.
- `Faixa ideal: 20-30`.

### Como a codigestao resolve
Lodo de esgoto tem C/N ~8 (muito baixo). Vinhaca tem ~25. Residuo organico tem ~30. Misturando nas proporcoes certas, atingimos a faixa ideal.

---

## 7. Parametros operacionais fundamentais

## 7.1 Temperatura

### O que significa
A temperatura dentro do reator controla a velocidade das reacoes biologicas.

### Faixas

| Regime | Faixa | Tipico | Vantagem | Desvantagem |
|---|---|---|---|---|
| Mesofilico | 30-40 degC | 35 degC | Mais estavel, mais comum | Mais lento |
| Termofilico | 50-60 degC | 55 degC | Mais rapido, higieniza | Mais sensivel |

### Premissa
`Regime mesofilico a 35 degC` - mais comum em ETEs brasileiras.

## 7.2 Tempo de retencao hidraulica (TRH)

### Definicao simples
Tempo medio que o material fica dentro do reator.

### Formula
`TRH = V_reator / Q_alimentacao`

### Faixa tipica
15-25 dias para codigestao mesofilica.

### Premissa
`TRH = 20 dias`

## 7.3 Carga organica volumetrica (COV)

### Definicao simples
Quantidade de materia organica alimentada por volume de reator por dia.

### Formula
`COV = (Q * SV_concentracao) / V_reator`

### Faixa tipica
1-4 kg SV/m3.dia (mesofilico convencional).

## 7.4 pH

### Faixa ideal no reator
6.8 a 7.4 para a metanogenese funcionar bem.

---

## 8. O que sai do processo

### Dois produtos

1. `Biogas`: CH4 + CO2 + tracos.
2. `Digestato`: lodo estabilizado, com menos materia organica.

### Rendimentos tipicos na literatura

| Mistura | Rendimento | CH4 | Referencia |
|---|---|---|---|
| Lodo + residuo organico 80:20 | 0.66 Nm3/kgSV | 62% | UFPR (2024) |
| Lodo + vinhaca 25:75 | 207 mL CH4/gDQOad | var. | UFRJ (2023) |
| Lodo + vinhaca + esterco 49.5:49.5:1 | 261 mL CH4/gSVad | var. | Cadiz (2022) |

---

## 9. Equacao global simplificada

`Lodo + Vinhaca + Residuo organico -> Biogas (CH4 + CO2) + Digestato + Calor`

### O que o modelo precisa responder
1. Quanta materia organica entra? (SV de entrada)
2. Quanto e convertido? (eficiencia de remocao)
3. Quanto biogas? (rendimento)
4. Composicao do biogas? (CH4, CO2)
5. Quanto digestato? (fechamento de massa)
6. Composicao elementar? (C, H, O, N)
7. Quanto calor? (aquecimento, perdas, CHP)
8. O processo se paga? (autossuficiencia termica)

---

## 10. Confiabilidade

### Nivel
`Nivel B - Boa confiabilidade para engenharia conceitual`

### O que ja e confiavel
- estrutura do processo correta;
- 4 etapas biologicas bem descritas;
- parametros operacionais tipicos de literatura;
- composicao dos substratos embasada em fontes brasileiras e internacionais;
- composicao elementar com referencia.

### O que ainda precisa para nivel A
- dados reais de caracterizacao dos substratos deste projeto;
- ensaios de BMP laboratoriais;
- dados operacionais de planta;
- dados do Gabriel sobre proporcoes e origem dos residuos.
