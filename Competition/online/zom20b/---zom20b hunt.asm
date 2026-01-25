; 10, 30, 14, 18, 26, 29, 2a, 2e, 34, 


; Вход: AH = Исходное значение
; Выход: AH = Результат
push es

push cs
pop es

mov [0x0], word 0xFEEB ; то, куда будет прыгать зомби

mov si, ax
mov di, ax
xor ax, ax
nop
nop
nop
mov ah, [0x2612]
;mov AH, 0xFB



TRANSFORM_BYTE:

    MOV DL, AH ; Сохраняем копию исходного индекса в DL

    ; --- 1. Обработка старшего полубайта ---
    MOV BL, DL
    
    mov cl, 0x4
    SHR BX, cl ; Сдвигаем вправо, получаем 0..15 (индекс строки)
    
    add bx, si
    MOV AH, byte [BX + HIGH_NIBS] ; Получаем базовое значение строки


    ; --- 2. Обработка младшего полубайта ---
    AND DL, 0Fh ; Оставляем только 0..15 (индекс столбца)
    add di, dx
    ADD AH, byte [di + LOW_NIBS] ; Складываем: Hi_Val + Lo_Val
    ADC AH, 0 ; прибавляет cary flag
    
    ; --- 3. Базовая коррекция (-2) ---
    SUB AH, 2

    ; --- 4. Коррекция переполнения ---
    ; Вычитаем значение из таблицы коррекций
    SUB AH, byte [di + CORR_NIBS] 

add ax, 147
mov di, ax
mov ax, 0xE2FF
mov dx, 0xE2FF

INT 0x86

;mov ax, si

pop es

jmp $




; Значения для младших полубайтов (0x00-0x0F)
LOW_NIBS: 
db 2
db 80
db 102
db 180
db 250
db 9
db 95
db 109
db 179
db 193
db 22
db 36
db 106
db 184
db 206
db 29

; Значения для старших полубайтов (0x00, 0x10 ... 0xF0)
HIGH_NIBS:
 db 2
 db 35 
 db 66 
 db 99 
 db 130 
 db 163 
 db 194 
 db 227 
 db 3 
 db 34 
 db 67 
 db 98 
 db 131 
 db 162 
 db 195 
 db 226

; Таблица коррекций (исправляет ошибки переполнения для столбцов)
CORR_NIBS: 
db 0 
db 0 
db 0 
db 0 
db 1 
db 2 
db 2 
db 2 
db 2 
db 2 
db 0 
db 0 
db 0 
db 0 
db 0 
db 2
