_2_BX_SHIFT equ 0x60

jmp zomb_hunting_int87
musor:
    ;waqef
    ;qwfwqfe
    ;qwefqw
    ;wfewefw
    ;waef
    ;waqefawq

zomb_hunting_int87:

    PUSH ES
    POP DS

    mov bx, _2_BX_SHIFT
    
    jmp [_2_BX_SHIFT]
