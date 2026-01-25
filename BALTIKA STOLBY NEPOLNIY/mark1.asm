VAR_SHIFT_CS equ 0x3
VAR_BOMBING_AREA_SHIFT equ 0x6200
VAR_BOMBING_AREA_SIZE equ 0x300

BX_SHIFT equ 0x40
REP_SIZE equ 0x9

COMP_SP_SHIFT equ VAR_BOMBING_AREA_SHIFT - (VAR_BOMBING_AREA_SIZE)
COMP_CS_SHIFT equ VAR_SHIFT_CS*0x10
COMP_NEW_CS equ 0x1000 + VAR_SHIFT_CS


main:
    
    MOV SI, AX
    ADD WORD SI, replicator
    mov CX, REP_SIZE + 3
    REP MOVSW
    

    MOV BX, BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    
    
    ; свап сегментов
    PUSH ES
    POP DS


    add ax, target-COMP_CS_SHIFT      

    MOV [BX], AX ; записываем IP для target
    MOV WORD [BX + 0x2], COMP_NEW_CS ; записываем будующий CS
    call far [bx]
target:
    PUSH CS
    POP ES
    
    POP DX ; пропускаем 2 байта, чтобы добраться до CS, который в стек положил call far
    POP SS
   
  
    MOV AL, 0xA1 ; сдвигаемся на столбец A3
    inc ah
    MOV [BX], AX ; записываем будующий IP
   

    
    MOV DI, AX ; выставляем то, куда будем копировать
    
    MOV SP, DI 
    ADD WORD SP, VAR_BOMBING_AREA_SIZE; сдвигаем на размер облости бомбёжки
    add sp, COMP_CS_SHIFT
    
    MOV BP, VAR_BOMBING_AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, COMP_SP_SHIFT ; размер области бомбёжки
        

    MOV CL, REP_SIZE
    
    mov si, jump_destination - replicator
    
    movsw
    movsw
    
    sub di, 0x3

    XOR SI, SI 
        
    mov ax, 0xc
    
    JMP [BX]

replicator:
    REP MOVSW
    
    SUB [BX], BP
    
    SUB SP, DX
    
    MOV DI, [BX]
    nop
    
    movsw
    movsw
    sub di, 0x3
    XOR SI, SI
    
    MOV CL, REP_SIZE
    JMP [bx]


jump_destination:
    sub sp, ax
    call far [bx]
