# Fermentacao Pseudo-Estequiometrica da Penicilina G

## Objetivo
Este arquivo fecha uma versao mais rigorosa da etapa de fermentacao para uso em:

- estudo didatico;
- planilha Excel;
- estimativa de consumo de substrato;
- estimativa de demanda de oxigenio;
- estimativa de geracao de CO2;
- preparacao de um `PFD` mais consistente.

## Ideia central

### Definicao simples
Uma fermentacao real da penicilina e biologicamente complexa demais para ser representada por uma unica reacao exata de sala de aula.

### Definicao tecnica
A biossintese da penicilina envolve:

- metabolismo central;
- crescimento celular;
- manutencao;
- formacao de metabolito secundario;
- uso de precursor de cadeia lateral;
- uso de nutrientes nitrogenados e sulfurados;
- respiracao aerobia.

### O que vamos fazer aqui
Vamos montar um modelo `pseudo-estequiometrico`, isto e:

- simplificado o suficiente para caber num Excel;
- coerente o suficiente para passar pelos filtros de massa, energia e plausibilidade;
- explicito o suficiente para nao fingir exatidao bioquimica que nao temos.

## 1. Dados herdados do arquivo principal

Do arquivo `01_penicilina_g_balanco_massa_energia.md`, adotamos:

- produto final seco: `1000 kg`
- penicilina no caldo fermentado: `1106.9 kg`
- volume de caldo: `24.60 m3`
- biomassa seca no caldo: `442.8 kg`

## 2. Definicoes fundamentais

## 2.1 O que e biomassa

### Definicao simples
Biomassa e a massa do fungo que cresce no fermentador.

### Definicao tecnica
Para balancos elementares, biomassa microbiana costuma ser representada por uma `formula empirica`, que resume sua composicao media.

### Formula empirica adotada
Usaremos a formula tipica:

`CH1.8O0.5N0.2`

### Por que isso importa
Ela permite estimar:

- quanto nitrogenio foi assimilado;
- quanto carbono ficou retido em crescimento;
- quanto oxigenio pode ter sido consumido.

## 2.2 O que e penicilina G

### Formula molecular
`C16H18N2O4S`

### Massa molar
`334.4 g/mol`

### O que isso significa
Cada mol de penicilina contem:

- 16 atomos de carbono;
- 18 de hidrogenio;
- 2 de nitrogenio;
- 4 de oxigenio;
- 1 de enxofre.

## 2.3 O que significa "glicose equivalente"

### Definicao simples
Nem sempre a fermentacao usa apenas glicose pura.
Pode haver lactose, outros acucares, alimentacao ao longo do tempo e fontes carbonadas diversas.

### Definicao tecnica
Para simplificar o balanco, vamos tratar a fonte carbonada principal como `glicose equivalente`.

### Regra pratica
Isso quer dizer:

- nao estamos afirmando que toda a alimentacao foi glicose pura;
- estamos usando a glicose como base padrao de comparacao.

## 3. Premissas especificas desta etapa

## 3.1 Rendimento produto/substrato

### Premissa
Adotaremos um rendimento conceitual:

`Yp/s = 0.08 kg penicilina / kg glicose equivalente consumida`

### Interpretacao
Para cada `1 kg` de fonte carbonada equivalente consumida, cerca de `0.08 kg` acabam associados ao produto formado no caldo.

### Observacao importante
Este e um rendimento de engenharia conceitual, nao um valor unico universal de planta.

## 3.2 Precursor da cadeia lateral

### Definicao simples
A penicilina G precisa de um precursor especifico para formar sua cadeia lateral aromatica.

### Composto adotado
`Acido fenilacetico (PAA)`

### Regra pratica
Vamos rastrear o precursor separadamente, pois ele e importante para:

- coerencia do processo;
- custo;
- entendimento da rota.

## 4. Quantidade de penicilina formada no caldo

### Formula

`n_pen = m_pen / MM_pen`

### Calculo

`n_pen = 1106.9 / 334.4 = 3.310 kmol`

### Interpretacao simples
No caldo fermentado existem aproximadamente `3.31 kmol` de penicilina G.

## 5. Quantidade de biomassa formada

### Massa molar da biomassa empirica por C-mol

Para `CH1.8O0.5N0.2`:

- C = 12.0
- H = 1.8
- O = 8.0
- N = 2.8

Total:

`MM_biomassa = 24.6 kg por kmol de formula empirica`

### Calculo

`n_x = 442.8 / 24.6 = 18.0 kmol de biomassa empirica`

### Interpretacao simples
A biomassa formada equivale a `18.0 kmol` da formula media `CH1.8O0.5N0.2`.

## 6. Consumo de fonte carbonada equivalente

