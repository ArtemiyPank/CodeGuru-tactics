BOMBING_AREA_SHIFT equ 0x61f0
BOMBING_AREA_SIZE equ 0x300 - 0x1

DI_SHIFT equ BOMBING_AREA_SHIFT + BOMBING_AREA_SIZE - 0x1
LAST_BYTE_ZERO_MASK equ 0xFFF0
MIN_VALUE_CS equ 0x5b0
REP_SIZE equ 0x14


main:

    ;# по BX будут лежать координаты прыжка call far 
    mov bx, 0x40

    mov cx, REP_SIZE + 0x3 ;# REP_SIZE + сдвиг, чтобы щаписать call far

    mov si, ax
    add si, replicator
    rep movsw

    ;# хуячим ES и SS на поле, a DS туда, где был ES
    push cs
    push es
    push cs

    pop es
    pop ds
    pop ss

    ;# перемещаем SP
    mov sp, ax
    
    ;# SI = 0x0
    mov si, jump_destination - replicator
    
    mov bp, BOMBING_AREA_SIZE;# BP = BOMBING_AREA_SIZE
    mov dx, DI_SHIFT;# DX = DI_SHIFT
    
    
    mov di, ax
    and al, 0xF0
    
    
    
    jmp first_callfar
    
replicator:
   
    ;# REP MOVSW 
    rep movsw
    
  first_callfar:
    

    ;# сдвинуть DI 
    sub di, dx
    and di, LAST_BYTE_ZERO_MASK    
    
    ;# сдвинуть SP
    mov sp, di
    add sp, bp

    ;# подготовить значение CS
    mov ax, di 

    xor al, al


    mov cl, 0x4
    shr ax, cl

    add ax, MIN_VALUE_CS
    mov [bx+0x2], ax

    ;# подготовить значение IP
    
    mov [bx], di
    mov byte [bx + 1], 0xa5
    
    ;# подготовить куда прыгнуть
    movsw

    ;# уменьшить DI, чтобы копировать опкоды сразу после A5
    dec di

    ;# обновить CX для rep
    mov cl, REP_SIZE
    
    ;# SI = 0x0
    xor si, si
    
    ;# сдвинуть CS и IP и прыгнуть на callfar
    call far [bx]
nop
nop
nop

    
;# для того, чтобы подготовить куда прыгнуть

jump_destination:
    call far [bx]
    