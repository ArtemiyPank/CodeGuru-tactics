mov si, ax

lea bp, [si + zomb]
xor ax, ax
nop ; -
nop ; -
; --- 6
mov dx, [0x1243]
; --- 6
push es
push cs
pop es

mov bx, 0x10e1
div bx

mov di, ax
mov [0x0], bp

mov ax, 0x24FF
mov dx, 0x24FF

INT 0x86


jmp $
zomb:
jmp $
