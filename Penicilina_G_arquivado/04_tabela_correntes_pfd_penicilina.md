# Tabela de Correntes - PFD da Penicilina G

## Objetivo
Este arquivo converte o estudo da penicilina em uma tabela de correntes no estilo `PFD` (`Process Flow Diagram`), isto e, uma tabela que organiza o processo em correntes numeradas.

## Como ler esta tabela

### Definicao simples
Uma corrente e tudo o que flui de uma etapa para outra.

### Definicao tecnica
No `PFD`, cada corrente recebe um numero e uma composicao resumida.

### O que vamos rastrear aqui
Para manter o modelo didatico e usavel, vamos rastrear quatro grupos principais:

- `Penicilina`
- `Biomassa`
- `Solvente`
- `Agua + solutos dissolvidos`

## Regra importante
Nem todas as correntes abaixo representam um fechamento rigoroso de todos os componentes do processo real.
Elas representam uma `base conceitual consistente` para:

- montar fluxograma;
- preencher Excel;
- construir dashboard;
- discutir perdas e recuperacoes.

## 1. Premissas adicionais para esta tabela

Para tornar o trecho de extracao legivel no `PFD`, adotamos duas premissas extras:

### Premissa A - Solvente de extracao
Usaremos `acetato de butila` como solvente representativo.

### Premissa B - Relacao solvente/alimentacao
Assumiremos uma circulacao de solvente fresco equivalente a:

`S/F = 0.25 kg solvente / kg de liquido alimentado ao extrator`

Como o liquido para extracao e `23125 kg`:

`m_solvente = 0.25 * 23125 = 5781.3 kg`

### Premissa C - Arraste aquoso para a fase organica
Assumiremos `1%` de arraste da fase aquosa para a fase organica:

`m_entrainment = 0.01 * 23125 = 231.3 kg`

## 2. Lista de correntes principais

## Corrente 101 - Caldo fermentado

### Descricao
Saida do fermentador antes da remocao de biomassa.

| Item | Valor (kg) |
|---|---:|
| Massa total | 25339.0 |
| Penicilina | 1106.9 |
| Biomassa | 442.8 |
| Solvente | 0.0 |
| Agua + solutos dissolvidos | 23789.3 |

## Corrente 102 - Torta de biomassa

### Descricao
Corrente retirada no filtro/centrifuga.

| Item | Valor (kg) |
|---|---:|
| Massa total | 2214.0 |
| Penicilina perdida com a torta | 5.5 |
| Biomassa | 442.8 |
| Solvente | 0.0 |
| Agua + solutos dissolvidos | 1765.7 |

## Corrente 103 - Filtrado clarificado

### Descricao
Corrente liquida que segue para a extracao.

| Item | Valor (kg) |
|---|---:|
| Massa total | 23125.0 |
| Penicilina | 1101.4 |
| Biomassa | 0.0 |
| Solvente | 0.0 |
| Agua + solutos dissolvidos | 22023.6 |

## Corrente 104 - Solvente para extracao

### Descricao
Entrada de solvente no extrator.

| Item | Valor (kg) |
|---|---:|
| Massa total | 5781.3 |
| Penicilina | 0.0 |
| Biomassa | 0.0 |
| Solvente | 5781.3 |
| Agua + solutos dissolvidos | 0.0 |

## Corrente 105 - Extrato organico rico em penicilina

### Descricao
Fase organica apos a extracao primaria.

### Calculo da penicilina
Penicilina extraida:

`1101.4 * 0.97 = 1068.4 kg`

### Composicao assumida

| Item | Valor (kg) |
|---|---:|
| Massa total | 7081.0 |
| Penicilina | 1068.4 |
| Biomassa | 0.0 |
| Solvente | 5781.3 |
| Agua + solutos dissolvidos arrastados | 231.3 |

## Corrente 106 - Rafinado aquoso

### Descricao
Fase aquosa que sai do extrator.

### Composicao

| Item | Valor (kg) |
|---|---:|
| Massa total | 21825.3 |
| Penicilina | 33.0 |
| Biomassa | 0.0 |
| Solvente | 0.0 |
| Agua + solutos dissolvidos | 21792.3 |

## Corrente 107 - Solucao purificada para cristalizacao

### Descricao
Corrente apos reextracao/purificacao.

| Item | Valor (kg) |
|---|---:|
| Massa total | nao fixado neste nivel |
| Penicilina | 1025.7 |
| Biomassa | 0.0 |
| Solvente | traços / nao contabilizado |
| Agua + solutos dissolvidos | restante |

### Observacao
Nesta etapa, o mais importante para o `PFD` conceitual e a carga de penicilina disponivel para cristalizacao.

## Corrente 108 - Licor-mae / perdas da cristalizacao

### Descricao
Perda de penicilina na cristalizacao e filtracao.

