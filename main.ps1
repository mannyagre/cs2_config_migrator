Import-Module .\installation_paths.psm1
Import-Module .\file_operations.psm1

# Configuración de logging (PowerShell usa Write-Verbose para debug logging)
$VerbosePreference = "Continue"

# Obteniendo las rutas de instalación de steam y cs2
$steam_path_result = Get-SteamInstallationPath
$cs2_path_result = Get-Cs2InstallationPath

Write-Host "Ruta de instalación de steam: $steam_path_result.Path"
Write-Host "Ruta de instalación de cs2: $cs2_path_result.Path"

if ($steam_path_result.Success -and $cs2_path_result.Success) {
    # Buscando todos los archivos config.cfg de cs:go
    $config_files_result = Find-ConfigFiles -SteamPath $steam_path_result.Path

    if ($config_files_result.Success) {
        foreach ($file_info in $config_files_result.Files) {
            # Modifica cada archivo config.cfg encontrado
            Invoke-CfgFile -CfgFile $file_info.CfgFile -UserFolder $file_info.UserFolder -Cs2Path $cs2_path_result.Path
        }
    } else {
        Write-Error "No config.cfg files found"
    }
} else {
    Write-Error "Steam or CS2 not found"
}