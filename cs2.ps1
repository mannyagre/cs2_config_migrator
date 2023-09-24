Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console {
    $window = [Console.Window]::GetConsoleWindow()
    # 0 = Hide
    [Console.Window]::ShowWindow($window, 0)
}

Hide-Console

function Get-Configurations {
    $patterns = @(
        @{ Regex = '\+moveleft'; Replacement = '+left' },
        @{ Regex = '\+moveright'; Replacement = '+right' },
        @{ Regex = '\+speed'; Replacement = '+sprint' },
        @{ Regex = 'sv_noclipspeed "5"'; Replacement = 'sv_noclipspeed "1000"' },
        @{ Regex = 'KP_INS'; Replacement = 'KP_0' },
        @{ Regex = 'KP_END'; Replacement = 'KP_1' },
        @{ Regex = 'KP_DOWNARROW'; Replacement = 'KP_2' },
        @{ Regex = 'KP_PGDN'; Replacement = 'KP_3' },
        @{ Regex = 'KP_LEFTARROW'; Replacement = 'KP_4' },
        @{ Regex = 'KP_RIGHTARROW'; Replacement = 'KP_6' },
        @{ Regex = 'KP_HOME'; Replacement = 'KP_7' },
        @{ Regex = 'KP_UPARROW'; Replacement = 'KP_8' },
        @{ Regex = 'KP_PGUP'; Replacement = 'KP_9' },
        @{ Regex = 'KP_SLASH'; Replacement = 'KP_DIVIDE' }
    )

    $cs2BetterNetConfigs = @(
        @{ Key = 'cl_updaterate'; Value = '128' },
        @{ Key = 'cl_interp_ratio'; Value = '1' },
        @{ Key = 'cl_interp'; Value = '0.015625' }
    )

    $deprecatedCommands = @(
        "unbindall", "cfgver", "@panorama_debug_overlay_opacity", "ai_report_task_timings_on_limit",
            "ai_think_limit_label", "aim_flickstick_circular_deadzone_max", "aim_flickstick_circular_deadzone_min",
            "aim_flickstick_crank_sensitivity", "aim_flickstick_crank_tightness", "aim_flickstick_enabled",
            "aim_flickstick_flick_snap_mode", "aim_flickstick_flick_tightness", "aim_flickstick_forward_deadzone",
            "aim_flickstick_release_dampen_speed", "aim_gyro_acceleration", "aim_gyro_base_sensitivity",
            "aim_gyro_circular_deadzone", "aim_gyro_conversion_mode", "aim_gyro_enable_mode",
            "aim_gyro_high_sense_multiplier", "aim_gyro_high_sense_speed", "aim_gyro_invert_pitch",
            "aim_gyro_invert_yaw", "aim_gyro_low_sense_speed", "aim_gyro_pitchyaw_ratio",
            "aim_gyro_precision_speed", "aim_gyro_raw", "aim_gyro_ray_angle",
            "aim_gyro_siapi_convert_pixels_to_angles", "aim_gyro_siapi_sensitivity_setting", 
            "aim_gyro_siapi_vertical_scale_setting", "aim_gyro_square_deadzone_pitch",
            "aim_gyro_square_deadzone_yaw", "aim_gyro_zoom_dampening_level1",
            "aim_gyro_zoom_dampening_level2", "aim_stick_circular_deadzone_max",
            "aim_stick_circular_deadzone_min", "aim_stick_extra_turning_delay",
            "aim_stick_extra_turning_ramp_up_time", "aim_stick_extra_yaw",
            "aim_stick_invert_pitch", "aim_stick_invert_yaw",
            "aim_stick_rate_pitch", "aim_stick_rate_yaw",
            "aim_stick_response_curve", "aim_stick_square_deadzone_pitch",
            "aim_stick_square_deadzone_yaw", "aim_stick_zoom_dampening_level1",
            "aim_stick_zoom_dampening_level2", "aim_touchpad_circular_deadzone_min",
            "aim_touchpad_invert_pitch", "aim_touchpad_invert_yaw",
            "aim_touchpad_sensitivity_pitch", "aim_touchpad_sensitivity_yaw",
            "aim_touchpad_square_deadzone_pitch", "aim_touchpad_square_deadzone_yaw",
            "aim_touchpad_zoom_dampening_level1", "aim_touchpad_zoom_dampening_level2",
            "budget_averages_window", "budget_background_alpha", 
            "budget_bargraph_background_alpha", "budget_bargraph_range_ms",
            "budget_history_numsamplesvisible", "budget_history_range_ms",
            "budget_panel_bottom_of_history_fraction", "budget_panel_height",
            "budget_panel_width", "budget_panel_x",
            "budget_panel_y", "budget_peaks_window",
            "budget_show_averages", "budget_show_history",
            "budget_show_peaks", "bugreporter_uploadasync",
            "bugreporter_username", "cam_idealdistright",
            "cam_idealdistup", "cc_predisplay_time",
            "chet_debug_idle", "cl_allowdownload",
            "cl_allowupload", "cl_autowepswitch",
            "cl_bob_lower_amt", "cl_bobamt_lat",
            "cl_bobamt_vert", "cl_bobcycle",
            "cl_buywheel_nomousecentering", "cl_chatfilter_version",
            "cl_cmdrate", "cl_debugrumble",
            "cl_detail_avoid_force", "cl_detail_avoid_radius",
            "cl_detail_avoid_recover_speed", "cl_detail_max_sway",
            "cl_disablefreezecam", "cl_disablehtmlmotd",
            "cl_downloadfilter", "cl_freezecampanel_position_dynamic",
            "cl_grass_mip_bias", "cl_hud_background_alpha",
            "cl_hud_bomb_under_radar", "cl_hud_healthammo_style",
            "cl_hud_playercount_pos", "cl_hud_playercount_showcount",
            "cl_idealpitchscale", "cl_minimal_rtt_shadows",
            "cl_observercrosshair", "cl_righthand",
            "cl_rumblescale", "cl_showhelp",
            "cl_showpluginmessages2", "cl_spec_follow_grenade_key",
            "cl_spec_mode", "cl_thirdperson",
            "cl_viewmodel_shift_left_amt", "cl_viewmodel_shift_right_amt",
            "closeonbuy", "commentary_firstrun", "con_allownotify", "demo_index", 
            "demo_index_max_other", "dsp_enhance_stereo", "force_audio_english", 
            "g15_update_msec", "hud_takesshots", "joy_accelmax", "joy_accelscale", 
            "joy_accelscalepoly", "joy_autoaimdampen", "joy_autoAimDampenMethod", 
            "joy_autoaimdampenrange", "joy_cfg_preset", "joy_circle_correct", 
            "joy_curvepoint_1", "joy_curvepoint_2", "joy_curvepoint_3", 
            "joy_curvepoint_4", "joy_curvepoint_end", "joy_diagonalpov", 
            "joy_forwardsensitivity", "joy_forwardthreshold", "joy_gamma", 
            "joy_inverty", "joy_lowend", "joy_lowend_linear", "joy_lowmap", "joy_no_accel_jump", "joy_pitchthreshold", "joy_response_look_pitch", 
            "joy_sensitive_step0", "joy_sensitive_step1", "joy_sensitive_step2", 
            "joy_sidethreshold", "joy_yawthreshold", "joystick_force_disabled", 
            "joystick_force_disabled_set_from_options", "lookspring", "lookstrafe", 
            "m_customaccel", "m_customaccel_exponent", "m_customaccel_max", 
            "m_customaccel_scale", "m_forward", "m_mouseaccel1", "m_mouseaccel2", 
            "m_mousespeed", "m_rawinput", "m_side", "mat_enable_uber_shaders", 
            "mat_monitorgamma", "mat_monitorgamma_tv_enabled", "mat_powersavingsmode", 
            "mat_queue_report", "mat_spewalloc", "mat_texture_list_content_path", "mc_accel_band_size", "mc_dead_zone_radius", "mc_max_pitchrate", 
            "mc_max_yawrate", "move_stick_aggression_strength", "move_stick_aggressive", 
            "move_stick_circular_deadzone_max", "move_stick_circular_deadzone_min", 
            "move_stick_response_curve", "move_stick_square_deadzone_forward", 
            "move_stick_square_deadzone_strafe", "move_stick_walk_zone", 
            "move_touchpad_circular_deadzone_min", "move_touchpad_sensitivity_forward", 
            "move_touchpad_sensitivity_strafe", "move_touchpad_square_deadzone_forward", 
            "move_touchpad_square_deadzone_strafe", "muzzleflash_light", "net_graph", 
            "net_graphheight", "net_graphholdsvframerate", "net_graphipc", 
            "net_graphmsecs", "net_graphpos", "net_graphproportionalfont", 
            "net_graphshowinterp", "net_graphshowlatency", "net_graphshowsvframerate", 
            "net_graphsolid", "net_scale", "net_steamcnx_allowrelay", "npc_height_adjust",
            "play_distance", "player_competitive_maplist_2v2_10_0_E8C782EC",
            "player_competitive_maplist_8_10_0_C9C8D674", "player_wargames_list2_10_0_E04",
            "r_drawmodelstatsoverlaymax", "r_drawmodelstatsoverlaymin", "r_eyegloss",
            "r_eyemove", "r_eyeshift_x", "r_eyeshift_y", "r_eyeshift_z", "r_eyesize",
            "scene_showfaceto", "scene_showlook", "scene_showmoveto", "scene_showunlock",
            "snd_ducking_off", "snd_dzmusic_volume", "snd_hrtf_distance_behind",
            "snd_hrtf_voice_delay", "snd_hwcompat", "snd_mix_async",
            "snd_mix_async_onetime_reset", "snd_music_volume_onetime_reset_2",
            "snd_musicvolume_multiplier_inoverlay", "snd_pitchquality", "snd_surround_speakers", "ss_splitmode", "steaminput_firsttimepopup", 
            "steaminput_glyph_display_mode", "steaminput_glyph_neutral", 
            "steaminput_glyph_solid", "steaminput_glyph_style", "store_version", 
            "suitvolume", "sv_forcepreload", "sv_pvsskipanimation", 
            "test_convar", "texture_budget_background_alpha", 
            "texture_budget_panel_bottom_of_history_fraction", 
            "texture_budget_panel_height", "texture_budget_panel_width", 
            "texture_budget_panel_x", "texture_budget_panel_y", 
            "tr_best_course_time", "tr_completed_training", 
            "triple_monitor_mode", "trusted_launch_once", 
            "ui_mainmenu_bkgnd_movie_CC4ECB9", "vgui_message_dialog_modal", 
            "viewmodel_recoil", "voice_caster_enable", 
            "voice_caster_scale", "voice_enable", "voice_forcemicrecord", "voice_mixer_boost", "voice_mixer_mute", "voice_mixer_volume", 
            "voice_positional", "voice_system_enable", "vprof_graphheight", 
            "vprof_graphwidth", "vprof_unaccounted_limit", "vprof_verbose", 
            "vprof_warningmsec", "weapon_accuracy_logging", "xbox_autothrottle", 
            "xbox_throttlebias", "xbox_throttlespoof", "zoom_sensitivity_ratio_joystick", 
            "zoom_sensitivity_ratio_mouse"
    )

    $fixFloats = @{
        cl_crosshairalpha = { param($x) [string][int][double]::Parse($x) }
        cl_crosshaircolor_b = { param($x) [string][int][double]::Parse($x) }
        cl_crosshaircolor_g = { param($x) [string][int][double]::Parse($x) }
        cl_crosshaircolor_r = { param($x) [string][int][double]::Parse($x) }
        rate = { param($x) [string][int][double]::Parse($x) }
        skill = { param($x) [string][int][double]::Parse($x) }
        cl_quickinventory_line_update_speed = { param($x) $x.TrimEnd('f') }
    }

    return @($patterns, $cs2BetterNetConfigs, $deprecatedCommands, $fixFloats)
}

