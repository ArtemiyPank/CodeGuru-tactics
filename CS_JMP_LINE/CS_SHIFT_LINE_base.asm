  BOMBING_AREA_SHIFT equ 0x4200
  BOMBING_AREA_SIZE equ 0x300
  DI_SHIFT equ BOMBING_AREA_SHIFT + BOMBING_AREA_SIZE - 0x1

  MIN_VALUE_CS equ 0x5b0
  REP_SIZE equ 0x14




  ;# по BX будут лежать координаты прыжка coll far 
  mov bx, 0xff

  main:

      mov cx, REP_SIZE

      mov si, ax
      add si, commands
      rep movsw

      ;# хуячим ES и SS на поле, a DS туда, где был ES
      push cs
      push es
      push cs

      pop es
      pop ds
      pop ss

      ;# перемещаем SP
      push ax
      mov sp, ax
      
      ;# SI = 0x0
      xor si, si
      
      
      mov bp, BOMBING_AREA_SHIFT;# BP = BOMBING_AREA_SHIFT
      mov dx, DI_SHIFT;# DX = DI_SHIFT
      
      
      mov di, ax
      
      ;jmp first_callfar
      
  commands:
      
      
      ;# REP MOVSW 
      rep movsw ; F3 A5
      
    first_callfar:
      
      ;# сдвинуть SP
      sub sp, bp ; 81 EC 00 03

      ;# сдвинуть DI 
      sub di, dx ; 81 EF 00 06

      ;# подготовить значение CS и запушить в стек
      mov ax, di ; 89 F8 

      xor al, al ; 30 C0


      mov cl, 0x4 ; B1 04
      shr ax, cl ; D3 E8

      add ax, MIN_VALUE_CS ; 05 B0 05
      push ax ; 50

      ;# подготовить значение IP и запушить в стек
      mov cx, di ; 89 F9
      mov ch, 0xA5 ; B5 A5

      push cx ; 51

      ;# положить новые значения CS и IP по[BX]
      mov [bx+0x2], ax ; 89 47 02
      mov [bx], cx ; 89 0F

      ;# подготовить куда прыгнуть
      mov ax, 0x1fff ; B8 FF 1F
      STOSW ; AB

      ;# уменьшить DI, чтобы копировать опкоды сразу после A5
      dec di ; 4F

      ;# обновить CX для rep
      mov cx, REP_SIZE ; B9 15 00
      
      ;# SI = 0x0
      xor si, si
      
      ;# сдвинуть CS и IP
      retf ; CB