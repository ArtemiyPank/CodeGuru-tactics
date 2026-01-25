zomb_hunting_int87:
    std
    push ES

    ; ES на поле
    push CS
    pop ES

    add ax, zomb_1
    mov [0x0], ax ; только у одного 


    mov ax, 0x0ffe
    mov dx, 0xf9eb

    mov cx, 0x24FF ; выбираем тот регистр, который на нуле и по нему прыгаем
    mov bx, cx

    int 0x87

    sub ax, zomb_1
    pop ES
    cld