function Invoke-DeprecatedCommands {
    param (
        [Parameter(Mandatory=$true)]
        [string]$line,
        
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[string]]$deprecatedCommands
    )

    $shouldDelete = $false

    foreach ($command in $deprecatedCommands) {
        if ($line.Trim().StartsWith($command)) {
            $shouldDelete = $true
            Write-Host "Found and removed deprecated command '$command' in the line: $($line.Trim())"
        }
    }

    return $line, $shouldDelete
}

function Invoke-PatternHandler {
    param (
        [string]$line,
        [System.Collections.Generic.List[System.Tuple[string, string]]]$patterns
    )
    
    foreach ($patternTuple in $patterns) {
        if ($line -match $patternTuple.Item1) {
            $line = $line -replace $patternTuple.Item1, $patternTuple.Item2
            Write-Host "Found and replaced pattern '$($patternTuple.Item1)' with '$($patternTuple.Item2)' in the line: $($line.Trim())"
        }
    }
    
    return $line
}

function Invoke-FixCommands {
    param(
        [string]$Line,
        [hashtable]$FixCommands
    )
    
    $FixCommands.GetEnumerator() | ForEach-Object {
        $currentKey = $_.Key
        $currentScriptBlock = $_.Value
        if ($Line.Trim().StartsWith($currentKey)) {
            $Value = ($Line.Trim() -split ' ')[1].Trim('"')
            $correctedValue = & $currentScriptBlock $Value
            $Line = "{0} ""{1}""" -f $currentKey, $correctedValue
            Write-Host "Corrected the command '$currentKey' with the value '$correctedValue' in the line: $($Line.Trim())"
        }
    }
    
    return $Line
}

