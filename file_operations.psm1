[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Import-Module .\config_handlers.psm1
Import-Module .\utilities.psm1

function Find-ConfigFiles {
    param(
        [string]$SteamPath
    )

    if (-not $SteamPath -or $SteamPath -isnot [string]) {
        Write-Host "Invalid Steam path provided." -ForegroundColor Red
        return @(), $false
    }

    try {
        $CfgFiles = @()

        # Define the userdata directory using the provided steam_path
        $UserdataDir = Join-Path $SteamPath "userdata"

        # Check if the userdata directory exists
        if (-not (Test-Path $UserdataDir)) {
            Write-Host "The 'userdata' folder does not exist at the path: $UserdataDir" -ForegroundColor Yellow
            return $CfgFiles, ($CfgFiles.Count -gt 0)
        }

        # Find all directories within UserdataDir
        $UserFolders = Get-ChildItem -Path $UserdataDir -Directory | Select-Object -ExpandProperty Name

        # Check if any user folders are found
        if (-not $UserFolders -or $UserFolders.Count -eq 0) {
            Write-Host "No user ID folders found in 'userdata' at the path: $UserdataDir" -ForegroundColor Yellow
            return $CfgFiles, ($CfgFiles.Count -gt 0)
        }

        # Loop through each user folder to find config directories
        foreach ($UserFolder in $UserFolders) {
            $CfgDir = Join-Path $UserdataDir "$UserFolder\730\local\cfg"

            # If a config directory is found, find all config.cfg files in it
            if (Test-Path $CfgDir) {
                $CfgFilePaths = Get-ChildItem -Path $CfgDir -Recurse -Filter "config.cfg" | Select-Object -ExpandProperty FullName

                foreach ($CfgFilePath in $CfgFilePaths) {
                    $CfgFiles += ,@($CfgFilePath, $UserFolder)
                }
            }
        }

        # Return the list of config files and a boolean indicating if any were found
        return $CfgFiles, ($CfgFiles.Count -gt 0)
    }
    catch {
        Write-Host "An unexpected error occurred while searching for config.cfg files: $_" -ForegroundColor Red
        return @(), $false
    }
}

function Set-Destination {
    param(
        [string]$CfgFile,
        [string]$UserFolder,
        [string]$Cs2InstallPath
    )

    try {
        # Check if the Cs2InstallPath directory exists
        if (-not (Test-Path -Path $Cs2InstallPath)) {
            Write-Warning "The 'Steam32ID' folder does not exist at the path: $Cs2InstallPath"
        }

        # Construct the new file name
        $NewFileName = "$UserFolder.cfg"
        Write-Host "Generated new file name: $NewFileName" -ForegroundColor Green

        # Determine the destination path using string concatenation
        $Destination = Join-Path $Cs2InstallPath $NewFileName

        # Now, instead of copying the original file, you just return the destination
        # path where the new, modified content will be written.
        Write-Host "Prepared destination path: $Destination" -ForegroundColor Green

        # Return the destination path
        return $Destination
    }
    catch {
        Write-Host "An error occurred while preparing the destination: $_" -ForegroundColor Red
        return $null
    }
}

function Get-EchoLines {
    <#
    .SYNOPSIS
    This function returns an ASCII art that will be added at the end of the config.cfg file.

    .DESCRIPTION
    The Get-EchoLines function returns a list of strings that create an ASCII art to be added at the end of a config.cfg file.

    .OUTPUTS
    System.String[]
    #>
    return @(
        'echo "                                             .=-   +#=                                              "',
        'echo "                                            :@@%- :@@@:                                             "',
        'echo "                                            :@@@#=#@@@-  .                                          "',
        'echo "                                         :  .@@@@@@@@@+.=#+                                         "',
        'echo "                                        +@%+#@@@@@@@@@@@@@@+                                        "',
        'echo "                                       :@@@@@@@#=::=#@@@@@@=                                        "',
        'echo "                                       .%@@@@#-      -#@@@#.                                        "',
        'echo "                                        :@@@*..=*=  ...*@@*                                         "',
        'echo "                                         @@#..*%*: .+: .#@@#*+.                                     "',
        'echo "                                      :=#@@- =@%:  :#.- -@@@@%:                                     "',
        'echo "                                     =@@@@#-%@%%%. +@## .%@@@@-                                     "',
        'echo "                                     =@@@@*.+%:=@%*@*=. .*@@@#:                                     "',
        'echo "                                     :#@@@*  :  +@@%.    *@@-                                       "',
        'echo "                                      .:%@*.   .*@@%-   .*@@                                        "',
        'echo "                                        *@#.  +%@*=@%-  .%@@#.                                      "',
        'echo "                                       .%@@- =+%*  =@@: -@@@@%.                                     "',
        'echo "                                      :%@@@#.. ==   +@*.#@@@@#.                                     "',
        'echo "                                      =@@@@@+  -:   .-.*@@###=                                      "',
        'echo "                                      .%@#%@@*:      :*@@#:...                                      "',
        'echo "                                       ...:#@@%*-::-*%@@@*.                                         "',
        'echo "                                           *@@@@@@@@@@@@@%:                                         "',
        'echo "                                          .#@@@%@@@@@##@@@-                                         "',
        'echo "                                          :#@@+:+@@@*. =#=.                                         "',
        'echo "                                           :*=  .%@@=   .                                           "',
        'echo "                                                 *@%-                                               "',
        'echo "                                ::                   :*################=.               .%:         "',
        'echo "                               -%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=-----.        -@-         "',
        'echo "                             .+@@@@@@@@@@@@@@@@@@@@@@@@@@@%***####**##@@@%****##-       =*-         "',
        'echo "                  .::-=:   -+#@@@@@@@@@@@@@@@@@@@@@@@@@@@@%***%%%%**#%@@@@%%%%%@%*-:...=**=.        "',
        'echo "        .:-=+*##%%@@@@@@**%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=       "',
        'echo "       =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+-       "',
        'echo "       +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%#=====+#+--------*#.         "',
        'echo "       +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##@@@@@@@@@++++*%@%+:::::::::::.                            "',
        'echo "       +@@@@@@@@@@@@@@@@@@@@%#%@@@@@@@*=..+@@@@@@@@.    :-:                                         "',
        'echo "       +@@@@@@@@@@@@@@@@@@*:...:%@@@@%:-  -%@@@@@@@:                                                "',
        'echo "       +@@@@@@@@@@@@@@@#=      -@@@@@%=...=##@@@@@@=                                                "',
        'echo "       +@@@@@@@@@@@%#+:       .%@@@@*..:-:   %@@@@@#                                                "',
        'echo "       +@@@@@@@@@#+-          *@@@@*         =@@@@@%:                                               "',
        'echo "       +@@@@@@%+:.           -@@@@#.         .@@@@@@*.                                              "',
        'echo "       +@@@@*:.              #@@@@:           +@@@@@@=                                              "',
        'echo "       =@#=                  %@@@*            :@@@@@@@:                                             "',
        'echo "        .                    =@@%:             +@@@@@@%:                                            "',
        'echo "                              --:              :#@@@@@@%=                                           "',
        'echo "                                                -@@@@@@@@+.                                         "',
        'echo "                                                 =@@@@@@@@=                                         "',
        'echo "                                                  +@@@@@@%:                                         "',
        'echo "                                                   +@@@@@=                                          "',
        'echo "                                                    =%@@*                                           "',
        'echo "                                                     -%%.                                           "',
        'echo "                                                      ..                                            "',
        'echo "                                       _____    _____   ___                                         "',
        'echo "                                      / ____|  / ____| |__ \                                        "',
        'echo "                                      | |     | (___      ) |                                       "',
        'echo "                                      | |      \___ \    / /                                        "',
        'echo "                                      | |___   ____) |  / /_                                        "',
        'echo "                                      \_____| |_____/  |____|                                       "',
        'echo "                                                                                                    "',
        'echo "                                 _____                 __   _                                       "',
        'echo "                                / ____|               / _| (_)                                      "',
        'echo "                                | |       ___   _ __  | |_  _   __ _                                "',
        'echo "                                | |      / _ \ | _  \ |  _|| | / _  |                               "',
        'echo "                                | |____ | (_) || | | || |  | || (_| |                               "',
        'echo "                                \_____|  \___/ |_| |_||_|  |_| \__, |                               "',
        'echo "                                                                __/ |                               "',
        'echo "                                                               |___/                                "',
        'echo "                           __  __  _                      _                                         "',
        'echo "                          |  \/  |(_)                    | |                                        "',
        'echo "                          | \  / | _   __ _  _ __   __ _ | |_   ___   _ __                          "',
        'echo "                          | |\/| || | / _  ||  __| / _  || __| / _ \ |  __|                         "',
        'echo "                          | |  | || || (_| || |   | (_| || |_ | (_) || |                            "',
        'echo "                          |_|  |_||_| \__, ||_|    \__,_|\___| \___/ |_|                            "',
        'echo "                                       __/ |                                                        "',
        'echo "                                      |___/                                                         "',
        'echo "                                                                                                    "',
        'echo "                                           By IG: manny_agre                                        "',
        'echo "                                                                                                    "',
        'echo "                                                                                                    "',
        'echo "                                     CONFIG SUCCESFULLY APPLIED                                     "',
        'echo "                                                                                                    "',
        'echo "                                               GLHF :)                                              "'
    )
}

function Invoke-Lines {
    <#
    .SYNOPSIS
    This function modifies the lines from the configuration file based on various rules defined in 
    Get-Configurations function. It handles deprecated commands, pattern replacements, fix commands,
    and network configurations. It also appends 'host_writeconfig' and the content of Get-EchoLines
    at the end of the modified lines.
    
    .PARAMETER Lines
    A list of strings where each string is a line from the original configuration file.

    .OUTPUTS
    System.String[]
    #>
    param(
        [string[]]$Lines
    )

    # Fetching configurations for modifying the lines
    $patterns, $cs2BetterNetConfigs, $deprecatedCommands, $fixCommands = Get-Configurations
    
    # Initialize an empty list to store the modified lines
    $modifiedLines = @()

    # Loop through each line in the input lines
    foreach ($line in $Lines) {
        # Handle deprecated commands and determine if the line should be deleted
        $line, $shouldDelete = Invoke-DeprecatedCommands -Line $line -DeprecatedCommands $deprecatedCommands
        
        # Handle pattern replacements in the line
        $line = Invoke-PatternHandler -Line $line -Patterns $patterns
        
        # Handle fix commands in the line
        $line = Invoke-FixCommands -Line $line -FixCommands $fixCommands

        # If the line should not be deleted, handle network configurations and add it to the modified lines
        if (-not $shouldDelete) {
            $line = Invoke-NetConfigs -Line $line -CS2BetterNetConfigs $cs2BetterNetConfigs
            $modifiedLines += $line
        }
        else {
            continue
        }
    }

    # Add 'host_writeconfig' at the end of the file
    $modifiedLines += "host_writeconfig"
    Write-Host "Added 'host_writeconfig' at the end of the file"

    # Append echo's content at the end of the modified lines
    $echoLinesContent = Get-EchoLines
    foreach ($echoLine in $echoLinesContent) {
        $modifiedLines += $echoLine
    }
    Write-Host "Added echos at the end of the file"

    return $modifiedLines
}

function Invoke-CfgFile {
    param(
        [string]$CfgFile,
        [string]$UserFolder,
        [string]$CS2InstallPath
    )
    
    try {
        # Inicializando config_modified como True suponiendo una modificación exitosa
        $config_modified = $true
        
        # Leyendo las líneas del archivo cfg original con permisos de solo lectura
        $lines = Read-File $CfgFile
        
        # Modificando las líneas en memoria basándose en configuraciones predefinidas
        $modified_lines = Invoke-Lines $lines
        
        # Preparando el destino para el archivo cfg
        $destination = Set-Destination $CfgFile $UserFolder $CS2InstallPath
        
        # Escribiendo las líneas modificadas en el archivo cfg en el destino
        Write-ModifiedLines $destination $modified_lines
        
        # Logging the successful modification of the cfg file
        Write-Log -Message "Se hicieron modificaciones exitosas del archivo $CfgFile" -Level Info
        
        # Devolviendo True para indicar una modificación exitosa
        return $config_modified
    } catch {
        # Si ocurre una excepción, estableciendo config_modified en False
        $config_modified = $false
        
        # Logging the error that occurred during the modification
        Write-Log -Message "Ocurrió un error mientras se modificaba o movía el archivo $CfgFile" -Level Error
        
        # Devolviendo False para indicar una modificación no exitosa
        return $config_modified
    }
}

Export-ModuleMember -Function Invoke-CfgFile, Invoke-Lines, Get-EchoLines, Set-Destination, Find-ConfigFiles
