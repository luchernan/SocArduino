# ===============================
# MINI SOC - POWERSHELL SCRIPT
# ===============================

# --- CONFIGURACIÓN SERIAL ---
$COM = "COM3"        # CAMBIA AL TUYO
$BAUD = 9600

$port = New-Object System.IO.Ports.SerialPort $COM,$BAUD,None,8,one
$port.Open()

Write-Host "[SOC] Panel conectado por $COM"

# --- INICIALIZAR REGISTROS ---
$lastSecurity = (Get-WinEvent -LogName Security -MaxEvents 1).RecordId
$lastSSH      = (Get-WinEvent -LogName "Microsoft-Windows-OpenSSH/Operational" -MaxEvents 1 -ErrorAction SilentlyContinue).RecordId

# --- CONTADORES PARA CORRELACIÓN ---
$failedLogins = @()

# ===============================
# BUCLE PRINCIPAL SOC
# ===============================
while ($true) {

    # ---------------------------
    # LOG SECURITY (LOGIN)
    # ---------------------------
    $securityEvents = Get-WinEvent -LogName Security -MaxEvents 10 |
        Where-Object { $_.RecordId -gt $lastSecurity }

    foreach ($event in $securityEvents) {

        $lastSecurity = $event.RecordId

        #  LOGIN CORRECTO
        if ($event.Id -eq 4624) {
            $port.WriteLine("SEVERITY=INFO;MSG=Login correcto")
            Write-Host "[INFO] Login correcto"
        }

        #  LOGIN FALLIDO
        if ($event.Id -eq 4625) {
            $time = Get-Date
            $failedLogins += $time

            $port.WriteLine("SEVERITY=HIGH;MSG=Login fallido")
            Write-Host "[HIGH] Login fallido"
        }
    }

    # ---------------------------
    # CORRELACIÓN (FUERZA BRUTA)
    # ---------------------------
    $now = Get-Date
    $failedLogins = $failedLogins | Where-Object { ($now - $_).TotalSeconds -lt 30 }

    if ($failedLogins.Count -ge 5) {
        $port.WriteLine("SEVERITY=CRITICAL;MSG=Fuerza bruta detectada")
        Write-Host "[CRITICAL] Fuerza bruta detectada"
        $failedLogins = @()
    }

    # ---------------------------
    # LOG SSH
    # ---------------------------
    $sshEvents = Get-WinEvent -LogName "Microsoft-Windows-OpenSSH/Operational" -MaxEvents 5 -ErrorAction SilentlyContinue |
        Where-Object { $_.Id -eq 4 -and $_.RecordId -gt $lastSSH }

    foreach ($event in $sshEvents) {
        $lastSSH = $event.RecordId
        $port.WriteLine("SEVERITY=HIGH;MSG=SSH login fallido")
        Write-Host "[HIGH] SSH login fallido"
    }

    # ---------------------------
    # EVENTO INFORMATIVO (LOW)
    # ---------------------------
    $systemEvent = Get-WinEvent -LogName System -MaxEvents 1 |
        Where-Object { $_.Id -eq 7036 }

    if ($systemEvent) {
        $port.WriteLine("SEVERITY=LOW;MSG=Servicio del sistema iniciado")
        Write-Host "[LOW] Servicio iniciado"
    }

    Start-Sleep -Seconds 3
}
