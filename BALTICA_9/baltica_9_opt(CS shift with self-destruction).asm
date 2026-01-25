VAR_SHIFT_CS equ 0x3
VAR_BOMBING_AREA_SHIFT equ 0x6200
VAR_BOMBING_AREA_SIZE equ 0x300

BX_SHIFT equ 0x40
REP_SIZE equ 0x9

COMP_SP_SHIFT equ VAR_BOMBING_AREA_SHIFT - VAR_BOMBING_AREA_SIZE
COMP_CS_SHIFT equ VAR_SHIFT_CS*0x10
COMP_NEW_CS equ 0x1000 + VAR_SHIFT_CS


main:

    MOV SI, AX
    ADD WORD SI, replication
    MOV CL, REP_SIZE+2
    REP MOVSW
    
    MOV BP, VAR_BOMBING_AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, COMP_SP_SHIFT
    MOV BX, BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    
    
    ; свап сегментов
    PUSH ES
    POP DS

    PUSH CS
    POP ES

    add ax, target-COMP_CS_SHIFT      

    MOV [BX], AX ; записываем IP для target
    MOV WORD [BX + 0x2], COMP_NEW_CS ; записываем будующий CS
    call far [bx]
target:


    PUSH CS
    POP SS
    
    
    
    XOR SI, SI 
    
    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
   
    MOV SP, AX 
    ADD WORD SP, VAR_BOMBING_AREA_SIZE ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, AX
    
    
    MOV AX, 0x1FFF ; ; чтобы первый раз поставить call far
    MOV CL, REP_SIZE
        
    STOSW
    DEC DI

    MOV AX, 0x3 ; кол-во итераций репликации до смерти


    JMP [BX]

replication:
    REP MOVSW
    
    SUB [BX], BP
    SUB SP, DX
    MOV DI, [BX]
    movsw
    
    dec ax
    jz hui
    DEC DI
    XOR SI, SI
    MOV CL, REP_SIZE
    JMP [bx]
    nop

jump_destination:
    call far [bx]
hui: