import logging
import re

def get_configurations():
    """
    Manual counter-strike configurations that will be used in the "handle's" functions
    """
    patterns = [
            (r'\+moveleft', '+left'),
            (r'\+moveright', '+right'),
            (r'\+speed', '+sprint'),
            (r'sv_noclipspeed "5"', 'sv_noclipspeed "1000"'),
            (r'KP_INS', 'KP_0'),
            (r'KP_END', 'KP_1'),
            (r'KP_DOWNARROW', 'KP_2'),
            (r'KP_PGDN', 'KP_3'),
            (r'KP_LEFTARROW', 'KP_4'),
            (r'KP_RIGHTARROW', 'KP_6'),
            (r'KP_HOME', 'KP_7'),
            (r'KP_UPARROW', 'KP_8'),
            (r'KP_PGUP', 'KP_9'),
            (r'KP_SLASH', 'KP_DIVIDE')
        ]

    cs2_better_net_configs = {
            'cl_updaterate': '"128"',
            'cl_interp_ratio': '"1"',
            'cl_interp': '"0.015625"'
        }

    deprecated_commands = [
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
        ]

    fix_commands = {
            "cl_crosshairalpha": lambda x: str(int(float(x))),
            "cl_crosshaircolor_b": lambda x: str(int(float(x))),
            "cl_crosshaircolor_g": lambda x: str(int(float(x))),
            "cl_crosshaircolor_r": lambda x: str(int(float(x))),
            "rate": lambda x: str(int(float(x))),
            "skill": lambda x: str(int(float(x))),
            "cl_quickinventory_line_update_speed": lambda x: x.rstrip('f')
        }

    return patterns, cs2_better_net_configs, deprecated_commands, fix_commands

def handle_deprecated_commands(line, deprecated_commands):
    """
    Checks if a line starts with a deprecated command and marks it for deletion if so.
    
    :param line: The line from the config file being processed.
    :param deprecated_commands: A list of deprecated commands to check for.
    :return: The original line and a boolean indicating whether the line should be deleted.
    """
    should_delete = False
    for command in deprecated_commands:
        if line.strip().startswith(command):
            should_delete = True
            logging.info("Found and removed deprecated command '%s' in the line: %s", command, line.strip())
            break

    return line, should_delete

def handle_patterns(line, patterns):
    """
    Handles the replacement of patterns in a line based on a list of pattern-replacement pairs.
    
    :param line: The line from the config file being processed.
    :param patterns: A list of tuples where each tuple contains a pattern to search for and its respective replacement.
    :return: The modified line with all found patterns replaced; otherwise, the original line.
    """
    for pattern, replacement in patterns:
        if re.search(pattern, line):
            line = re.sub(pattern, replacement, line)
            logging.info("Found and replaced pattern '%s' with '%s' in the line: %s", pattern, replacement, line.strip())

    return line

def handle_fix_commands(line, fix_commands):
    """
    Handles the correction of certain commands in a line based on a dictionary of command fixer functions.
    
    :param line: The line from the config file being processed.
    :param fix_commands: A dictionary where keys are commands to find and values are functions to correct the command values.
    :return: The modified line if a fix command was found and processed; otherwise, the original line.
    """
    for command, corrector in fix_commands.items():
        if line.strip().startswith(command):
            value = line.strip().split(' ')[1].strip('"')
            line = f'{command} "{corrector(value)}"\n'
            logging.info("Corrected the command '%s' with the value '%s' in the line: %s", command, corrector(value), line.strip())
            break

    return line

def handle_net_configs(line, cs2_better_net_configs):
    """
    This function is responsible for handling network configurations in a line of the configuration file.
    
    :param line: A string representing a line in the configuration file.
    :param cs2_better_net_configs: A dictionary containing network configuration patterns and their respective replacements.
    :return: The modified line with necessary network configurations replaced; otherwise, the original line.
    """
    for pattern, replacement in cs2_better_net_configs.items():
        if line.startswith(pattern):
            line = f'{pattern} {replacement}\n'
            logging.info("Found and replaced '%s' with '%s' in the line: %s", pattern, replacement, line.strip())

    return line