function Invoke-NetConfigs {
    param(
        [string]$Line,
        [Array]$CS2BetterNetConfigs,
        [ref]$FoundNetConfigs
    )

    $CS2BetterNetConfigs | ForEach-Object {
        if ($Line.StartsWith($_.Key)) {
            $Line = "{0} {1}`n" -f $_.Key, $_.Value
            Write-Host ("Found and replaced '{0}' with the value '{1}' in the line: {2}" -f $_.Key, $_.Value, $Line.Trim())
            $FoundNetConfigs.Value[$_.Key] = $true
        }
    }
    return $Line
}

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

        $UserdataDir = Join-Path $SteamPath "userdata"

        if (-not (Test-Path $UserdataDir)) {
            Write-Host "The 'userdata' folder does not exist at the path: $UserdataDir" -ForegroundColor Yellow
            return $CfgFiles, ($CfgFiles.Count -gt 0)
        }

        $UserFolders = Get-ChildItem -Path $UserdataDir -Directory | Select-Object -ExpandProperty Name

        if (-not $UserFolders -or $UserFolders.Count -eq 0) {
            Write-Host "No user ID folders found in 'userdata' at the path: $UserdataDir" -ForegroundColor Yellow
            return $CfgFiles, ($CfgFiles.Count -gt 0)
        }

        foreach ($UserFolder in $UserFolders) {
            $CfgDir = Join-Path $UserdataDir "$UserFolder\730\local\cfg"

            if (Test-Path $CfgDir) {
                $CfgFilePaths = Get-ChildItem -Path $CfgDir -Recurse -Filter "config.cfg" | Select-Object -ExpandProperty FullName

                foreach ($CfgFilePath in $CfgFilePaths) {
                    $CfgFiles += ,@($CfgFilePath, $UserFolder)
                }
            }
        }

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
        if (-not (Test-Path -Path $Cs2InstallPath)) {
            Write-Warning "The 'Steam32ID' folder does not exist at the path: $Cs2InstallPath" -ForegroundColor Yellow
        }

        $NewFileName = "$UserFolder.cfg"
        Write-Host "Generated new file name: $NewFileName"

        $Destination = Join-Path $Cs2InstallPath $NewFileName

        Write-Host "Prepared destination path: $Destination"

        return $Destination
    }
    catch {
        Write-Host "An error occurred while preparing the destination: $_" -ForegroundColor Red
        return $null
    }
}

