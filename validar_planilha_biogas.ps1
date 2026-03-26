$ErrorActionPreference = "Stop"
$path = Join-Path (Get-Location) "Planilha_Biogas_Codigestao.xlsx"
$excel = $null; $wb = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $wb = $excel.Workbooks.Open($path)
    $excel.CalculateFull()

    $refs = @(
        "Calculos_Massa!B5",
        "Calculos_Massa!B6",
        "Calculos_Massa!B7",
        "Calculos_Massa!B8",
        "Calculos_Massa!B9",
        "Calculos_Massa!B10",
        "Calculos_Massa!B11",
        "Calculos_Massa!B12",
        "Calculos_Massa!B13",
        "Calculos_Massa!B14",
        "Calculos_Massa!B15",
        "Calculos_Massa!B16",
        "Calculos_Massa!B17",
        "Calculos_Massa!B18",
        "Calculos_Massa!B19",
        "Calculos_Massa!B20",
        "Calculos_Massa!B21",
        "Calculos_Massa!B22",
        "Calculos_Massa!B23",
        "Calculos_Massa!B24",
        "Calculos_Massa!B25",
        "Calculos_Massa!B26",
        "Calculos_Massa!B27",
        "Calculos_Massa!B28",
        "Calculos_Massa!B29",
        "Calculos_Massa!B30",
        "Calculos_Massa!B31",
        "Calculos_Massa!B32",
        "Calculos_Massa!B33",
        "Calculos_Massa!B34",
        "Calculos_Massa!B35",
        "Calculos_Massa!B36",
        "Calculos_Massa!B37",
        "Calculos_Massa!B38",
        "Fechamento_Elementar!E5",
        "Fechamento_Elementar!E6",
        "Fechamento_Elementar!E7",
        "Fechamento_Elementar!E8",
        "Fechamento_Elementar!E9",
        "Fechamento_Elementar!F5",
        "Fechamento_Elementar!F6",
        "Fechamento_Elementar!F7",
        "Fechamento_Elementar!B12",
        "Fechamento_Elementar!B15",
        "Balanco_Energia!B5",
        "Balanco_Energia!B6",
        "Balanco_Energia!B7",
        "Balanco_Energia!B8",
        "Balanco_Energia!B9",
        "Balanco_Energia!B11",
        "Balanco_Energia!B12",
        "Balanco_Energia!B13",
        "Balanco_Energia!B14",
        "Balanco_Energia!B15",
        "Balanco_Energia!B16",
        "Verificacoes!C5",
        "Verificacoes!E5",
        "Verificacoes!C6",
        "Verificacoes!E6",
        "Verificacoes!C7",
        "Verificacoes!E7",
        "Verificacoes!C8",
        "Verificacoes!E8",
        "Verificacoes!C9",
        "Verificacoes!E9",
        "Verificacoes!C10",
        "Verificacoes!E10",
        "Verificacoes!C11",
        "Verificacoes!E11",
        "Verificacoes!C12",
        "Verificacoes!E12",
        "Verificacoes!C13",
        "Verificacoes!E13",
        "Verificacoes!C14",
        "Verificacoes!E14"
    )

    foreach ($ref in $refs) {
        $parts = $ref.Split("!")
        $value = $wb.Worksheets.Item($parts[0]).Range($parts[1]).Value2
        Write-Output ($ref + " = " + $value)
    }

    $wb.Close($false); $excel.Quit()
}
finally {
    if ($wb) { [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb) }
    if ($excel) { [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) }
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}