## 6.1 Ideia fisica
Se eu conheco o produto e assumo um rendimento produto/substrato, posso estimar a massa de substrato carbonado consumida.

## 6.2 Formula

`m_s = m_pen / Yp/s`

## 6.3 Calculo

`m_s = 1106.9 / 0.08 = 13836.3 kg de glicose equivalente`

### Conversao para kmol de glicose equivalente

Com `MM_glicose = 180 kg/kmol`:

`n_s = 13836.3 / 180 = 76.868 kmol`

### Interpretacao simples
O fermentador precisaria consumir cerca de `13.84 t` de fonte carbonada equivalente para sustentar esse nivel de producao, dentro da premissa adotada.

## 7. Rendimento biomassa/substrato retrocalculado

## 7.1 Formula

`Yx/s = m_x / m_s`

## 7.2 Calculo

`Yx/s = 442.8 / 13836.3 = 0.0320 kg/kg`

### Interpretacao simples
Neste modelo, para cada `1 kg` de substrato equivalente consumido:

- `0.08 kg` viram penicilina no caldo;
- `0.032 kg` viram biomassa seca;
- o restante vai para manutencao, respiracao e perdas metabolicas.

## 8. Necessidade de precursor PAA

## 8.1 Ideia fisica
Cada mol de penicilina G precisa de uma unidade de cadeia lateral derivada de `acido fenilacetico`.

## 8.2 Hipotese
Adotaremos `5%` de excesso operacional de precursor.

## 8.3 Formula

`n_PAA = 1.05 * n_pen`

Com `MM_PAA = 136.15 kg/kmol`

`m_PAA = n_PAA * MM_PAA`

## 8.4 Calculo

`n_PAA = 1.05 * 3.310 = 3.476 kmol`

`m_PAA = 3.476 * 136.15 = 473.3 kg`

### Interpretacao simples
Uma primeira estimativa de precursor de cadeia lateral e da ordem de `473 kg de acido fenilacetico`.

## 9. Necessidade de nitrogenio

## 9.1 Ideia fisica
O nitrogenio aparece:

- na biomassa;
- na penicilina.

## 9.2 Nitrogenio na biomassa

Cada mol de biomassa empirica contem `0.2 mol` de N.

`n_N_biomassa = 0.2 * 18.0 = 3.6 kmol de N`

## 9.3 Nitrogenio na penicilina

Cada mol de penicilina contem `2 mol` de N.

`n_N_pen = 2 * 3.310 = 6.620 kmol de N`

## 9.4 Nitrogenio total assimilado

`n_N_total = 3.6 + 6.620 = 10.220 kmol de N`

Se o nitrogenio for expresso como `amonia equivalente`:

`m_NH3_eq = 10.220 * 17 = 173.7 kg NH3 equivalente`

### Interpretacao simples
O consumo quimicamente retido em biomassa + produto equivale a aproximadamente `174 kg de amonia`.

### Observacao importante
Na planta real, a fonte de nitrogenio pode ser uma combinacao de:

- amonia;
- sais de amonio;
- corn steep liquor;
- outros nutrientes complexos.

## 10. Necessidade de enxofre

## 10.1 Ideia fisica
A penicilina contem enxofre em sua estrutura.

## 10.2 Calculo

Cada mol de penicilina contem `1 mol` de S:

`n_S_pen = 3.310 kmol de S`

Com `MM_S = 32 kg/kmol`:

`m_S_eq = 3.310 * 32 = 105.9 kg de S equivalente`

### Interpretacao simples
So o produto final retido no caldo ja representa cerca de `106 kg` de enxofre equivalente.

### Observacao
O enxofre real vem de sais sulfurados e metabolismo de precursores sulfurados; neste modelo ele e rastreado como requisito, nao como reacao bioquimica detalhada.

## 11. Estimativa de CO2 gerado

## 11.1 Ideia fisica
O carbono do substrato que nao fica retido em biomassa ou produto sai principalmente como `CO2`.

## 11.2 Carbono total na glicose equivalente

Cada mol de glicose contem `6 mol` de C:

`n_C_feed = 6 * 76.868 = 461.208 kmol de C`

## 11.3 Carbono retido na biomassa

Cada mol de biomassa empirica contem `1 mol` de C:

`n_C_x = 18.0 kmol de C`

## 11.4 Carbono retido na penicilina

Cada mol de penicilina contem `16 mol` de C:

`n_C_pen = 16 * 3.310 = 52.963 kmol de C`

## 11.5 Carbono que sai como CO2

`n_CO2 = n_C_feed - n_C_x - n_C_pen`

`n_CO2 = 461.208 - 18.0 - 52.963 = 390.245 kmol`

