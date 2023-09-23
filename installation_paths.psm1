[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Get-SteamInstallationPath {
    try {
        # Retrieving the Steam installation path from the registry
        $steamPath = Get-ItemPropertyValue -Path 'HKCU:\Software\Valve\Steam' -Name 'SteamPath'
        
        # If the path is found, return it along with a success flag
        if ($steamPath) {
            return [PSCustomObject]@{
                Path = $steamPath
                Success = $true
            }
        } else {
            # If the path is not found, throw an exception
            throw "Steam installation path not found in the registry."
        }
    } catch {
        # Logging the error and returning a failure flag
        Write-Error "Could not retrieve the Steam installation path: $_"
        return [PSCustomObject]@{
            Path = $null
            Success = $false
        }
    }
}

function Get-CS2InstallationPath {
    try {
        # Retrieving the CS2 installation path from the registry
        $cs2Path = Get-ItemPropertyValue -Path 'HKCU:\Software\Classes\csgo\Shell\Open\Command' -Name '(default)'
        
        # If the path is found, extract the executable path and adjust it
        if ($cs2Path) {
            $path = $cs2Path -split '"' | Select-Object -Index 1
            $path = $path -replace '\\game\\bin\\win64\\cs2\.exe', '\\game\\csgo\\cfg'
            
            # Return the modified path along with a success flag
            return [PSCustomObject]@{
                Path = $path
                Success = $true
            }
        } else {
            # If the path is not found, throw an exception
            throw "CS2 installation path not found in the registry."
        }
    } catch {
        # Logging the error and returning a failure flag
        Write-Error "Could not retrieve the CS2 installation path: $_"
        return [PSCustomObject]@{
            Path = $null
            Success = $false
        }
    }
}

Export-ModuleMember -Function Get-SteamInstallationPath, Get-CS2InstallationPath
