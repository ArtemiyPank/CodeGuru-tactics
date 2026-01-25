REAL_START_ROW equ 0x0

REAL_REPLICATOR_LINE_SHIFT equ 0x4
REAL_BOMBING_ROW_SHIFT equ 0x6

BX_SHIFT equ 0x40
REP_SIZE equ 0x17 


COMP_MIN_CS_VALUE equ 0x5b0
COMP_SHIFT_BY_ONE_LINE equ 0x104

COMP_REPLICATOR_LINE_SHIFT equ 0xfc + 0x100 * (REAL_BOMBING_ROW_SHIFT-12)
COMP_BOMBING_AREA_SHIFT equ COMP_REPLICATOR_LINE_SHIFT - REP_SIZE*2 + 5 + REAL_REPLICATOR_LINE_SHIFT

COMP_START_ROW equ REAL_START_ROW + 0x1

main:
    
    ;# сдвиг следующего столбца 
    mov dx, COMP_BOMBING_AREA_SHIFT
    
    ;# сдвиг, чтобы получался столбец 
    mov bp,  COMP_SHIFT_BY_ONE_LINE

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
    

    mov al, COMP_START_ROW
    mov di, ax    
    
    jmp start_from_given_row
    
replicator:
    
    
    ;# REP MOVSW 
    rep movsw
    
    
    ;# сдвинуть DI 
    add di, dx

start_from_given_row:

    ;# перепрыгнуть через границу, если находимся к ней слишком близко
    mov ax, di 

    cmp al, 0xF7
    jb  without_mask      ; прыжок, если al < 0xF7
    add ax, 0xA
    mov di, ax

without_mask:  



    ;# подготовить значение CS
    xor al, al

    mov cl, 0x4
    shr ax, cl

    add ax, COMP_MIN_CS_VALUE

    ;# подготовить значение IP
    mov cx, di
    mov ch, 0xA5

    ;# положить новые значения CS и IP по[BX]
    mov [bx+0x2], ax
    mov [bx], cx

    ;# сдвинуть SP    
    lea sp, [di + bp-1]

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

    