Convertendo para massa:

`m_CO2 = 390.245 * 44 = 17170.8 kg`

### Interpretacao simples
O processo fermentativo desta base pode gerar algo da ordem de `17.17 t de CO2`.

## 12. Estimativa de O2 consumido

## 12.1 Definicao importante
Aqui faremos um `balanco pseudo-estequiometrico CHON`.

### O que isso significa
Vamos fechar carbono, hidrogenio, oxigenio e nitrogenio com:

- glicose equivalente;
- amonia equivalente;
- biomassa;
- penicilina;
- CO2;
- agua;
- O2.

### O que nao estamos fazendo
Nao estamos afirmando que a bioquimica real e exatamente uma unica reacao global.

## 12.2 Sistema pseudo-estequiometrico

Base:

`76.868 kmol glicose equivalente + 10.220 kmol NH3 + c kmol O2`

gerando:

- `18.0 kmol biomassa empirica`
- `3.310 kmol penicilina`
- `390.245 kmol CO2`
- `g kmol H2O`

## 12.3 Balanco de hidrogenio

H na entrada:

`12*76.868 + 3*10.220 = 953.08 kmol H`

H na biomassa + produto:

`1.8*18.0 + 18*3.310 = 91.98 kmol H`

Resto vai para agua:

`g = 430.55 kmol H2O`

Convertendo:

`m_H2O_gen = 430.55 * 18 = 7749.9 kg`

## 12.4 Balanco de oxigenio

O na entrada sem O2:

`6*76.868 = 461.21 kmol O`

O na saida sem agua:

- biomassa: `0.5*18.0 = 9.0`
- penicilina: `4*3.310 = 13.24`
- CO2: `2*390.245 = 780.49`
- agua: `430.55`

Total:

`1233.28 kmol O`

Logo:

`461.21 + 2*c = 1233.28`

`c = 386.04 kmol O2`

Convertendo para massa:

`m_O2 = 386.04 * 32 = 12353.1 kg`

### Interpretacao simples
O consumo total de oxigenio na campanha, nesta base conceitual, e de cerca de `12.35 t de O2`.

## 13. Estimativa de ar total

## 13.1 Formula

Assumindo ar seco com `21% molar` de O2:

`n_ar = n_O2 / 0.21 = 1838.3 kmol de ar`

Em `Nm3`:

`V_ar_N = 1838.3 * 22.414 = 41201 Nm3`

Massa aproximada do ar:

`m_ar = 53000 kg`

## 13.2 Se a fermentacao durar 160 horas

Vazao media de ar:

`Q_ar_media = 41201 / 160 = 257.5 Nm3/h`

Como o caldo ocupa `24.6 m3`, isso equivale aproximadamente a:

`0.174 vvm`

### O que e vvm
`vvm` significa `volumes de ar por volume de liquido por minuto`.

### Interpretacao simples
Esse valor medio parece plausivel para uma estimativa inicial, mas em planta real o pico de aeracao costuma ser maior do que a media.

## 14. Resumo numerico da fermentacao

| Grandeza | Valor |
|---|---:|
| Penicilina no caldo | 1106.9 kg |
| Biomassa seca | 442.8 kg |
| Glicose equivalente consumida | 13836.3 kg |
| Precursor PAA | 473.3 kg |
| NH3 equivalente assimilado | 173.7 kg |
| Enxofre equivalente no produto | 105.9 kg |
| CO2 gerado | 17170.8 kg |
| O2 consumido | 12353.1 kg |
| Ar total estimado | 41201 Nm3 |

## 15. O que este modelo ensina

### Ideia principal
Na fermentacao da penicilina:

- entra muito mais substrato do que produto sai;
- uma parte relevante vai para respiracao;
- a demanda de ar e importante;
- a geracao de CO2 e grande;
- o produto e valioso, mas aparece diluido no caldo.

### Em linguagem bem simples
O fermentador nao e uma "maquina que transforma acucar em penicilina".
Ele e um sistema biologico que:

- cresce;
- respira;
- gera calor;
- libera CO2;
- e so uma parte do que consome vira antibiotico.

## 16. Confiabilidade deste bloco

### Classificacao
`Nivel B para engenharia conceitual`

### Por que nao e Nivel A
Porque ainda faltam:

- composicao real do meio;
- estrategia real de alimentacao;
- dados de OUR/OTR medidos;
- composicao elementar real da biomassa;
- rendimento real por campanha industrial.

### Mesmo assim, o que ja e forte

- o raciocinio fisico esta correto;
- o modelo e transparente;
- as hipoteses estao explicitas;
- o resultado pode ser levado para Excel e dashboard;
- ele ja serve para comparacao de cenarios.
