REAL_BOMBING_COLUMN_SHIFT equ 0x62
REAL_BOMBING_ROW_SHIFT equ 0x1 ; сдвиг по возможным столбам

REP_SIZE equ 0x12

COMP_CS_SHIFT equ REAL_BOMBING_COLUMN_SHIFT*0x10+REAL_BOMBING_ROW_SHIFT
COMP_IP_SHIFT equ COMP_CS_SHIFT*0x10


main:
    
    ;# сдвиг, чтобы получался столбец 
    mov bp,  0x104

    ;# по BX будут лежать координаты прыжка call far 
    mov bx, 0x40



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
    mov sp, 0xF4A1
    
    ;# SI = 0x0
    ;mov si, jump_destination - replicator
    xor si, si

    mov di, 0xA5EF
    
    ;movsw
    mov ax, 0xA5F3

    stosw
    ;xor si, si
    mov cx, REP_SIZE

    mov ax, 0xA5EF
    mov [bx], ax

    mov ax, ss
    nop
    mov [bx+0x2], ax

    call far [bx]

    
replicator:
    ;# сдвинуть DI
    add di, COMP_IP_SHIFT-(REP_SIZE+1)*2

    add ax, COMP_CS_SHIFT

    CMP ax, 0x15a1 ; 1000−A5F
    jb skip
    sub ax, 0x1000

skip:
    ;# сдвинуть SP
    mov sp, di
    add sp, 0x104

    mov [bx+0x2], ax



    ;# подготовить куда прыгнуть 
    movsw
    movsw

    ;# уменьшить DI, чтобы копировать опкоды сразу после A5
    sub di, 0x2

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

    