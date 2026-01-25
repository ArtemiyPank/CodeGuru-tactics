VAR_SHIFT_CS equ -0x0

VAR_BOMBING_AREA_SHIFT equ 0x6200; New Shift
VAR_BOMBING_AREA_SIZE equ 0x300


BX_SHIFT equ 0x40

REP_SIZE equ 0x12    



COMP_CS_SHIFT equ VAR_SHIFT_CS*0x10
COMP_NEW_CS equ 0x1000 + VAR_SHIFT_CS









core:  
    mov si, ax
    ADD SI, replicator
    MOV CL, REP_SIZE + 3
    REP MOVSW
    

    MOV BX, BX_SHIFT ; по BX будут лежать координаты прыжка call far 

    ; свап сегментов
    PUSH ES
    POP DS


    add ax, target - COMP_CS_SHIFT      

    MOV [BX], ax ; записываем IP для target
    
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
    
    MOV [BX], ax ; записываем будующий IP


    MOV SP, ax 
    ADD SP, 0x102 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, ax
    add di, COMP_CS_SHIFT
    


        

    MOV CX, REP_SIZE
    
    mov si, jump_destination - replicator
    
    movsw
    movsw

    DEC DI

    XOR SI, SI 
    mov bp, 0x0104
    MOV ax, VAR_BOMBING_AREA_SHIFT ; сдвиг бомбёжки
    
    JMP [BX]


replicator:
    REP MOVSW
    inc word[bx+0x2]
        

    mov dx, cs
    cmp dl, dh
    jb skip
        
    sub word[bx+0x2], 0x10
    sub di, 0x100
            
        
        
skip:    

    add di, -(REP_SIZE+2)*2-1+0x10
    sub di, ax


    lea sp, [di+bp+0x2]
    
    sub [bx], ax
    movsw
    movsw

    DEC DI
    XOR SI, SI
    MOV CL, REP_SIZE
    call far[bx]


jump_destination:
    add sp, bp
    call far [bx]