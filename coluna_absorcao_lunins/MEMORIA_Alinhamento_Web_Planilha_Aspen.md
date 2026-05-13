# Coluna de absorção Lunins — alinhamento Web · Planilha · Aspen (rascunho defendível)

**Fonte primária numérica:** ficheiro de grupo **«ultima planilha.xlsx»**, aba **«Coluna de Absorção»** (bloco de resumo aproximadamente **R62–R66** e grelha **K4–O13** para o declive **O/N**). **Ferramenta Web:** `coluna_absorcao_lunins/index.html` (preset **«ultima planilha»** + preset didático **Lunins v1**).

**A melhorar (explícito):** **HETP** não consta na «ultima planilha» — mantém-se valor típico **0,6 m** na Web até haver folha de recheio; **Q_L** da coluna não tem aba *Purificacao_Biometano* neste ficheiro — mantém-se **proxy 1668,571 m³/d ÷ 24** alinhado ao maestro de referência do projecto; **altura geométrica** «Coluna de Absorção» **15 m** em **Equipamentos!H12** é **cota de equipamento**, não confundir com **Z = N·HETP** sem reconciliação.

---

## Tabela «fonte → valor → confiança» (dados fechados vs pendentes)

| Grandeza | Valor (planilha / derivado) | Fonte | Confiança |
|----------|-----------------------------|-------|-----------|
| **L′** | 8 003 238,361 mol/h | «ultima planilha» C62 | Alta (célula fechada) |
| **V′** | 12 715,694 mol/h | «ultima planilha» C63 | Alta |
| **L′/V′** | ≈ 629,17 | C62/C63 | Alta |
| **y_ent** | 0,68 (—) | «ultima planilha» C65 | Alta |
| **y_sai** | 0,061 (—) | «ultima planilha» C66 | Alta |
| **x₀** | 0 | C64 / G62 | Alta |
| **x_sai,ℓ** (fundo, OL) | 0,00328377… | «ultima planilha» G66 | Alta |
| **Y_ent** | 2,125 | «ultima planilha» G63 (= y/(1−y)) | Alta |
| **Y_sai** | 0,0649627… | «ultima planilha» G64 | Alta |
| **m em y\* = m x** | **206** (média O/N em K4–K13) | Coluna O ÷ N da grelha | Média — recta global; VLE real pode curvar |
| **L/G** na Web (pendente total) | (y_ent−y_sai)/x_sai,ℓ ≈ **188,50** | Derivado dos extremos da OL em (y,x) | Alta *condicionada* à mesma x_sai,ℓ |
| **A = (L/G)/m** (base y,x Web) | ≈ **0,915** | 188,5/206 | Alta *algébrica*; interpretação física **não** é a de «absorção fácil» no sentido diluído clássico |
| **A_inerte = (L′/V′)/m** | ≈ **3,055** | (629,17)/206 | Alta — coerente com Seader (inertes) |
| **N (Kremser Web, y,x)** | calculado pela ferramenta com *A* e *m* anteriores | Malha fechada da página | **Média a baixa** se y_ent elevado: validar com Y,X ou simulador |
| **HETP** | 0,6 m (default Web) | **PENDENTE** fabricante | Baixa até folha |
| **Q_G** | 7342,854/24 m³/h | BM!G23 | Média (proxy documentado) |
| **Q_L** | 1668,571/24 m³/h | Referência maestro (aba ausente aqui) | Média — **A MELHORAR** |

---

## A) Resumo executivo (15 linhas)

1. O **objecto** é o **water scrubbing** de CO₂ com **rastreio**: a planilha do grupo usa **L′**, **V′** e composições em **y**, **x** e também **Y**, **X** (soluto-livre).  
2. A **Web Lunins** implementa **Kremser** e **McCabe–Thiele** numa malha **linear em (y,x)** com **L/G** obtido como **pendente da recta de operação** em frações molares totais.  
3. Com **y_ent = 0,68**, **Y ≠ y**; a planilha regista **Y_ent = 2,125** (coerente com **0,68/(1−0,68)**).  
4. O **declive da equilíbrio** na grelha da planilha (**O/N**) é **≈ 206** em **y\* ≈ m·x** no intervalo tabulado — usamos esse **m** no preset «ultima planilha».  
5. **L/G** na Web = **(y_ent − y_sai)/x_sai,ℓ** ≈ **188,5**; **não** é numericamente igual a **L′/V′** ≈ **629** — são bases diferentes (total vs inerte; gás concentrado).  
6. **A = (L/G)/m** ≈ **0,915** (< 1) **não** contradiz a viabilidade **quando** se olha **A_inerte = (L′/V′)/m** ≈ **3,06** (> 1): o primeiro usa a convenção da ferramenta em **(y,x)**; o segundo alinha com a **planilha Seader**.  
7. O **preset didático Lunins** (**0,38 / 0,02**, **m = 0,35**, **L/G = 2,5**) permanece para **aula** em gás **diluído**; é **outro cenário** que o bloco **0,68 / 0,061**.  
8. **Paridade Aspen** no sentido **screening**: mesmo **núcleo algébrico** que um **RadFrac** ideal com **Henry linear** e **L/G** constantes **na mesma base** em que se escreve o modelo — **não** equivalência a **rate-based**, **EOS** ou **Murphree**.  
9. **Z = N·HETP** na Web escala com **HETP** ainda **proxy**; **15 m** em *Equipamentos* é **cota**, não **Z** validada.  
10. **Export** (CSV/Excel) inclui **Figuras** (URL, procedimento PNG) e, com preset planilha, **L′** e **V′** nas premissas.  
11. **Trabalho futuro:** HETP do fabricante; **Q_L** medido ou da aba Purificação; **diagrama ou RadFrac em Y,X**; comparar **N** com coluna da planilha se existir contagem explícita.  
12. **Figuras mínimas:** y–x, McCabe, esta tabela, excerto **R62–R66** da planilha.  
13. **Regra:** qualquer número em relatório oficial com **fonte** e **check**; quando **A<1** em **(y,x)** mas **A_inerte>1**, declarar **ambos**.  
14. **Conclusão intermédia:** a Web é **didática** e **útil para screening** em **diluído**; para **0,68** em **y**, usar **A_inerte** e **validação** externa de **N**.  
15. **Aspen/HYSYS rigoroso** continua necessário para **FEED** executivo, **ΔP**, **eficiência** e **VLE** não linear.

