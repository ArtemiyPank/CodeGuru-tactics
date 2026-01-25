AREA_SHIFT equ 0x6200
AREA_SIZE equ 0x300

BX_SHIFT equ 0x40

SP_SHIFT equ AREA_SHIFT - AREA_SIZE

SHIFT_OFFSET equ 0x10
SHIFT equ SHIFT_OFFSET*0x10
NEW_CS equ 0x1000 + SHIFT_OFFSET


main:
    MOV SI, AX
    ADD WORD SI, replication
    MOV CL, 0x8
    REP MOVSW
    
    MOV BP, AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, SP_SHIFT
    
    
    ; свап сегментов
    mov cx, NEW_CS    
    push cx
 
    add ax, target
    sub ax, SHIFT      
    push ax
    retf

target:
    
    mov cx, 0x1000
    PUSH cx
    xor cx, cx
    
    POP SS
    PUSH ES
    POP DS
    PUSH CS
    POP ES

    
    
    MOV BX, BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    XOR SI, SI 
    
    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
    MOV WORD [BX + 0x2], NEW_CS ; записываем будующий CS
   
    MOV SP, AX 
    ADD WORD SP, 0x300 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, AX
    
    
    MOV AX, 0x1FFF ; чтобы ставить call far
    MOV CL, 0x7
        
    STOSW
    DEC DI

    JMP [BX]

replication:
    REP MOVSW
    
    SUB [BX], BP
    SUB SP, DX
    MOV DI, [BX]
    XOR SI, SI
    MOV CL, 0x7
    STOSW
    DEC DI
    JMP [BX]
