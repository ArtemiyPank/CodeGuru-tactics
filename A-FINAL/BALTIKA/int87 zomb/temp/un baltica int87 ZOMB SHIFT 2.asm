_2_BX_SHIFT equ 0x60

jmp zomb_hunting_int87
musor:
    ;waqef
    ;qwfwqfe
    ;qwefqw
    ;wfewefw
    ;waef
    ;waqefawq

zomb_hunting_int87:
    mov word [0x0], 0x1234 ; тригернули 
    

    std
    push ES

    ; ES на поле
    push CS
    pop ES



    mov ax, 0x0ffe
    mov dx, 0xf9eb

    mov cx, 0x24FF ; выбираем тот регистр, который на нуле и по нему прыгаем
    mov bx, cx

    int 0x87
    xor cx, cx
    cld

    mov bx, _2_BX_SHIFT
    POP DS

    nop
    nop

    jmp [_2_BX_SHIFT]
