$ErrorActionPreference = "Stop"
$outputPath = Join-Path (Get-Location) "Planilha_Biogas_Codigestao.xlsx"

function Set-HeaderStyle($range) {
    $range.Font.Bold = $true
    $range.Interior.Color = 15773696
    $range.Borders.LineStyle = 1
}
function Set-TitleStyle($range) {
    $range.Font.Bold = $true
    $range.Font.Size = 14
}
function Set-SubtitleStyle($range) {
    $range.Font.Bold = $true
    $range.Font.Size = 11
    $range.Font.Color = 8421504
}
function Set-CardStyle($range, $color) {
    $range.Merge() | Out-Null
    $range.WrapText = $true
    $range.HorizontalAlignment = -4108
    $range.VerticalAlignment = -4108
    $range.Font.Bold = $true
    $range.Font.Size = 12
    $range.Interior.Color = $color
    $range.Borders.LineStyle = 1
}
function Set-Cell($cell, $value) {
    if ($null -eq $value) { $cell.Value2 = ""; return }
    if ($value -is [string]) {
        if ($value.StartsWith("=")) { $cell.Formula = $value } else { $cell.Value2 = [string]$value }
        return
    }
    $cell.Value2 = [double]$value
}
function AutoFit-UsedRange($sheet) { $sheet.UsedRange.Columns.AutoFit() | Out-Null }

$excel = $null; $workbook = $null

