lorom

;smash tv defines
{
    !rng_state        = $05A8
    !current_circuit  = $05AB
    !current_arena    = $05AC
    !item_drop_timer  = $05AE
    !money_drop_timer = $05AF
    !room_complete    = $05D3
    !room_exit_timer  = $05D4 ;time until opening doors, then also until homing blades spawn upon completing a room

    !enemy_counter = $06C6

    !x_pos_list = $0B46
    !y_pos_list = $0C9C

    !item_timer_list = $134A

    ; $18C5 some kind of active enemy list. separates grunts by color but they're not stored in the same slot always

    !grunt_active = $18E4
    !mr_shrapnel_active = $18EC

    !waves_allowed_remaining = $18FF
    !waves_remaining         = $1900

    !wave_type              = $1902
    !wave_count             = $1909
    !wave_count2            = $1910
    !wave_spawn_limit       = $1917
    !wave_flags             = $191E ;not sure what this is
    !wave_cooldown          = $1925
    !wave_cooldown2         = $192C
    !wave_pre_spawned       = $1933
    !wave_spawn_timer       = $193A
    !wave_spawn_timer2      = $1941
}

;enemy types
{
    !grunt = $01
    !wall_gunner = $02
    !worm = $03
    !red_droid = $04
    !snakes = $05
    !cobra_grunt = $06
    !laser_orb = $07
    !tank = $08
	!red_cluster = $09
    !mr_shrapnel = $0A
    !worm_segment = $0B
    !purple_red_homing_droid = $0C
    !droid = $0D
    !purple_worm = $0E
    !mine = $0F
    !mutoid_man = $11
    !scarface = $12
    !presents = $14
    !question_mark = $15
}

;---------- 00

{ : org $0097B7 ;97B7 - 97D2
_0097B7:
    lda #$00 : pha : plb
    lda !current_arena
    sta $04
    asl
    clc
    adc $04
    tay ; Y = current_arena * 3
    ldx !current_circuit
    lda.w arena_connections+0,X : sta $04
    lda.w arena_connections+3,X : sta $05
    rts
}

{ : org $00AA66 ;AA66 - AB10
arena_connections:
    db $6C, $90, $C9
    db $AA, $AA, $AA

.circuit1:
    db $00, $01, $00 ;tv studio
    db $00, $03, $00 ;arena 1
    db $00, $04, $00 ;collect 10 keys!
    db $02, $00, $06 ;collect powerups!
    db $00, $05, $08 ;meet mr. shrapnel
    db $00, $00, $09
    db $00, $07, $00
    db $08, $0B, $00
    db $00, $09, $00
    db $00, $0A, $00
    db $00, $FF, $00
    db $09, $00, $04

.circuit2:
    db $00, $01, $00
    db $08, $02, $0D
    db $09, $03, $0E
    db $04, $00, $0F
    db $0B, $00, $00
    db $00, $00, $06
    db $00, $07, $00
    db $00, $FF, $00
    db $00, $09, $00
    db $00, $04, $00
    db $10, $07, $0B
    db $00, $0C, $00
    db $00, $00, $05
    db $00, $0E, $00
    db $00, $0F, $00
    db $00, $00, $11
    db $06, $00, $00
    db $00, $12, $00
    db $10, $0A, $00

.circuit3:
    db $00, $01, $00
    db $08, $02, $0D
    db $09, $03, $0E
    db $04, $00, $0F
    db $0B, $00, $00
    db $00, $00, $06
    db $00, $07, $00
    db $00, $13, $00
    db $00, $09, $00
    db $00, $04, $00
    db $10, $07, $0B
    db $00, $0C, $00
    db $00, $00, $05
    db $00, $0E, $00
    db $00, $0F, $00
    db $00, $00, $11
    db $06, $00, $00
    db $00, $12, $00
    db $10, $0A, $00
    db $00, $14, $00
    db $00, $15, $16
    db $00, $FF, $00
    db $00, $15, $00
    db $00, $15, $00
}

