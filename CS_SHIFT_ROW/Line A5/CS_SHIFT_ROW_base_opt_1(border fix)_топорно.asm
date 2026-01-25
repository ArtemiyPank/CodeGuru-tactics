REP_SIZE equ 0x14 
BOMBING_AREA_LINE_SHIFT equ 0x20
BOMBING_AREA_ROW_SHIFT equ 0x10


COMP_LAST_BYTE_ZERO_MASK equ 0xFFF8
COMP_MIN_VALUE_CS equ 0x5b0
COMP_BOMBING_AREA_SHIFT equ -(REP_SIZE+1)*2 + 0x100*BOMBING_AREA_LINE_SHIFT + BOMBING_AREA_ROW_SHIFT


main:
    
    ;# сдвиг следующего столбца 
    mov dx, COMP_BOMBING_AREA_SHIFT
    
    ;# сдвиг, чтобы получался столбец 
    mov bp,  0x104

    ;# по BX будут лежать координаты прыжка call far 
    mov bx, 0xff



    ;# для определения длины репликации
    mov cx, REP_SIZE + 0x3

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
    
    mov di, ax
    
    jmp first_callfar
    
replicator:
    
    
    ;# REP MOVSW 
    rep movsw
    
  first_callfar:
    
    ;# сдвинуть DI 
    add di, dx
    
    and di, COMP_LAST_BYTE_ZERO_MASK
    
    ;# сдвинуть SP
    lea sp, [di + bp-1]


    ;# подготовить значение CS и запушить в стек
    mov ax, di 

    xor al, al


    mov cl, 0x4
    shr ax, cl

    add ax, COMP_MIN_VALUE_CS

    ;# подготовить значение IP и запушить в стек
    mov cx, di
    mov ch, 0xA5

    ;# положить новые значения CS и IP по[BX]
    mov [bx+0x2], ax
    mov [bx], cx

    ;# подготовить куда прыгнуть 
    movsw
    movsw

    ;# уменьшить DI, чтобы копировать опкоды сразу после A5
    sub di, 0x3

    ;# обновить CX для rep
    mov cx, REP_SIZE
    
    ;# SI = 0x0
    xor si, si
    
    ;# сдвинуть CS и IP и прыгнуть на callfar
    call far [bx]

    
;# для того, чтобы подготовить куда прыгнуть
jump_destination:
    add sp, bp
    call far [bx]

    