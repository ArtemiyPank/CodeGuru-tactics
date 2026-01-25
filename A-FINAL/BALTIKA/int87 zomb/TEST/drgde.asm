_2_BX_SHIFT equ 0x60

jmp zomb_hunting_int87
musor:

    std
    push ES

    ; ES на поле
    push CS
    pop ES



    mov ax, 0x8907
    mov dx, 0xd3c2

    mov bx, 0xCB8C
    mov cx, 0x27FF;

    int 0x87
    xor cx, cx
    cld

    mov bx, _2_BX_SHIFT
    POP DS

    nop
    nop

    jmp [_2_BX_SHIFT]
    
    std
    push ES

    ; ES на поле
    push CS
    pop ES



    mov ax, 0x8907
    mov dx, 0xd3c2

    mov bx, 0xCB8C
    mov cx, 0x27FF;

    int 0x87
    xor cx, cx
    cld

    mov bx, _2_BX_SHIFT
    POP DS

    nop
    nop

    jmp [_2_BX_SHIFT]

zomb_hunting_int87:

    

    std
    push ES

    ; ES на поле
    push CS
    pop ES



    mov ax, 0x8907
    mov dx, 0xd3c2

    mov bx, 0xCB8C
    mov cx, 0x27FF;

    int 0x87
    xor cx, cx
    cld

    mov bx, _2_BX_SHIFT
    POP DS

    nop
    nop
    nop
    jmp [_2_BX_SHIFT]



    std
    push ES

    ; ES на поле
    push CS
    pop ES



    mov ax, 0x8907
    mov dx, 0xd3c2

    mov bx, 0xCB8C
    mov cx, 0x27FF;

    int 0x87
    xor cx, cx
    cld

    mov bx, _2_BX_SHIFT
    POP DS

    nop
    nop

    jmp [_2_BX_SHIFT]
    
    
    std
    push ES

    ; ES на поле
    push CS
    pop ES



    mov ax, 0x8907
    mov dx, 0xd3c2

    mov bx, 0xCB8C
    mov cx, 0x27FF;

    int 0x87
    xor cx, cx
    cld

    mov bx, _2_BX_SHIFT
    POP DS

    nop
    nop

    jmp [_2_BX_SHIFT]