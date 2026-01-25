mov si, ax
add si, zombie
mov cl, 43

rep movsw

push es
push cs
pop es
pop ds
xor si, si
mov cl, 43
mov di, 0x8080
rep movsw

mov si, ax
mov ax, 0xca89
mov dx, 0xce01
mov bx, 0xe3ff
nop
int 0x87 ;меняем байты для нашего прыжка

push cs
pop ds

inc byte[0x8080]
mov di, 0x8080 + 84
jmp di

zombie:
    db 0x8a
    db 0x07


start:
    ;ИНИЦИАЛИЗАЦИЯ ==================
    
    mov bx, 1       
 
    ; (Раньше здесь было -1, а в BX было -256. Мы просто поменяли их суть)
    mov bp, -256    
    
    ; Глубина рекурсии
    mov cl, 6       
    
    ; DX управляет поворотом (+ = Right, - = Left)
    mov dx, 1       
    
    mov di, 8000h   

    stosw
    call Univ
    ret

;УНИВЕРСАЛЬНАЯ РЕКУРСИЯ (без изменений) ===
Univ:
    push cx
    dec cl
    js PopRet
    
    ; Секция 1 (Logic B)
    neg dx          ; Left logic
    call TurnSeq    
    
    ; Секция 2 (Logic A)
    neg dx          ; Right logic
    call TurnSeq    
    
    ; Секция 3 (A)
    call Univ
    
    ; Секция 4 (+ F)
    call Turn
    call Draw
    
    ; Секция 5 (B)
    neg dx          ; Left logic
    call Univ
    
    ; Восстановление (-)
    call Turn
    neg dx          
    
PopRet:
    pop cx
    ret

; === ХЕЛПЕР ===
TurnSeq:
    call Turn
    call Univ
    ; Fallthrough

; === РИСОВАНИЕ ===
Draw:
    mov [di], al
    add di, bx
    mov [di], al
    add di, bx
    ret

; === ПОВОРОТ ===
Turn:
    xchg bx, bp
    test dx, dx     
    js T_Left       
    
    neg bx          ; Right turn logic
    ret
T_Left:
    neg bp          ; Left turn logic
    ret

jmp $