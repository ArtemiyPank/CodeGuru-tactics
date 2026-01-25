_2_BX_SHIFT equ 0x40

    mov bx, _2_BX_SHIFT
    PUSH ES
    POP DS

    jmp [_2_BX_SHIFT]
