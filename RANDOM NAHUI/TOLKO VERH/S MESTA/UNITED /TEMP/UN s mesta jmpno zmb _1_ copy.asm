REP_SIZE equ 0x7


_1_VAR_SHIFT_CS equ 0xA2
_1_VAR_BOMBING_AREA_SIZE equ 0x600
_1_VAR_START_PLACE equ 0x80A1 ; _ _ A 1

_1_BX_SHIFT equ 0x60

_1_COMP_SP_EX_SHIFT_TO_A5 equ 0x0
_1_COMP_SP_SHIFT equ -_1_VAR_BOMBING_AREA_SIZE
_1_COMP_CS_SHIFT equ _1_VAR_SHIFT_CS*0x10
_1_COMP_NEW_CS equ 0x1000 + _1_VAR_SHIFT_CS


_2_VAR_SHIFT_CS equ 0xA5
_2_VAR_BOMBING_AREA_SIZE equ 0x600
_2_VAR_START_PLACE equ 0x80A9 ; _ _ A 9

_2_BX_SHIFT equ 0x40

_2_COMP_SP_EX_SHIFT_TO_A5 equ 0x2
_2_COMP_SP_SHIFT equ -_2_VAR_BOMBING_AREA_SIZE
_2_COMP_CS_SHIFT equ _2_VAR_SHIFT_CS*0x10
_2_COMP_NEW_CS equ 0x1000 + _2_VAR_SHIFT_CS


;====================================
;       SURVIVOR 1
;====================================
start_surv_1:

preperation_for_surv2_jmp:
    mov di, _2_BX_SHIFT
    add ax, start_surv_2
    stosw
    sub ax, start_surv_2
    xor di, di

surv_1_main:
    MOV SI, AX
    ADD WORD SI, replicator
    mov CX, REP_SIZE + 3
    REP MOVSW
    

    MOV BX, _1_BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    
    
    ; свап сегментов
    PUSH ES
    POP DS


    add ax, surv_1_target - _1_COMP_CS_SHIFT      

    MOV [BX], AX ; записываем IP для target
    MOV WORD [BX + 0x2], _1_COMP_NEW_CS ; записываем будующий CS
    call far [bx]
surv_1_target:
    PUSH CS
    POP ES
    
    POP si ; пропускаем 2 байта, чтобы добраться до CS, который в стек положил call far
    POP SS
   
   
    mov ax, _1_VAR_START_PLACE; сдвигаемся на столбец A1
    
    MOV [BX], AX ; записываем будующий IP
   

    
    MOV DI, AX ; выставляем то, куда будем копировать
    
    MOV SP, DI 
    sub WORD SP, _1_VAR_BOMBING_AREA_SIZE - _1_COMP_CS_SHIFT + _1_COMP_SP_EX_SHIFT_TO_A5; сдвигаем на размер облости бомбёжки
    
    MOV DX, _1_COMP_SP_SHIFT; размер области бомбёжки
        

    MOV CL, REP_SIZE
    
    mov si, jump_destination - replicator
    
    movsw
    movsw
    
    sub di, 0x3

    XOR SI, SI 
    
    mov ax, 0x14
    mov bp, 0x3
    JMP [BX]

replicator:
    REP MOVSW
    
    add SP, DX
    
    MOV DI, [BX]
    
    movsw
    movsw
    sub di, bp
    XOR SI, SI
    
    MOV CL, REP_SIZE
    JMP [bx]


jump_destination:
    add sp, ax
    call far [bx]



;====================================
;       SURVIVOR 2
;====================================

start_surv_2:


surv_2_main:
    ;MOV BX, _2_BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    
    ; свап сегментов
    ;PUSH ES
    ;POP DS
    mov ax, [bx]

    add ax, surv_2_target-_2_COMP_CS_SHIFT-start_surv_2      

    MOV [BX], AX ; записываем IP для target
    MOV WORD [BX + 0x2], _2_COMP_NEW_CS ; записываем будующий CS
    call far [bx]
surv_2_target:
    PUSH CS
    POP ES
    
    POP si ; пропускаем 2 байта, чтобы добраться до CS, который в стек положил call far
    POP SS
   

    mov ax, _2_VAR_START_PLACE ; сдвигаемся на столбец A9
    
    MOV [BX], AX ; записываем будующий IP
   

    
    MOV DI, AX ; выставляем то, куда будем копировать
    
    MOV SP, DI 
    sub WORD SP, _2_VAR_BOMBING_AREA_SIZE - _2_COMP_CS_SHIFT + _2_COMP_SP_EX_SHIFT_TO_A5; сдвигаем на размер облости бомбёжки
    

    MOV DX, _2_COMP_SP_SHIFT; размер области бомбёжки
        

    MOV CL, REP_SIZE
    
    mov si, jump_destination - replicator
    
    movsw
    movsw
    
    sub di, 0x3

    XOR SI, SI 
        
    mov ax, 0x14
    mov bp, 0x3
    JMP [BX]


