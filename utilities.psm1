[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Read-File {
    param (
        [string]$Destination
    )

    try {
        # Lee las líneas del archivo en la ruta de destino
        $lines = Get-Content -Path $Destination
        Write-Host "Successfully read the file at: $Destination"
        return $lines
    }
    catch {
        # Loggea cualquier error que ocurra durante la lectura del archivo
        Write-Host "An error occurred while reading the file at $Destination"
        return $null
    }
}

function Write-ModifiedLines {
    param (
        [string]$Destination,
        [string[]]$ModifiedLines
    )
    
    try {
        foreach ($line in $ModifiedLines) {
            $formattedLine = $line.Trim()
            if ($formattedLine) {
                # Solo añade la línea al archivo si no está vacía
                Add-Content -Path $Destination -Value $formattedLine
            }
            else {
                # Si deseas escribir una línea vacía en el archivo, puedes usar esta línea:
                # Add-Content -Path $Destination -Value ""
            }
        }
        Write-Host "Successfully wrote the modified lines to the file at: $Destination"
    }
    catch {
        # Loggea cualquier error que ocurra durante la escritura en el archivo
        Write-Host "An error occurred while writing the modified lines to the file at $Destination"
    }
}

Export-ModuleMember -Function Read-File, Write-ModifiedLines