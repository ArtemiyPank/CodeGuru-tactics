; балтика + зомби 1

AREA_SHIFT equ 0x6200
AREA_SIZE equ 0x300

BX_SHIFT equ 0x40

SP_SHIFT equ AREA_SHIFT - AREA_SIZE

SHIFT_OFFSET equ -0xa
SHIFT equ SHIFT_OFFSET*0x10
NEW_CS equ 0x1000 + SHIFT_OFFSET



ZOMB_AREA_SHIFT equ 0x3100
ZOMB_AREA_SIZE equ 0x300

ZOMB_BX_SHIFT equ 0x40

ZOMB_SP_SHIFT equ ZOMB_AREA_SHIFT - ZOMB_AREA_SIZE

ZOMB_SHIFT_OFFSET equ 0x3
ZOMB_SHIFT equ ZOMB_SHIFT_OFFSET*0x10
ZOMB_NEW_CS equ 0x1000 + ZOMB_SHIFT_OFFSET

ZOMB_COUNT_UNTIL_DEATH equ 0x50

jmp main

ZOMB_cod:
    mainZ:
        mov ax, [di]
        MOV SI, AX
        ADD WORD SI, replicationZOMB-0x2
        MOV CL, 0xc
        REP MOVSW
    
        MOV BP, ZOMB_AREA_SHIFT ; сдвиг бомбёжки
        MOV DX, ZOMB_SP_SHIFT
    
    

        PUSH ds
        POP SS

        PUSH ES
        POP DS

        ; свап сегментов
        MOV BX, ZOMB_BX_SHIFT ; по BX будут лежать координаты прыжка call far 

        MOV WORD [BX + 0x2], ZOMB_NEW_CS ; записываем будующий CS 

        add ax, targetZ - ZOMB_SHIFT - 0x2
        MOV [BX], AX 
        nop;---------------39
        call far [BX]

    targetZ:

        PUSH CS
        POP ES
        
        XOR SI, SI 
    
        add ah, 0x6
        MOV AL, 0xA3 ; сдвигаемся на столбец A3
        MOV [BX], AX ; записываем будующий IP
   
        MOV SP, AX 
        ADD WORD SP, 0x300 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
        MOV DI, AX
    
    
        MOV AX, 0x1FFF ; ; чтобы первый раз поставить call far
        MOV CL, 0xa
        
        STOSW
        DEC DI

        MOV AX, ZOMB_COUNT_UNTIL_DEATH ; кол-во итераций репликации до смерти


        JMP [BX]
nop
nop
nop
nop
nop
nop
nop
nop;----------39
    replicationZOMB:
        REP MOVSW
    
        SUB [BX], BP
        SUB SP, DX
        MOV DI, [BX]
        movsw
    
        dec ax
        DEC DI
        XOR SI, SI
        MOV CL, 0xa
        cmp ax, 0
        JZ hui
        JMP [bx]
     hui:
    call far [bx]
;end of the ZOMB


main:
    getZOMB:
        mov si, ax
        push es
        mov ax, 0x0000
        mov dx, [0x1243]
        mov bx, 0x10e1
        push cs
        nop;-------39
        pop es
        div bx
        
        add si, 0x2
        
        mov word[0x0], si
        mov di, ax
        mov ax, 0x25FF
        mov dx, 0x25FF

        INT 0x86
        pop es
        
    our_main:
    sub si, 0x2
    xor di, di
    MOV ax, si
    
    MOV BP, AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, SP_SHIFT
    
      
    ; свап сегментов
    MOV BX, BX_SHIFT ; по BX будут лежать координаты прыжка call far 
    PUSH ES
    nop;--------39
    POP DS

    PUSH CS
    POP SS

    add ax, target-SHIFT      

    MOV [BX], AX ; записываем target для IP
    MOV WORD [BX + 0x2], NEW_CS ; записываем будующий CS
    call far [bx]
target:
    PUSH CS
    POP ES
    
    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
   
    
    XOR SI, SI 
    
    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
   
    MOV SP, AX 
    ADD WORD SP, 0x300 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, AX
    
    
    MOV AX, 0x1FFF ; чтобы ставить call far
    nop;-------39
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
    PUSH ES
POP DS
PUSH CS
POP ES
PUSH ES
POP DS
PUSH CS
POP SS
PUSH ES
POP DS
PUSH CS
POP ES
PUSH ES
POP DS
PUSH CS
POP SS
nop;------39
PUSH ES
POP DS
PUSH CS
POP ES
PUSH ES
POP DS
PUSH CS
POP SS
PUSH ES
POP DS
PUSH CS
POP SS
PUSH CS
POP ES
PUSH CS
POP ES
PUSH ES
POP DS
PUSH CS
POP SS
PUSH CS
POP ES
PUSH CS
POP SS
PUSH ES
POP DS
PUSH CS
POP SS
PUSH ES
POP DS
PUSH CS
POP ES
PUSH CS
POP SS
PUSH CS
POP ES
PUSH ES
POP DS