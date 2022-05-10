lorom


;final fight defines
{
    !rng_slot = $0109
    !rng_state = $010A
    !frame_counter = $0CB4
}


;---------- 00


{ : org $00B0E1 ;B0E1 - B133
get_rng:
    phx
    lda #$00
    xba
    lda !rng_slot : inc : and #$03 : sta !rng_slot
    tax
    lda !rng_state,X : adc #$13 : sta !rng_state,X ;carry bit status unknown here
    plx
    rtl

update_rng:
    lda !rng_state+0 : adc #$01 : sta !rng_state+0 ;carry bit status unknown here
    lda !rng_state+1 : adc #$03 : sta !rng_state+1
    lda !rng_state+2 : adc #$05 : sta !rng_state+2
    lda !rng_state+3 : adc #$07 : sta !rng_state+3
    lda !frame_counter
    bne .B133

    lda !rng_state+3
    adc !rng_state+2 : sta !rng_state+2
    adc !rng_state+1 : sta !rng_state+1
    adc !rng_state+0 : sta !rng_state+0
.B133:
    rtl
}