nop

push ds
pop es
mov bx, ax
add word bx, 0x3
xlatb
xchg ah, al
xlatb
mov di, 0x2612

rep_stosw:
    stosw
    add word di, 0xFFE
jmp rep_stosw