---

## B) Quadro hipóteses vs impacto

| Hipótese | Impacto |
|----------|---------|
| CO₂ **diluído** | **Y ≈ y**, **L/G ≈ L′/V′**; Kremser Web ≈ planilha |
| **y_ent** elevado (≈0,68) | **Y ≠ y**; **L/G** Web **≠** **L′/V′**; comparar **A** vs **A_inerte** |
| **y\* = m x** com **m** constante | Erro se **VLE** curvar; **m = 206** vem da grelha O/N |
| **HETP** único | **Z** linear em **N**; valor **0,6** é **placeholder** |
| **Q_G**, **Q_L** proxies | **D** e **FLV** indicativos até medições |

---

## C) Alinhamento planilha ↔ Web (passo a passo)

1. Carregar **Preset «ultima planilha»** na Web — importa **y_ent**, **y_sai**, **x₀**, **m**, **L/G** derivado, **L′**, **V′**.  
2. Verificar **x_sai,ℓ** na Web = **0,00328377** (fecha com planilha G66).  
3. Comparar **A** e **A_inerte** nos resultados — ler nota em **Análise executiva**.  
4. **Não** afirmar **N_Web = N_planilha** sem coluna de estágios na planilha ou export JSON do mesmo passo de cálculo.  
5. Para **discussão de relatório**, citar **«ultima planilha.xlsx»** e **versão** do `EXPORT_META.versaoRelatorio` no HTML.

---

## D) Discussão académica + limitações

A formulação **Seader** com **L′**, **V′**, **Y**, **X** existe precisamente para **evitar** a confusão entre **fluxos totais** e **inertes** quando o **soluto** não é traço. A ferramenta Web permanece deliberadamente num plano **(y,x)** **didático**; o preset da planilha **explicita a tensão** entre **A** e **A_inerte** em vez de escondê-la.

---

## E) Texto pronto — Discussão / Conclusões (colar e ajustar)

O dimensionamento da coluna de absorção foi discutido com base na **«ultima planilha.xlsx»** do grupo, nomeadamente na aba **«Coluna de Absorção»**, onde se documentam **L′**, **V′**, **y_ent**, **y_sai**, **x_sai,ℓ** e a **grelha de equilíbrio** com **declive O/N ≈ 206** na aproximação **y\* = m·x**. A **ferramenta Web** Lunins calcula **N** e **McCabe–Thiele** numa base **(y,x)** com **L/G = (y_ent − y_sai)/x_sai,ℓ**, o que produz **A = (L/G)/m < 1** apesar de a coluna ser termodinamicamente viável, situação que se clarifica com o indicador **A_inerte = (L′/V′)/m ≈ 3,1** extraído da mesma planilha. Conclui-se que, para **gás concentrado em CO₂**, a leitura do **factor de absorção** deve seguir as **definições em L′/V′** (ou **Y/X**) e **não** apenas o cociente **(L/G)/m** na base **(y,x)** da página, salvo após conversão explícita. A **altura Z = N·HETP** permanece dependente de **HETP** ainda **não** fornecido pelo fabricante do recheio (**a melhorar**). O **diâmetro D** na Web é um **proxy hidráulico**. A comparação com **Aspen Plus / HYSYS** limita-se ao **nível de screening** com **estágios ideais**; **não** se reivindica paridade com **rate-based** nem com **pacotes EOS completos**.

---

## F) Lista de figuras / anexos sugeridos

1. Diagrama **y–x** (Web ou export PNG).  
2. **McCabe–Thiele** (Web ou export PNG).  
3. Excerto **«ultima planilha.xlsx»** R62–R66 e, opcionalmente, grelha K4–O13.  
4. Tabela **fonte → valor → confiança** (folha **Rastreio** do export Excel).  
5. Fluxograma de decisão **A** vs **A_inerte** (relatório).

---

*Documento alinhado à leitura automática da planilha «ultima planilha.xlsx» em 2026-05-13. Rever após nova versão da planilha.*
