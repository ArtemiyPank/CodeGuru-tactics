start:
    push ds
    pop es
         
    inc bp ; mov bp, 1
    
    mov bx, -256    
    
    ; Глубина рекурсии
    mov cl, 6       
    
    ; si управляет поворотом (+ = Right, - = Left) 
    inc si ; mov si, 1
    
    ; Центр экрана 
    mov di, 8000h   

    stosw
    call Univ
    ret

Univ:
    push cx
    dec cl
    js PopRet
    
    ; Секция 1 (B)
    neg si  
    call TurnSeq    
    
    ; Секция 2 (A)
    neg si  
    call TurnSeq    
    
    ; Секция 3 (A)
    call Univ
    
    ; Секция 4 (+ F)
    call Turn
    call Draw
    
    ; Секция 5 (B)
    neg si
    call Univ
    
    ; Восстановление (-)
    call Turn
    neg si          
    
PopRet:
    pop cx
    ret

TurnSeq:
    call Turn
    call Univ
    ; Fallthrough

Draw:
    mov [di], al
    add di, bp
    mov [di], al
    add di, bp
    ret

Turn:
    xchg bp, bx
    test si, si     
    js T_Left       
    
    neg bp          ; Right turn logic
    ret
T_Left:
    neg bx          ; Left turn logic
    ret