{ : org $00C1CE ;C1CE - C249
_00C1CE: ;load level data
    lda #$02 : pha : plb
    lda !current_circuit : asl : tax
    lda.w level_data+0,X : sta $04
    lda.w level_data+1,X : sta $05
    lda !current_arena : asl : tay
    lda ($04),Y : sta $12
    iny
    lda ($04),Y : sta $13 ;$12 = offset to level data
    ldy #$00
    lda ($12),Y : sta $10 ;wave count
.C1F5:
    inc !waves_remaining
    ldx $10
    iny
    lda ($12),Y : sta !wave_type,X
    iny
    lda ($12),Y : sta !wave_count,X
    iny
    lda ($12),Y : sta !wave_count2,X ;upper byte
    iny
    lda ($12),Y : sta !wave_spawn_limit,X
    iny
    lda ($12),Y : sta !wave_flags,X ;flags/subtype?
    iny
    lda ($12),Y : sta !wave_cooldown,X ;next wave timer
    iny
    lda ($12),Y : sta !wave_cooldown2,X ;upper byte
    iny
    lda ($12),Y : sta !wave_pre_spawned,X
    iny
    lda ($12),Y : sta !wave_spawn_timer,X
    iny
    lda ($12),Y : sta !wave_spawn_timer2,X ;upper byte
    sty $11
    jsr _00C355
    ldy $11
    dec $10
    bpl .C1F5

    iny
    lda ($12),Y : sta !waves_allowed_remaining
    plb
    plp
    rts
}

{ : org $00C355 ;C355 - ?
_00C355:
    lda !wave_type,X : asl : tax
    jmp (+,X) : +: dw .grunt, .tank

;-----

.grunt:
.tank:
}

{ : org $00DD0A ;DD0A - DD29
spawn_item_pos: ;x/y offsets for item drops
    db $64, $6C, $74, $7C, $84, $2C, $34, $3C
    db $44, $4C, $54, $5C, $64, $6C, $74, $7C
    db $84, $8C, $94, $9C, $A4, $AC, $B4, $BC
    db $C4, $CC, $D4, $84, $7C, $84, $8C, $94
}

{ : org $00E87B ;E87B - ?
_00E87B: ;set stage name
    phb
    lda #$00 : pha : plb
    lda !current_circuit : asl : tax
    lda.w stage_names+0,X : sta $04
    lda.w stage_names+1,X : sta $05
    lda !current_arena
    dec
    sta $4202
    lda #$1A : sta $4203
    nop #4
    clc
    lda $04 : adc $4216 : sta $04
    lda $05 : adc $4217 : sta $05
    ;todo
}

{ : org $00E977 ;E977 - EEC4
stage_names:
    dw .circuit1, .circuit2, .circuit3

.circuit1:
    db "          ARENA 1         "
    db "     COLLECT 10 KEYS!     "
    db "     COLLECT POWERUPS!    "
    db "     MEET MR. SHRAPNEL    "
    db "       BONUS PRIZES!      "
    db "      EAT MY SHRAPNEL     "
    db "       TOTAL CARNAGE      "
    db "       CROWD CONTROL      "
    db "       TANK TROUBLE       "
    db "        MUTOID MAN!       "
    db "     SECRET ROOM #1!      "

.circuit2:
    db "           ORBS!          "
    db "       MEET MY TWIN       "
    db "        SMASH 'EM         "
    db "   FIRE POWER IS NEEDED!  "
    db "      SLAUGHTER 'EM       "
    db "     LAZER DEATH ZONE     "
    db "      MEET SCARFACE!      "
    db "       ROWDY DROIDS       "
    db "       VACUUM CLEAN       "
    db "      SECRET ROOM #2!     "
    db "        METAL DEATH       "
    db "      WATCH YOUR STEP     "
    db "        FILM AT 11        "
    db "         DEFEND ME        "
    db "      TURTLES NEARBY      "
    db "      CHUNKS GALORE!      "
    db "     THESE ARE FAST!      "
    db "   BUFFALO HERD NEARBY!   "

.circuit3:
    db "          NO DICE         "
    db "       TEMPLE ALERT       "
    db "      SCORPION FEVER      "
    db "     COBRA JUST AHEAD!    "
    db "       WALLS OF PAIN      "
    db "        LAST ARENA?       "
    db "       COBRA DEATH!       "
    db "      TURTLES BEWARE!     "
    db "    EXTRA SAUCE ACTION!   "
    db "      SECRET ROOM #3!     "
    db "   SECRET ROOMS NEARBY!   "
    db "     ENJOY MY WEALTH      "
    db "   NO TURTLES ALLOWED!    "
    db "   TURTLE CHUNKS NEEDED   "
    db "   DYNAMITE COBRA BOSS    "
    db "   USE THE BUFFALO GUN    "
    db "  WITNESS TOTAL CARNAGE   "
    db "   SECRET ROOMS NEARBY!   "
    db "    ALMOST ENOUGH KEYS    "
    db "  YOU HAVE ENOUGH KEYS!   "
    db "     EAT MY EYEBALLS!     "
    db "      PLEASURE DOME!      "
    db "     NOT ENOUGH KEYS!     "
}

