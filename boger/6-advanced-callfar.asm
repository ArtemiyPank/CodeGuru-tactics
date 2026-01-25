%define major_copy_lng (end_of_stack_copy - stack_copy) / 2
%define minor_copy_lng major_copy_lng - 3
%define jmp_lng 0x1e00
%define stack_distance 0x700
%define sp_jmp_lng 0x7
%define add_to_cs 2
%define take_off_di_at_end 0x3
%define add_to_sp_once (add_to_cs + 1) * (sp_jmp_lng + 4) - (stack_distance - add_to_cs * 16 - 4) % (sp_jmp_lng + 4)
%define add_to_sp_repeat add_to_sp_once - 4 - (sp_jmp_lng + 2) - 2

start:

    ;actual code starts here
    push cs
    push ss
    pop es
    pop ss
    mov si, ax
    add si,stack_copy
    mov cl,major_copy_lng
    rep movsw
    sub ah,0x7  ;start call far loop from further high up in order not to waste firepower on empty areas (around your surv init)
    add di,0x40
    mov bx,di
    mov al,0xa1
    stosw
    mov bp,ax
    mov ax, 0x1000 + add_to_cs
    stosw
    mov si,es
    mov es,ax
    mov di,bp
    mov bp,jmp_lng
    mov sp,di
    add sp, stack_distance + add_to_sp_once
    mov cl,minor_copy_lng
    mov ax, sp_jmp_lng
    mov word [di + add_to_cs * 16 - 8], 0x1FFF
    mov word [di + add_to_cs * 16 - 4], 0x1FFF
    mov word [di + add_to_cs * 16], 0xC429
    mov word [di + add_to_cs * 16 + 2], 0x1FFF
    mov word [di + add_to_cs * 16 + 6], 0x1FFF
    mov word [di + add_to_cs * 16 + 10], 0x1FFF
    mov ds,si
    mov dx, stack_distance + add_to_sp_repeat
    xor si,si
    inc di
    call far [bx]

stack_copy:
    ;copy this to stack
    rep movsw
    sub [bx],bp
    mov di,[bx]
    movsw
    movsw
    xor si,si
    mov sp,di
    sub di,take_off_di_at_end
    add sp,dx
    mov cl,minor_copy_lng
    call word far [bx]
    nop

cpy_scd_part:
    sub sp, ax
    call word far [bx]
end_of_stack_copy:
;;copy to stack until here