| Item | Valor (kg) |
|---|---:|
| Massa total | nao fixado neste nivel |
| Penicilina | 20.5 |
| Biomassa | 0.0 |
| Solvente | residual / nao fixado |
| Agua + solutos dissolvidos | restante |

## Corrente 109 - Cristais umidos

### Descricao
Bolo umido que entra no secador.

### Valores herdados do balanco de secagem

| Item | Valor (kg) |
|---|---:|
| Massa total | 1256.5 |
| Penicilina / solido seco util | 1005.2 |
| Biomassa | 0.0 |
| Solvente | desprezado |
| Agua | 251.3 |

## Corrente 110 - Produto final

### Descricao
Penicilina G final seca.

| Item | Valor (kg) |
|---|---:|
| Massa total umida final | 1010.1 |
| Penicilina final seca | 1000.0 |
| Biomassa | 0.0 |
| Solvente | 0.0 |
| Agua residual | 10.1 |

## Corrente 111 - Agua evaporada na secagem

### Descricao
Umidade removida no secador.

| Item | Valor (kg) |
|---|---:|
| Massa total | 241.2 |
| Penicilina | 0.0 |
| Biomassa | 0.0 |
| Solvente | 0.0 |
| Agua evaporada | 241.2 |

## 3. Tabela consolidada no formato PFD

| Corrente | Descricao | Massa total (kg) | Penicilina (kg) | Biomassa (kg) | Solvente (kg) | Agua + solutos (kg) |
|---|---|---:|---:|---:|---:|---:|
| 101 | Caldo fermentado | 25339.0 | 1106.9 | 442.8 | 0.0 | 23789.3 |
| 102 | Torta de biomassa | 2214.0 | 5.5 | 442.8 | 0.0 | 1765.7 |
| 103 | Filtrado clarificado | 23125.0 | 1101.4 | 0.0 | 0.0 | 22023.6 |
| 104 | Solvente para extracao | 5781.3 | 0.0 | 0.0 | 5781.3 | 0.0 |
| 105 | Extrato organico | 7081.0 | 1068.4 | 0.0 | 5781.3 | 231.3 |
| 106 | Rafinado aquoso | 21825.3 | 33.0 | 0.0 | 0.0 | 21792.3 |
| 107 | Solucao purificada | nao fixado | 1025.7 | 0.0 | tracos | restante |
| 108 | Licor-mae / perdas | nao fixado | 20.5 | 0.0 | residual | restante |
| 109 | Cristais umidos | 1256.5 | 1005.2 | 0.0 | 0.0 | 251.3 |
| 110 | Produto final | 1010.1 | 1000.0 | 0.0 | 0.0 | 10.1 |
| 111 | Agua evaporada | 241.2 | 0.0 | 0.0 | 0.0 | 241.2 |

## 4. Como usar esta tabela no PFD

## 4.1 Regra pratica
No fluxograma, cada linha principal recebe o numero da corrente:

- `101` na saida do fermentador;
- `102` na descarga de biomassa;
- `103` para o filtrado;
- `104` na alimentacao de solvente;
- `105` e `106` nas duas saidas do extrator;
- `109` no bolo umido;
- `110` no produto final.

## 4.2 O que colocar embaixo do fluxograma
Voce pode montar uma tabela-resumo com:

- vazao total;
- temperatura;
- pressao;
- composicao resumida;
- observacoes.

## 4.3 Exemplo de informacoes adicionais por corrente

| Corrente | T sugerida | Observacao |
|---|---|---|
| 101 | 25 degC | caldo apos fermentacao |
| 103 | 5 degC apos resfriamento | filtrado acidificado para extracao |
| 105 | 5 degC | fase organica rica em penicilina |
| 109 | baixa temperatura de cristalizacao | cristais umidos |
| 110 | ambiente controlado | produto final seco |

## 5. O que esta tabela resolve

Ela permite:

- desenhar o `PFD`;
- numerar correntes;
- alimentar o Excel;
- montar graficos de distribuicao de massa;
- identificar perdas de produto.

## 6. Limites desta tabela

Ela ainda nao fecha, em nivel executivo:

- todas as especies dissolvidas;
- todo o ciclo de solvente reciclado;
- todas as utilidades;
- todas as correntes gasosas.

Por isso, ela deve ser lida como:

`PFD conceitual forte`, e nao ainda como `balanco final de engenharia detalhada`.

## 7. Resumo final em linguagem simples

Se voce olhar essa tabela como aluno iniciante, a leitura principal e:

- o produto nasce diluido no caldo;
- uma parte dele se perde com biomassa;
- a maior parte vai para a extracao;
- depois ele e purificado;
- depois vira cristal umido;
- por fim vira produto seco.

Em outras palavras:
o `PFD` conta a historia da massa atravessando o processo.
