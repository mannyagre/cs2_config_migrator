[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Get-Configurations {
    <#
    .SYNOPSIS
    Manual counter-strike configurations that will be used in the "handle's" functions
    #>
    
    $patterns = @(
        @{ Regex = '+moveleft'; Replacement = '+left' },
        @{ Regex = '+moveright'; Replacement = '+right' },
        @{ Regex = '+speed'; Replacement = '+sprint' },
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

    $cs2BetterNetConfigs = @{
        cl_updaterate = '128'
        cl_interp_ratio = '1'
        cl_interp = '0.015625'
    }

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

    $fixCommands = @{
        cl_crosshairalpha = { param($x) [string][int][double]::Parse($x) }
        cl_crosshaircolor_b = { param($x) [string][int][double]::Parse($x) }
        cl_crosshaircolor_g = { param($x) [string][int][double]::Parse($x) }
        cl_crosshaircolor_r = { param($x) [string][int][double]::Parse($x) }
        rate = { param($x) [string][int][double]::Parse($x) }
        skill = { param($x) [string][int][double]::Parse($x) }
        cl_quickinventory_line_update_speed = { param($x) $x.TrimEnd('f') }
    }

    return $patterns, $cs2BetterNetConfigs, $deprecatedCommands, $fixCommands
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
            break
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
        if ($Line.Trim().StartsWith($_.Key)) {
            $Value = ($Line.Trim() -split ' ')[1].Trim('"')
            $Line = "{0} ""{1}""" -f $_.Key, ($_.Value.Invoke($Value))
            Write-Host "Corrected the command '$_.Key' with the value '$($_.Value.Invoke($Value))' in the line: $($Line.Trim())"
            break
        }
    }
    
    return $Line
}

function Invoke-NetConfigs {
    param(
        [string]$Line,
        [hashtable]$CS2BetterNetConfigs
    )

    $CS2BetterNetConfigs.GetEnumerator() | ForEach-Object {
        if ($Line.StartsWith($_.Key)) {
            $Line = "{0} {1}`n" -f $_.Key, $_.Value
            Write-Host ("Found and replaced '{0}' with '{1}' in the line: {2}" -f $_.Key, $_.Value, $Line.Trim())
        }
    }

    return $Line
}

Export-ModuleMember -Function Invoke-DeprecatedCommands, Invoke-NetConfigs, Invoke-PatternHandler, Invoke-FixCommands, Get-Configurations