function Get-EchoLines {
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
    param(
        [string[]]$Lines
    )

    $configurations = Get-Configurations
    $patterns = $configurations[0]
    $cs2BetterNetConfigs = $configurations[1]
    $deprecatedCommands = $configurations[2]
    $fixFloats = $configurations[3]

    $patternsList = New-Object 'System.Collections.Generic.List[System.Tuple[string,string]]'
    $patterns | ForEach-Object { $patternsList.Add([System.Tuple]::Create($_.Regex, $_.Replacement)) }

    $modifiedLines = @()

    $foundNetConfigs = @{}
    $cs2BetterNetConfigs | ForEach-Object { $foundNetConfigs[$_.Key] = $false }

    foreach ($line in $Lines) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $line, $shouldDelete = Invoke-DeprecatedCommands -Line $line -DeprecatedCommands $deprecatedCommands

            $line = Invoke-PatternHandler -Line $line -Patterns $patternsList

            $line = Invoke-FixCommands -Line $line -FixCommands $fixFloats

            if (-not $shouldDelete) {
                $line = Invoke-NetConfigs -Line $line -CS2BetterNetConfigs $cs2BetterNetConfigs -FoundNetConfigs ([ref]$foundNetConfigs)
                $modifiedLines += $line
            }
        }
    }

    $foundNetConfigs.GetEnumerator() | ForEach-Object {
        $currentKey = $_.Key
        if (-not $_.Value) {
            $configValue = ($cs2BetterNetConfigs | Where-Object { $_.Key -eq $currentKey } | Select-Object -First 1).Value
            $modifiedLines += ("{0} {1}" -f $currentKey, $configValue)
            Write-Host ("Added better net configuration '{0}' with value '{1}'" -f $currentKey, $configValue)
        }
    }
             
    $modifiedLines += "host_writeconfig"
    Write-Host "Added 'host_writeconfig' at the end of the file"

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
        $config_modified = $true
        
        $lines = Read-File $CfgFile
        
        $modified_lines = Invoke-Lines $lines


        $destination = Set-Destination $CfgFile $UserFolder $CS2InstallPath

        Write-ModifiedLines $destination $modified_lines
        
        
        return $config_modified
    } catch {
        $config_modified = $false
        
        Write-Host "An error in the Invoke-CfgFile Function with the cfgfile:", $CfgFile -ForegroundColor Red
        
        return $config_modified
    }
}

