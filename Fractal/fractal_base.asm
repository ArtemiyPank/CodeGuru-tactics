org 100h

start:
    push ds
    pop es

    mov ax, -256
    mov dx, 256


    mov di, 0x8000
    stosw

    ; Начальное направление: вправо (так как старт с середины, а кривая растет)
    mov bx, 1        
    
    ; Глубина рекурсии (порядок кривой)
    mov cl, 6           

    ; Запускаем
    call hilbert_a

    stosw  
    ret              ; Завершение


hilbert_a:
    dec cl     
    jl end_rec          
    
    push cx    

    call turn_left      
    call hilbert_b 
         
    call draw_f 

    call turn_right     
    call hilbert_a    
      
    call draw_f         
    
    call hilbert_a     
    call turn_right  
       
    call draw_f         
    
    call hilbert_b      
    call turn_left      

    pop cx
    inc cl
    ret


hilbert_b:
    dec cl
    jl end_rec
    
    push cx
    
    call turn_right     
    call hilbert_a   
      
    call draw_f         
    
    call turn_left      
    call hilbert_b   
       
    call draw_f         
    
    call hilbert_b      
    call turn_left   
       
    call draw_f         
    
    call hilbert_a     
    call turn_right     
    
    pop cx
    inc cl
    ret

end_rec:
    inc cl
    ret

; =================================================================
; РИСОВАНИЕ ЛИНИИ (F)
; =================================================================
draw_f:
    push cx             ; Сохраняем CX (счетчик рекурсии)

    mov cl, 2           ; Нам нужно закрасить 3 "клетки"
draw_loop:
    mov [di], al ; Ставим "пиксель" (цвет/код)
    add di, bx          ; Сдвигаемся на 1 шаг в текущем направлении
    loop draw_loop      ; Повторяем 3 раза
    
    pop cx              ; Восстанавливаем CX
    ret



; =================================================================
; ЛОГИКА ПОВОРОТОВ
; Мы меняем значение в BX между: 1, 256, -1, -256
; =================================================================

; Поворот НАПРАВО (+90 градусов):
; Вверх (-256) -> Право (1)
; Право (1)    -> Вниз (256)
; Вниз (256)   -> Лево (-1)
; Лево (-1)    -> Вверх (-256)
turn_right:
    cmp bx, ax
    je .to_right
    cmp bx, 1
    je .to_down
    
    cmp bx, dx
    je .to_left
    ; иначе было -1, стало быть вверх
.to_top:
    mov bx, ax
    ret
.to_right:
    mov bx, 1
    ret
.to_down:
    mov bx, dx
    ret
.to_left:
    mov bx, -1
    ret

; Поворот НАЛЕВО (-90 градусов):
; Обратный порядок
turn_left:
    cmp bx, ax
    je .to_left
    cmp bx, -1
    je .to_down
    cmp bx, dx
    je .to_right
    ; иначе было 1, стало быть вверх
.to_top:
    mov bx, ax
    ret
.to_left:
    mov bx, -1
    ret
.to_down:
    mov bx, dx
    ret
.to_right:
    mov bx, 1
    ret