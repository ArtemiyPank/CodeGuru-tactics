nop
inc cx

loopStart:
    ADD WORD BX, 0x10E1
    MUL WORD BX
    MOV [0x1243], DX
    INC CX
    XCHG BX, AX
    loop loopStart