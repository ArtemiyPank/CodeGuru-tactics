start:
    push ds
    pop es
    
    mov bx, 1       
 
    mov bp, -256    
    
    ; Глубина рекурсии
    mov cl, 6       
    
    ; DX управляет поворотом (+ = Right, - = Left)
    mov dx, 1       
    
    ; Центр экрана (можно сдвинуть, если узор уходит за край, 
    mov di, 8000h   

    stosw
    call Univ
    ret

Univ:
    push cx
    dec cl
    js PopRet
    
    ; Секция 1 (B)
    neg dx  
    call TurnSeq    
    
    ; Секция 2 (A)
    neg dx  
    call TurnSeq    
    
    ; Секция 3 (A)
    call Univ
    
    ; Секция 4 (+ F)
    call Turn
    call Draw
    
    ; Секция 5 (B)
    neg dx
    call Univ
    
    ; Восстановление (-)
    call Turn
    neg dx          
    
PopRet:
    pop cx
    ret

TurnSeq:
    call Turn
    call Univ
    ; Fallthrough

Draw:
    mov [di], al
    add di, bx
    mov [di], al
    add di, bx
    ret

Turn:
    xchg bx, bp
    test dx, dx     
    js T_Left       
    
    neg bx          ; Right turn logic
    ret
T_Left:
    neg bp          ; Left turn logic
    ret