;---------- 02

{ : org $02B5F0 ;B5F0 - ?
level_data:
    dw .circuit1, .circuit2, .circuit3

;-----

.circuit1:
    dw $0000
    dw .arena_1, .collect_10_keys, .collect_powerups, .meet_mr_shrapnel
    dw .bonus_prizes, .eat_my_shrapnel, .total_carnage, .crowd_control
    dw .tank_trouble, .mutoid_man, .secret_room_1
.circuit2:
    dw $0000
    dw .orbs, .meet_my_twin, .smash_em, .fire_power_is_needed
    dw .slaughter_em, .lazer_death_zone, .meet_scarface, .rowdy_droids
    dw .vacuum_clean, .secret_room_2, .metal_death, .watch_your_step
    dw .film_at_11, .defend_me, .turtles_nearby, .chunks_galore
    dw .these_are_fast, .buffalo_herd_nearby
.circuit3:
    dw $0000
    dw .no_dice, .temple_alert, .scorpion_fever, .cobra_just_ahead
    dw .walls_of_pain, .last_arena, .cobra_death, .turtles_beware
    dw .extra_sauce_action, .secret_room_3, .secret_rooms_nearby, .enjoy_my_wealth
    dw .no_turtles_allowed, .turtle_chunks_needed, .dynamite_cobra_boss, $BD38
    dw $BD58, $BD82, $BDB6, $BDEA
    dw $BE1E, $BE48, $BDEA

;-----

;wave count

;count
;spawn limit
;setting this above 0 spawns purple guys
;timer before next wave is allowed to spawn
;enemies already spawned on entering room
;timer before spawning

;waves allowed to remain and still beat the room? think it depends on enemy type

.arena_1:
    db $01
    db !grunt : dw $0064 : db $09, $00 : dw $0012 : db $04 : dw $005A
    db !tank  : dw $0005 : db $01, $00 : dw $010E : db $00 : dw $0F78
    db $01

.collect_10_keys:
    db $04
    db !grunt       : dw $012C : db $0A, $02 : dw $0018 : db $10 : dw $0003
    db !mr_shrapnel : dw $000F : db $02, $00 : dw $010E : db $02 : dw $005A
    db !mine        : dw $0005 : db $04, $00 : dw $0000 : db $05 : dw $0003
    db !wall_gunner : dw $0001 : db $01, $00 : dw $0000 : db $01 : dw $0003
    db !tank        : dw $0005 : db $01, $00 : dw $010E : db $00 : dw $1428
    db $02

.collect_powerups:
    db $03
    db !grunt       : dw $00C3 : db $0A, $01 : dw $0003 : db $00 : dw $0003
    db !mr_shrapnel : dw $0006 : db $02, $00 : dw $01E0 : db $00 : dw $0096
    db !mine        : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db !tank        : dw $0005 : db $01, $00 : dw $01A4 : db $00 : dw $10A4
    db $02

.meet_mr_shrapnel:
    db $04
    db !grunt       : dw $0019 : db $04, $03 : dw $0003 : db $00 : dw $04CE
    db !mr_shrapnel : dw $001E : db $08, $01 : dw $000F : db $07 : dw $0078
    db !mine        : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db !tank        : dw $0005 : db $01, $00 : dw $010E : db $00 : dw $1428
    db !wall_gunner : dw $0002 : db $01, $00 : dw $0000 : db $02 : dw $0003
    db $01

.bonus_prizes:
    db $04
    db !presents    : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db !grunt       : dw $01C7 : db $0C, $06 : dw $000C : db $00 : dw $0168
    db !mr_shrapnel : dw $0019 : db $03, $00 : dw $00F0 : db $00 : dw $04B0
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !tank        : dw $0002 : db $01, $00 : dw $01A4 : db $00 : dw $1518
    db $02

.eat_my_shrapnel:
    db $04
    db !grunt       : dw $0041 : db $04, $03 : dw $0003 : db $10 : dw $01EF
    db !red_cluster : dw $0001 : db $01, $00 : dw $023A : db $00 : dw $00B4
    db !mr_shrapnel : dw $000F : db $04, $00 : dw $0087 : db $03 : dw $00D2
    db !mine        : dw $0002 : db $02, $00 : dw $0000 : db $02 : dw $0003
    db !tank        : dw $0005 : db $02, $00 : dw $02D0 : db $00 : dw $0E4C
    db $01

.total_carnage:
    db $04
    db !grunt       : dw $018B : db $0C, $03 : dw $0003 : db $10 : dw $005A
    db !red_cluster : dw $0001 : db $01, $00 : dw $02EE : db $00 : dw $0F3C
    db !mr_shrapnel : dw $000D : db $03, $00 : dw $0159 : db $02 : dw $0003
    db !mine        : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db !tank        : dw $0005 : db $01, $00 : dw $01A4 : db $00 : dw $12FC
    db $03

.crowd_control:
    db $05
    db !grunt       : dw $0127 : db $0D, $04 : dw $0003 : db $00 : dw $01E0
    db !red_cluster : dw $0001 : db $01, $00 : dw $05DC : db $00 : dw $0003
    db !mr_shrapnel : dw $000A : db $02, $00 : dw $001E : db $03 : dw $0003
    db !wall_gunner : dw $0002 : db $02, $00 : dw $0000 : db $02 : dw $0003
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !tank        : dw $000D : db $01, $00 : dw $0078 : db $00 : dw $0834
    db $01

.tank_trouble:
    db $04
    db !grunt       : dw $0145 : db $0E, $04 : dw $0003 : db $00 : dw $0003
    db !wall_gunner : dw $0002 : db $02, $00 : dw $0000 : db $02 : dw $0003
    db !tank        : dw $001B : db $01, $00 : dw $01E0 : db $00 : dw $0258
    db !mr_shrapnel : dw $0012 : db $02, $00 : dw $0003 : db $03 : dw $0384
    db !mine        : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db $02

.mutoid_man:
    db $03
    db !mutoid_man  : dw $0001 : db $01, $00 : dw $0000 : db $01 : dw $0003
    db !mine        : dw $0002 : db $02, $00 : dw $0000 : db $02 : dw $0003
    db !red_cluster : dw $0001 : db $01, $00 : dw $0087 : db $00 : dw $003C
    db !mr_shrapnel : dw $0023 : db $03, $00 : dw $01A4 : db $00 : dw $0BB8
    db $01

.secret_room_1:
    db $01
    db !presents      : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db !question_mark : dw $0001 : db $01, $00 : dw $0000 : db $00 : dw $021C
    db $00

;-----

.orbs:
    db $00
    db !laser_orb : dw $0062 : db $0A, $00 : dw $001E : db $01 : dw $0003
    db $00

.meet_my_twin:
    db $01
    db !droid       : dw $017C : db $0F, $03 : dw $0003 : db $00 : dw $0003
    db !mr_shrapnel : dw $0001 : db $01, $00 : dw $010E : db $01 : dw $05DC
    db $01

.smash_em:
    db $03
    db !droid       : dw $010E : db $0F, $05 : dw $000F : db $03 : dw $09F6
    db !red_cluster : dw $0002 : db $01, $00 : dw $00F0 : db $00 : dw $0003
    db !mine        : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db !worm        : dw $000F : db $01, $00 : dw $001E : db $00 : dw $01C2
    db $01

.fire_power_is_needed:
    db $03
    db !red_cluster  : dw $0001 : db $01, $00 : dw $00D2 : db $00 : dw $0003
    db !red_droid    : dw $00F0 : db $0F, $04 : dw $0003 : db $00 : dw $0960
    db !mine         : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db !worm_segment : dw $003C : db $04, $00 : dw $002D : db $00 : dw $0003
    db $00

.slaughter_em:
    db $05
    db !droid        : dw $014A : db $10, $07 : dw $0003 : db $00 : dw $0708
    db !worm_segment : dw $0028 : db $07, $00 : dw $0018 : db $00 : dw $021F
    db !mr_shrapnel  : dw $000A : db $02, $00 : dw $023A : db $01 : dw $05DC
    db !mine         : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db !red_cluster  : dw $0004 : db $01, $00 : dw $00E1 : db $00 : dw $0003
    db !tank         : dw $0006 : db $01, $00 : dw $00B4 : db $01 : dw $0E10
    db $02

.lazer_death_zone:
    db $03
    db !laser_orb               : dw $005A : db $0E, $00 : dw $0018 : db $01 : dw $04B0
    db !purple_red_homing_droid : dw $0023 : db $09, $00 : dw $002D : db $00 : dw $0003
    db !mine                    : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db !tank                    : dw $0017 : db $02, $00 : dw $0096 : db $01 : dw $0003
    db $01

.meet_scarface:
    db $01
    db !scarface : dw $0001 : db $01, $00 : dw $0000 : db $01 : dw $0003
    db !mine     : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db $01

.rowdy_droids:
    db $02
    db !droid : dw $00B4 : db $0E, $03 : dw $0003 : db $00 : dw $0960
    db !worm  : dw $0010 : db $02, $00 : dw $001E : db $00 : dw $001E
    db !mine  : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db $01

.vacuum_clean:
    db $02
    db !red_droid   : dw $0122 : db $10, $05 : dw $0003 : db $00 : dw $0186
    db !red_cluster : dw $0004 : db $02, $00 : dw $00F0 : db $00 : dw $0003
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db $00

.secret_room_2:
    db $01
    db !presents      : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db !question_mark : dw $0001 : db $01, $00 : dw $0000 : db $00 : dw $021C
    db $00

.metal_death:
    db $01
    db !droid : dw $0168 : db $10, $05 : dw $0003 : db $00 : dw $0A6E
    db !worm  : dw $0010 : db $03, $00 : dw $001E : db $00 : dw $0003
    db $01

.watch_your_step:
    db $03
    db !presents    : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db !droid       : dw $0226 : db $11, $04 : dw $0003 : db $00 : dw $01C2
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !mr_shrapnel : dw $0011 : db $02, $00 : dw $00D2 : db $00 : dw $05DC
    db $01

.film_at_11:
    db $02
    db !purple_red_homing_droid : dw $0018 : db $05, $00 : dw $0012 : db $00 : dw $001E
    db !droid                   : dw $015E : db $12, $04 : dw $000F : db $00 : dw $03A2
    db !mine                    : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db $00

.defend_me:
    db $05
    db !presents    : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db !droid       : dw $017C : db $0C, $05 : dw $000C : db $00 : dw $01C2
    db !worm        : dw $0003 : db $01, $00 : dw $021C : db $00 : dw $05DC
    db !mr_shrapnel : dw $0009 : db $03, $00 : dw $001E : db $00 : dw $0BB8
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !tank        : dw $0003 : db $01, $00 : dw $023A : db $00 : dw $0A8C
    db $02

.turtles_nearby:
    db $02
    db !laser_orb : dw $005A : db $0C, $00 : dw $0018 : db $01 : dw $0003
    db !mine      : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !tank      : dw $0008 : db $03, $00 : dw $023A : db $01 : dw $0003
    db $01

.chunks_galore:
    db $05
    db !red_droid    : dw $015E : db $11, $05 : dw $0003 : db $00 : dw $0870
    db !worm_segment : dw $0028 : db $04, $00 : dw $0015 : db $00 : dw $021F
    db !mr_shrapnel  : dw $000A : db $02, $00 : dw $023A : db $01 : dw $05DC
    db !mine         : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db !red_cluster  : dw $0004 : db $01, $00 : dw $00E1 : db $00 : dw $0003
    db !tank         : dw $0008 : db $01, $00 : dw $00B4 : db $01 : dw $0E10
    db $02

.these_are_fast:
    db $00
    db !droid : dw $0226 : db $14, $07 : dw $0003 : db $00 : dw $0003
    db $01

.buffalo_herd_nearby:
    db $04
    db !red_droid               : dw $02B2 : db $12, $05 : dw $0003 : db $00 : dw $0E10
    db !mine                    : dw $0002 : db $02, $00 : dw $0000 : db $02 : dw $0003
    db !red_cluster             : dw $0009 : db $01, $00 : dw $00F0 : db $00 : dw $0003
    db !worm                    : dw $000F : db $02, $00 : dw $001E : db $00 : dw $0618
    db !purple_red_homing_droid : dw $0005 : db $05, $00 : dw $001E : db $00 : dw $0CC6
    db $01

;-----

.no_dice:
    db $03
    db !cobra_grunt : dw $000C : db $06, $02 : dw $0003 : db $08 : dw $0A8C
    db !snakes      : dw $000F : db $1E, $00 : dw $0348 : db $00 : dw $04B0
    db !tank        : dw $001E : db $03, $00 : dw $0039 : db $00 : dw $0003
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db $01

.temple_alert:
    db $04
    db !cobra_grunt : dw $013B : db $10, $02 : dw $0018 : db $03 : dw $041A
    db !snakes      : dw $014F : db $19, $02 : dw $00F0 : db $00 : dw $0003
    db !purple_worm : dw $0006 : db $01, $00 : dw $0096 : db $00 : dw $0096
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !tank        : dw $0003 : db $01, $00 : dw $012C : db $00 : dw $1194
    db $01

.scorpion_fever:
    db $04
    db !grunt       : dw $02BC : db $0E, $07 : dw $0003 : db $05 : dw $0003
    db !mr_shrapnel : dw $0005 : db $02, $00 : dw $01FE : db $02 : dw $189C
    db !snakes      : dw $00EB : db $19, $01 : dw $0366 : db $00 : dw $0003
    db !mine        : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db !tank        : dw $0003 : db $01, $00 : dw $012C : db $00 : dw $1C20
    db $01

.cobra_just_ahead:
    db $02
    db !cobra_grunt : dw $028A : db $12, $07 : dw $0003 : db $05 : dw $0003
    db !mine        : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db !mr_shrapnel : dw $0011 : db $02, $01 : dw $00D2 : db $04 : dw $05DC
    db $01

.walls_of_pain:
    db $01
    db !droid : dw $0190 : db $19, $06 : dw $000C : db $00 : dw $0003
    db !mine  : dw $0008 : db $08, $00 : dw $0000 : db $08 : dw $0003
    db $01

.last_arena:
    db $03
    db !grunt       : dw $0410 : db $12, $06 : dw $0003 : db $01 : dw $0960
    db !red_cluster : dw $000D : db $02, $00 : dw $00D2 : db $00 : dw $0003
    db !mine        : dw $000E : db $0E, $00 : dw $0000 : db $0E : dw $0003
    db !purple_worm : dw $0022 : db $02, $00 : dw $04B0 : db $00 : dw $021C
    db $01

.cobra_death:
    db $00
    db $10 : dw $0001 : db $08, $00 : dw $0708 : db $00 : dw $0003
    db $01

.turtles_beware:
    db $02
    db !grunt  : dw $02BC : db $0D, $05 : dw $0006 : db $05 : dw $0003
    db !snakes : dw $0343 : db $14, $04 : dw $00F0 : db $00 : dw $003C
    db !mine   : dw $0006 : db $06, $00 : dw $0000 : db $06 : dw $0003
    db $01

.extra_sauce_action:
    db $03
    db !grunt       : dw $028A : db $0E, $06 : dw $0003 : db $00 : dw $0E10
    db !mr_shrapnel : dw $0011 : db $02, $00 : dw $01FE : db $04 : dw $05DC
    db !snakes      : dw $0B13 : db $14, $00 : dw $004B : db $00 : dw $0096
    db !mine        : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db $02

secret_room_3:
    db $01
    db !presents : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db $15 : dw $0001 : db $01, $00 : dw $0000 : db $00 : dw $021C
    db $00

.secret_rooms_nearby:
    db $02
    db $01 : dw $0009 : db $08, $02 : dw $0003 : db $05 : dw $0CE4
    db !tank : dw $0055 : db $03, $00 : dw $002D : db $01 : dw $0003
    db !mine : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db $01

.enjoy_my_wealth:
    db $05
    db !presents : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db $01 : dw $0258 : db $12, $06 : dw $0003 : db $00 : dw $041A
    db !mine : dw $0006 : db $06, $00 : dw $0000 : db $06 : dw $0003
    db $0A : dw $0008 : db $02, $00 : dw $0003 : db $00 : dw $1068
    db !worm : dw $0004 : db $02, $00 : dw $0096 : db $00 : dw $021C
    db !red_cluster : dw $0005 : db $01, $00 : dw $0348 : db $00 : dw $0834
    db $01

.no_turtles_allowed:
    db $05
    db !cobra_grunt : dw $0190 : db $10, $02 : dw $0003 : db $0A : dw $0003
    db !snakes : dw $0217 : db $17, $04 : dw $00F0 : db $00 : dw $0096
    db !mine : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !red_cluster : dw $0001 : db $01, $00 : dw $00F0 : db $00 : dw $0834
    db $0A : dw $0009 : db $02, $00 : dw $0003 : db $00 : dw $1068
    db $0E : dw $0005 : db $01, $00 : dw $0096 : db $00 : dw $021C
    db $01

.turtle_chunks_needed:
    db $04
    db !presents    : dw $0002 : db $00, $00 : dw $010E : db $00 : dw $0003
    db !cobra_grunt : dw $022B : db $10, $05 : dw $0003 : db $00 : dw $01C2
    db !mr_shrapnel : dw $0011 : db $02, $00 : dw $01FE : db $00 : dw $04B0
    db !tank        : dw $000A : db $01, $00 : dw $012C : db $00 : dw $1194
    db !mine        : dw $0006 : db $06, $00 : dw $0000 : db $06 : dw $0003
    db $02

.dynamite_cobra_boss:
    db $03
    db !red_droid : dw $0384 : db $0E, $04 : dw $0003 : db $00 : dw $0F3C
    db !mine : dw $0004 : db $04, $00 : dw $0000 : db $04 : dw $0003
    db $0E : dw $0005 : db $01, $00 : dw $021C : db $00 : dw $021C
    db !snakes : dw $0B13 : db $0F, $00 : dw $0063 : db $00 : dw $0003
    db $01

    db $02
    db !red_droid : dw $0988 : db $14, $04 : dw $0003 : db $00 : dw $0003
    db !mine : dw $0005 : db $05, $00 : dw $0000 : db $05 : dw $0003
    db !red_cluster : dw $000D : db $01, $00 : dw $021C : db $00 : dw $0A8C
    db $01

    db $03
    db !grunt  : dw $028A : db $12, $05 : dw $0003 : db $01 : dw $0BB8
    db !snakes : dw $0B13 : db $0F, $00 : dw $004B : db $00 : dw $0003
    db $0E : dw $0005 : db $01, $00 : dw $0258 : db $00 : dw $021C
    db !mine : dw $0006 : db $06, $00 : dw $0000 : db $06 : dw $0003
    db $01

    db $04
    db !grunt       : dw $02EE : db $11, $05 : dw $0009 : db $05 : dw $0003
    db !mine        : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db $0E : dw $000F : db $02, $00 : dw $0096 : db $00 : dw $021C
    db !mr_shrapnel : dw $001B : db $02, $00 : dw $00F0 : db $04 : dw $05DC
    db !red_cluster : dw $000F : db $01, $00 : dw $021C : db $00 : dw $1518
    db $02

    db $04
    db !laser_orb               : dw $00F0 : db $08, $00 : dw $0018 : db $01 : dw $04B0
    db !purple_red_homing_droid : dw $0023 : db $05, $00 : dw $002D : db $00 : dw $0003
    db !mine : dw $0008 : db $08, $00 : dw $0000 : db $08 : dw $0003
    db !tank        : dw $000A : db $01, $00 : dw $021C : db $01 : dw $012C
    db !mr_shrapnel : dw $000D : db $02, $00 : dw $0003 : db $00 : dw $0E10
    db $01

    db $04
    db $01 : dw $09EC : db $13, $06 : dw $0009 : db $05 : dw $00F0
    db !mine : dw $0003 : db $03, $00 : dw $0000 : db $03 : dw $0003
    db !worm : dw $0002 : db $01, $00 : dw $001E : db $00 : dw $001E
    db $0A : dw $001B : db $02, $00 : dw $021C : db $04 : dw $0A8C
    db !red_cluster : dw $0002 : db $01, $00 : dw $021C : db $00 : dw $189C
    db $01

    db $03
    db $11 : dw $0001 : db $01, $00 : dw $0000 : db $01 : dw $0003
    db !mine : dw $0002 : db $02, $00 : dw $0000 : db $02 : dw $0003
    db !red_cluster : dw $0001 : db $01, $00 : dw $0087 : db $00 : dw $003C
    db $0A : dw $0023 : db $03, $00 : dw $01A4 : db $00 : dw $0BB8
    db $01

    db $02
    db $01 : dw $000F : db $05, $06 : dw $0003 : db $00 : dw $0A8C
    db $16 : dw $000A : db $00, $00 : dw $010E : db $00 : dw $0003
    db $15 : dw $0001 : db $01, $00 : dw $0000 : db $00 : dw $0A6E
    db $00
}

;---------- 0E

{ : org $0ECA95
rng:
    lda !rng_state
    asl
    lda !rng_state
    rol
    adc #$4E
    eor #$3A
    sta !rng_state
    eor !rng_state+1
    adc #$C3
    sta !rng_state+1
    rtl
}
