BOMBING_AREA_SHIFT equ 0xf20

MIN_VALUE_CS equ 0x5b0
REP_SIZE equ 0x14 


main:
    
    ;# сдвиг следующего столбца 
    mov dx, BOMBING_AREA_SHIFT
    
    ;# сдвиг, чтобы получался столбец 
    mov bp,  0xfc

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
    
    ;# сдвинуть SP
    mov sp, di
    sub sp, bp
    dec sp

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
    nop
    
;# для того, чтобы подготовить куда прыгнуть
jump_destination:
    sub sp, bp
    call far [bx]

    