VAR_SHIFT_CS equ -0x5
VAR_BOMBING_AREA_SHIFT equ 0x6200
VAR_BOMBING_AREA_SIZE equ 0x500

_1_BX_SHIFT equ 0x40
_2_BX_SHIFT equ 0x60

REP_SIZE equ 0x7

COMP_SP_SHIFT equ VAR_BOMBING_AREA_SHIFT - VAR_BOMBING_AREA_SIZE
COMP_CS_SHIFT equ VAR_SHIFT_CS*0x10
COMP_NEW_CS equ 0x1000 + VAR_SHIFT_CS

;====================================
;       SURVIVOR 1
;====================================
start_surv_1:
zomb_hunting_int87:
    std
    push ES

    ; ES на поле
    push CS
    pop ES

    mov si, ax

    add ax, zomb_1
    mov [0x0], ax ; только у одного 


    mov ax, 0x0ffe
    mov dx, 0xf9eb

    mov cx, 0x24FF ; выбираем тот регистр, который на нуле и по нему прыгаем
    mov bx, cx

    int 0x87


    lea ax, [si + start_surv_2]
    pop ES
    cld


preparation_for_surv2_jmp:
    mov di, _2_BX_SHIFT
    stosw
    sub ax, start_surv_2
    xor di, di

    mov bp, ax ; !!! запоминаем оригинальный ax



main:

    MOV SI, AX
    ADD WORD SI, replicator
    MOV CX, REP_SIZE + 2
    REP MOVSW
    

    MOV BX, _1_BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    
    
    ; свап сегментов
    PUSH ES
    POP DS

main_surv_2:

    add ax, target-COMP_CS_SHIFT      

    MOV [BX], AX ; записываем IP для target
    MOV WORD [BX + 0x2], COMP_NEW_CS ; записываем будующий CS
    call far [bx]
target:
    PUSH CS
    POP ES
    
    POP DX ; пропускаем 2 байта, чтобы добраться до CS, который в стек положил call far
    POP SS
   
    mov ax, bp ; !!! берём оригинальный ax

    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
   
    MOV SP, AX 
    ADD WORD SP, VAR_BOMBING_AREA_SIZE ; сдвигаем на размер облости бомбёжки
    
    
    MOV DI, AX ; выставляем то, куда будем копировать
    
    MOV BP, VAR_BOMBING_AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, COMP_SP_SHIFT ; размер области бомбёжки
        

    MOV CL, REP_SIZE
    
    mov si, jump_destination - replicator
    
    movsw
    DEC DI

    XOR SI, SI 

    JMP [BX]

replicator:
    REP MOVSW
    
    SUB [BX], BP
    SUB SP, DX
    MOV DI, [BX]
    movsw

    DEC DI
    XOR SI, SI
    MOV CL, REP_SIZE
    JMP [bx]


jump_destination:
    call far [bx]



;====================================
;       SURVIVOR 2
;====================================

start_surv_2:
    mov bp, ax ; !!! запоминаем оригинальный ax

    mov ax, [bx]
    sub ax, start_surv_2
    jmp main_surv_2


zomb_1:
    mov si, [0x0]
    lea ax, [si - zomb_1]
    lea bp, [si + VAR_BOMBING_AREA_SIZE] ; !!! запоминаем оригинальный ax
    xor di, di
    jmp main