function Get-SteamInstallationPath {
    try {
        $steamPath = Get-ItemPropertyValue -Path 'HKCU:\Software\Valve\Steam' -Name 'SteamPath'
        
        if ($steamPath) {
            return [PSCustomObject]@{
                Path = $steamPath
                Success = $true
            }
        } else {
            throw "Steam installation path not found in the registry."
        }
    } catch {
        Write-Error "Could not retrieve the Steam installation path: $_" -ForegroundColor Red
        return [PSCustomObject]@{
            Path = $null
            Success = $false
        }
    }
}

function Get-CS2InstallationPath {
    try {
        $cs2Path = Get-ItemPropertyValue -Path 'HKCU:\Software\Classes\csgo\Shell\Open\Command' -Name '(default)'
        
        if ($cs2Path) {
            $path = $cs2Path -split '"' | Select-Object -Index 1
            $path = $path -replace '\\game\\bin\\win64\\cs2.exe', '\game\csgo\cfg'
            
            return [PSCustomObject]@{
                Path = $path
                Success = $true
            }
        } else {
            throw "CS2 installation path not found in the registry."
        }
    } catch {
        Write-Error "Could not retrieve the CS2 installation path: $_" -ForegroundColor Red
        return [PSCustomObject]@{
            Path = $null
            Success = $false
        }
    }
}

function Read-File {
    param (
        [string]$Destination
    )
 
    try {
        $lines = Get-Content -Path $Destination
        Write-Host "Successfully read the file at: $Destination"
        return $lines
    }
    catch {
        Write-Host "An error occurred while reading the file at $Destination. Error: $_" -ForegroundColor Red
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
                Add-Content -Path $Destination -Value $formattedLine
            }
        }
        Write-Host "Successfully wrote the modified lines to the file at: $Destination" -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred while writing the modified lines to the file at $Destination" -ForegroundColor Red
    }
}

function Get-Nickname {
    param (
        [string]$userFolder
    )

    $url = "https://steamid.xyz/$userFolder"

    $headers = @{
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    }

    $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Get

    if ($response.StatusCode -eq 200) {
        $divGuide = $response.ParsedHtml.getElementById('guide')
        if ($divGuide) {
            $nicknameElements = @($divGuide.getElementsByTagName('input')) | Where-Object { $_.type -eq 'text' }
            if ($nicknameElements -and $nicknameElements.Count -gt 4) {
                return $nicknameElements[4].value
            } else {
                return "Nickname not found"
            }
        } else {
            return "'guide' div not found"
        }
    } else {
        return "Error: $($response.StatusCode)"
    }
}

