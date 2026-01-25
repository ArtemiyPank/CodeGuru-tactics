push cs
pop ss

mov sp, 0x1dff - 2
mov word [0x1dff - 2], 0x1dff

mov ax, es
mov ds, ax
mov [di+2], cs
mov word [di], 0x1dff - 2

callfar:
call word far [di]