try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $workbook = $excel.Workbooks.Add()

    while ($workbook.Worksheets.Count -lt 23) { $null = $workbook.Worksheets.Add() }

    $sheetNames = @(
        "Premissas",
        "Calculos_Massa",
        "Fechamento_Elementar",
        "Correntes_PFD",
        "Balanco_Energia",
        "Fermentacao",
        "Verificacoes",
        "Dicionario_Variaveis",
        "Conceitos",
        "Utilidades",
        "Custos",
        "PFD_Visual",
        "Resumo_Executivo",
        "KPIs",
        "Dashboard",
        "Secagem_Digestato",
        "Dimensionamento",
        "Materiais",
        "Otimizacao",
        "CAPEX",
        "OPEX",
        "Fluxo_Caixa",
        "Indicadores_Econ"
    )

    for ($i = 1; $i -le $sheetNames.Count; $i++) { $workbook.Worksheets.Item($i).Name = $sheetNames[$i - 1] }
    while ($workbook.Worksheets.Count -gt $sheetNames.Count) { $workbook.Worksheets.Item($workbook.Worksheets.Count).Delete() }

    $prem = $workbook.Worksheets.Item("Premissas")
    $calc = $workbook.Worksheets.Item("Calculos_Massa")
    $elem = $workbook.Worksheets.Item("Fechamento_Elementar")
    $corr = $workbook.Worksheets.Item("Correntes_PFD")
    $ener = $workbook.Worksheets.Item("Balanco_Energia")
    $ferm = $workbook.Worksheets.Item("Fermentacao")
    $veri = $workbook.Worksheets.Item("Verificacoes")
    $dict = $workbook.Worksheets.Item("Dicionario_Variaveis")
    $conc = $workbook.Worksheets.Item("Conceitos")
    $util = $workbook.Worksheets.Item("Utilidades")
    $cost = $workbook.Worksheets.Item("Custos")
    $pfvd = $workbook.Worksheets.Item("PFD_Visual")
    $exec = $workbook.Worksheets.Item("Resumo_Executivo")
    $kpi  = $workbook.Worksheets.Item("KPIs")
    $dash = $workbook.Worksheets.Item("Dashboard")
    $seca = $workbook.Worksheets.Item("Secagem_Digestato")
    $dime = $workbook.Worksheets.Item("Dimensionamento")
    $mate = $workbook.Worksheets.Item("Materiais")
    $otim = $workbook.Worksheets.Item("Otimizacao")
    $capx = $workbook.Worksheets.Item("CAPEX")
    $opex = $workbook.Worksheets.Item("OPEX")
    $flux = $workbook.Worksheets.Item("Fluxo_Caixa")
    $indi = $workbook.Worksheets.Item("Indicadores_Econ")

    # ==============================
    # === PREMISSAS (38 linhas) ===
    # ==============================
    $prem.Range("A1").Value2 = "Premissas do modelo - Biogas por Codigestao Anaerobia"
    Set-TitleStyle $prem.Range("A1")
    $prem.Range("A2").Value2 = "Todos os valores sao editaveis. A planilha recalcula automaticamente."
    Set-SubtitleStyle $prem.Range("A2")
    $prem.Range("A4:F4").Value2 = @("ID","Parametro","Valor","Unidade","Fonte","Mini-resumo didatico")
    Set-HeaderStyle $prem.Range("A4:F4")

    $premissas = @(
        @("P01","Volume total de mistura",100,"m3/dia","Base de calculo","Quanto liquido entra no digestor por dia."),
        @("P02","Fracao volumetrica lodo",0.50,"-","Premissa","Metade do volume vem do lodo de esgoto."),
        @("P03","Fracao volumetrica vinhaca",0.30,"-","Premissa","30% do volume e vinhaca de cana."),
        @("P04","Fracao volumetrica residuo organico",0.20,"-","Premissa","20% do volume sao residuos organicos."),
        @("P05","Densidade lodo",1020,"kg/m3","PROSAB","Massa por litro do lodo."),
        @("P06","Densidade vinhaca",1009,"kg/m3","RVQ 2024","Massa por litro da vinhaca."),
        @("P07","Densidade residuo organico",1050,"kg/m3","Literatura","Massa por litro do residuo."),
        @("P08","ST lodo",3.5,"%","Embrapa 2024","Solidos totais: tudo que sobra se secar o lodo."),
        @("P09","ST vinhaca",1.7,"%","RVQ 2024","Solidos totais da vinhaca; bem diluida."),
        @("P10","ST residuo organico",20.0,"%","Literatura","Solidos totais do residuo; concentrado."),
        @("P11","SV/ST lodo",65,"%","Embrapa","Quanto dos solidos e materia organica no lodo."),
        @("P12","SV/ST vinhaca",75,"%","Literatura","Quanto dos solidos e materia organica na vinhaca."),
        @("P13","SV/ST residuo organico",85,"%","Literatura","Quanto dos solidos e materia organica no residuo."),
        @("P14","C/N lodo",8,"-","Literatura BR","Relacao C/N do lodo; baixa sozinha (ideal 20-30)."),
        @("P15","C/N vinhaca",25,"-","Literatura","C/N da vinhaca; ajuda a equilibrar."),
        @("P16","C/N residuo organico",30,"-","Literatura","C/N do residuo; puxa para a faixa ideal."),
        @("P17","C% lodo (base SV)",51.0,"%","Nature/Sci.Reports","Carbono elementar no SV seco do lodo."),
        @("P18","H% lodo (base SV)",7.9,"%","Nature/Sci.Reports","Hidrogenio elementar no SV seco do lodo."),
        @("P19","O% lodo (base SV)",34.6,"%","Nature/Sci.Reports","Oxigenio elementar no SV seco do lodo."),
        @("P20","N% lodo (base SV)",5.4,"%","Nature/Sci.Reports","Nitrogenio elementar no SV seco do lodo."),
        @("P21","S% lodo (base SV)",1.1,"%","Nature/Sci.Reports","Enxofre elementar no SV seco do lodo."),
        @("P22","C% vinhaca (base SV)",43.0,"%","Estimativa lit.","Carbono elementar no SV seco da vinhaca."),
        @("P23","H% vinhaca (base SV)",6.5,"%","Estimativa lit.","Hidrogenio elementar no SV seco da vinhaca."),
        @("P24","O% vinhaca (base SV)",46.0,"%","Estimativa lit.","Oxigenio elementar no SV seco da vinhaca."),
        @("P25","N% vinhaca (base SV)",3.5,"%","Estimativa lit.","Nitrogenio elementar no SV seco da vinhaca."),
        @("P26","S% vinhaca (base SV)",1.0,"%","Estimativa lit.","Enxofre elementar no SV seco da vinhaca."),
        @("P27","C% residuo (base SV)",48.0,"%","MDPI 2019","Carbono elementar no SV seco do residuo."),
        @("P28","H% residuo (base SV)",6.4,"%","MDPI 2019","Hidrogenio elementar no SV seco do residuo."),
        @("P29","O% residuo (base SV)",42.0,"%","MDPI 2019 (ajust.)","Oxigenio elementar no SV seco do residuo (ajustado por diferenca para fechar 100%)."),
        @("P30","N% residuo (base SV)",3.2,"%","MDPI 2019","Nitrogenio elementar no SV seco do residuo."),
        @("P31","S% residuo (base SV)",0.4,"%","MDPI 2019","Enxofre elementar no SV seco do residuo."),
        @("P32","Temperatura de entrada",20,"degC","Media ambiental","Temperatura da mistura antes do digestor."),
        @("P33","Temperatura do digestor",35,"degC","Mesofilico","Temperatura operacional do reator."),
        @("P34","TRH",20,"dias","Tipico codigestao","Tempo medio que o material fica no reator."),
        @("P35","Eficiencia de remocao de SV",55,"%","UFPR 2024","Quanto da materia organica e digerida."),
        @("P36","Rendimento de biogas",0.60,"Nm3/kgSV rem","UFPR 2024","Volume de biogas por kg de SV consumido."),
        @("P37","Teor de CH4 no biogas",62,"% vol","UFPR 2024","Fracao de metano no biogas."),
        @("P38","Teor de CO2 no biogas",36,"% vol","Complemento","Fracao de CO2 no biogas."),
        @("P39","Teor de outros gases",2,"% vol","Tracos","H2S, H2O, etc."),
        @("P40","Cp da mistura",4.0,"kJ/kg.K","Aprox. aquosa","Energia para aquecer 1 kg em 1 grau."),
        @("P41","Perdas de calor do reator",15,"%","Premissa","Perdas pelas paredes, topo e fundo."),
        @("P42","PCI do metano",35.8,"MJ/Nm3","Literatura","Energia ao queimar 1 Nm3 de CH4."),
        @("P43","Eficiencia eletrica CHP",0.38,"-","Motor a gas","Fracao da energia que vira eletricidade."),
        @("P44","Eficiencia termica CHP",0.42,"-","Motor a gas","Fracao que vira calor recuperavel."),
        @("P45","Consumo auxiliar eletrico",0.05,"-","Premissa","Bombas, mistura, instrumentacao (5%)."),
        @("P46","Calor reacao anaerobia",1.2,"MJ/kgSV rem","Literatura","Calor gerado pela bioconversao."),
        @("P47","Preco eletricidade",0.75,"R$/kWh","Premissa","Valor conceitual editavel."),
        @("P48","Preco descarte digestato",0.30,"R$/kg ST","Premissa","Custo de destinacao do digestato."),
        @("P49","ST do digestato desaguado",25,"%","Premissa","Concentracao de solidos apos desaguamento."),
        @("P50","MM CH4",16,"kg/kmol","Constante","Massa molar do metano."),
        @("P51","MM CO2",44,"kg/kmol","Constante","Massa molar do dioxido de carbono."),
        @("P52","MM H2O",18,"kg/kmol","Constante","Massa molar da agua."),
        @("P53","M atomica C",12,"kg/kmol","Constante","Massa atomica do carbono."),
        @("P54","Volume molar normal",22.414,"Nm3/kmol","Constante","Volume de 1 kmol de gas ideal a 0C e 1 atm."),
        @("P55","MM outros gases (media)",29,"kg/kmol","Premissa","Massa molar media dos gases minoritarios.")
    )

    $row = 5
    foreach ($item in $premissas) {
        for ($col = 1; $col -le 6; $col++) { Set-Cell $prem.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }

    # ==============================
    # === CALCULOS_MASSA ===
    # ==============================
    $calc.Range("A1").Value2 = "Calculos de massa - Balanco global"
    Set-TitleStyle $calc.Range("A1")
    $calc.Range("A2").Value2 = "Todas as celulas de valor (coluna B) sao formulas que referenciam Premissas."
    Set-SubtitleStyle $calc.Range("A2")
    $calc.Range("A4:D4").Value2 = @("ID","Valor","Unidade","Mini-resumo didatico")
    Set-HeaderStyle $calc.Range("A4:D4")

    $calcRows = @(
        @("Volume lodo (m3/dia)","=Premissas!C5*Premissas!C6","m3/dia","Volume total x fracao de lodo."),
        @("Volume vinhaca (m3/dia)","=Premissas!C5*Premissas!C7","m3/dia","Volume total x fracao de vinhaca."),
        @("Volume residuo (m3/dia)","=Premissas!C5*Premissas!C8","m3/dia","Volume total x fracao de residuo."),
        @("Massa lodo (kg/dia)","=B5*Premissas!C9","kg/dia","Volume x densidade do lodo."),
        @("Massa vinhaca (kg/dia)","=B6*Premissas!C10","kg/dia","Volume x densidade da vinhaca."),
        @("Massa residuo (kg/dia)","=B7*Premissas!C11","kg/dia","Volume x densidade do residuo."),
        @("Massa total entrada (kg/dia)","=B8+B9+B10","kg/dia","Soma das tres correntes."),
        @("ST lodo (kg/dia)","=B8*Premissas!C12/100","kg/dia","Massa lodo x %ST."),
        @("ST vinhaca (kg/dia)","=B9*Premissas!C13/100","kg/dia","Massa vinhaca x %ST."),
        @("ST residuo (kg/dia)","=B10*Premissas!C14/100","kg/dia","Massa residuo x %ST."),
        @("ST total entrada (kg/dia)","=B12+B13+B14","kg/dia","Carga solida total."),
        @("SV lodo (kg/dia)","=B12*Premissas!C15/100","kg/dia","ST lodo x %SV/ST."),
        @("SV vinhaca (kg/dia)","=B13*Premissas!C16/100","kg/dia","ST vinhaca x %SV/ST."),
        @("SV residuo (kg/dia)","=B14*Premissas!C17/100","kg/dia","ST residuo x %SV/ST."),
        @("SV total entrada (kg/dia)","=B16+B17+B18","kg/dia","Materia organica total disponivel."),
        @("C/N mistura (ponderada SV)","=(B16*Premissas!C18+B17*Premissas!C19+B18*Premissas!C20)/B19","-","Media ponderada; ideal 20-30."),
        @("SV removido (kg/dia)","=B19*Premissas!C39/100","kg/dia","SV entrada x eficiencia de remocao."),
        @("Volume biogas (Nm3/dia)","=B21*Premissas!C40","Nm3/dia","SV removido x rendimento."),
        @("Volume CH4 (Nm3/dia)","=B22*Premissas!C41/100","Nm3/dia","Biogas x %CH4."),
        @("Volume CO2 (Nm3/dia)","=B22*Premissas!C42/100","Nm3/dia","Biogas x %CO2."),
        @("Volume outros (Nm3/dia)","=B22*Premissas!C43/100","Nm3/dia","Biogas x %outros."),
        @("n CH4 (kmol/dia)","=B23/Premissas!C58","kmol/dia","Volume CH4 / volume molar normal."),
        @("m CH4 (kg/dia)","=B26*Premissas!C54","kg/dia","n CH4 x MM CH4."),
        @("n CO2 (kmol/dia)","=B24/Premissas!C58","kmol/dia","Volume CO2 / volume molar normal."),
        @("m CO2 (kg/dia)","=B28*Premissas!C55","kg/dia","n CO2 x MM CO2."),
        @("n outros (kmol/dia)","=B25/Premissas!C58","kmol/dia","Volume outros / volume molar normal."),
        @("m outros (kg/dia)","=B30*Premissas!C59","kg/dia","n outros x MM outros."),
        @("Massa biogas total (kg/dia)","=B27+B29+B31","kg/dia","Soma CH4 + CO2 + outros."),
        @("Volume reator (m3)","=Premissas!C5*Premissas!C38","m3","Volume total x TRH."),
        @("COV (kgSV/m3.dia)","=B19/B33","kgSV/m3.dia","SV entrada / volume reator. Faixa: 1-4."),
        @("SV residual (kg/dia)","=B19-B21","kg/dia","SV nao digerido = SV entrada - SV removido."),
        @("SF entrada (kg/dia)","=B15-B19","kg/dia","Solidos fixos = ST - SV."),
        @("ST digestato (kg/dia)","=B35+B36","kg/dia","SV residual + SF."),
        @("Massa digestato (kg/dia)","=B11-B32","kg/dia","Massa entrada - massa biogas.")
    )

    $row = 5
    foreach ($item in $calcRows) {
        Set-Cell $calc.Cells.Item($row,1) $item[0]
        Set-Cell $calc.Cells.Item($row,2) $item[1]
        Set-Cell $calc.Cells.Item($row,3) $item[2]
        Set-Cell $calc.Cells.Item($row,4) $item[3]
        $row++
    }
    $calc.Range("B5:B38").NumberFormat = "0.0000"

    # ==============================
    # === FECHAMENTO ELEMENTAR ===
    # ==============================
    $elem.Range("A1").Value2 = "Fechamento elementar C/H/O/N/S"
    Set-TitleStyle $elem.Range("A1")
    $elem.Range("A2").Value2 = "Rastreamento dos elementos quimicos desde a entrada ate biogas e digestato."
    Set-SubtitleStyle $elem.Range("A2")

    $elem.Range("A4:H4").Value2 = @("Elemento","Lodo (kg/dia)","Vinhaca (kg/dia)","Residuo (kg/dia)","Total entrada (kg/dia)","No biogas (kg/dia)","Residual digestato (kg/dia)","Mini-resumo")
    Set-HeaderStyle $elem.Range("A4:H4")

    # C: SV_lodo*C%lodo/100, etc. C no biogas = n_CH4*12 + n_CO2*12
    Set-Cell $elem.Cells.Item(5,1) "C (Carbono)"
    Set-Cell $elem.Cells.Item(5,2) "=Calculos_Massa!B16*Premissas!C21/100"
    Set-Cell $elem.Cells.Item(5,3) "=Calculos_Massa!B17*Premissas!C26/100"
    Set-Cell $elem.Cells.Item(5,4) "=Calculos_Massa!B18*Premissas!C31/100"
    Set-Cell $elem.Cells.Item(5,5) "=B5+C5+D5"
    Set-Cell $elem.Cells.Item(5,6) "=Calculos_Massa!B26*Premissas!C57+Calculos_Massa!B28*Premissas!C57"
    Set-Cell $elem.Cells.Item(5,7) "=E5-F5"
    Set-Cell $elem.Cells.Item(5,8) "C no biogas: 12 kg/kmol por cada mol de CH4 e CO2."

    # H: SV*H%/100. H no biogas = n_CH4 * 4 (4 H por CH4, mas em kg: n_CH4 * 4 * 1)
    Set-Cell $elem.Cells.Item(6,1) "H (Hidrogenio)"
    Set-Cell $elem.Cells.Item(6,2) "=Calculos_Massa!B16*Premissas!C22/100"
    Set-Cell $elem.Cells.Item(6,3) "=Calculos_Massa!B17*Premissas!C27/100"
    Set-Cell $elem.Cells.Item(6,4) "=Calculos_Massa!B18*Premissas!C32/100"
    Set-Cell $elem.Cells.Item(6,5) "=B6+C6+D6"
    Set-Cell $elem.Cells.Item(6,6) "=Calculos_Massa!B26*4"
    Set-Cell $elem.Cells.Item(6,7) "=E6-F6"
    Set-Cell $elem.Cells.Item(6,8) "H no biogas: 4 kg H por kmol de CH4."

    # O: SV*O%/100. O no biogas = n_CO2 * 32
    Set-Cell $elem.Cells.Item(7,1) "O (Oxigenio)"
    Set-Cell $elem.Cells.Item(7,2) "=Calculos_Massa!B16*Premissas!C23/100"
    Set-Cell $elem.Cells.Item(7,3) "=Calculos_Massa!B17*Premissas!C28/100"
    Set-Cell $elem.Cells.Item(7,4) "=Calculos_Massa!B18*Premissas!C33/100"
    Set-Cell $elem.Cells.Item(7,5) "=B7+C7+D7"
    Set-Cell $elem.Cells.Item(7,6) "=Calculos_Massa!B28*32"
    Set-Cell $elem.Cells.Item(7,7) "=E7-F7"
    Set-Cell $elem.Cells.Item(7,8) "O no biogas: 32 kg O por kmol de CO2."

    # N
    Set-Cell $elem.Cells.Item(8,1) "N (Nitrogenio)"
    Set-Cell $elem.Cells.Item(8,2) "=Calculos_Massa!B16*Premissas!C24/100"
    Set-Cell $elem.Cells.Item(8,3) "=Calculos_Massa!B17*Premissas!C29/100"
    Set-Cell $elem.Cells.Item(8,4) "=Calculos_Massa!B18*Premissas!C34/100"
    Set-Cell $elem.Cells.Item(8,5) "=B8+C8+D8"
    Set-Cell $elem.Cells.Item(8,6) 0
    Set-Cell $elem.Cells.Item(8,7) "=E8-F8"
    Set-Cell $elem.Cells.Item(8,8) "N permanece no digestato (NH3 no gas desprezado)."

    # S
    Set-Cell $elem.Cells.Item(9,1) "S (Enxofre)"
    Set-Cell $elem.Cells.Item(9,2) "=Calculos_Massa!B16*Premissas!C25/100"
    Set-Cell $elem.Cells.Item(9,3) "=Calculos_Massa!B17*Premissas!C30/100"
    Set-Cell $elem.Cells.Item(9,4) "=Calculos_Massa!B18*Premissas!C35/100"
    Set-Cell $elem.Cells.Item(9,5) "=B9+C9+D9"
    Set-Cell $elem.Cells.Item(9,6) 0
    Set-Cell $elem.Cells.Item(9,7) "=E9-F9"
    Set-Cell $elem.Cells.Item(9,8) "S permanece no digestato (H2S no gas desprezado)."

    # Totais
    Set-Cell $elem.Cells.Item(10,1) "TOTAL"
    for ($col = 2; $col -le 7; $col++) {
        $colLetter = [char](64 + $col)
        Set-Cell $elem.Cells.Item(10,$col) "=SUM(${colLetter}5:${colLetter}9)"
    }
    $elem.Range("B5:G10").NumberFormat = "0.0000"
    $elem.Range("A10:H10").Font.Bold = $true

    # C/N elementar
    $elem.Range("A12").Value2 = "C/N elementar da mistura (pela composicao):"
    $elem.Range("A12").Font.Bold = $true
    Set-Cell $elem.Cells.Item(12,2) "=E5/E8"
    $elem.Range("B12").NumberFormat = "0.00"
    $elem.Range("A13").Value2 = "Nota: diferente do C/N de catalogo (media ponderada ~24.6) porque este e derivado da analise elementar."

    # % C que sai no biogas
    $elem.Range("A15").Value2 = "% do C de entrada que sai como biogas:"
    $elem.Range("A15").Font.Bold = $true
    Set-Cell $elem.Cells.Item(15,2) "=F5/E5*100"
    $elem.Range("B15").NumberFormat = "0.00"
    $elem.Range("C15").Value2 = "%"

    $elem.Range("B5:G10").NumberFormat = "0.0000"

    # ==============================
    # === CORRENTES PFD ===
    # ==============================
    $corr.Range("A1").Value2 = "Tabela de correntes - PFD"
    Set-TitleStyle $corr.Range("A1")
    $corr.Range("A2").Value2 = "Cada corrente numerada pode ser conectada no diagrama de fluxo de processo."
    Set-SubtitleStyle $corr.Range("A2")
    $corr.Range("A4:G4").Value2 = @("Corrente","Descricao","Massa total (kg/dia)","ST (kg/dia)","SV (kg/dia)","Agua+outros (kg/dia)","Mini-resumo")
    Set-HeaderStyle $corr.Range("A4:G4")

    $corrData = @(
        @(101,"Lodo de esgoto","=Calculos_Massa!B8","=Calculos_Massa!B12","=Calculos_Massa!B16","=C5-D5","Entrada do lodo; traz N e buffer."),
        @(102,"Vinhaca","=Calculos_Massa!B9","=Calculos_Massa!B13","=Calculos_Massa!B17","=C6-D6","Entrada da vinhaca; traz C e acidez."),
        @(103,"Residuo organico","=Calculos_Massa!B10","=Calculos_Massa!B14","=Calculos_Massa!B18","=C7-D7","Entrada do residuo; alto SV."),
        @(104,"Mistura alimentada","=Calculos_Massa!B11","=Calculos_Massa!B15","=Calculos_Massa!B19","=C8-D8","Soma das 3 correntes; entra no digestor."),
        @(105,"Biogas bruto","=Calculos_Massa!B32",0,0,"=C9","Gas produzido: CH4 + CO2 + tracos."),
        @(106,"Digestato bruto","=Calculos_Massa!B38","=Calculos_Massa!B37","=Calculos_Massa!B35","=C10-D10","Lodo estabilizado que sai do digestor."),
        @(107,"CH4 no biogas","=Calculos_Massa!B27","-","-","=C11","Componente combustivel do biogas."),
        @(108,"CO2 no biogas","=Calculos_Massa!B29","-","-","=C12","Inerte; diluente do biogas."),
        @(109,"Digestato desaguado (torta)","=Calculos_Massa!B37/Premissas!C53*100","=Calculos_Massa!B37","=Calculos_Massa!B35","=C13-D13","Torta a 25% ST apos desaguamento."),
        @(110,"Agua separada do digestato","=C10-C13",0,0,"=C14","Filtrado/centrifugado; retorna ou trata.")
    )

    $row = 5
    foreach ($item in $corrData) {
        for ($col = 1; $col -le 7; $col++) { Set-Cell $corr.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $corr.Range("C5:F14").NumberFormat = "0.0000"

    # ==============================
    # === BALANCO DE ENERGIA ===
    # ==============================
    $ener.Range("A1").Value2 = "Balanco de energia completo"
    Set-TitleStyle $ener.Range("A1")
    $ener.Range("A2").Value2 = "Inclui calor de reacao anaerobia, aquecimento, perdas, CHP e eletricidade."
    Set-SubtitleStyle $ener.Range("A2")
    $ener.Range("A4:D4").Value2 = @("Grandeza","Valor","Unidade","Mini-resumo didatico")
    Set-HeaderStyle $ener.Range("A4:D4")

    $enerRows = @(
        @("Q aquecimento mistura","=Calculos_Massa!B11*Premissas!C44*(Premissas!C37-Premissas!C36)/1000","MJ/dia","Massa x Cp x DeltaT. Aquecer de 20 a 35 degC."),
        @("Q perdas reator","=B5*Premissas!C45/100","MJ/dia","Perdas pelas paredes = 15% do calor de aquecimento."),
        @("Q reacao anaerobia","=Premissas!C50*Calculos_Massa!B21","MJ/dia","Calor exotermico = 1.2 MJ/kgSV removido."),
        @("Q demanda termica liquida","=B5+B6-B7","MJ/dia","Aquecimento + perdas - calor da reacao."),
        @("Energia no biogas (PCI)","=Calculos_Massa!B23*Premissas!C46","MJ/dia","Volume CH4 x PCI metano."),
        @("E eletrica CHP (MJ/dia)","=B9*Premissas!C47","MJ/dia","Energia biogas x eficiencia eletrica."),
        @("E eletrica CHP (kWh/dia)","=B10/3.6","kWh/dia","Conversao MJ para kWh (1 kWh = 3.6 MJ)."),
        @("Q calor recuperavel CHP","=B9*Premissas!C48","MJ/dia","Energia biogas x eficiencia termica."),
        @("Q excedente termico","=B12-B8","MJ/dia","Calor CHP - demanda. Se > 0, sobra calor."),
        @("E auxiliar eletrica","=B11*Premissas!C49","kWh/dia","5% da eletricidade gerada."),
        @("E eletrica liquida","=B11-B14","kWh/dia","Eletricidade gerada - consumo auxiliar."),
        @("Potencia eletrica media","=B15/24","kW","Eletricidade liquida / 24 horas.")
    )

    $row = 5
    foreach ($item in $enerRows) {
        for ($col = 1; $col -le 4; $col++) { Set-Cell $ener.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $ener.Range("B5:B16").NumberFormat = "0.0000"

    # ==============================
    # === FERMENTACAO (etapas) ===
    # ==============================
    $ferm.Range("A1").Value2 = "Etapas da digestao anaerobia - Modelo conceitual"
    Set-TitleStyle $ferm.Range("A1")
    $ferm.Range("A2").Value2 = "As 4 etapas biologicas e suas contribuicoes para o balanco."
    Set-SubtitleStyle $ferm.Range("A2")
    $ferm.Range("A4:F4").Value2 = @("Etapa","O que entra","O que sai","Agentes","Fracao do CH4","Mini-resumo")
    Set-HeaderStyle $ferm.Range("A4:F4")

    $fermRows = @(
        @("1. Hidrolise","Proteinas, carboidratos, lipideos","Aminoacidos, acucares, ac. graxos","Bacterias hidroliticas (enzimas extracelulares)","0%","Quebra moleculas grandes; etapa limitante com solidos."),
        @("2. Acidogenese","Aminoacidos, acucares, ac. graxos","Ac. acetico, propionico, butirico, etanol, H2, CO2","Bacterias acidogenicas (~90% da populacao)","0%","Gera acidos volateis; risco de acidificacao se muito rapida."),
        @("3. Acetogenese","Ac. propionico, butirico, etanol","Acetato, H2, CO2","Bacterias acetogenicas (sintróficas)","0%","Prepara substrato para metanogenicas; sensivel a H2."),
        @("4a. Metanogenese acetoclastica","Acetato (CH3COOH)","CH4 + CO2","Arqueias metanogenicas","~70%","CH3COOH -> CH4 + CO2. Rota principal."),
        @("4b. Metanogenese hidrogenotrofica","CO2 + H2","CH4 + H2O","Arqueias metanogenicas","~30%","CO2 + 4H2 -> CH4 + 2H2O. Rota secundaria."),
        @("TOTAL","Materia organica (SV)","Biogas + Digestato","Consorcio microbiano","100%","SV entrada -> SV removido + SV residual.")
    )

    $row = 5
    foreach ($item in $fermRows) {
        for ($col = 1; $col -le 6; $col++) { Set-Cell $ferm.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }

    # Conversao molar simplificada
    $ferm.Range("A12").Value2 = "Reacoes simplificadas (estequiometria)"
    Set-SubtitleStyle $ferm.Range("A12")
    $ferm.Range("A13:C13").Value2 = @("Reacao","Equacao","Observacao")
    Set-HeaderStyle $ferm.Range("A13:C13")
    Set-Cell $ferm.Cells.Item(14,1) "Acetoclastica"
    Set-Cell $ferm.Cells.Item(14,2) "CH3COOH -> CH4 + CO2"
    Set-Cell $ferm.Cells.Item(14,3) "1 mol acetato -> 1 mol CH4 + 1 mol CO2"
    Set-Cell $ferm.Cells.Item(15,1) "Hidrogenotrofica"
    Set-Cell $ferm.Cells.Item(15,2) "CO2 + 4H2 -> CH4 + 2H2O"
    Set-Cell $ferm.Cells.Item(15,3) "1 mol CO2 + 4 mol H2 -> 1 mol CH4 + 2 mol H2O"
    Set-Cell $ferm.Cells.Item(16,1) "Global simplificada"
    Set-Cell $ferm.Cells.Item(16,2) "C6H12O6 -> 3CH4 + 3CO2"
    Set-Cell $ferm.Cells.Item(16,3) "Glicose como substrato modelo; 1 mol glicose -> 3 mol CH4"

    # Producao por rota
    $ferm.Range("A18").Value2 = "Distribuicao de CH4 por rota (estimativa)"
    Set-SubtitleStyle $ferm.Range("A18")
    $ferm.Range("A19:C19").Value2 = @("Rota","CH4 (Nm3/dia)","CH4 (kg/dia)")
    Set-HeaderStyle $ferm.Range("A19:C19")
    Set-Cell $ferm.Cells.Item(20,1) "Acetoclastica (70%)"
    Set-Cell $ferm.Cells.Item(20,2) "=Calculos_Massa!B23*0.70"
    Set-Cell $ferm.Cells.Item(20,3) "=Calculos_Massa!B27*0.70"
    Set-Cell $ferm.Cells.Item(21,1) "Hidrogenotrofica (30%)"
    Set-Cell $ferm.Cells.Item(21,2) "=Calculos_Massa!B23*0.30"
    Set-Cell $ferm.Cells.Item(21,3) "=Calculos_Massa!B27*0.30"
    Set-Cell $ferm.Cells.Item(22,1) "TOTAL"
    Set-Cell $ferm.Cells.Item(22,2) "=B20+B21"
    Set-Cell $ferm.Cells.Item(22,3) "=C20+C21"
    $ferm.Range("B20:C22").NumberFormat = "0.0000"
    $ferm.Range("A22:C22").Font.Bold = $true

    # ==============================
    # === VERIFICACOES ===
    # ==============================
    $veri.Range("A1").Value2 = "Verificacoes de consistencia"
    Set-TitleStyle $veri.Range("A1")
    $veri.Range("A2").Value2 = "Todas as verificacoes devem retornar OK para o modelo ser valido."
    Set-SubtitleStyle $veri.Range("A2")
    $veri.Range("A4:E4").Value2 = @("Verificacao","Como calcula","Residual","Unidade","Status")
    Set-HeaderStyle $veri.Range("A4:E4")

    $veriRows = @(
        @("Fechamento massa global","Entrada - biogas - digestato","=Calculos_Massa!B11-Calculos_Massa!B32-Calculos_Massa!B38","kg/dia","=IF(ABS(C5)<1,""OK"",""REVISAR"")"),
        @("Fechamento ST digestato","SF + SV residual = ST digestato","=Calculos_Massa!B36+Calculos_Massa!B35-Calculos_Massa!B37","kg/dia","=IF(ABS(C6)<0.01,""OK"",""REVISAR"")"),
        @("C/N na faixa ideal (20-30)","Catalogo ponderado","=Calculos_Massa!B20","-","=IF(AND(C7>=20,C7<=30),""OK"",""FORA DA FAIXA"")"),
        @("COV na faixa tipica (1-4)","SV/Vreator","=Calculos_Massa!B34","kgSV/m3.dia","=IF(AND(C8>=1,C8<=4),""OK"",""FORA DA FAIXA"")"),
        @("Autossuficiencia termica","Calor CHP >= demanda","=Balanco_Energia!B12-Balanco_Energia!B8","MJ/dia","=IF(C9>=0,""OK - autossuficiente"",""DEFICIT TERMICO"")"),
        @("Composicao biogas = 100%","CH4+CO2+outros","=Premissas!C41+Premissas!C42+Premissas!C43","% vol","=IF(ABS(C10-100)<0.01,""OK"",""REVISAR"")"),
        @("Composicao elem. lodo = 100%","C+H+O+N+S","=Premissas!C21+Premissas!C22+Premissas!C23+Premissas!C24+Premissas!C25","% SV","=IF(ABS(C11-100)<0.1,""OK"",""REVISAR"")"),
        @("Composicao elem. vinhaca = 100%","C+H+O+N+S","=Premissas!C26+Premissas!C27+Premissas!C28+Premissas!C29+Premissas!C30","% SV","=IF(ABS(C12-100)<0.1,""OK"",""REVISAR"")"),
        @("Composicao elem. residuo >= 95%","C+H+O+N+S (dif = outros elem)","=Premissas!C31+Premissas!C32+Premissas!C33+Premissas!C34+Premissas!C35","% SV","=IF(C13>=95,""OK"",""REVISAR"")"),
        @("Fracoes volumetricas = 1","Lodo+vinhaca+residuo","=Premissas!C6+Premissas!C7+Premissas!C8","-","=IF(ABS(C14-1)<0.001,""OK"",""REVISAR"")")
    )

    $row = 5
    foreach ($item in $veriRows) {
        for ($col = 1; $col -le 5; $col++) { Set-Cell $veri.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $veri.Range("C5:C14").NumberFormat = "0.000000"

    # ==============================
    # === DICIONARIO VARIAVEIS ===
    # ==============================
    $dict.Range("A1").Value2 = "Dicionario de variaveis"
    Set-TitleStyle $dict.Range("A1")
    $dict.Range("A2").Value2 = "Cada variavel usada na planilha, explicada para leigo."
    Set-SubtitleStyle $dict.Range("A2")
    $dict.Range("A4:F4").Value2 = @("Variavel","Nome simples","Definicao para leigo","Unidade","Formula","Por que importa")
    Set-HeaderStyle $dict.Range("A4:F4")

    $dictRows = @(
        @("ST","Solidos totais","Tudo que sobra se secar completamente.","% ou kg/dia","Lab","Carga solida total."),
        @("SV","Solidos volateis","Parcela organica dos solidos.","% ST ou kg/dia","SV=ST*(SV/ST)","Combustivel dos microrganismos."),
        @("SF","Solidos fixos","Cinzas e minerais.","kg/dia","SF=ST-SV","Nao e digerida."),
        @("C/N","Relacao C/N","Proporcao carbono/nitrogenio.","-","Ponderada","Ideal 20-30."),
        @("TRH","Tempo retencao hidraulica","Tempo medio no reator.","dias","V/Q","Curto = digestao incompleta."),
        @("COV","Carga organica volumetrica","SV alimentada/volume/dia.","kgSV/m3.dia","SV/V","Alta = sobrecarga."),
        @("eta_SV","Eficiencia remocao SV","Fracao digerida.","% ou fracao","Premissa","Desempenho biologico."),
        @("Y_bg","Rendimento biogas","Nm3 biogas por kg SV removido.","Nm3/kgSV","Premissa","Liga digestao ao produto."),
        @("PCI","Poder calorifico inferior","Energia util da combustao.","MJ/Nm3","Constante","Transforma CH4 em energia."),
        @("CHP","Cogeracao","Maquina: biogas -> eletricidade + calor.","-","Descritivo","Aproveitamento energetico."),
        @("Q_aquec","Calor aquecimento","Energia para aquecer a mistura.","MJ/dia","M*Cp*DT","Maior demanda termica."),
        @("Q_perdas","Perdas termicas","Calor perdido pelo reator.","MJ/dia","Q_aquec*%","Reator isolado perde menos."),
        @("Q_reacao","Calor de reacao","Calor liberado pela biologia.","MJ/dia","q_rx*SV_rem","Reduz demanda liquida."),
        @("Q_demanda","Demanda termica total","Aquecimento + perdas - reacao.","MJ/dia","Soma","Precisa suprir para manter T."),
        @("E_biogas","Energia no biogas","Energia quimica no metano.","MJ/dia","V_CH4*PCI","Energia bruta."),
        @("E_el","Eletricidade gerada","Parte que vira eletricidade.","kWh/dia","E*eta_el/3.6","Para consumo ou venda."),
        @("Q_CHP","Calor recuperavel","Parte que vira calor util.","MJ/dia","E*eta_th","Para aquecer digestor."),
        @("Excedente","Calor que sobra","CHP - demanda.","MJ/dia","Diferenca","Se > 0, autossuficiente."),
        @("E_aux","Consumo auxiliar","Eletricidade interna.","kWh/dia","E_el*%","Bombas, controle."),
        @("E_liq","Eletricidade liquida","O que sobra apos auxiliares.","kWh/dia","E_el-E_aux","Venda ou uso externo."),
        @("Digestato","Lodo estabilizado","Saida do digestor, menos organica.","kg/dia","Entrada-biogas","Destinacao."),
        @("m_C,gas","C no biogas","Carbono que saiu como gas.","kg/dia","n_CH4*12+n_CO2*12","Rastreamento elementar."),
        @("m_H,gas","H no biogas","Hidrogenio que saiu como gas.","kg/dia","n_CH4*4","Rastreamento elementar."),
        @("m_O,gas","O no biogas","Oxigenio que saiu como gas.","kg/dia","n_CO2*32","Rastreamento elementar.")
    )

    $row = 5
    foreach ($item in $dictRows) {
        for ($col = 1; $col -le 6; $col++) { Set-Cell $dict.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }

    # ==============================
    # === CONCEITOS ===
    # ==============================
    $conc.Range("A1").Value2 = "Conceitos utilizados no modelo"
    Set-TitleStyle $conc.Range("A1")
    $conc.Range("A2").Value2 = "Comece por esta aba se quiser entender a intuicao fisica antes das formulas."
    Set-SubtitleStyle $conc.Range("A2")
    $conc.Range("A4:D4").Value2 = @("Conceito","Definicao simples","Definicao tecnica","Por que aparece na planilha")
    Set-HeaderStyle $conc.Range("A4:D4")

    $conceitos = @(
        @("Digestao anaerobia","Decomposicao sem oxigenio que gera biogas.","Conversao bioquimica de materia organica em CH4 e CO2 por consorcio microbiano.","Processo central do projeto."),
        @("Codigestao","Digerir dois ou mais residuos juntos.","Mistura de substratos para equilibrar C/N e aumentar rendimento.","Justifica a mistura lodo+vinhaca+residuo."),
        @("Hidrolise","Quebra de moleculas grandes em pequenas.","Enzimas extracelulares rompem polimeros.","Etapa 1; limitante com solidos."),
        @("Acidogenese","Monomeros viram acidos organicos.","Bacterias fermentativas produzem acidos volateis.","Etapa 2; gera intermediarios."),
        @("Acetogenese","Acidos viram acetato e H2.","Conversao de acidos em acetato e H2.","Etapa 3; prepara para metanogenese."),
        @("Metanogenese","Acetato e H2 viram metano.","Arqueias produzem CH4.","Etapa 4; gera o produto util."),
        @("Balanco de massa","Tudo que entra tem que sair.","Conservacao de massa no digestor.","Garante entrada = biogas + digestato."),
        @("Balanco de energia","Energia nao surge do nada.","1a Lei da Termodinamica.","Garante viabilidade termica."),
        @("Fechamento elementar","Rastrear C, H, O, N, S.","Conservacao dos elementos quimicos.","Verifica consistencia do modelo."),
        @("Autossuficiencia termica","Calor do CHP >= demanda?","Balanco termico do processo.","Se sim, nao precisa fonte externa."),
        @("Biogas","Gas com CH4 e CO2.","Mistura gasosa combustivel da digestao.","Produto principal."),
        @("Digestato","Lodo estabilizado.","Efluente com menor materia organica.","Destinacao: agricultura ou descarte."),
        @("Vinhaca","Efluente da destilacao de etanol.","Rica em materia organica e potassio.","Substrato complementar."),
        @("Lodo de esgoto","Residuo de ETE.","Lodo do tratamento de esgoto domestico.","Substrato base."),
        @("Residuo organico","Restos de comida, cascas.","Biodegradaveis domesticos/comerciais.","Equilibra C/N e SV."),
        @("CHP (Cogeracao)","Motor que gera eletricidade e calor.","Combined Heat and Power.","Aproveitamento otimizado do biogas."),
        @("Calor de reacao","Calor liberado pela biologia.","Exotermico ~1.2 MJ/kgSV removido.","Reduz demanda de aquecimento externo."),
        @("Desaguamento","Separar agua do digestato.","Filtro-prensa ou centrifuga.","Reduz volume para destinacao.")
    )

    $row = 5
    foreach ($item in $conceitos) {
        for ($col = 1; $col -le 4; $col++) { Set-Cell $conc.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }

    # ==============================
    # === UTILIDADES ===
    # ==============================
    $util.Range("A1").Value2 = "Utilidades do processo"
    Set-TitleStyle $util.Range("A1")
    $util.Range("A2").Value2 = "Consumos e producoes de utilidades."
    Set-SubtitleStyle $util.Range("A2")
    $util.Range("A4:E4").Value2 = @("Utilidade","Quantidade","Unidade","Custo (R$/dia)","Mini-resumo")
    Set-HeaderStyle $util.Range("A4:E4")

    $utilRows = @(
        @("Calor para aquecer mistura","=Balanco_Energia!B5","MJ/dia","=0","Suprido pelo CHP se autossuficiente."),
        @("Calor para perdas","=Balanco_Energia!B6","MJ/dia","=0","Suprido pelo CHP."),
        @("Calor de reacao (credito)","=Balanco_Energia!B7","MJ/dia","=0","Gerado pela biologia; nao e custo."),
        @("Eletricidade auxiliar","=Balanco_Energia!B14","kWh/dia","=B8*Premissas!C51","Consumo interno."),
        @("Eletricidade liquida (venda)","=Balanco_Energia!B15","kWh/dia","=-B9*Premissas!C51","Receita (negativo = entrada).")
    )

    $row = 5
    foreach ($item in $utilRows) {
        for ($col = 1; $col -le 5; $col++) { Set-Cell $util.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $util.Range("B5:D9").NumberFormat = "0.0000"

    # ==============================
    # === CUSTOS ===
    # ==============================
    $cost.Range("A1").Value2 = "Custos e receitas conceituais"
    Set-TitleStyle $cost.Range("A1")
    $cost.Range("A2").Value2 = "Valores editaveis; nao substitui orcamento executivo."
    Set-SubtitleStyle $cost.Range("A2")
    $cost.Range("A4:F4").Value2 = @("Item","Quantidade","Unidade","Custo unit.","Subtotal (R$/dia)","Mini-resumo")
    Set-HeaderStyle $cost.Range("A4:F4")

    $costRows = @(
        @("Descarte digestato (ST)","=Calculos_Massa!B37","kg ST/dia","=Premissas!C52","=B5*D5","Custo de destinacao dos solidos."),
        @("Consumo eletrico auxiliar","=Balanco_Energia!B14","kWh/dia","=Premissas!C51","=B6*D6","Energia interna do sistema."),
        @("Receita de eletricidade","=Balanco_Energia!B15","kWh/dia","=Premissas!C51","=-B7*D7","Receita (valor negativo)."),
        @("Agua de processo","=Calculos_Massa!B11*0.001","m3/dia","=2.0","=B8*D8","Estimativa agua de selagem e limpeza."),
        @("Manutencao (% investimento/dia)","=1","verba/dia","=500","=B9*D9","Manutencao preventiva.")
    )

    $row = 5
    foreach ($item in $costRows) {
        for ($col = 1; $col -le 6; $col++) { Set-Cell $cost.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $cost.Range("B5:E9").NumberFormat = "0.0000"
    $cost.Range("A11").Value2 = "Saldo operacional diario"
    $cost.Range("A11").Font.Bold = $true
    $cost.Range("E11").Formula = "=SUM(E5:E9)"
    $cost.Range("E11").Font.Bold = $true
    $cost.Range("E11").NumberFormat = "0.00"

    # ==============================
    # === PFD VISUAL ===
    # ==============================
    $pfvd.Range("A1").Value2 = "PFD Visual - Diagrama de fluxo simplificado"
    Set-TitleStyle $pfvd.Range("A1")
    $pfvd.Range("A2").Value2 = "Representacao em texto do fluxo de processo."
    Set-SubtitleStyle $pfvd.Range("A2")

    $pfvd.Range("A4").Value2 = "[101] LODO DE ESGOTO"
    $pfvd.Range("A5").Value2 = "     |"
    $pfvd.Range("A6").Value2 = "     v"
    $pfvd.Range("A7").Value2 = "[102] VINHACA  ------>  [TANQUE DE MISTURA]  ---[104]--->  [DIGESTOR ANAEROBIO]  ---[105]---> BIOGAS"
    $pfvd.Range("A8").Value2 = "     ^                                                          |               |---[107]---> CH4 (combustivel)"
    $pfvd.Range("A9").Value2 = "     |                                                          |               |---[108]---> CO2 (inerte)"
    $pfvd.Range("A10").Value2 = "[103] RESIDUO ORG.                                             |"
    $pfvd.Range("A11").Value2 = "                                                               v"
    $pfvd.Range("A12").Value2 = "                                                        [106] DIGESTATO"
    $pfvd.Range("A13").Value2 = "                                                               |"
    $pfvd.Range("A14").Value2 = "                                                        [DESAGUAMENTO]"
    $pfvd.Range("A15").Value2 = "                                                          /          \\"
    $pfvd.Range("A16").Value2 = "                                                   [109] TORTA    [110] AGUA"
    $pfvd.Range("A17").Value2 = "                                                   (25% ST)       (filtrado)"

    $pfvd.Range("A4:A17").Font.Name = "Consolas"
    $pfvd.Range("A4:A17").Font.Size = 10

    $pfvd.Range("A19").Value2 = "Correntes principais (valores)"
    Set-SubtitleStyle $pfvd.Range("A19")
    $pfvd.Range("A20:C20").Value2 = @("Corrente","Massa (kg/dia)","Descricao")
    Set-HeaderStyle $pfvd.Range("A20:C20")
    for ($i = 0; $i -lt 10; $i++) {
        $pfvd.Cells.Item(21 + $i, 1).Formula = "=Correntes_PFD!A$($i+5)"
        $pfvd.Cells.Item(21 + $i, 2).Formula = "=Correntes_PFD!C$($i+5)"
        $pfvd.Cells.Item(21 + $i, 3).Formula = "=Correntes_PFD!B$($i+5)"
    }
    $pfvd.Range("B21:B30").NumberFormat = "0.00"

    # ==============================
    # === SECAGEM DIGESTATO ===
    # ==============================
    $seca.Range("A1").Value2 = "Secagem / Desaguamento do digestato"
    Set-TitleStyle $seca.Range("A1")
    $seca.Range("A2").Value2 = "Estimativa de massas apos separacao solido-liquido."
    Set-SubtitleStyle $seca.Range("A2")
    $seca.Range("A4:D4").Value2 = @("Grandeza","Valor","Unidade","Mini-resumo")
    Set-HeaderStyle $seca.Range("A4:D4")

    $secaRows = @(
        @("Massa digestato bruto","=Calculos_Massa!B38","kg/dia","Tudo que sai do digestor (menos o gas)."),
        @("ST no digestato","=Calculos_Massa!B37","kg/dia","Solidos totais na saida."),
        @("SV no digestato","=Calculos_Massa!B35","kg/dia","Materia organica residual."),
        @("SF no digestato","=Calculos_Massa!B36","kg/dia","Cinzas e minerais."),
        @("Agua no digestato","=B5-B6","kg/dia","Massa total menos solidos."),
        @("% ST no digestato","=B6/B5*100","%","Concentracao de solidos."),
        @("ST alvo apos desaguamento","=Premissas!C53","%","Premissa: 25% ST na torta."),
        @("Massa torta desaguada","=B6/(B11/100)","kg/dia","ST dividido pela concentracao alvo."),
        @("Agua na torta","=B12-B6","kg/dia","Agua retida na torta."),
        @("Agua separada (filtrado)","=B9-B13","kg/dia","Filtrado para tratamento ou reuso."),
        @("Massa filtrado total","=B5-B12","kg/dia","Digestato - torta.")
    )

    $row = 5
    foreach ($item in $secaRows) {
        for ($col = 1; $col -le 4; $col++) { Set-Cell $seca.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $seca.Range("B5:B15").NumberFormat = "0.0000"

    # ==============================
    # === RESUMO EXECUTIVO ===
    # ==============================
    $exec.Range("A1").Value2 = "Resumo Executivo - Biogas por Codigestao Anaerobia"
    Set-TitleStyle $exec.Range("A1")
    $exec.Range("A2").Value2 = "Leitura rapida para apresentacao academica ou profissional."
    Set-SubtitleStyle $exec.Range("A2")
    $exec.Range("A4:D4").Value2 = @("Bloco","Mensagem","Valor","Unidade")
    Set-HeaderStyle $exec.Range("A4:D4")

    $execRows = @(
        @("Base","Volume de mistura/dia","=Premissas!C5","m3/dia"),
        @("Massa","Massa total de entrada","=Calculos_Massa!B11","kg/dia"),
        @("Organica","Solidos volateis de entrada","=Calculos_Massa!B19","kg/dia"),
        @("C/N","Relacao C/N (catalogo)","=Calculos_Massa!B20","-"),
        @("C/N elem.","Relacao C/N (elementar)","=Fechamento_Elementar!B12","-"),
        @("Biogas","Volume de biogas","=Calculos_Massa!B22","Nm3/dia"),
        @("Metano","Volume de metano","=Calculos_Massa!B23","Nm3/dia"),
        @("Energia","Energia no biogas (PCI)","=Balanco_Energia!B9","MJ/dia"),
        @("Potencia","Potencia eletrica media","=Balanco_Energia!B16","kW"),
        @("Eletricidade","Eletricidade liquida","=Balanco_Energia!B15","kWh/dia"),
        @("Termica","Excedente termico","=Balanco_Energia!B13","MJ/dia"),
        @("Digestato","Massa de digestato","=Calculos_Massa!B38","kg/dia"),
        @("Reator","Volume do reator","=Calculos_Massa!B33","m3"),
        @("Checks","Verificacoes OK","=COUNTIF(Verificacoes!E5:E14,""OK"")+COUNTIF(Verificacoes!E5:E14,""OK - autossuficiente"")","de 10")
    )

    $row = 5
    foreach ($item in $execRows) {
        for ($col = 1; $col -le 4; $col++) { Set-Cell $exec.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $exec.Range("C5:C18").NumberFormat = "0.0000"

    $exec.Range("A21").Value2 = "Mensagens para apresentacao"
    Set-SubtitleStyle $exec.Range("A21")
    $exec.Range("A22").Formula = "=""O digestor recebe ""&FIXED(Premissas!C5,0,TRUE)&"" m3/dia de mistura (""&FIXED(Calculos_Massa!B11,0,TRUE)&"" kg/dia) com C/N de ""&FIXED(Calculos_Massa!B20,1,TRUE)&""."""
    $exec.Range("A23").Formula = "=""Produz ""&FIXED(Calculos_Massa!B22,0,TRUE)&"" Nm3/dia de biogas contendo ""&FIXED(Calculos_Massa!B23,0,TRUE)&"" Nm3/dia de metano (""&FIXED(Premissas!C41,0,TRUE)&""% CH4)."""
    $exec.Range("A24").Formula = "=""A cogeracao gera ""&FIXED(Balanco_Energia!B15,0,TRUE)&"" kWh/dia de eletricidade liquida (""&FIXED(Balanco_Energia!B16,1,TRUE)&"" kW medio) e o sistema e termicamente autossuficiente."""
    $exec.Range("A25").Formula = "=""O fechamento elementar rastreia C/H/O/N/S desde a entrada ate biogas e digestato."""
    $exec.Range("A22:A25").WrapText = $true

    # ==============================
    # === KPIs ===
    # ==============================
    $kpi.Range("A1").Value2 = "Indicadores-chave de desempenho (KPIs)"
    Set-TitleStyle $kpi.Range("A1")
    $kpi.Range("A3:C3").Value2 = @("KPI","Valor","Unidade")
    Set-HeaderStyle $kpi.Range("A3:C3")

    $kpiRows = @(
        @("Volume de biogas","=Calculos_Massa!B22","Nm3/dia"),
        @("Volume de metano","=Calculos_Massa!B23","Nm3/dia"),
        @("C/N da mistura","=Calculos_Massa!B20","-"),
        @("COV","=Calculos_Massa!B34","kgSV/m3.dia"),
        @("Eficiencia remocao SV","=Premissas!C39","%"),
        @("Eletricidade liquida","=Balanco_Energia!B15","kWh/dia"),
        @("Potencia media","=Balanco_Energia!B16","kW"),
        @("Excedente termico","=Balanco_Energia!B13","MJ/dia"),
        @("Energia no biogas","=Balanco_Energia!B9","MJ/dia"),
        @("Massa de digestato","=Calculos_Massa!B38","kg/dia"),
        @("Volume do reator","=Calculos_Massa!B33","m3"),
        @("C no biogas (%)","=Fechamento_Elementar!B15","%"),
        @("Saldo operacional diario","=Custos!E11","R$/dia"),
        @("Verificacoes OK","=COUNTIF(Verificacoes!E5:E14,""OK"")+COUNTIF(Verificacoes!E5:E14,""OK - autossuficiente"")","de 10")
    )

    $row = 4
    foreach ($item in $kpiRows) {
        Set-Cell $kpi.Cells.Item($row,1) $item[0]
        Set-Cell $kpi.Cells.Item($row,2) $item[1]
        Set-Cell $kpi.Cells.Item($row,3) $item[2]
        $row++
    }
    $kpi.Range("B4:B17").NumberFormat = "0.0000"

    # ==============================
    # === DASHBOARD ===
    # ==============================
    $dash.Range("A1").Value2 = "Dashboard - Biogas por Codigestao Anaerobia"
    Set-TitleStyle $dash.Range("A1")
    $dash.Range("A2").Value2 = "Indicadores visuais, graficos e leitura executiva."
    Set-SubtitleStyle $dash.Range("A2")

    # 8 cards KPI (2 linhas x 4)
    Set-CardStyle $dash.Range("A4:C7") 15773696
    Set-CardStyle $dash.Range("E4:G7") 15773696
    Set-CardStyle $dash.Range("I4:K7") 15773696
    Set-CardStyle $dash.Range("M4:O7") 15773696
    Set-CardStyle $dash.Range("A9:C12") 13434879
    Set-CardStyle $dash.Range("E9:G12") 13434879
    Set-CardStyle $dash.Range("I9:K12") 13434879
    Set-CardStyle $dash.Range("M9:O12") 13434879

    $dash.Range("A4").Formula = "=""Biogas""&CHAR(10)&FIXED(KPIs!B4,0,TRUE)&"" Nm3/dia"""
    $dash.Range("E4").Formula = "=""Metano""&CHAR(10)&FIXED(KPIs!B5,0,TRUE)&"" Nm3/dia"""
    $dash.Range("I4").Formula = "=""C/N Mistura""&CHAR(10)&FIXED(KPIs!B6,1,TRUE)"
    $dash.Range("M4").Formula = "=""COV""&CHAR(10)&FIXED(KPIs!B7,2,TRUE)&"" kgSV/m3.dia"""
    $dash.Range("A9").Formula = "=""Eletricidade liq.""&CHAR(10)&FIXED(KPIs!B9,0,TRUE)&"" kWh/dia"""
    $dash.Range("E9").Formula = "=""Potencia media""&CHAR(10)&FIXED(KPIs!B10,1,TRUE)&"" kW"""
    $dash.Range("I9").Formula = "=""Digestato""&CHAR(10)&FIXED(KPIs!B13,0,TRUE)&"" kg/dia"""
    $dash.Range("M9").Formula = "=""Saldo R$/dia""&CHAR(10)&FIXED(KPIs!B16,2,TRUE)"

    # Leitura executiva
    $dash.Range("A14").Value2 = "Leitura executiva"
    Set-SubtitleStyle $dash.Range("A14")
    $dash.Range("A15").Formula = "=""O processo recebe ""&FIXED(Premissas!C5,0,TRUE)&"" m3/dia de mistura e gera ""&FIXED(KPIs!B4,0,TRUE)&"" Nm3/dia de biogas com ""&FIXED(Premissas!C41,0,TRUE)&""% de metano."""
    $dash.Range("A16").Formula = "=""A cogeracao produz ""&FIXED(KPIs!B9,0,TRUE)&"" kWh/dia de eletricidade liquida (""&FIXED(KPIs!B10,1,TRUE)&"" kW medio) e o sistema e termicamente autossuficiente."""
    $dash.Range("A17").Formula = "=""O fechamento elementar mostra que ""&FIXED(KPIs!B15,1,TRUE)&""% do carbono de entrada sai como biogas."""
    $dash.Range("A15:A17").WrapText = $true

    # Tabelas de dados para graficos (area oculta Q-R)
    $dash.Range("Q2").Value2 = "CH4 (kg/dia)"
    $dash.Range("R2").Formula = "=Calculos_Massa!B27"
    $dash.Range("Q3").Value2 = "CO2 (kg/dia)"
    $dash.Range("R3").Formula = "=Calculos_Massa!B29"
    $dash.Range("Q4").Value2 = "Outros (kg/dia)"
    $dash.Range("R4").Formula = "=Calculos_Massa!B31"

    $dash.Range("Q6").Value2 = "SV removido"
    $dash.Range("R6").Formula = "=Calculos_Massa!B21"
    $dash.Range("Q7").Value2 = "SV residual"
    $dash.Range("R7").Formula = "=Calculos_Massa!B35"

    $dash.Range("Q9").Value2 = "Aquecimento"
    $dash.Range("R9").Formula = "=Balanco_Energia!B5"
    $dash.Range("Q10").Value2 = "Perdas"
    $dash.Range("R10").Formula = "=Balanco_Energia!B6"
    $dash.Range("Q11").Value2 = "Reacao (credito)"
    $dash.Range("R11").Formula = "=Balanco_Energia!B7"
    $dash.Range("Q12").Value2 = "Excedente CHP"
    $dash.Range("R12").Formula = "=Balanco_Energia!B13"

    $dash.Range("Q14").Value2 = "C no biogas"
    $dash.Range("R14").Formula = "=Fechamento_Elementar!F5"
    $dash.Range("Q15").Value2 = "C no digestato"
    $dash.Range("R15").Formula = "=Fechamento_Elementar!G5"
    $dash.Range("Q16").Value2 = "H no biogas"
    $dash.Range("R16").Formula = "=Fechamento_Elementar!F6"
    $dash.Range("Q17").Value2 = "H no digestato"
    $dash.Range("R17").Formula = "=Fechamento_Elementar!G6"

    $dash.Range("Q19").Value2 = "Lodo (SV)"
    $dash.Range("R19").Formula = "=Calculos_Massa!B16"
    $dash.Range("Q20").Value2 = "Vinhaca (SV)"
    $dash.Range("R20").Formula = "=Calculos_Massa!B17"
    $dash.Range("Q21").Value2 = "Residuo (SV)"
    $dash.Range("R21").Formula = "=Calculos_Massa!B18"

    # Grafico 1: composicao do biogas (pizza)
    $c1Obj = $dash.ChartObjects().Add(20,400,380,230)
    $c1 = $c1Obj.Chart; $c1.ChartType = 5
    $s1 = $c1.SeriesCollection().NewSeries()
    $s1.Values = $dash.Range("R2:R4"); $s1.XValues = $dash.Range("Q2:Q4")
    $c1.HasTitle = $true; $c1.ChartTitle.Text = "Composicao do biogas (massa)"

    # Grafico 2: SV removido vs residual (pizza)
    $c2Obj = $dash.ChartObjects().Add(420,400,380,230)
    $c2 = $c2Obj.Chart; $c2.ChartType = 5
    $s2 = $c2.SeriesCollection().NewSeries()
    $s2.Values = $dash.Range("R6:R7"); $s2.XValues = $dash.Range("Q6:Q7")
    $c2.HasTitle = $true; $c2.ChartTitle.Text = "Conversao de SV (kg/dia)"

    # Grafico 3: balanco termico (barras)
    $c3Obj = $dash.ChartObjects().Add(20,650,380,230)
    $c3 = $c3Obj.Chart; $c3.ChartType = 51
    $s3 = $c3.SeriesCollection().NewSeries()
    $s3.Values = $dash.Range("R9:R12"); $s3.XValues = $dash.Range("Q9:Q12")
    $c3.HasTitle = $true; $c3.ChartTitle.Text = "Balanco termico (MJ/dia)"

    # Grafico 4: fechamento elementar C e H (barras)
    $c4Obj = $dash.ChartObjects().Add(420,650,380,230)
    $c4 = $c4Obj.Chart; $c4.ChartType = 51
    $s4 = $c4.SeriesCollection().NewSeries()
    $s4.Values = $dash.Range("R14:R17"); $s4.XValues = $dash.Range("Q14:Q17")
    $c4.HasTitle = $true; $c4.ChartTitle.Text = "Fechamento elementar C e H (kg/dia)"

    # Grafico 5: contribuicao de SV por substrato (pizza)
    $c5Obj = $dash.ChartObjects().Add(20,900,380,230)
    $c5 = $c5Obj.Chart; $c5.ChartType = 5
    $s5 = $c5.SeriesCollection().NewSeries()
    $s5.Values = $dash.Range("R19:R21"); $s5.XValues = $dash.Range("Q19:Q21")
    $c5.HasTitle = $true; $c5.ChartTitle.Text = "Contribuicao de SV por substrato"

    # Grafico 6: custo vs receita (barras)
    $dash.Range("Q23").Value2 = "Descarte digestato"
    $dash.Range("R23").Formula = "=Custos!E5"
    $dash.Range("Q24").Value2 = "Consumo eletrico"
    $dash.Range("R24").Formula = "=Custos!E6"
    $dash.Range("Q25").Value2 = "Receita eletricidade"
    $dash.Range("R25").Formula = "=ABS(Custos!E7)"
    $dash.Range("Q26").Value2 = "Outros custos"
    $dash.Range("R26").Formula = "=Custos!E8+Custos!E9"

    $c6Obj = $dash.ChartObjects().Add(420,900,380,230)
    $c6 = $c6Obj.Chart; $c6.ChartType = 51
    $s6 = $c6.SeriesCollection().NewSeries()
    $s6.Values = $dash.Range("R23:R26"); $s6.XValues = $dash.Range("Q23:Q26")
    $c6.HasTitle = $true; $c6.ChartTitle.Text = "Custos e receitas (R$/dia)"

    # ==============================
    # === DIMENSIONAMENTO ===
    # ==============================
    $dime.Range("A1").Value2 = "Dimensionamento de equipamentos"
    Set-TitleStyle $dime.Range("A1")
    $dime.Range("A2").Value2 = "Calculo de dimensoes principais de cada equipamento com formulas automaticas."
    Set-SubtitleStyle $dime.Range("A2")
    $dime.Range("A4:H4").Value2 = @("Tag","Equipamento","Variavel dimensionamento","Formula","Valor","Unidade","Margem","Valor final")
    Set-HeaderStyle $dime.Range("A4:H4")

    $dimeRows = @(
        @("TQ-101","Tanque mistura","Volume util","Q_tot * t_ret (12h)","=Premissas!C5*0.5","m3","20%","=E5*1.20"),
        @("TQ-101","","Diametro (H/D=1)","(4V/pi)^(1/3)","=(4*H5/3.14159)^(1/3)","m","",""),
        @("TQ-101","","Altura","=D","=E6","m","",""),
        @("TQ-101","","Potencia agitador","0.5 kW/m3","=0.5*H5","kW","",""),
        @("D-101","Digestor anaerobio","Volume util","Q_tot * TRH","=Premissas!C5*Premissas!C38","m3","15% headspace","=E9*1.15"),
        @("D-101","","Diametro (H/D=1.5)","(4V/(1.5*pi))^(1/3)","=(4*E9/(1.5*3.14159))^(1/3)","m","",""),
        @("D-101","","H liquido","1.5*D","=1.5*E10","m","",""),
        @("D-101","","H headspace","~3 m","=3","m","",""),
        @("D-101","","H total","H_liq + H_head","=E11+E12","m","",""),
        @("D-101","","V real (check)","pi/4*D^2*H_liq","=3.14159/4*E10^2*E11","m3","",""),
        @("D-101","","Potencia agitacao","5-10 W/m3","=0.010*E9","kW","",""),
        @("D-101","","Espessura minima","ASME VIII: P*R/(S*E-0.6P)","=(0.00507*E10/2*1000)/(137.9*0.85-0.6*0.00507)","mm","+ 3mm corrosao","=MAX(E16,6.35)+3"),
        @("TC-101","Trocador de calor","Carga termica","M*Cp*DT/1000","=Calculos_Massa!B11*Premissas!C44*(Premissas!C37-Premissas!C36)/1000","MJ/dia","",""),
        @("TC-101","","Carga termica (kW)","Q/(86.4)","=E17/86.4","kW","",""),
        @("TC-101","","LMTD (contracorrente)","(DT1-DT2)/ln(DT1/DT2)","=(45-30)/LN(45/30)","degC","",""),
        @("TC-101","","U (coeficiente global)","800 (conservador lodo)","=800","W/m2.K","",""),
        @("TC-101","","Area requerida","Q/(U*LMTD)","=E18*1000/E20/E19","m2","30% fouling","=E21*1.30"),
        @("P-101","Bomba alimentacao","Vazao","Q_tot/24","=Premissas!C5/24","m3/h","",""),
        @("P-101","","dP","~2 bar","=2","bar","",""),
        @("P-101","","Potencia hidraulica","Q*dP","=E23/3600*E24*100000","W","",""),
        @("P-101","","Potencia eixo","W_hid/eta","=E25/0.60","W","Motor comercial","=0.75"),
        @("P-102","Bomba digestato","Vazao","~igual P-101","=Calculos_Massa!B38/1010/24","m3/h","Motor","=0.75"),
        @("FP-101","Filtro-prensa","Vazao digestato","massa/dia","=Calculos_Massa!B38","kg/dia","",""),
        @("FP-101","","Area filtracao","~100 m2 (literatura)","=100","m2","",""),
        @("FP-101","","Pressao operacao","6-15 bar","=10","bar","",""),
        @("MG-101","Motor-gerador CHP","Combustivel","Biogas","=Calculos_Massa!B22","Nm3/dia","",""),
        @("MG-101","","Energia quimica","V_CH4*PCI","=Calculos_Massa!B23*Premissas!C46","MJ/dia","",""),
        @("MG-101","","Potencia eletrica bruta","E*eta_el/86.4","=E33*Premissas!C47/86.4","kW","",""),
        @("MG-101","","Potencia eletrica liq","bruta*(1-aux)","=E34*(1-Premissas!C49)","kW","Nominal","=200"),
        @("MG-101","","Potencia termica","E*eta_th/86.4","=E33*Premissas!C48/86.4","kW","",""),
        @("TQ-102","Gasometro","Volume buffer 6h","Q_bg/24*6","=Calculos_Massa!B22/24*6","Nm3","",""),
        @("DS-101","Dessulfurizador","Vazao biogas","Q_bg/24","=Calculos_Massa!B22/24","Nm3/h","",""),
        @("DS-101","","EBCT","3 min","=3","min","",""),
        @("DS-101","","Volume carvao","Q*EBCT/60","=E38/60*E39","m3","",""),
        @("DS-101","","Diametro torre","~1 m","=1.0","m","",""),
        @("DS-101","","Altura leito","V/(pi/4*D^2)","=E40/(3.14159/4*E41^2)","m","",""),
        @("TQ-103","Tanque NaOH","Volume","1-2 m3 reserva","=2","m3","","")
    )

    $row = 5
    foreach ($item in $dimeRows) {
        for ($col = 1; $col -le 8; $col++) { Set-Cell $dime.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $dime.Range("E5:E44").NumberFormat = "0.00"
    $dime.Range("H5:H44").NumberFormat = "0.00"

    # ==============================
    # === MATERIAIS ===
    # ==============================
    $mate.Range("A1").Value2 = "Selecao de materiais de construcao"
    Set-TitleStyle $mate.Range("A1")
    $mate.Range("A2").Value2 = "Criterios de corrosao, abrasao e compatibilidade quimica para cada equipamento."
    Set-SubtitleStyle $mate.Range("A2")

    $mate.Range("A4:F4").Value2 = @("Tag","Equipamento","Material corpo","Material interno","Justificativa","Norma")
    Set-HeaderStyle $mate.Range("A4:F4")

    $mateRows = @(
        @("TQ-101","Tanque mistura","Aco carbono A36","Rev. epoxi","pH acido da vinhaca; baixa pressao","ASTM A36"),
        @("P-101","Bomba alimentacao","Ferro fundido","Rotor inox 316L","Abrasao do lodo; solidos","ASTM A743"),
        @("TC-101","Trocador de calor","Aco carbono (casco)","Inox 316L (tubos)","H2S dissolvido no lodo","ASTM A312"),
        @("D-101","Digestor","Aco carbono A516 Gr.70","Rev. epoxi + zona gas 316L","H2S no headspace; pressao","ASME VIII / NACE"),
        @("P-102","Bomba digestato","Ferro fundido","Rotor inox 316L","Abrasao + H2S residual","ASTM A743"),
        @("FP-101","Filtro-prensa","Aco carbono","Placas polipropileno","Contato com lodo; quimicos","NBR 7821"),
        @("MG-101","Motor-gerador","Padrao fabricante","N/A","Biogas tratado (H2S < 200 ppm)","ISO"),
        @("TQ-102","Gasometro","Estrutura aco","Membrana EPDM","Biogas umido; flexibilidade","NR-20"),
        @("DS-101","Dessulfurizador","PRFV","Carvao ativado","H2S concentrado no gas","ASTM D3299"),
        @("TQ-103","Tanque NaOH","PEAD","N/A","NaOH 50%; quimico agressivo","ASTM D1998")
    )

    $row = 5
    foreach ($item in $mateRows) {
        for ($col = 1; $col -le 6; $col++) { Set-Cell $mate.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }

    $mate.Range("A16").Value2 = "Agentes de corrosao no processo"
    Set-SubtitleStyle $mate.Range("A16")
    $mate.Range("A17:D17").Value2 = @("Agente","Onde aparece","Efeito","Gravidade")
    Set-HeaderStyle $mate.Range("A17:D17")
    $agentes = @(
        @("H2S","Biogas, headspace, fase liquida","Pitting em aco carbono","Alta"),
        @("CO2 dissolvido","Fase liquida","Corrosao acida leve","Media"),
        @("Acidos organicos volateis","Fase liquida","Corrosao acida","Media"),
        @("Abrasao por solidos","Bombas, tubulacoes","Desgaste mecanico","Alta em pontos"),
        @("pH acido (vinhaca)","Entrada, TQ-101","Ataque acido","Media"),
        @("Cloretos","Se agua salobra","Pitting em inox 304","Media")
    )
    $row = 18
    foreach ($item in $agentes) {
        for ($col = 1; $col -le 4; $col++) { Set-Cell $mate.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }

    # ==============================
    # === OTIMIZACAO ===
    # ==============================
    $otim.Range("A1").Value2 = "Analise de sensibilidade e otimizacao"
    Set-TitleStyle $otim.Range("A1")
    $otim.Range("A2").Value2 = "Efeito das proporcoes de mistura, TRH e temperatura nos resultados do processo."
    Set-SubtitleStyle $otim.Range("A2")

    $otim.Range("A4").Value2 = "Cenarios de proporcao (x_L : x_V : x_R)"
    Set-SubtitleStyle $otim.Range("A4")
    $otim.Range("A5:J5").Value2 = @("Cenario","x_L","x_V","x_R","SV (kg/dia)","C/N","Biogas (Nm3/dia)","CH4 (Nm3/dia)","Eletric. (kWh/dia)","COV (kgSV/m3.dia)")
    Set-HeaderStyle $otim.Range("A5:J5")

    Set-Cell $otim.Cells.Item(6,1) "A - Base"
    Set-Cell $otim.Cells.Item(6,2) 0.50; Set-Cell $otim.Cells.Item(6,3) 0.30; Set-Cell $otim.Cells.Item(6,4) 0.20
    Set-Cell $otim.Cells.Item(6,5) "=B6*Premissas!C5*Premissas!C9*Premissas!C12/100*Premissas!C15/100+C6*Premissas!C5*Premissas!C10*Premissas!C13/100*Premissas!C16/100+D6*Premissas!C5*Premissas!C11*Premissas!C14/100*Premissas!C17/100"
    Set-Cell $otim.Cells.Item(6,6) "=(B6*Premissas!C5*Premissas!C9*Premissas!C12/100*Premissas!C15/100*Premissas!C18+C6*Premissas!C5*Premissas!C10*Premissas!C13/100*Premissas!C16/100*Premissas!C19+D6*Premissas!C5*Premissas!C11*Premissas!C14/100*Premissas!C17/100*Premissas!C20)/E6"
    Set-Cell $otim.Cells.Item(6,7) "=E6*Premissas!C39/100*Premissas!C40"
    Set-Cell $otim.Cells.Item(6,8) "=G6*Premissas!C41/100"
    Set-Cell $otim.Cells.Item(6,9) "=H6*Premissas!C46*Premissas!C47/3.6"
    Set-Cell $otim.Cells.Item(6,10) "=E6/Calculos_Massa!B33"

    $scenarios = @(
        @("B - Mais lodo",0.60,0.20,0.20),
        @("C - Mais residuo",0.40,0.20,0.40),
        @("D - Mais vinhaca",0.40,0.40,0.20),
        @("E - Max biogas",0.30,0.30,0.40)
    )
    for ($s = 0; $s -lt $scenarios.Count; $s++) {
        $r = 7 + $s
        Set-Cell $otim.Cells.Item($r,1) $scenarios[$s][0]
        Set-Cell $otim.Cells.Item($r,2) $scenarios[$s][1]
        Set-Cell $otim.Cells.Item($r,3) $scenarios[$s][2]
        Set-Cell $otim.Cells.Item($r,4) $scenarios[$s][3]
        Set-Cell $otim.Cells.Item($r,5) "=B$r*Premissas!C5*Premissas!C9*Premissas!C12/100*Premissas!C15/100+C$r*Premissas!C5*Premissas!C10*Premissas!C13/100*Premissas!C16/100+D$r*Premissas!C5*Premissas!C11*Premissas!C14/100*Premissas!C17/100"
        Set-Cell $otim.Cells.Item($r,6) "=(B$r*Premissas!C5*Premissas!C9*Premissas!C12/100*Premissas!C15/100*Premissas!C18+C$r*Premissas!C5*Premissas!C10*Premissas!C13/100*Premissas!C16/100*Premissas!C19+D$r*Premissas!C5*Premissas!C11*Premissas!C14/100*Premissas!C17/100*Premissas!C20)/E$r"
        Set-Cell $otim.Cells.Item($r,7) "=E$r*Premissas!C39/100*Premissas!C40"
        Set-Cell $otim.Cells.Item($r,8) "=G$r*Premissas!C41/100"
        Set-Cell $otim.Cells.Item($r,9) "=H$r*Premissas!C46*Premissas!C47/3.6"
        Set-Cell $otim.Cells.Item($r,10) "=E$r/Calculos_Massa!B33"
    }
    $otim.Range("B6:J10").NumberFormat = "0.00"

    $otim.Range("A13").Value2 = "Efeito do TRH"
    Set-SubtitleStyle $otim.Range("A13")
    $otim.Range("A14:E14").Value2 = @("TRH (dias)","V reator (m3)","eta_SV (%)","Biogas (Nm3/dia)","COV (kgSV/m3.dia)")
    Set-HeaderStyle $otim.Range("A14:E14")
    $trhVals = @(15,20,25,30)
    for ($t = 0; $t -lt $trhVals.Count; $t++) {
        $r = 15 + $t
        Set-Cell $otim.Cells.Item($r,1) $trhVals[$t]
        Set-Cell $otim.Cells.Item($r,2) "=Premissas!C5*A$r"
        $eta = 30 + 1.5 * $trhVals[$t]
        Set-Cell $otim.Cells.Item($r,3) $eta
        Set-Cell $otim.Cells.Item($r,4) "=Calculos_Massa!B19*C$r/100*Premissas!C40"
        Set-Cell $otim.Cells.Item($r,5) "=Calculos_Massa!B19/B$r"
    }
    $otim.Range("B15:E18").NumberFormat = "0.00"

    $otim.Range("A21").Value2 = "Efeito da temperatura"
    Set-SubtitleStyle $otim.Range("A21")
    $otim.Range("A22:F22").Value2 = @("Regime","T (degC)","eta_SV (%)","Y_bg (Nm3/kgSV)","Biogas (Nm3/dia)","Q aquec (MJ/dia)")
    Set-HeaderStyle $otim.Range("A22:F22")
    Set-Cell $otim.Cells.Item(23,1) "Mesofilico"
    Set-Cell $otim.Cells.Item(23,2) 35; Set-Cell $otim.Cells.Item(23,3) 55; Set-Cell $otim.Cells.Item(23,4) 0.60
    Set-Cell $otim.Cells.Item(23,5) "=Calculos_Massa!B19*C23/100*D23"
    Set-Cell $otim.Cells.Item(23,6) "=Calculos_Massa!B11*Premissas!C44*(B23-Premissas!C36)/1000"
    Set-Cell $otim.Cells.Item(24,1) "Termofilico"
    Set-Cell $otim.Cells.Item(24,2) 55; Set-Cell $otim.Cells.Item(24,3) 65; Set-Cell $otim.Cells.Item(24,4) 0.65
    Set-Cell $otim.Cells.Item(24,5) "=Calculos_Massa!B19*C24/100*D24"
    Set-Cell $otim.Cells.Item(24,6) "=Calculos_Massa!B11*Premissas!C44*(B24-Premissas!C36)/1000"
    $otim.Range("B23:F24").NumberFormat = "0.00"

    # ==============================
    # === CAPEX ===
    # ==============================
    $capx.Range("A1").Value2 = "CAPEX - Investimento fixo"
    Set-TitleStyle $capx.Range("A1")
    $capx.Range("A2").Value2 = "Estimativa de ordem de grandeza. Nivel C (Towler & Sinnott, 2012)."
    Set-SubtitleStyle $capx.Range("A2")
    $capx.Range("A4:E4").Value2 = @("Tag","Equipamento","Dimensao","Custo FOB (R$)","Mini-resumo")
    Set-HeaderStyle $capx.Range("A4:E4")

    $capxRows = @(
        @("TQ-101","Tanque mistura 60 m3","=Dimensionamento!H5","=80000","Aco carbono + epoxi"),
        @("P-101","Bomba cavidade 0.75 kW","=Dimensionamento!H26","=15000","Ferro fundido / 316L"),
        @("TC-101","Trocador espiral 3.1 m2","=Dimensionamento!H21","=50000","316L / aco carbono"),
        @("D-101","Digestor 2300 m3","=Dimensionamento!H9","=2500000","Aco carbono + rev. epoxi"),
        @("P-102","Bomba digestato 0.75 kW","=Dimensionamento!H27","=15000","Ferro fundido / 316L"),
        @("FP-101","Filtro-prensa 100 m2","=Dimensionamento!E29","=300000","Polipropileno / aco"),
        @("MG-101","Motor-gerador 200 kW","=Dimensionamento!H35","=600000","Padrao fabricante"),
        @("TQ-102","Gasometro 420 Nm3","=Dimensionamento!E37","=150000","EPDM / aco"),
        @("DS-101","Dessulfurizador 3.5 m3","=Dimensionamento!E40","=40000","PRFV / carvao"),
        @("TQ-103","Tanque NaOH 2 m3","=Dimensionamento!E43","=5000","PEAD"),
        @("-","Tubulacao, valvulas, instr.","-","=400000","Estimativa 10% equipamentos"),
        @("-","Eletrica e automacao","-","=200000","Estimativa")
    )

    $row = 5
    foreach ($item in $capxRows) {
        for ($col = 1; $col -le 5; $col++) { Set-Cell $capx.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $capx.Range("D5:D16").NumberFormat = "#,##0"

    Set-Cell $capx.Cells.Item(18,1) "TOTAL FOB"
    $capx.Range("A18").Font.Bold = $true
    Set-Cell $capx.Cells.Item(18,4) "=SUM(D5:D16)"
    $capx.Range("D18").Font.Bold = $true
    $capx.Range("D18").NumberFormat = "#,##0"

    Set-Cell $capx.Cells.Item(20,1) "Fator de Lang"
    Set-Cell $capx.Cells.Item(20,2) "Solidos-liquidos"
    Set-Cell $capx.Cells.Item(20,4) 3.6
    Set-Cell $capx.Cells.Item(20,5) "Towler & Sinnott (2012)"

    Set-Cell $capx.Cells.Item(21,1) "Investimento total instalado"
    Set-Cell $capx.Cells.Item(21,4) "=D18*D20"
    $capx.Range("D21").NumberFormat = "#,##0"
    $capx.Range("A21").Font.Bold = $true

    Set-Cell $capx.Cells.Item(22,1) "Capital de giro (15%)"
    Set-Cell $capx.Cells.Item(22,4) "=D21*0.15"
    $capx.Range("D22").NumberFormat = "#,##0"

    Set-Cell $capx.Cells.Item(24,1) "CAPEX TOTAL"
    $capx.Range("A24").Font.Bold = $true
    Set-Cell $capx.Cells.Item(24,4) "=D21+D22"
    $capx.Range("D24").Font.Bold = $true
    $capx.Range("D24").NumberFormat = "#,##0"

    # ==============================
    # === OPEX ===
    # ==============================
    $opex.Range("A1").Value2 = "OPEX - Custo operacional anual"
    Set-TitleStyle $opex.Range("A1")
    $opex.Range("A2").Value2 = "Custos recorrentes de operacao da planta."
    Set-SubtitleStyle $opex.Range("A2")
    $opex.Range("A4:F4").Value2 = @("Item","Quantidade","Unidade","Custo unitario","Custo anual (R$)","Como calculou")
    Set-HeaderStyle $opex.Range("A4:F4")

    $opexRows = @(
        @("Mao de obra (4 pessoas)","=4","pessoas","=120000","=B5*D5","4 x R$10.000/mes x 12"),
        @("NaOH","=100*365","kg/ano","=4","=B6*D6","100 kg/dia x 365 x R$4/kg"),
        @("Carvao ativado","=16*365","kg/ano","=15","=B7*D7","16 kg/dia x R$15/kg"),
        @("Agua industrial","=2.6*365","m3/ano","=10","=B8*D8","2.6 m3/dia x R$10/m3"),
        @("Manutencao (3% CAPEX)","=1","-","=CAPEX!D21*0.03","=D9","3% do investimento instalado"),
        @("Descarte digestato","=Calculos_Massa!B37*365","kgST/ano","=0.30","=B10*D10","ST x R$0.30/kg"),
        @("Seguro e impostos (2% CAPEX)","=1","-","=CAPEX!D21*0.02","=D11","2% do investimento instalado")
    )

    $row = 5
    foreach ($item in $opexRows) {
        for ($col = 1; $col -le 6; $col++) { Set-Cell $opex.Cells.Item($row,$col) $item[$col-1] }
        $row++
    }
    $opex.Range("E5:E11").NumberFormat = "#,##0"

    Set-Cell $opex.Cells.Item(13,1) "TOTAL OPEX anual"
    $opex.Range("A13").Font.Bold = $true
    Set-Cell $opex.Cells.Item(13,5) "=SUM(E5:E11)"
    $opex.Range("E13").Font.Bold = $true
    $opex.Range("E13").NumberFormat = "#,##0"

    $opex.Range("A16").Value2 = "Receitas anuais"
    Set-SubtitleStyle $opex.Range("A16")
    $opex.Range("A17:E17").Value2 = @("Receita","Quantidade","Unidade","Preco","Valor anual (R$)")
    Set-HeaderStyle $opex.Range("A17:E17")

    Set-Cell $opex.Cells.Item(18,1) "Venda eletricidade"
    Set-Cell $opex.Cells.Item(18,2) "=Balanco_Energia!B15*365"
    Set-Cell $opex.Cells.Item(18,3) "kWh/ano"
    Set-Cell $opex.Cells.Item(18,4) "=Premissas!C51"
    Set-Cell $opex.Cells.Item(18,5) "=B18*D18"

    Set-Cell $opex.Cells.Item(19,1) "Biofertilizante (torta)"
    Set-Cell $opex.Cells.Item(19,2) "=Secagem_Digestato!B12*365"
    Set-Cell $opex.Cells.Item(19,3) "kg/ano"
    Set-Cell $opex.Cells.Item(19,4) 0.05
    Set-Cell $opex.Cells.Item(19,5) "=B19*D19"

    Set-Cell $opex.Cells.Item(20,1) "Creditos de carbono (est.)"
    Set-Cell $opex.Cells.Item(20,2) "=Calculos_Massa!B23*365*0.000714"
    Set-Cell $opex.Cells.Item(20,3) "tCO2eq/ano"
    Set-Cell $opex.Cells.Item(20,4) 200
    Set-Cell $opex.Cells.Item(20,5) "=B20*D20"
    $opex.Range("E18:E20").NumberFormat = "#,##0"

    Set-Cell $opex.Cells.Item(22,1) "TOTAL RECEITAS anual"
    $opex.Range("A22").Font.Bold = $true
    Set-Cell $opex.Cells.Item(22,5) "=SUM(E18:E20)"
    $opex.Range("E22").Font.Bold = $true
    $opex.Range("E22").NumberFormat = "#,##0"

    Set-Cell $opex.Cells.Item(24,1) "RESULTADO OPERACIONAL anual"
    $opex.Range("A24").Font.Bold = $true
    Set-Cell $opex.Cells.Item(24,5) "=E22-E13"
    $opex.Range("E24").Font.Bold = $true
    $opex.Range("E24").NumberFormat = "#,##0"

    # ==============================
    # === FLUXO DE CAIXA ===
    # ==============================
    $flux.Range("A1").Value2 = "Fluxo de caixa projetado (20 anos)"
    Set-TitleStyle $flux.Range("A1")
    $flux.Range("A2").Value2 = "Projecao simplificada sem inflacao, com taxa de desconto."
    Set-SubtitleStyle $flux.Range("A2")

    $flux.Range("A4:G4").Value2 = @("Ano","Investimento","Receita","OPEX","Fluxo liq.","Fluxo desc.","VPL acum.")
    Set-HeaderStyle $flux.Range("A4:G4")

    Set-Cell $flux.Cells.Item(5,1) 0
    Set-Cell $flux.Cells.Item(5,2) "=-CAPEX!D24"
    Set-Cell $flux.Cells.Item(5,3) 0
    Set-Cell $flux.Cells.Item(5,4) 0
    Set-Cell $flux.Cells.Item(5,5) "=B5+C5-D5"
    Set-Cell $flux.Cells.Item(5,6) "=E5"
    Set-Cell $flux.Cells.Item(5,7) "=F5"

    for ($yr = 1; $yr -le 20; $yr++) {
        $r = 5 + $yr
        Set-Cell $flux.Cells.Item($r,1) $yr
        Set-Cell $flux.Cells.Item($r,2) 0
        Set-Cell $flux.Cells.Item($r,3) "=OPEX!E22"
        Set-Cell $flux.Cells.Item($r,4) "=OPEX!E13"
        Set-Cell $flux.Cells.Item($r,5) "=B$r+C$r-D$r"
        Set-Cell $flux.Cells.Item($r,6) "=E$r/(1+Indicadores_Econ!B5)^A$r"
        Set-Cell $flux.Cells.Item($r,7) "=G$(($r-1))+F$r"
    }
    $flux.Range("B5:G25").NumberFormat = "#,##0"

    # ==============================
    # === INDICADORES ECONOMICOS ===
    # ==============================
    $indi.Range("A1").Value2 = "Indicadores economicos"
    Set-TitleStyle $indi.Range("A1")
    $indi.Range("A2").Value2 = "VPL, TIR e payback do projeto."
    Set-SubtitleStyle $indi.Range("A2")

    $indi.Range("A4:C4").Value2 = @("Indicador","Valor","Unidade/Obs")
    Set-HeaderStyle $indi.Range("A4:C4")

    Set-Cell $indi.Cells.Item(5,1) "Taxa de desconto"
    Set-Cell $indi.Cells.Item(5,2) 0.10
    Set-Cell $indi.Cells.Item(5,3) "a.a. (editavel)"
    $indi.Range("B5").NumberFormat = "0.00%"

    Set-Cell $indi.Cells.Item(6,1) "Vida util"
    Set-Cell $indi.Cells.Item(6,2) 20
    Set-Cell $indi.Cells.Item(6,3) "anos"

    Set-Cell $indi.Cells.Item(7,1) "CAPEX total"
    Set-Cell $indi.Cells.Item(7,2) "=CAPEX!D24"
    Set-Cell $indi.Cells.Item(7,3) "R$"
    $indi.Range("B7").NumberFormat = "#,##0"

    Set-Cell $indi.Cells.Item(8,1) "OPEX anual"
    Set-Cell $indi.Cells.Item(8,2) "=OPEX!E13"
    Set-Cell $indi.Cells.Item(8,3) "R$/ano"
    $indi.Range("B8").NumberFormat = "#,##0"

    Set-Cell $indi.Cells.Item(9,1) "Receita anual"
    Set-Cell $indi.Cells.Item(9,2) "=OPEX!E22"
    Set-Cell $indi.Cells.Item(9,3) "R$/ano"
    $indi.Range("B9").NumberFormat = "#,##0"

    Set-Cell $indi.Cells.Item(10,1) "Resultado operacional anual"
    Set-Cell $indi.Cells.Item(10,2) "=OPEX!E24"
    Set-Cell $indi.Cells.Item(10,3) "R$/ano"
    $indi.Range("B10").NumberFormat = "#,##0"

    Set-Cell $indi.Cells.Item(12,1) "VPL (20 anos)"
    Set-Cell $indi.Cells.Item(12,2) "=Fluxo_Caixa!G25"
    Set-Cell $indi.Cells.Item(12,3) "R$"
    $indi.Range("B12").NumberFormat = "#,##0"
    $indi.Range("A12").Font.Bold = $true

    Set-Cell $indi.Cells.Item(13,1) "TIR"
    Set-Cell $indi.Cells.Item(13,2) "=IFERROR(IRR(Fluxo_Caixa!E5:E25),""N/A (negativo)"")"
    Set-Cell $indi.Cells.Item(13,3) "a.a."
    $indi.Range("A13").Font.Bold = $true

    Set-Cell $indi.Cells.Item(14,1) "Payback simples"
    Set-Cell $indi.Cells.Item(14,2) "=IF(OPEX!E24>0,CAPEX!D24/OPEX!E24,""Nao se paga"")"
    Set-Cell $indi.Cells.Item(14,3) "anos"
    $indi.Range("A14").Font.Bold = $true

    Set-Cell $indi.Cells.Item(16,1) "Nota:"
    Set-Cell $indi.Cells.Item(16,2) "Projeto de biogas em ETE e tipicamente viabilizado por obrigacao regulatoria, subsidios e creditos de carbono, nao apenas por venda de eletricidade."

    # ==============================
    # === FORMATACAO FINAL ===
    # ==============================
    foreach ($sheet in @($prem,$calc,$elem,$corr,$ener,$ferm,$veri,$dict,$conc,$util,$cost,$pfvd,$exec,$kpi,$dash,$seca,$dime,$mate,$otim,$capx,$opex,$flux,$indi)) {
        $sheet.UsedRange.Borders.LineStyle = 1
        AutoFit-UsedRange $sheet
        $sheet.Activate() | Out-Null
        try {
            $excel.ActiveWindow.SplitRow = 4
            $excel.ActiveWindow.FreezePanes = $true
        } catch {}
    }

    $prem.Activate() | Out-Null
    $xlOpenXMLWorkbook = 51
    $workbook.SaveAs($outputPath, $xlOpenXMLWorkbook)
    $workbook.Close($true)
    $excel.Quit()
    Write-Output "Planilha criada em: $outputPath"
}
finally {
    if ($workbook) { [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook) }
    if ($excel) { [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) }
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}