# Main function
function Migra {
    $VerbosePreference = "Continue"

    $steam_path_result = Get-SteamInstallationPath
    $cs2_path_result = Get-Cs2InstallationPath

    if ($steam_path_result.Success -and $cs2_path_result.Success) {
        $CfgFiles, $found = Find-ConfigFiles -SteamPath $steam_path_result.Path

        if ($found) {
            # Clear the textBox before adding new content
            $script:textBox.Text = "------------------------------------------------------------`r`n`r`n"

            foreach ($file_info in $CfgFiles) {
                $cfgFilePath = $file_info[0]
                $userFolder = $file_info[1]
                $nickname = Get-Nickname -userFolder $userFolder
                $user = "User: ${nickname}`r`n"
                $command = "Command: exec $userFolder`r`n`r`n"
                $separador = "------------------------------------------------------------`r`n`r`n"
                $script:textBox.Text += $user
                $script:textBox.Text += $command
                $script:textBox.Text += $separador

                Invoke-CfgFile -CfgFile $cfgFilePath -UserFolder $userFolder -CS2InstallPath $cs2_path_result.Path
            }
        } else {
            Write-Error "No config.cfg files found"
        }
    } else {
        Write-Error "Steam or CS2 not found"
    }
}

# GUI function
function CS2_Config_Migrator {
    $formWidth = 700
    $formHeight = 700
    $textBoxWidth = 300
    $textBoxHeight = 200
    $buttonWidth = 360
    $buttonHeight = 30

    $form = New-Object Windows.Forms.Form
    $form.Text = "CS:GO to CS2 Config Migrator by manny_agre"
    $form.Width = $formWidth
    $form.Height = $formHeight
    $form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.MaximizeBox = $false

    $label = New-Object Windows.Forms.Label
    $label.Text = "
    After clicking on the START button, open CS2 and type 'exec <config_name>' in the 
    console to apply the desired config, where <config_name> is the name of the
    configuration file you wish to use (one for each user who has played CS:GO on this
    computer).
    
    The config file is named after the user's Steam32 ID.
    
    Here are the config files found on this computer and you can copy the respective
    command to apply them in CS2:"
    $label.AutoSize = $true
    $label.Location = New-Object Drawing.Point(10,10)
    $label.Font = New-Object System.Drawing.Font('Baskerville', 12)
    $label.ForeColor = [System.Drawing.Color]::White 

    $script:textBox = New-Object Windows.Forms.TextBox
    $script:textBox.Width = $textBoxWidth
    $script:textBox.Height = $textBoxHeight
    $script:textBox.Multiline = $true
    $script:textBox.ReadOnly = $true
    $script:textBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical 
    $script:textBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45) 
    $script:textBox.ForeColor = [System.Drawing.Color]::White
    $script:textBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Center

    # Calculate locations
    $textBoxX = ($formWidth - $textBoxWidth) / 2
    $textBoxY = ($formHeight - $textBoxHeight) / 2.3
    $buttonX = ($formWidth - $buttonWidth) / 2
    $buttonY = $textBoxY + $textBoxHeight + 20

    # Set the locations
    $script:textBox.Location = New-Object Drawing.Point($textBoxX, $textBoxY)

    $button = New-Object Windows.Forms.Button
    $button.Text = "START"
    $button.Width = $buttonWidth
    $button.Height = $buttonHeight
    $button.Location = New-Object Drawing.Point($buttonX, $buttonY)
    $button.Font = New-Object System.Drawing.Font('Baskerville', 11)
    $button.ForeColor = [System.Drawing.Color]::White 
    $button.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
    $button.Add_Click({ Migra })

    $form.Controls.Add($label)
    $form.Controls.Add($script:textBox)
    $form.Controls.Add($button)

    $form.ShowDialog()
}

# Run the GUI
CS2_Config_Migrator

