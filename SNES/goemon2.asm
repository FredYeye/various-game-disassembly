lorom

{ ;inputs
	!r      = $0010
    !x      = $0040
    !a      = $0080
	!right  = $0100
	!start  = $1000
	!select = $2000
}

{ ;ram
    !buttons_held    = $36
    !buttons_pressed = $38
    !game_state      = $42
    !frame_counter   = $4A
    !lag_frame       = $4C ;"vblank handler busy" bool. set to 1 early in vblank handler, cleared when done
    !stage_state     = $84
    !rng             = $8C
    !timer           = $AE

    !ryo = $0474
    !helmet_state = $0478
    !helmet_count = $0479
    !armor_state  = $047A
    !armor_count  = $047B
    !lives = $0498

    !status_bar = $1880

    !impact_health = $1B48

    !maneki_neko_counter = $1BA4
}

{ ;game state defines
	!gs_debug = $0007
	!gs_map   = $0008
	!gs_stage = $0009
}
