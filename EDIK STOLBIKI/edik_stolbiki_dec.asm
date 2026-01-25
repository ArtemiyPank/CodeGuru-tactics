VAR_SHIFT_CS equ -0x0

VAR_BOMBING_AREA_SHIFT equ 0x6200; New Shift
VAR_BOMBING_AREA_SIZE equ 0x300


BX_SHIFT_1 equ 0x40

REP_SIZE equ 0xC

COMP_SP_SHIFT equ VAR_BOMBING_AREA_SHIFT - VAR_BOMBING_AREA_SIZE


COMP_CS_SHIFT equ VAR_SHIFT_CS*0x10
COMP_NEW_CS equ 0x1000 + VAR_SHIFT_CS









core:  
    mov si, ax
    ADD SI, replicator
    MOV CL, REP_SIZE + 3
    REP MOVSW
    

    MOV BX, BX_SHIFT_1 ; по BX будут лежать координаты прыжка call far 
    MOV BP, VAR_BOMBING_AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, VAR_BOMBING_AREA_SIZE ; размер области бомбёжки

    ; свап сегментов
    PUSH ES
    POP DS


    add ax, target - COMP_CS_SHIFT      

    MOV [BX], AX ; записываем IP для target
    
    MOV WORD [BX + 0x2], COMP_NEW_CS ; записываем будующий CS
    call far [bx]


target:

    mov CX, 0x1000
    push cx
    pop es
    
    POP CX ; пропускаем 2 байта, чтобы добраться до CS, который в стек положил call far
    POP SS
   
    
    MOV AL, 0xA1 ; сдвигаемся на столбец A3
    MOV AH, 0x03 ; сдвигаемся на столбец A3
    
    MOV [BX], AX ; записываем будующий IP


    MOV SP, AX 
    ADD SP, 0x102 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, AX
    add di, COMP_CS_SHIFT
    


        

    MOV CX, REP_SIZE
    
    mov si, jump_destination - replicator
    
    movsw
    movsw

    DEC DI

    XOR SI, SI 
    mov ax, 0x0104
    mov dx, 0x010
    
    JMP [BX]


replicator:
    REP MOVSW
    dec word[bx+0x2]
    
    sub di,(REP_SIZE+3)*4+1-0x10
    sub di, bp

    
    
    mov sp, di
    add sp, dx
    
    sub [bx], bp
    movsw
    nop
    movsw

    DEC DI
    XOR SI, SI
    MOV CL, REP_SIZE
    call far[bx]


jump_destination:
    add sp, ax
    call far [bx]