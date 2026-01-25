; 2 соред с захватом 2 зомби




AREA_SHIFT equ 0x6200
AREA_SIZE equ 0x300

BX_SHIFT equ 0x60

SP_SHIFT equ AREA_SHIFT - AREA_SIZE

SHIFT_OFFSET equ -0xa
SHIFT equ SHIFT_OFFSET*0x10
NEW_CS equ 0x1000 + SHIFT_OFFSET



ZOMB_AREA_SHIFT equ 0x6200
ZOMB_AREA_SIZE equ 0x300

ZOMB_BX_SHIFT equ 0x60

ZOMB_SP_SHIFT equ ZOMB_AREA_SHIFT - ZOMB_AREA_SIZE

ZOMB_SHIFT_OFFSET equ 0x5
ZOMB_SHIFT equ ZOMB_SHIFT_OFFSET*0x10
ZOMB_NEW_CS equ 0x1000 + ZOMB_SHIFT_OFFSET

ZOMB_COUNT_UNTIL_DEATH equ 0x50

jmp getZombie

zombie_cod:
    mainZ:
    nop
        mov ax, [si]
        mov [si],bp

        mov si, ax
        ADD SI, replicationZombie-0x3
        MOV CL, 0xc

        push ss 
        pop es
        xor di, di
        
        REP MOVSW
    
        MOV BP, ZOMB_AREA_SHIFT ; сдвиг бомбёжки
        MOV DX, ZOMB_SP_SHIFT
    
    
    
    
        ; свап сегментов
        MOV BX, ZOMB_BX_SHIFT ; по BX будут лежать координаты прыжка call far 
      
        PUSH ES
        POP DS
        push CS
        POP SS
        
    
 
        add ax, targetZ-ZOMB_SHIFT-0x3     

        MOV [BX], AX ; записываем target для IP
        MOV WORD [BX + 0x2], ZOMB_NEW_CS ; записываем будующий CS
        
        call far [bx]

    targetZ:
    
        PUSH CS
        POP ES
        
        add ah, 0x6
        MOV AL, 0xA3 ; сдвигаемся на столбец A3
        XOR SI, SI


        MOV [BX], AX ; записываем будующий IP
    
        
         
    
        
        
        ;MOV WORD [BX + 0x2], NEW_CS ; записываем будующий CS
   
        MOV SP, AX 
        ADD WORD SP, 0x300 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
        MOV DI, AX
    
    
        MOV AX, 0x1FFF ; ; чтобы первый раз поставить call far
        MOV CL, 0xa
        
        STOSW
        DEC DI

        MOV AX, 0x50 ; кол-во итераций репликации до смерти


        JMP [BX]

    replicationZombie:
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
;end of the zombie


getZombie:
push es
push cs
pop es

push ax
mov si, ax
mov ax, 0x24FF
mov dx, 0x24FF


nop
nop

mov bl, [0x2612]

add bx, si

mov ch, [bx + TABLE]

add cx, 0x140
mov di, cx

nop
nop
nop
add si, 0x3
mov word[0x0], si

INT 0x86

pop ax
pop es
jmp main

TABLE:
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
db 35
db 113
db 135
db 213
db 26
db 40
db 126
db 140
db 210
db 224
db 55
db 69
db 139
db 217
db 239
db 60
db 66
db 144
db 166
db 244
db 59
db 73
db 159
db 173
db 243
db 0
db 86
db 100
db 170
db 248
db 15
db 93
db 99
db 177
db 199
db 20
db 90
db 104
db 190
db 204
db 19
db 33
db 119
db 133
db 203
db 24
db 46
db 124
db 130
db 208
db 230
db 53
db 123
db 137
db 223
db 237
db 50
db 64
db 150
db 164
db 234
db 57
db 79
db 157
db 163
db 241
db 6
db 84
db 154
db 168
db 254
db 13
db 83
db 97
db 183
db 197
db 10
db 88
db 110
db 188
db 194
db 17
db 39
db 117
db 187
db 201
db 30
db 44
db 114
db 128
db 214
db 228
db 43
db 121
db 143
db 221
db 227
db 48
db 70
db 148
db 218
db 232
db 63
db 77
db 147
db 161
db 247
db 4
db 74
db 152
db 174
db 252
db 3
db 81
db 103
db 181
db 251
db 8
db 94
db 108
db 178
db 192
db 23
db 37
db 107
db 185
db 207
db 28
db 34
db 112
db 134
db 212
db 27
db 41
db 127
db 141
db 211
db 225
db 54
db 68
db 138
db 216
db 238
db 61
db 67
db 145
db 167
db 245
db 58
db 72
db 158
db 172
db 242
db 1
db 87
db 101
db 171
db 249
db 14
db 92
db 98
db 176
db 198
db 21
db 91
db 105
db 191
db 205
db 18
db 32
db 118
db 132
db 202
db 25
db 47
db 125
db 131
db 209
db 231
db 52
db 122
db 136
db 222
db 236
db 51
db 65
db 151
db 165
db 235
db 56
db 78
db 156
db 162
db 240
db 7
db 85
db 155
db 169
db 255
db 12
db 82
db 96
db 182
db 196
db 11
db 89
db 111
db 189
db 195
db 16
db 38
db 116
db 186
db 200
db 31
db 45
db 115
db 129
db 215
db 229
db 42
db 120
db 142
db 220
db 226
db 49
db 71
db 149
db 219
db 233
db 62
db 76
db 146
db 160
db 246
db 5
db 75
db 153
db 175
db 253

;endZomby----------------------------------------------------


main:
    MOV BX, BX_SHIFT ; по BX будут лежать координаты прыжка call far 

    xor di, di
    xor cx, cx
    mov si, ax
    ADD WORD SI, replication
    MOV CL, 0x8
    REP MOVSW
    
    MOV BP, AREA_SHIFT ; сдвиг бомбёжки
    MOV DX, SP_SHIFT


    ; свап сегментов
    PUSH ES
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


    XOR SI, SI 
    
    MOV AL, 0xA3 ; сдвигаемся на столбец A3
    MOV [BX], AX ; записываем будующий IP
    ;MOV WORD [BX + 0x2], NEW_CS ; записываем будующий CS
   
    MOV SP, AX 
    ADD WORD SP, 0x300 ; сдвигаем на размер облости бомбёжки
    
    ; выставляем то, куда будем копировать
    MOV DI, AX
    
    
    MOV AX, 0x1FFF ; чтобы ставить call far
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