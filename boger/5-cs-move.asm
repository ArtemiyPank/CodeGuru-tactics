%define add_to_cs 20

push cs
pop ss

mov sp, 0x1dff - 2 + add_to_cs * 16
mov word [0x1dff - 2 + add_to_cs * 16], 0x1dff

mov ax, es
mov ds, ax
mov bx, cs
add bx, add_to_cs
mov [di+2], bx
mov word [di], 0x1dff - 2

callfar:
call word far [di]