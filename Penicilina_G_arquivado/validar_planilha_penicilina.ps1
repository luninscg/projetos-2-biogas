$ErrorActionPreference = "Stop"

$path = Join-Path (Get-Location) "Planilha_Penicilina_G.xlsx"
$excel = $null
$wb = $null

try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $wb = $excel.Workbooks.Open($path)
    $excel.CalculateFull()

    $refs = @(
        "Calculos_Produto!B4",
        "Calculos_Produto!B5",
        "Calculos_Produto!B6",
        "Calculos_Produto!B7",
        "Calculos_Produto!B8",
        "Calculos_Produto!B9",
        "Calculos_Produto!B11",
        "Calculos_Produto!B16",
        "Fermentacao!B21",
        "Fermentacao!B25",
        "Fermentacao!B27",
        "Balanco_Energia!H4",
        "Balanco_Energia!H5",
        "Balanco_Energia!H6",
        "Balanco_Energia!H7",
        "Balanco_Energia!B11",
        "Secagem!B9",
        "Correntes_PFD!C15",
        "Utilidades!G12",
        "Custos!G13",
        "Custos!G14",
        "KPIs!B16",
        "KPIs!B17",
        "KPIs!B18",
        "KPIs!B19",
        "Resumo_Executivo!C6",
        "Resumo_Executivo!C12",
        "Dashboard!A4",
        "Dashboard!M4",
        "Verificacoes!C4",
        "Verificacoes!C5",
        "Verificacoes!C6",
        "Verificacoes!C7",
        "Verificacoes!C8",
        "Verificacoes!C9",
        "Verificacoes!C10",
        "Verificacoes!C11",
        "Verificacoes!C12",
        "Verificacoes!E4",
        "Verificacoes!E5",
        "Verificacoes!E6",
        "Verificacoes!E7",
        "Verificacoes!E8",
        "Verificacoes!E9",
        "Verificacoes!E10",
        "Verificacoes!E11",
        "Verificacoes!E12"
    )

    foreach ($ref in $refs) {
        $parts = $ref.Split("!")
        $value = $wb.Worksheets.Item($parts[0]).Range($parts[1]).Value2
        Write-Output ($ref + "=" + $value)
    }

    $wb.Close($false)
    $excel.Quit()
}
finally {
    if ($wb) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb)
    }
    if ($excel) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
