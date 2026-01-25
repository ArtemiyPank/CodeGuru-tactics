BOMBING_AREA_SHIFT equ 0x4200
BOMBING_AREA_SIZE equ 0x1000
DI_SHIFT equ BOMBING_AREA_SHIFT + BOMBING_AREA_SIZE - 0x1

MIN_VALUE_CS equ 0x5b0
REP_SIZE equ 0x14 ;# по факту 0x13, но тогда не попадаем на A5


main:

    ;# по BX будут лежать координаты прыжка call far 
    mov bx, 0xff

    mov cx, REP_SIZE

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
    push ax
    mov sp, ax
    
    ;# SI = 0x0
    xor si, si
    
    
    mov bp, BOMBING_AREA_SHIFT;# BP = BOMBING_AREA_SHIFT
    mov dx, DI_SHIFT;# DX = DI_SHIFT
    
    
    mov di, ax
    
    jmp first_callfar
    
replicator:
    
    
    ;# REP MOVSW 
    rep movsw
    
  first_callfar:
    
    ;# сдвинуть SP
    sub sp, bp

    ;# сдвинуть DI 
    sub di, dx

    ;# подготовить значение CS и запушить в стек
    mov ax, di 

    xor al, al


    mov cl, 0x4
    shr ax, cl

    add ax, MIN_VALUE_CS

    ;# подготовить значение IP и запушить в стек
    mov cx, di
    mov ch, 0xA5

    ;# положить новые значения CS и IP по[BX]
    mov [bx+0x2], ax
    mov [bx], cx

    ;# подготовить куда прыгнуть
    mov ax, 0x1fff
    STOSW

    ;# уменьшить DI, чтобы копировать опкоды сразу после A5
    dec di

    ;# обновить CX для rep
    mov cl, REP_SIZE
    
    ;# SI = 0x0
    xor si, si
    
    ;# сдвинуть CS и IP и прыгнуть на callfar
    call far [bx]
    