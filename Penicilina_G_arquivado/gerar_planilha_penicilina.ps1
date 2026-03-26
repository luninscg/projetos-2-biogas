$ErrorActionPreference = "Stop"

$outputPath = Join-Path (Get-Location) "Planilha_Penicilina_G.xlsx"

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

function Set-ProcessBox($range, $color) {
    $range.Merge() | Out-Null
    $range.WrapText = $true
    $range.HorizontalAlignment = -4108
    $range.VerticalAlignment = -4108
    $range.Font.Bold = $true
    $range.Interior.Color = $color
    $range.Borders.LineStyle = 1
}

function Set-Cell($cell, $value) {
    if ($null -eq $value) {
        $cell.Value2 = ""
        return
    }

    if ($value -is [string]) {
        if ($value.StartsWith("=")) {
            $cell.Formula = $value
        } else {
            $cell.Value2 = [string]$value
        }
        return
    }

    $cell.Value2 = [double]$value
}

function AutoFit-UsedRange($sheet) {
    $sheet.UsedRange.Columns.AutoFit() | Out-Null
}

$excel = $null
$workbook = $null

try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false

    $workbook = $excel.Workbooks.Add()

    while ($workbook.Worksheets.Count -lt 16) {
        $null = $workbook.Worksheets.Add()
    }

    $sheetNames = @(
        "Premissas",
        "Calculos_Produto",
        "Recuperacoes",
        "Fermentacao",
        "Correntes_PFD",
        "Balanco_Energia",
        "Secagem",
        "Verificacoes",
        "Dicionario_Variaveis",
        "Conceitos",
        "Utilidades",
        "Custos",
        "PFD_Visual",
        "Resumo_Executivo",
        "KPIs",
        "Dashboard"
    )

    for ($i = 1; $i -le $sheetNames.Count; $i++) {
        $workbook.Worksheets.Item($i).Name = $sheetNames[$i - 1]
    }

    while ($workbook.Worksheets.Count -gt $sheetNames.Count) {
        $workbook.Worksheets.Item($workbook.Worksheets.Count).Delete()
    }

    $prem = $workbook.Worksheets.Item("Premissas")
    $calc = $workbook.Worksheets.Item("Calculos_Produto")
    $rec = $workbook.Worksheets.Item("Recuperacoes")
    $ferm = $workbook.Worksheets.Item("Fermentacao")
    $corr = $workbook.Worksheets.Item("Correntes_PFD")
    $ener = $workbook.Worksheets.Item("Balanco_Energia")
    $sec = $workbook.Worksheets.Item("Secagem")
    $veri = $workbook.Worksheets.Item("Verificacoes")
    $dict = $workbook.Worksheets.Item("Dicionario_Variaveis")
    $conc = $workbook.Worksheets.Item("Conceitos")
    $util = $workbook.Worksheets.Item("Utilidades")
    $cost = $workbook.Worksheets.Item("Custos")
    $pfdv = $workbook.Worksheets.Item("PFD_Visual")
    $exec = $workbook.Worksheets.Item("Resumo_Executivo")
    $kpi = $workbook.Worksheets.Item("KPIs")
    $dash = $workbook.Worksheets.Item("Dashboard")

    # Premissas
    $prem.Range("A1").Value2 = "Premissas do modelo - Penicilina G"
    Set-TitleStyle $prem.Range("A1")
    $prem.Range("A3:D3").Value2 = @("Parametro", "Valor", "Unidade", "Observacao")
    Set-HeaderStyle $prem.Range("A3:D3")

    $premissas = @(
        @("Produto final seco", 1000, "kg", "Base de calculo"),
        @("eta_sep", 0.995, "-", "Recuperacao na remocao de biomassa"),
        @("eta_ext1", 0.97, "-", "Recuperacao na extracao primaria"),
        @("eta_ext2", 0.96, "-", "Recuperacao na reextracao/purificacao"),
        @("eta_crist", 0.98, "-", "Recuperacao na cristalizacao/filtracao"),
        @("eta_dry", 0.995, "-", "Recuperacao na secagem/manuseio"),
        @("Titulo de penicilina no caldo", 45, "kg/m3", "Faixa tipica industrial"),
        @("Densidade do caldo", 1030, "kg/m3", "Premissa conceitual"),
        @("Biomassa seca no caldo", 18, "kg/m3", "Premissa conceitual"),
        @("Umidade do bolo final", 0.20, "fracao", "Antes da secagem"),
        @("Umidade residual final", 0.01, "fracao", "Produto final"),
        @("Temperatura inicial", 25, "degC", "Meio antes da esterilizacao"),
        @("Temperatura de esterilizacao", 121, "degC", "Esterilizacao do meio"),
        @("Temperatura de extracao", 5, "degC", "Caldo resfriado"),
        @("Cp do caldo", 4.0, "kJ/kg.K", "Premissa media"),
        @("Cp do solido umido", 1.6, "kJ/kg.K", "Premissa media"),
        @("Calor latente util do vapor", 2130, "kJ/kg", "Vapor util"),
        @("Entalpia de evaporacao na secagem", 2500, "kJ/kg", "Aproximacao"),
        @("Calor de fermentacao especifico", 8000, "kJ/kg produto", "Remocao no fermentador"),
        @("Eficiencia util do vapor", 0.85, "-", "Aquecimento util"),
        @("Fracao solida da torta de biomassa", 0.20, "fracao", "Separacao solido-liquido"),
        @("Relacao solvente/filtrado", 0.25, "kg/kg", "Extracao primaria"),
        @("Fracao de arraste aquoso no extrato", 0.01, "fracao", "Premissa conceitual"),
        @("Rendimento produto/substrato Yp/s", 0.08, "kg/kg", "Glicose equivalente"),
        @("Excesso de PAA", 0.05, "fracao", "Precursor"),
        @("Duracao da fermentacao", 160, "h", "Campanha conceitual"),
        @("Fracao molar de O2 no ar", 0.21, "-", "Ar seco"),
        @("Volume molar normal", 22.414, "Nm3/kmol", "Condicoes normais"),
        @("MM Penicilina G", 334.4, "kg/kmol", "Massa molar"),
        @("MM biomassa empirica", 24.6, "kg/kmol", "CH1.8O0.5N0.2"),
        @("MM glicose equivalente", 180, "kg/kmol", "Base padrao"),
        @("MM acido fenilacetico", 136.15, "kg/kmol", "PAA"),
        @("MM amonia", 17, "kg/kmol", "Equivalente"),
        @("MM enxofre", 32, "kg/kmol", "Elemento"),
        @("MM oxigenio", 32, "kg/kmol", "O2"),
        @("MM CO2", 44, "kg/kmol", "Dioxido de carbono"),
        @("MM ar seco", 28.84, "kg/kmol", "Aproximacao"),
        @("Recuperacao de solvente", 0.95, "-", "Fracao reciclada; custo incide so no make-up"),
        @("Preco glicose equivalente", 2.50, "R$/kg", "Premissa economica editavel"),
        @("Preco PAA", 18.00, "R$/kg", "Premissa economica editavel"),
        @("Preco NH3 equivalente", 4.50, "R$/kg", "Premissa economica editavel"),
        @("Preco acetato de butila", 9.00, "R$/kg", "Premissa economica editavel"),
        @("Preco vapor", 0.18, "R$/kg", "Premissa economica editavel"),
        @("DeltaT agua de resfriamento", 10.0, "degC", "Aproximacao para utilidades"),
        @("Preco agua de resfriamento", 4.00, "R$/m3", "Premissa economica editavel"),
        @("DeltaT agua gelada", 5.0, "degC", "Aproximacao para utilidades"),
        @("Preco frio industrial", 0.08, "R$/MJ", "Premissa economica editavel"),
        @("Preco eletricidade", 0.75, "R$/kWh", "Premissa economica editavel"),
        @("Potencia especifica soprador", 18.0, "kWh/1000 Nm3", "Estimativa conceitual"),
        @("Potencia especifica agitacao", 1.20, "kW/m3", "Estimativa conceitual"),
        @("Preco descarte de biomassa umida", 0.35, "R$/kg", "Premissa economica editavel"),
        @("Preco tratamento efluente liquido", 0.015, "R$/kg", "Premissa economica editavel")
    )

    $row = 4
    foreach ($item in $premissas) {
        Set-Cell $prem.Cells.Item($row, 1) $item[0]
        Set-Cell $prem.Cells.Item($row, 2) $item[1]
        Set-Cell $prem.Cells.Item($row, 3) $item[2]
        Set-Cell $prem.Cells.Item($row, 4) $item[3]
        $row++
    }
    $prem.Range("B4:B55").NumberFormat = "0.0000"

    # Calculos_Produto
    $calc.Range("A1").Value2 = "Calculos principais do produto"
    Set-TitleStyle $calc.Range("A1")
    $calc.Range("A3:B3").Value2 = @("Descricao", "Valor")
    Set-HeaderStyle $calc.Range("A3:B3")

    $calcRows = @(
        @("eta_global", "=Premissas!B5*Premissas!B6*Premissas!B7*Premissas!B8*Premissas!B9"),
        @("Penicilina no caldo, kg", "=Premissas!B4/B4"),
        @("Volume de caldo, m3", "=B5/Premissas!B10"),
        @("Massa de caldo, kg", "=B6*Premissas!B11"),
        @("Biomassa seca, kg", "=Premissas!B12*B6"),
        @("Torta umida removida, kg", "=B8/Premissas!B24"),
        @("Agua arrastada na torta, kg", "=B9-B8"),
        @("Liquido clarificado para extracao, kg", "=B7-B9"),
        @("Penicilina apos separacao, kg", "=B5*Premissas!B5"),
        @("Penicilina apos extracao primaria, kg", "=B12*Premissas!B6"),
        @("Penicilina apos reextracao, kg", "=B13*Premissas!B7"),
        @("Penicilina apos cristalizacao, kg", "=B14*Premissas!B8"),
        @("Produto final calculado, kg", "=B15*Premissas!B9"),
        @("Perda total de produto, kg", "=B5-B16")
    )

    $row = 4
    foreach ($item in $calcRows) {
        Set-Cell $calc.Cells.Item($row, 1) $item[0]
        Set-Cell $calc.Cells.Item($row, 2) $item[1]
        $row++
    }
    $calc.Range("B4:B18").NumberFormat = "0.0000"

    # Recuperacoes
    $rec.Range("A1").Value2 = "Recuperacoes por etapa"
    Set-TitleStyle $rec.Range("A1")
    $rec.Range("A3:F3").Value2 = @("Etapa", "Produto entrada (kg)", "Eficiencia", "Produto saida (kg)", "Perda (kg)", "Perda acumulada (kg)")
    Set-HeaderStyle $rec.Range("A3:F3")

    Set-Cell $rec.Cells.Item(4,1) "Caldo fermentado"
    Set-Cell $rec.Cells.Item(4,2) "=Calculos_Produto!B5"
    Set-Cell $rec.Cells.Item(4,3) 1
    Set-Cell $rec.Cells.Item(4,4) "=B4*C4"
    Set-Cell $rec.Cells.Item(4,5) "=B4-D4"
    Set-Cell $rec.Cells.Item(4,6) "=E4"

    $etapas = @(
        @("Separacao de biomassa", "=D4", "=Premissas!B5"),
        @("Extracao primaria", "=D5", "=Premissas!B6"),
        @("Reextracao/purificacao", "=D6", "=Premissas!B7"),
        @("Cristalizacao/filtracao", "=D7", "=Premissas!B8"),
        @("Secagem final", "=D8", "=Premissas!B9")
    )

    $row = 5
    foreach ($etapa in $etapas) {
        Set-Cell $rec.Cells.Item($row,1) $etapa[0]
        Set-Cell $rec.Cells.Item($row,2) $etapa[1]
        Set-Cell $rec.Cells.Item($row,3) $etapa[2]
        Set-Cell $rec.Cells.Item($row,4) "=B$row*C$row"
        Set-Cell $rec.Cells.Item($row,5) "=B$row-D$row"
        $prev = $row - 1
        Set-Cell $rec.Cells.Item($row,6) "=F$prev+E$row"
        $row++
    }
    $rec.Range("B4:F9").NumberFormat = "0.0000"

    # Fermentacao
    $ferm.Range("A1").Value2 = "Fermentacao pseudoestequiometrica"
    Set-TitleStyle $ferm.Range("A1")
    $ferm.Range("A3:B3").Value2 = @("Grandeza", "Valor")
    Set-HeaderStyle $ferm.Range("A3:B3")

    $fermRows = @(
        @("n_pen, kmol", "=Calculos_Produto!B5/Premissas!B32"),
        @("n_biomassa, kmol", "=Calculos_Produto!B8/Premissas!B33"),
        @("Substrato equivalente consumido, kg", "=Calculos_Produto!B5/Premissas!B27"),
        @("Substrato equivalente, kmol", "=B6/Premissas!B34"),
        @("Yx/s, kg/kg", "=Calculos_Produto!B8/B6"),
        @("n_PAA, kmol", "=(1+Premissas!B28)*B4"),
        @("m_PAA, kg", "=B9*Premissas!B35"),
        @("n_N biomassa, kmol", "=0.2*B5"),
        @("n_N penicilina, kmol", "=2*B4"),
        @("n_N total, kmol", "=B11+B12"),
        @("NH3 equivalente, kg", "=B13*Premissas!B36"),
        @("n_S penicilina, kmol", "=B4"),
        @("Enxofre equivalente, kg", "=B15*Premissas!B37"),
        @("n_C no substrato, kmol", "=6*B7"),
        @("n_C na biomassa, kmol", "=B5"),
        @("n_C na penicilina, kmol", "=16*B4"),
        @("n_CO2 gerado, kmol", "=B17-B18-B19"),
        @("m_CO2 gerado, kg", "=B20*Premissas!B39"),
        @("n_H2O gerada, kmol", "=((12*B7)+(3*B13)-(1.8*B5+18*B4))/2"),
        @("m_H2O gerada, kg", "=B22*18"),
        @("n_O2 consumido, kmol", "=((0.5*B5)+(4*B4)+(2*B20)+B22-(6*B7))/2"),
        @("m_O2 consumido, kg", "=B24*Premissas!B38"),
        @("n_ar total, kmol", "=B24/Premissas!B30"),
        @("Ar total, Nm3", "=B26*Premissas!B31"),
        @("Massa de ar, kg", "=B26*Premissas!B40"),
        @("Vazao media de ar, Nm3/h", "=B27/Premissas!B29"),
        @("vvm medio", "=B29/(Calculos_Produto!B6*60)")
    )

    $row = 4
    foreach ($item in $fermRows) {
        Set-Cell $ferm.Cells.Item($row,1) $item[0]
        Set-Cell $ferm.Cells.Item($row,2) $item[1]
        $row++
    }
    $ferm.Range("B4:B30").NumberFormat = "0.0000"

    # Correntes PFD
    $corr.Range("A1").Value2 = "Tabela de correntes - PFD"
    Set-TitleStyle $corr.Range("A1")
    $corr.Range("A3:H3").Value2 = @("Corrente", "Descricao", "Massa total (kg)", "Penicilina (kg)", "Biomassa (kg)", "Solvente (kg)", "Agua + outros (kg)", "Observacao")
    Set-HeaderStyle $corr.Range("A3:H3")

    $corrData = @(
        @(101, "Caldo fermentado", "=Calculos_Produto!B7", "=Calculos_Produto!B5", "=Calculos_Produto!B8", 0, "=C4-D4-E4-F4", "Saida do fermentador"),
        @(102, "Torta de biomassa", "=Calculos_Produto!B9", "=Calculos_Produto!B5-Calculos_Produto!B12", "=Calculos_Produto!B8", 0, "=C5-D5-E5-F5", "Remocao de biomassa"),
        @(103, "Filtrado clarificado", "=Calculos_Produto!B11", "=Calculos_Produto!B12", 0, 0, "=C6-D6", "Segue para extracao"),
        @(104, "Solvente para extracao", "=Premissas!B25*Calculos_Produto!B11", 0, 0, "=C7", 0, "Acetato de butila"),
        @(105, "Extrato organico", "=D8+F8+G8", "=Calculos_Produto!B13", 0, "=C7", "=Premissas!B26*Calculos_Produto!B11", "Fase organica rica"),
        @(106, "Rafinado aquoso", "=D9+G9", "=Calculos_Produto!B12-Calculos_Produto!B13", 0, 0, "=(Calculos_Produto!B11-Calculos_Produto!B12)-(Premissas!B26*Calculos_Produto!B11)", "Fase aquosa"),
        @(107, "Solucao purificada", "", "=Calculos_Produto!B14", 0, "", "", "Carga para cristalizacao"),
        @(108, "Licor mae / perdas", "", "=Calculos_Produto!B14-Calculos_Produto!B15", 0, "", "", "Perda na cristalizacao"),
        @(109, "Cristais umidos", "=Secagem!B5", "=Calculos_Produto!B15", 0, 0, "=Secagem!B6", "Entrada do secador"),
        @(110, "Produto final", "=Secagem!B7", "=Premissas!B4", 0, 0, "=Secagem!B8", "Produto seco"),
        @(111, "Agua evaporada", "=Secagem!B9", 0, 0, 0, "=Secagem!B9", "Saida do secador"),
        @(112, "Perda de penicilina na secagem", "=Calculos_Produto!B15-Calculos_Produto!B16", "=Calculos_Produto!B15-Calculos_Produto!B16", 0, 0, 0, "Perda de manuseio/secagem")
    )

    $row = 4
    foreach ($item in $corrData) {
        for ($col = 1; $col -le 8; $col++) {
            Set-Cell $corr.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }
    $corr.Range("C4:G15").NumberFormat = "0.0000"

    # Balanco_Energia
    $ener.Range("A1").Value2 = "Balanco de energia"
    Set-TitleStyle $ener.Range("A1")
    $ener.Range("A3:I3").Value2 = @("Etapa", "Massa (kg)", "Cp", "Tin", "Tout", "Q sensivel (kJ)", "Q latente (kJ)", "Q total (kJ)", "Tipo")
    Set-HeaderStyle $ener.Range("A3:I3")

    $enerRows = @(
        @("Esterilizacao", "=Calculos_Produto!B7", "=Premissas!B18", "=Premissas!B15", "=Premissas!B16", "=B4*C4*(E4-D4)", 0, "=F4+G4", "Aquecimento"),
        @("Resfriamento pos-esterilizacao", "=Calculos_Produto!B7", "=Premissas!B18", "=Premissas!B16", "=Premissas!B15", "=B5*C5*(D5-E5)", 0, "=F5+G5", "Resfriamento"),
        @("Calor da fermentacao", "=Calculos_Produto!B5", 0, 0, 0, 0, 0, "=Premissas!B22*Calculos_Produto!B5", "Resfriamento"),
        @("Resfriamento para extracao", "=Calculos_Produto!B11", "=Premissas!B18", "=Premissas!B15", "=Premissas!B17", "=B7*C7*(D7-E7)", 0, "=F7+G7", "Resfriamento"),
        @("Secagem", "=Secagem!B9", 0, 0, 0, 0, "=Secagem!B10", "=F8+G8", "Aquecimento")
    )

    $row = 4
    foreach ($item in $enerRows) {
        for ($col = 1; $col -le 9; $col++) {
            Set-Cell $ener.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }
    $ener.Range("B4:H8").NumberFormat = "0.0000"
    $ener.Range("A10:B10").Value2 = @("Vapor teorico, kg", "")
    $ener.Range("A11:B11").Value2 = @("Vapor real, kg", "")
    $ener.Range("B10").Formula = "=H4/Premissas!B20"
    $ener.Range("B11").Formula = "=B10/Premissas!B23"
    $ener.Range("B10:B11").NumberFormat = "0.0000"

    # Secagem
    $sec.Range("A1").Value2 = "Calculos da secagem"
    Set-TitleStyle $sec.Range("A1")
    $sec.Range("A3:B3").Value2 = @("Grandeza", "Valor")
    Set-HeaderStyle $sec.Range("A3:B3")

    $secRows = @(
        @("Solido seco antes do secador, kg", "=Calculos_Produto!B15"),
        @("Massa total do bolo, kg", "=B4/(1-Premissas!B13)"),
        @("Agua no bolo, kg", "=B5-B4"),
        @("Massa final umida, kg", "=Premissas!B4/(1-Premissas!B14)"),
        @("Agua final residual, kg", "=B7-Premissas!B4"),
        @("Agua evaporada, kg", "=B6-B8"),
        @("Carga de secagem, kJ", "=B9*Premissas!B21")
    )

    $row = 4
    foreach ($item in $secRows) {
        Set-Cell $sec.Cells.Item($row,1) $item[0]
        Set-Cell $sec.Cells.Item($row,2) $item[1]
        $row++
    }
    $sec.Range("B4:B10").NumberFormat = "0.0000"

    # Verificacoes
    $veri.Range("A1").Value2 = "Verificacoes de consistencia"
    Set-TitleStyle $veri.Range("A1")
    $veri.Range("A3:E3").Value2 = @("Verificacao", "Como foi checado", "Residual", "Unidade", "Leitura")
    Set-HeaderStyle $veri.Range("A3:E3")

    $veriRows = @(
        @("Fechamento do produto final", "Produto calculado - produto alvo", "=Calculos_Produto!B16-Premissas!B4", "kg", "=IF(ABS(C4)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento de recuperacoes", "Produto final + perdas - produto no caldo", "=SUM(Recuperacoes!E5:E9)+Recuperacoes!D9-Recuperacoes!B4", "kg", "=IF(ABS(C5)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento massa na separacao", "Corrente 101 - 102 - 103", "=Correntes_PFD!C4-Correntes_PFD!C5-Correntes_PFD!C6", "kg", "=IF(ABS(C6)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento massa na extracao", "Corrente 103 + 104 - 105 - 106", "=Correntes_PFD!C6+Correntes_PFD!C7-Correntes_PFD!C8-Correntes_PFD!C9", "kg", "=IF(ABS(C7)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento total na secagem", "Corrente 109 - 110 - 111 - 112", "=Correntes_PFD!C12-Correntes_PFD!C13-Correntes_PFD!C14-Correntes_PFD!C15", "kg", "=IF(ABS(C8)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento de solido na secagem", "Penicilina em 109 - 110 - 112", "=Correntes_PFD!D12-Correntes_PFD!D13-Correntes_PFD!D15", "kg", "=IF(ABS(C9)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento de agua na secagem", "Agua em 109 - 110 - 111", "=Correntes_PFD!G12-Correntes_PFD!G13-Correntes_PFD!G14", "kg", "=IF(ABS(C10)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento de carbono na fermentacao", "C alimentado - C em biomassa - C em penicilina - C em CO2", "=Fermentacao!B17-Fermentacao!B18-Fermentacao!B19-Fermentacao!B20", "kmol C", "=IF(ABS(C11)<=1E-6,""OK"",""Revisar"")"),
        @("Fechamento de vapor", "Vapor real - vapor teorico/eficiencia", "=Balanco_Energia!B11-(Balanco_Energia!B10/Premissas!B23)", "kg", "=IF(ABS(C12)<=1E-6,""OK"",""Revisar"")")
    )

    $row = 4
    foreach ($item in $veriRows) {
        for ($col = 1; $col -le 5; $col++) {
            Set-Cell $veri.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }
    $veri.Range("C4:C12").NumberFormat = "0.000000"

    # Dicionario_Variaveis
    $dict.Range("A1").Value2 = "Dicionario de variaveis"
    Set-TitleStyle $dict.Range("A1")
    $dict.Range("A2").Value2 = "Esta aba explica o significado fisico, a unidade e o papel de cada variavel principal da planilha."
    $dict.Range("A4:G4").Value2 = @("Variavel", "Nome simples", "Definicao didatica", "Unidade", "Formula ou origem", "Onde aparece", "Por que importa")
    Set-HeaderStyle $dict.Range("A4:G4")

    $dictRows = @(
        @("P_final", "Produto final seco", "Massa de penicilina seca que se deseja obter ao final da campanha.", "kg", "Premissa de projeto", "Premissas, KPIs, Dashboard", "Define toda a escala do estudo."),
        @("eta_sep", "Recuperacao na separacao", "Fracao de penicilina que continua no liquido apos remover a biomassa.", "-", "Premissa", "Premissas, Recuperacoes", "Mostra quanto produto se perde com a torta de biomassa."),
        @("eta_ext1", "Recuperacao na extracao primaria", "Fracao de penicilina transferida da fase aquosa para o solvente na primeira extracao.", "-", "Premissa", "Premissas, Recuperacoes", "Afeta fortemente a perda no downstream."),
        @("eta_ext2", "Recuperacao na purificacao", "Fracao de penicilina preservada na reextracao e purificacao.", "-", "Premissa", "Premissas, Recuperacoes", "Representa o desempenho da etapa de limpeza do produto."),
        @("eta_crist", "Recuperacao na cristalizacao", "Fracao de penicilina que efetivamente vira cristal recuperavel.", "-", "Premissa", "Premissas, Recuperacoes", "Indica a eficiencia da etapa que transforma soluto em cristais."),
        @("eta_dry", "Recuperacao na secagem", "Fracao de penicilina mantida apos secagem e manuseio final.", "-", "Premissa", "Premissas, Recuperacoes, Correntes_PFD", "Captura perdas finais de produto."),
        @("C_penic", "Titulo no caldo", "Concentracao de penicilina no caldo fermentado.", "kg/m3", "Premissa", "Premissas, Calculos_Produto", "Liga massa de produto ao volume de fermentacao."),
        @("rho_broth", "Densidade do caldo", "Massa por unidade de volume do caldo fermentado.", "kg/m3", "Premissa", "Premissas, Calculos_Produto", "Permite converter volume em massa total de caldo."),
        @("C_x", "Concentracao de biomassa", "Quantidade de biomassa seca presente por volume de caldo.", "kg/m3", "Premissa", "Premissas, Calculos_Produto", "Determina a carga de solidos que vai para a separacao."),
        @("Xw_cake", "Umidade do bolo", "Fracao da massa do bolo que ainda e agua antes da secagem.", "-", "Premissa", "Premissas, Secagem", "Define quanta agua precisa ser removida."),
        @("Xw_final", "Umidade final", "Fracao de agua que permanece no produto final.", "-", "Premissa", "Premissas, Secagem", "Define a massa final umida do produto."),
        @("T_in", "Temperatura inicial", "Temperatura do meio antes do aquecimento para esterilizacao.", "degC", "Premissa", "Premissas, Balanco_Energia", "Entra no calculo de aquecimento do meio."),
        @("T_ster", "Temperatura de esterilizacao", "Temperatura alvo para esterilizar o meio e evitar contaminacao.", "degC", "Premissa", "Premissas, Balanco_Energia", "Determina a principal carga de aquecimento."),
        @("T_ext", "Temperatura de extracao", "Temperatura reduzida do liquido antes da extracao com solvente.", "degC", "Premissa", "Premissas, Balanco_Energia", "Afeta a demanda de resfriamento para extracao."),
        @("Cp_broth", "Calor especifico do caldo", "Energia necessaria para aquecer 1 kg de caldo em 1 grau Celsius.", "kJ/kg.K", "Premissa", "Premissas, Balanco_Energia", "Entra nos calculos de aquecimento e resfriamento sensivel."),
        @("lambda_steam", "Calor latente util do vapor", "Energia entregue por cada kg de vapor util na condensacao.", "kJ/kg", "Premissa", "Premissas, Balanco_Energia", "Permite converter carga termica em consumo de vapor."),
        @("lambda_dry", "Entalpia de secagem", "Energia media para evaporar a agua removida no secador.", "kJ/kg", "Premissa", "Premissas, Secagem, Balanco_Energia", "Controla a carga termica da secagem."),
        @("q_ferm", "Calor de fermentacao especifico", "Carga termica media gerada pela fermentacao por kg de penicilina no caldo.", "kJ/kg", "Premissa", "Premissas, Balanco_Energia", "Representa a remocao de calor metabolico."),
        @("Yp/s", "Rendimento produto/substrato", "Massa de penicilina formada por massa de glicose equivalente consumida.", "kg/kg", "Premissa", "Premissas, Fermentacao", "Permite estimar consumo de substrato."),
        @("P_broth", "Penicilina no caldo", "Massa de penicilina que precisa existir no caldo antes das perdas do downstream.", "kg", "P_final / eta_global", "Calculos_Produto, Recuperacoes", "E o elo entre meta de producao e perdas do processo."),
        @("V_broth", "Volume de caldo", "Volume total de caldo fermentado necessario para conter a penicilina desejada.", "m3", "P_broth / C_penic", "Calculos_Produto, KPIs", "Ajuda a dimensionar fermentador e utilidades."),
        @("M_broth", "Massa de caldo", "Massa total do caldo fermentado.", "kg", "V_broth * rho_broth", "Calculos_Produto, Balanco_Energia", "Define a carga de aquecimento e resfriamento do meio."),
        @("M_x_dry", "Biomassa seca", "Massa seca do fungo produzida no fermentador.", "kg", "C_x * V_broth", "Calculos_Produto, Correntes_PFD", "Mostra o solido removido antes da extracao."),
        @("M_cake_wet", "Torta umida", "Massa total da torta retirada no filtro ou centrifuga.", "kg", "M_x_dry / fracao solida", "Calculos_Produto, Correntes_PFD", "Quantifica solidos mais agua arrastada."),
        @("M_liq_ext", "Liquido para extracao", "Massa liquida que segue para a extracao apos retirar a torta de biomassa.", "kg", "M_broth - M_cake_wet", "Calculos_Produto, Balanco_Energia", "Base para solvente, resfriamento e correntes da extracao."),
        @("Q_ster", "Carga de esterilizacao", "Energia sensivel para aquecer o meio da temperatura inicial ate a de esterilizacao.", "kJ", "M_broth * Cp_broth * (T_ster - T_in)", "Balanco_Energia", "Uma das maiores demandas energeticas do processo."),
        @("m_steam_real", "Vapor real", "Consumo de vapor corrigido pela eficiencia util do aquecimento.", "kg", "Q_ster / lambda_steam / eficiencia", "Balanco_Energia, KPIs", "Traduz energia em utilidade industrial."),
        @("Q_ferm", "Calor da fermentacao", "Energia que precisa ser removida do fermentador durante a producao.", "kJ", "q_ferm * P_broth", "Balanco_Energia", "Dimensiona a refrigeracao do fermentador."),
        @("Q_chill", "Carga de resfriamento para extracao", "Energia retirada do liquido para leva-lo da fermentacao ate a temperatura de extracao.", "kJ", "M_liq_ext * Cp_broth * (T_in - T_ext)", "Balanco_Energia", "Mostra a demanda de frio da etapa de extracao."),
        @("n_pen", "Quantidade de materia de penicilina", "Numero de kmol de penicilina presentes no caldo.", "kmol", "P_broth / MM penicilina", "Fermentacao", "Permite fazer os balancos elementares."),
        @("n_x", "Quantidade de biomassa", "Numero de kmol da formula empirica de biomassa.", "kmol", "M_x_dry / MM biomassa", "Fermentacao", "Permite fechar C, H, O e N na biomassa."),
        @("m_s", "Substrato consumido", "Massa de glicose equivalente consumida para sustentar a fermentacao.", "kg", "P_broth / Yp/s", "Fermentacao", "Estimativa inicial de necessidade carbonada."),
        @("m_PAA", "Precursor PAA", "Massa de acido fenilacetico estimada para formar a cadeia lateral da penicilina G.", "kg", "1.05 * n_pen * MM_PAA", "Fermentacao", "Mostra a necessidade de precursor especifico."),
        @("m_NH3_eq", "Amonia equivalente", "Quantidade de nitrogenio quimicamente retida em produto e biomassa expressa como NH3.", "kg", "n_N_total * MM_NH3", "Fermentacao", "Estimativa inicial do consumo nitrogenado."),
        @("m_CO2", "CO2 gerado", "Massa de dioxido de carbono liberada pela respiracao e metabolismo.", "kg", "n_CO2 * MM_CO2", "Fermentacao, KPIs", "Importante para ventilacao, emissao e interpretacao do metabolismo."),
        @("m_O2", "O2 consumido", "Massa de oxigenio requerida pela fermentacao aerobia.", "kg", "n_O2 * MM_O2", "Fermentacao", "Base para estimativa de ar e transferencia de oxigenio."),
        @("V_ar_N", "Ar total normal", "Volume de ar total requerido em condicoes normais.", "Nm3", "n_ar * volume molar normal", "Fermentacao, KPIs", "Ajuda a avaliar aeracao e sopradores."),
        @("eta_solvente", "Recuperacao de solvente", "Fracao de solvente recuperada e reciclada internamente.", "-", "Premissa economica", "Premissas, Custos", "Define quanto solvente novo precisa ser comprado."),
        @("Preco_vapor", "Preco do vapor", "Custo medio de 1 kg de vapor util entregue ao processo.", "R$/kg", "Premissa economica", "Premissas, Utilidades", "Converte a carga termica em custo."),
        @("Preco_eletricidade", "Preco da eletricidade", "Custo de 1 kWh de energia eletrica.", "R$/kWh", "Premissa economica", "Premissas, Utilidades", "Permite estimar custo de soprador e agitacao."),
        @("OPEX", "Custo operacional", "Soma dos custos de materias-primas, utilidades e tratamento de residuos.", "R$", "Somatorio da aba Custos", "Custos, KPIs, Dashboard", "Ajuda a comparar cenarios e identificar gargalos economicos."),
        @("Custo_especifico", "Custo por kg de produto", "Razao entre o custo total da campanha e a massa final produzida.", "R$/kg", "OPEX / P_final", "Custos, KPIs, Dashboard", "Mostra a intensidade economica do processo.")
    )

    $row = 5
    foreach ($item in $dictRows) {
        for ($col = 1; $col -le 7; $col++) {
            Set-Cell $dict.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }

    # Conceitos
    $conc.Range("A1").Value2 = "Conceitos utilizados no modelo"
    Set-TitleStyle $conc.Range("A1")
    $conc.Range("A2").Value2 = "Leitura recomendada: comece por esta aba se quiser entender a intuicao fisica antes das formulas."
    $conc.Range("A4:D4").Value2 = @("Conceito", "Definicao simples", "Definicao tecnica", "Por que aparece na planilha")
    Set-HeaderStyle $conc.Range("A4:D4")

    $conceitos = @(
        @("Balanco de massa", "Tudo o que entra, sai, e se acumula precisa fechar.", "Aplicacao da conservacao da massa a um volume de controle.", "E a base de todas as correntes e perdas da planilha."),
        @("Balanco de energia", "Energia nao surge do nada nem desaparece.", "Aplicacao da Primeira Lei da Termodinamica ao processo.", "Explica as cargas de aquecimento e resfriamento."),
        @("Recuperacao", "Parte do produto que sobrevive a uma etapa.", "Razao entre a massa de produto na saida util e a massa de produto na entrada.", "Usada nas etapas de separacao, extracao, cristalizacao e secagem."),
        @("Caldo fermentado", "Mistura liquida que sai do fermentador.", "Suspensao contendo agua, penicilina, biomassa e solutos dissolvidos.", "E o ponto de partida do downstream."),
        @("Biomassa", "Massa do fungo crescido na fermentacao.", "Massa celular seca do microrganismo produtor.", "Precisa ser removida antes da extracao."),
        @("Extracao liquido-liquido", "Separacao por preferencia do soluto entre duas fases.", "Transferencia de penicilina da fase aquosa para uma fase organica.", "Representa a etapa principal de recuperacao do produto."),
        @("Reextracao/purificacao", "Nova transferencia para limpar o produto.", "Operacao de purificacao que reduz impurezas e prepara a cristalizacao.", "Melhora a qualidade e reduz contaminantes."),
        @("Cristalizacao", "Transformacao do produto dissolvido em cristais.", "Operacao em que a solubilidade e reduzida para precipitar o soluto.", "Permite separar a penicilina como solido recuperavel."),
        @("Secagem", "Remocao de agua do bolo cristalino.", "Operacao termica de evaporacao da umidade residual do produto.", "Entrega o produto em forma mais estavel e comercial."),
        @("Pseudo-estequiometria", "Modelo simplificado de uma fermentacao real muito complexa.", "Fechamento aproximado de C, H, O e N usando reacoes globais equivalentes.", "Permite estimar substrato, O2, CO2 e precursor."),
        @("Glicose equivalente", "Forma padrao de representar a alimentacao carbonada.", "Base de comparacao que converte diferentes fontes de carbono em um equivalente comum.", "Facilita o uso do rendimento Yp/s."),
        @("PAA", "Precursor que ajuda a formar a penicilina G.", "Acido fenilacetico, fornecedor da cadeia lateral aromatica do produto.", "Sem ele, a rota especifica para Penicilina G nao fecha."),
        @("vvm", "Volumes de ar por volume de liquido por minuto.", "Indicador de intensidade de aeracao de fermentadores.", "Ajuda a avaliar se a estimativa de ar parece plausivel."),
        @("PFD", "Fluxograma de processo com correntes numeradas.", "Process Flow Diagram com equipamentos principais e correntes resumidas.", "A aba de correntes foi organizada para alimentar um PFD conceitual."),
        @("Calor latente", "Energia usada para mudar de fase sem mudar a temperatura.", "Energia de evaporacao ou condensacao por unidade de massa.", "Entra no vapor de esterilizacao e na secagem."),
        @("Fechamento", "Teste para ver se o calculo faz sentido fisico.", "Residual obtido ao comparar entradas, saidas e acumulacoes calculadas.", "A aba Verificacoes mostra se o modelo esta consistente."),
        @("Utilidade", "Recurso auxiliar que faz o processo funcionar.", "Servicos industriais como vapor, eletricidade, agua de resfriamento e frio industrial.", "A aba Utilidades traduz demanda fisica em consumo operacional."),
        @("Make-up de solvente", "Parte do solvente que precisa ser reposta.", "Quantidade de solvente fresco necessaria apos considerar reciclo e perdas.", "Aparece na aba Custos porque comprar todo o solvente seria economicamente irreal."),
        @("OPEX", "Custo operacional de campanha.", "Soma de materias-primas, utilidades e tratamento associados a uma campanha produtiva.", "A aba Custos foi criada para comparacao economica conceitual.")
    )

    $row = 5
    foreach ($item in $conceitos) {
        for ($col = 1; $col -le 4; $col++) {
            Set-Cell $conc.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }

    # Utilidades
    $util.Range("A1").Value2 = "Utilidades detalhadas"
    Set-TitleStyle $util.Range("A1")
    $util.Range("A2").Value2 = "Esta aba converte cargas de energia e aeracao em consumos de utilidades e custo associado."
    $util.Range("A4:H4").Value2 = @("Utilidade", "Base fisica", "Quantidade", "Unidade", "Custo unitario", "Unidade custo", "Subtotal (R$)", "Observacao")
    Set-HeaderStyle $util.Range("A4:H4")

    $utilRows = @(
        @("Vapor para esterilizacao", "Balanco_Energia!B11", "=Balanco_Energia!B11", "kg", "=Premissas!B46", "R$/kg", "=C5*E5", "Vapor real considerando eficiencia util"),
        @("Vapor equivalente para secagem", "Q secagem / lambda vapor", "=Balanco_Energia!H8/Premissas!B20", "kg", "=Premissas!B46", "R$/kg", "=C6*E6", "Equivalente termico para a secagem"),
        @("Agua de resfriamento equivalente", "(Q pos-ester + Q ferm)/(Cp*DeltaT)", "=(Balanco_Energia!H5+Balanco_Energia!H6)/(4.18*Premissas!B47)/1000", "m3", "=Premissas!B48", "R$/m3", "=C7*E7", "Remocao de calor com agua industrial"),
        @("Frio industrial para extracao", "Carga de resfriamento para 5 degC", "=Balanco_Energia!H7/1000", "MJ", "=Premissas!B50", "R$/MJ", "=C8*E8", "Uso de utilidade fria"),
        @("Eletricidade do soprador", "Ar total x potencia especifica", "=Fermentacao!B27/1000*Premissas!B52", "kWh", "=Premissas!B51", "R$/kWh", "=C9*E9", "Estimativa conceitual do soprador"),
        @("Eletricidade de agitacao", "Potencia x volume x tempo", "=Premissas!B53*Calculos_Produto!B6*Premissas!B29", "kWh", "=Premissas!B51", "R$/kWh", "=C10*E10", "Estimativa conceitual da agitacao")
    )

    $row = 5
    foreach ($item in $utilRows) {
        for ($col = 1; $col -le 8; $col++) {
            Set-Cell $util.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }
    $util.Range("C5:G10").NumberFormat = "0.0000"
    $util.Range("A12").Value2 = "Total de utilidades"
    $util.Range("G12").Formula = "=SUM(G5:G10)"
    $util.Range("A12:G12").Font.Bold = $true
    $util.Range("A12:H12").Borders.LineStyle = 1

    # Custos
    $cost.Range("A1").Value2 = "Custos conceituais da campanha"
    Set-TitleStyle $cost.Range("A1")
    $cost.Range("A2").Value2 = "Custos editaveis e conceituais. Esta aba nao representa orcamento executivo; ela serve para comparacao de cenarios."
    $cost.Range("A4:H4").Value2 = @("Categoria", "Item", "Quantidade", "Unidade", "Custo unitario", "Unidade custo", "Subtotal (R$)", "Base")
    Set-HeaderStyle $cost.Range("A4:H4")

    $costRows = @(
        @("Materia-prima", "Glicose equivalente", "=Fermentacao!B6", "kg", "=Premissas!B42", "R$/kg", "=C5*E5", "Consumo estimado na fermentacao"),
        @("Materia-prima", "Acido fenilacetico (PAA)", "=Fermentacao!B10", "kg", "=Premissas!B43", "R$/kg", "=C6*E6", "Precursor da cadeia lateral"),
        @("Materia-prima", "NH3 equivalente", "=Fermentacao!B14", "kg", "=Premissas!B44", "R$/kg", "=C7*E7", "Nitrogenio assimilado"),
        @("Solvente", "Make-up de acetato de butila", "=Correntes_PFD!F7*(1-Premissas!B41)", "kg", "=Premissas!B45", "R$/kg", "=C8*E8", "Somente reposicao; considera reciclo"),
        @("Tratamento", "Descarte de biomassa umida", "=Correntes_PFD!C5", "kg", "=Premissas!B54", "R$/kg", "=C9*E9", "Torta removida"),
        @("Tratamento", "Tratamento de efluente liquido", "=Correntes_PFD!C9+Correntes_PFD!C5", "kg", "=Premissas!B55", "R$/kg", "=C10*E10", "Rafinado + torta umida encaminhados a tratamento"),
        @("Utilidades", "Total de utilidades", "=0", "-", "=0", "-", "=Utilidades!G12", "Somatorio da aba Utilidades")
    )

    $row = 5
    foreach ($item in $costRows) {
        for ($col = 1; $col -le 8; $col++) {
            Set-Cell $cost.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }
    $cost.Range("C5:G11").NumberFormat = "0.0000"
    $cost.Range("A13").Value2 = "Custo operacional total da campanha"
    $cost.Range("G13").Formula = "=SUM(G5:G11)"
    $cost.Range("A14").Value2 = "Custo operacional especifico"
    $cost.Range("G14").Formula = "=G13/Premissas!B4"
    $cost.Range("H14").Value2 = "R$/kg produto"
    $cost.Range("A13:H14").Font.Bold = $true
    $cost.Range("A13:H14").Borders.LineStyle = 1

    # PFD_Visual
    $pfdv.Range("A1").Value2 = "PFD visual simplificado - Penicilina G"
    Set-TitleStyle $pfdv.Range("A1")
    $pfdv.Range("A2").Value2 = "Fluxograma conceitual ligado as correntes numeradas da aba Correntes_PFD."
    $pfdv.Range("A4:AG20").RowHeight = 28
    $pfdv.Range("A:AG").ColumnWidth = 12

    Set-ProcessBox $pfdv.Range("B5:D7") 13434879
    $pfdv.Range("B5").Value2 = "F-101`nFermentador`nSaida 101"
    Set-ProcessBox $pfdv.Range("G5:I7") 13434879
    $pfdv.Range("G5").Value2 = "S-101`nSeparacao de biomassa`nSaida 103"
    Set-ProcessBox $pfdv.Range("L5:N7") 13434879
    $pfdv.Range("L5").Value2 = "E-101`nExtracao primaria`nSaidas 105 e 106"
    Set-ProcessBox $pfdv.Range("Q5:S7") 13434879
    $pfdv.Range("Q5").Value2 = "P-101`nPurificacao`nSaida 107"
    Set-ProcessBox $pfdv.Range("V5:X7") 13434879
    $pfdv.Range("V5").Value2 = "CR-101`nCristalizacao`nSaidas 108 e 109"
    Set-ProcessBox $pfdv.Range("AA5:AC7") 13434879
    $pfdv.Range("AA5").Value2 = "D-101`nSecagem`nSaidas 110, 111 e 112"

    $pfdv.Range("E6").Value2 = "101 ->"
    $pfdv.Range("J6").Value2 = "103 ->"
    $pfdv.Range("O6").Value2 = "105/107 ->"
    $pfdv.Range("T6").Value2 = "109 ->"
    $pfdv.Range("Y6").Value2 = "-> 110"

    Set-ProcessBox $pfdv.Range("G10:I12") 15395562
    $pfdv.Range("G10").Value2 = "Corrente 102`nTorta de biomassa"
    Set-ProcessBox $pfdv.Range("L2:N4") 15395562
    $pfdv.Range("L2").Value2 = "Corrente 104`nSolvente de extracao"
    Set-ProcessBox $pfdv.Range("V10:X12") 15395562
    $pfdv.Range("V10").Value2 = "Corrente 108`nLicor-mae / perdas"
    Set-ProcessBox $pfdv.Range("AA10:AC12") 15395562
    $pfdv.Range("AA10").Value2 = "Corrente 111`nAgua evaporada"
    Set-ProcessBox $pfdv.Range("AE10:AG12") 15395562
    $pfdv.Range("AE10").Value2 = "Corrente 112`nPerda de penicilina"

    $pfdv.Range("B15:H15").Value2 = @("Corrente", "Descricao", "Massa (kg)", "Penicilina (kg)", "Biomassa (kg)", "Solvente (kg)", "Agua+outros (kg)")
    Set-HeaderStyle $pfdv.Range("B15:H15")
    $pfdv.Range("B16").Formula = "=Correntes_PFD!A4"
    $pfdv.Range("C16").Formula = "=Correntes_PFD!B4"
    $pfdv.Range("D16").Formula = "=Correntes_PFD!C4"
    $pfdv.Range("E16").Formula = "=Correntes_PFD!D4"
    $pfdv.Range("F16").Formula = "=Correntes_PFD!E4"
    $pfdv.Range("G16").Formula = "=Correntes_PFD!F4"
    $pfdv.Range("H16").Formula = "=Correntes_PFD!G4"
    $pfdv.Range("B17").Formula = "=Correntes_PFD!A13"
    $pfdv.Range("C17").Formula = "=Correntes_PFD!B13"
    $pfdv.Range("D17").Formula = "=Correntes_PFD!C13"
    $pfdv.Range("E17").Formula = "=Correntes_PFD!D13"
    $pfdv.Range("F17").Formula = "=Correntes_PFD!E13"
    $pfdv.Range("G17").Formula = "=Correntes_PFD!F13"
    $pfdv.Range("H17").Formula = "=Correntes_PFD!G13"
    $pfdv.Range("D16:H17").NumberFormat = "0.0000"

    # KPIs
    $kpi.Range("A1").Value2 = "Indicadores principais"
    Set-TitleStyle $kpi.Range("A1")
    $kpi.Range("A3:C3").Value2 = @("KPI", "Valor", "Unidade")
    Set-HeaderStyle $kpi.Range("A3:C3")

    $kpiRows = @(
        @("Recuperacao global", "=Calculos_Produto!B16/Calculos_Produto!B5", "%"),
        @("Penicilina no caldo", "=Calculos_Produto!B5", "kg"),
        @("Volume de caldo", "=Calculos_Produto!B6", "m3"),
        @("Biomassa seca gerada", "=Calculos_Produto!B8", "kg"),
        @("Perda total de produto", "=Calculos_Produto!B17", "kg"),
        @("Vapor real", "=Balanco_Energia!B11", "kg"),
        @("Aquecimento total", "=(Balanco_Energia!H4+Balanco_Energia!H8)/1000", "MJ"),
        @("Resfriamento total", "=(Balanco_Energia!H5+Balanco_Energia!H6+Balanco_Energia!H7)/1000", "MJ"),
        @("CO2 gerado", "=Fermentacao!B21", "kg"),
        @("Ar total", "=Fermentacao!B27", "Nm3"),
        @("m3 caldo / kg produto", "=Calculos_Produto!B6/Premissas!B4", "m3/kg"),
        @("kg biomassa / kg produto", "=Calculos_Produto!B8/Premissas!B4", "kg/kg"),
        @("Custo total da campanha", "=Custos!G13", "R$"),
        @("Custo especifico", "=Custos!G14", "R$/kg"),
        @("Make-up de solvente", "=Custos!C8", "kg"),
        @("Custo de utilidades", "=Utilidades!G12", "R$")
    )

    $row = 4
    foreach ($item in $kpiRows) {
        Set-Cell $kpi.Cells.Item($row,1) $item[0]
        Set-Cell $kpi.Cells.Item($row,2) $item[1]
        Set-Cell $kpi.Cells.Item($row,3) $item[2]
        $row++
    }
    $kpi.Range("B4:B19").NumberFormat = "0.0000"
    $kpi.Range("B4").NumberFormat = "0.00%"

    # Resumo_Executivo
    $exec.Range("A1").Value2 = "Resumo Executivo - Producao de Penicilina G"
    Set-TitleStyle $exec.Range("A1")
    $exec.Range("A2").Value2 = "Leitura rapida para apresentacao: o objetivo desta aba e sintetizar o caso em linguagem gerencial sem perder o significado tecnico."
    Set-SubtitleStyle $exec.Range("A2")
    $exec.Range("A4:F4").Value2 = @("Bloco", "Mensagem executiva", "Valor 1", "Valor 2", "Unidade", "Observacao")
    Set-HeaderStyle $exec.Range("A4:F4")

    $execRows = @(
        @("Objetivo", "Base de calculo adotada", "=Premissas!B4", "", "kg produto final", "Campanha conceitual de Penicilina G seca"),
        @("Recuperacao", "Recuperacao global estimada do processo", "=KPIs!B4", "", "%", "Indicador central de desempenho do downstream"),
        @("Escala", "Volume de caldo necessario", "=KPIs!B6", "", "m3", "Referencia para capacidade fermentativa"),
        @("Biomassa", "Biomassa seca gerada", "=KPIs!B7", "", "kg", "Carga solida removida antes da extracao"),
        @("Energia", "Vapor real para esterilizacao", "=KPIs!B9", "", "kg", "Maior utilidade termica individual"),
        @("Energia", "Resfriamento total requerido", "=KPIs!B11", "", "MJ", "Soma das principais demandas de frio"),
        @("Fermentacao", "CO2 gerado e ar total", "=KPIs!B12", "=KPIs!B13", "kg / Nm3", "Indicadores de respiracao e aeracao"),
        @("Economia", "Custo total e custo especifico", "=KPIs!B16", "=KPIs!B17", "R$ / R$/kg", "Custos conceituais e editaveis"),
        @("Confiabilidade", "Todos os fechamentos automaticos", "=COUNTIF(Verificacoes!E4:E12,""OK"")", "=ROWS(Verificacoes!E4:E12)", "checks", "A leitura ideal e todos os checks em OK")
    )

    $row = 5
    foreach ($item in $execRows) {
        for ($col = 1; $col -le 6; $col++) {
            Set-Cell $exec.Cells.Item($row, $col) $item[$col - 1]
        }
        $row++
    }
    $exec.Range("C5:D13").NumberFormat = "0.0000"
    $exec.Range("C6").NumberFormat = "0.00%"

    $exec.Range("A16").Value2 = "Mensagens prontas para apresentacao"
    Set-SubtitleStyle $exec.Range("A16")
    $exec.Range("A17").Formula = "=""Para produzir ""&FIXED(Premissas!B4,0,TRUE)&"" kg de Penicilina G seca, o modelo exige aproximadamente ""&FIXED(KPIs!B6,2,TRUE)&"" m3 de caldo fermentado e ""&FIXED(KPIs!B7,1,TRUE)&"" kg de biomassa seca gerada."""
    $exec.Range("A18").Formula = "=""A recuperacao global estimada do processo e de ""&FIXED(100*KPIs!B4,1,TRUE)&""%, indicando que a principal atencao do projeto deve estar no desempenho do downstream."""
    $exec.Range("A19").Formula = "=""Do ponto de vista energetico, o processo requer cerca de ""&FIXED(KPIs!B9,1,TRUE)&"" kg de vapor e ""&FIXED(KPIs!B11,1,TRUE)&"" MJ de resfriamento total."""
    $exec.Range("A20").Formula = "=""Do ponto de vista economico, o custo operacional conceitual desta campanha e de R$ ""&FIXED(KPIs!B16,2,TRUE)&"", equivalente a R$ ""&FIXED(KPIs!B17,2,TRUE)&"" por kg de produto."""
    $exec.Range("A21").Formula = "=""A base esta consistente no nivel conceitual: ""&COUNTIF(Verificacoes!E4:E12,""OK"")&"" de ""&ROWS(Verificacoes!E4:E12)&"" verificacoes automaticas ficaram em OK."""
    $exec.Range("A17:A21").WrapText = $true

    # Dashboard
    $dash.Range("A1").Value2 = "Dashboard - Penicilina G"
    Set-TitleStyle $dash.Range("A1")
    $dash.Range("A2").Value2 = "Versao para apresentacao: indicadores principais, distribuicoes e leitura executiva do processo."
    Set-SubtitleStyle $dash.Range("A2")

    Set-CardStyle $dash.Range("A4:C7") 15773696
    Set-CardStyle $dash.Range("E4:G7") 15773696
    Set-CardStyle $dash.Range("I4:K7") 15773696
    Set-CardStyle $dash.Range("M4:O7") 15773696
    Set-CardStyle $dash.Range("A9:C12") 13434879
    Set-CardStyle $dash.Range("E9:G12") 13434879
    Set-CardStyle $dash.Range("I9:K12") 13434879
    Set-CardStyle $dash.Range("M9:O12") 13434879

    $dash.Range("A4").Formula = "=""Recuperacao Global""&CHAR(10)&FIXED(100*KPIs!B4,1,TRUE)&""%"""
    $dash.Range("E4").Formula = "=""Penicilina no Caldo""&CHAR(10)&FIXED(KPIs!B5,1,TRUE)&"" kg"""
    $dash.Range("I4").Formula = "=""Volume de Caldo""&CHAR(10)&FIXED(KPIs!B6,2,TRUE)&"" m3"""
    $dash.Range("M4").Formula = "=""Custo Especifico""&CHAR(10)&""R$ ""&FIXED(KPIs!B17,2,TRUE)&""/kg"""
    $dash.Range("A9").Formula = "=""Vapor Real""&CHAR(10)&FIXED(KPIs!B9,1,TRUE)&"" kg"""
    $dash.Range("E9").Formula = "=""Resfriamento Total""&CHAR(10)&FIXED(KPIs!B11,1,TRUE)&"" MJ"""
    $dash.Range("I9").Formula = "=""CO2 Gerado""&CHAR(10)&FIXED(KPIs!B12,1,TRUE)&"" kg"""
    $dash.Range("M9").Formula = "=""Ar Total""&CHAR(10)&FIXED(KPIs!B13,1,TRUE)&"" Nm3"""

    $dash.Range("Q2:R5").Value2 = @(
        @("Produto final", ""),
        @("Biomassa removida", ""),
        @("Agua evaporada", ""),
        @("Perda total produto", "")
    )
    $dash.Range("R2").Formula = "=Premissas!B4"
    $dash.Range("R3").Formula = "=Calculos_Produto!B8"
    $dash.Range("R4").Formula = "=Secagem!B9"
    $dash.Range("R5").Formula = "=Calculos_Produto!B17"
    Set-HeaderStyle $dash.Range("Q2:R2")

    $dash.Range("A14").Value2 = "Leitura executiva"
    Set-SubtitleStyle $dash.Range("A14")
    $dash.Range("A15").Formula = "=""O processo entrega ""&FIXED(Premissas!B4,0,TRUE)&"" kg de produto final com recuperacao global de ""&FIXED(100*KPIs!B4,1,TRUE)&""%."""
    $dash.Range("A16").Formula = "=""Os maiores esforcos energeticos estao em esterilizacao, resfriamento pos-esterilizacao e fermentacao."""
    $dash.Range("A17").Formula = "=""O custo conceitual da campanha e de R$ ""&FIXED(KPIs!B16,2,TRUE)&"", com forte influencia de materias-primas e utilidades."""
    $dash.Range("A18").Formula = "=""Todos os fechamentos automaticos permanecem consistentes: ""&COUNTIF(Verificacoes!E4:E12,""OK"")&"" verificacoes em OK."""
    $dash.Range("A15:A18").WrapText = $true

    # Chart 1 - perdas por etapa
    $chart1Obj = $dash.ChartObjects().Add(20, 360, 420, 230)
    $chart1 = $chart1Obj.Chart
    $chart1.ChartType = 51
    $series1 = $chart1.SeriesCollection().NewSeries()
    $series1.Name = "=""Perda por etapa"""
    $series1.Values = $rec.Range("E5:E9")
    $series1.XValues = $rec.Range("A5:A9")
    $chart1.HasTitle = $true
    $chart1.ChartTitle.Text = "Perdas de produto por etapa"

    # Chart 2 - produto remanescente
    $chart2Obj = $dash.ChartObjects().Add(460, 360, 420, 230)
    $chart2 = $chart2Obj.Chart
    $chart2.ChartType = 4
    $series2 = $chart2.SeriesCollection().NewSeries()
    $series2.Name = "=""Produto apos etapa"""
    $series2.Values = $rec.Range("D4:D9")
    $series2.XValues = $rec.Range("A4:A9")
    $chart2.HasTitle = $true
    $chart2.ChartTitle.Text = "Produto remanescente no processo"

    # Chart 3 - cargas energeticas
    $chart3Obj = $dash.ChartObjects().Add(20, 610, 420, 230)
    $chart3 = $chart3Obj.Chart
    $chart3.ChartType = 51
    $series3 = $chart3.SeriesCollection().NewSeries()
    $series3.Name = "=""Carga energetica"""
    $series3.Values = $ener.Range("H4:H8")
    $series3.XValues = $ener.Range("A4:A8")
    $chart3.HasTitle = $true
    $chart3.ChartTitle.Text = "Cargas energeticas por etapa"

    # Chart 4 - distribuicao simplificada das saidas
    $chart4Obj = $dash.ChartObjects().Add(460, 610, 420, 230)
    $chart4 = $chart4Obj.Chart
    $chart4.ChartType = 5
    $series4 = $chart4.SeriesCollection().NewSeries()
    $series4.Name = "=""Distribuicao das saidas"""
    $series4.Values = $dash.Range("R2:R5")
    $series4.XValues = $dash.Range("Q2:Q5")
    $chart4.HasTitle = $true
    $chart4.ChartTitle.Text = "Distribuicao simplificada das saidas"

    $dash.Range("T2:U7").Value2 = @(
        @("Glicose eq", ""),
        @("PAA", ""),
        @("NH3 eq", ""),
        @("Solvente make-up", ""),
        @("Biomassa / efluente", ""),
        @("Utilidades", "")
    )
    $dash.Range("U2").Formula = "=Custos!G5"
    $dash.Range("U3").Formula = "=Custos!G6"
    $dash.Range("U4").Formula = "=Custos!G7"
    $dash.Range("U5").Formula = "=Custos!G8"
    $dash.Range("U6").Formula = "=Custos!G9+Custos!G10"
    $dash.Range("U7").Formula = "=Custos!G11"
    Set-HeaderStyle $dash.Range("T2:U2")

    $dash.Range("T10:U15").Value2 = @(
        @("Vapor esterilizacao", ""),
        @("Vapor secagem", ""),
        @("Agua resfriamento", ""),
        @("Frio industrial", ""),
        @("Energia soprador", ""),
        @("Energia agitacao", "")
    )
    $dash.Range("U10").Formula = "=Utilidades!G5"
    $dash.Range("U11").Formula = "=Utilidades!G6"
    $dash.Range("U12").Formula = "=Utilidades!G7"
    $dash.Range("U13").Formula = "=Utilidades!G8"
    $dash.Range("U14").Formula = "=Utilidades!G9"
    $dash.Range("U15").Formula = "=Utilidades!G10"
    Set-HeaderStyle $dash.Range("T10:U10")

    $chart5Obj = $dash.ChartObjects().Add(900, 360, 420, 230)
    $chart5 = $chart5Obj.Chart
    $chart5.ChartType = 51
    $series5 = $chart5.SeriesCollection().NewSeries()
    $series5.Name = "=""Custos por categoria"""
    $series5.Values = $dash.Range("U2:U7")
    $series5.XValues = $dash.Range("T2:T7")
    $chart5.HasTitle = $true
    $chart5.ChartTitle.Text = "Distribuicao de custos"

    $chart6Obj = $dash.ChartObjects().Add(900, 610, 420, 230)
    $chart6 = $chart6Obj.Chart
    $chart6.ChartType = 51
    $series6 = $chart6.SeriesCollection().NewSeries()
    $series6.Name = "=""Custos de utilidades"""
    $series6.Values = $dash.Range("U10:U15")
    $series6.XValues = $dash.Range("T10:T15")
    $chart6.HasTitle = $true
    $chart6.ChartTitle.Text = "Custos de utilidades"

    # General formatting
    foreach ($sheet in @($prem, $calc, $rec, $ferm, $corr, $ener, $sec, $veri, $dict, $conc, $util, $cost, $pfdv, $exec, $kpi, $dash)) {
        $sheet.UsedRange.Borders.LineStyle = 1
        AutoFit-UsedRange $sheet
        $sheet.Activate() | Out-Null
        $excel.ActiveWindow.SplitRow = 3
        $excel.ActiveWindow.FreezePanes = $true
    }

    $prem.Activate() | Out-Null

    $xlOpenXMLWorkbook = 51
    $workbook.SaveAs($outputPath, $xlOpenXMLWorkbook)
    $workbook.Close($true)
    $excel.Quit()

    Write-Output "Planilha criada em: $outputPath"
}
finally {
    if ($workbook) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
    }
    if ($excel) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
