lorom


;smash tv defines
{
    !rng_state        = $05A8
    !current_circuit  = $05AB
    !current_arena    = $05AC
    !item_drop_timer  = $05AE
    !money_drop_timer = $05AF
    !room_complete    = $05D3
    !room_exit_timer  = $05D4 ;time until opening doors, then until homing blades spawn upon completing a room

    !enemy_counter = $06C6

    !x_pos_list = $0B46
    !y_pos_list = $0C9C

    !item_timer_list = $134A
}


;enemy types
{
    !grunt = $01
    !wall_gunner = $02
    !tank = $08
    !mr_shrapnel = $0A
    !mine = $0F

    ; 3 = worm
    ; 4 = big red flying enemy (arena 2)
    ; 5 = snakes
    ; 6 = snake man
    ; 7 = laser orb
    ; 9 = red cluster
    ; B = blue worm, single segment
    ; C = purple/red homing thing
}


;---------- 00


{ : org $00C1CE ;C1CE - C249
    ;load level data
}


{ : org $00DD0A ;DD0A - DD29
spawn_item_pos: ;x/y offsets for item drops
    db $64, $6C, $74, $7C, $84, $2C, $34, $3C
    db $44, $4C, $54, $5C, $64, $6C, $74, $7C
    db $84, $8C, $94, $9C, $A4, $AC, $B4, $BC
    db $C4, $CC, $D4, $84, $7C, $84, $8C, $94
}


;---------- 02


{ : org $02B5F0 ;B5F0 - ?
level_data:
    dw .circuit1, .circuit2, .circuit3

;-----

.circuit1:
    dw $0000, .arena_1, .collect_powerups, $B6AE, $B6D8, $B70C, $B740, $B774, $B7A8, $B7E6, $B81A, $B844
.circuit2:
    dw $0000, $B85A, $B866, $B87C, $B8A6, $B8D0, $B90E, $B938, $B94E, $B96E, $B98E, $B9A4
    dw $B9BA, $B9E4, $BA04, $BA42, $BA62, $BAA0, $BAAC
.circuit3:
    dw $0000, $BAE0, $BB0A, $BB3E, $BB72, $BB92, $BBA8, $BBD2, $BBDE, $BBFE, $BC28, $BC3E
    dw $BC5E, $BC9C, $BCDA, $BD0E, $BD38, $BD58, $BD82, $BDB6, $BDEA, $BE1E, $BE48, $BDEA

;-----

.arena_1:
    db $01    ;enemy list count

    db !grunt ;type
    dw $0064  ;count
    db $09    ;active spawn limit
    db $00    ;setting this above 0 spawns purple guys
    dw $0012  ;timer before next wave is allowed to spawn
    db $04    ;enemies already spawned on entering room
    dw $005A  ;timer before spawning

    dw !tank
    dw $0005
    db $01
    db $00
    dw $010E
    db $00
    dw $0F78

    db $01    ;?

.B67A: ;unused?
    db $04
    
    db !grunt
    dw $012C
    db $0A
    db $02
    dw $0018
    db $10
    dw $0003

    db !mr_shrapnel
    dw $000F
    db $02
    db $00
    dw $010E
    db $02
    dw $005A

    db !mine
    dw $0005
    db $04
    db $00
    dw $0000
    db $05
    dw $0003
    
    db !wall_gunner
    dw $0001
    db $01
    db $00
    dw $0000
    db $01
    dw $0003
    
    db !tank
    dw $0005
    db $01
    db $00
    dw $010E
    db $00
    dw $1428
    
    db $02

.collect_powerups:
    db $03

    db !grunt
    dw $00C3
    db $0A
    db $01
    dw $0003
    db $00
    dw $0003

    db !mr_shrapnel
    dw $0006
    db $02
    db $00
    dw $01E0
    db $00
    dw $0096
    
    db !mine
    dw $0003
    db $03
    db $00
    dw $0000
    db $03
    dw $0003

    db !tank
    dw $0005
    db $01
    db $00
    dw $01A4
    db $00
    dw $10A4

    db $02
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
