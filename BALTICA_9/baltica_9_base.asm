AREA_SHIFT equ 0x3600

main:
    MOV SI, AX
    ADD WORD SI, replication
    MOV CL, 0xB
    REP MOVSW
    
    MOV BP, AREA_SHIFT ; сдвиг бомбёжки
    
    
    ; свап сегментов
    PUSH ES
    POP DS
    PUSH CS
    POP ES
    PUSH CS
    POP SS
    
    
    MOV BX, 0x500 ; по BX будут лежать координаты прыжка call far 
    XOR SI, SI 
    
    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
    MOV WORD [BX + 0x2], 0x1000 ; записываем будующий CS
    
    MOV SP, AX 
    ADD WORD SP, 0x300 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, AX
    
    
    MOV AX, 0x1FFF ; чтобы ставить call far
    MOV CL, 0xB
        
    STOSW
    DEC DI

    JMP [BX]

replication:
    REP MOVSW
    SUB [BX], BP
    MOV SP, [BX]
    ADD WORD SP, 0x200
    MOV DI, [BX]
    XOR SI, SI
    MOV CL, 0xB
    STOSW
    DEC DI
    JMP [BX]
