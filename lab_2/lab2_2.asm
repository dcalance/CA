.model small
.data
x dw 1234h
z dw 1200h
y dw 1 dup(?)

.code
start:
mov ax, @data
mov ds, ax

mov ax, x
add ax, 2
mov bx, z
cmp ax, bx
jg greater

mov ax, x
shr ax, 1
sub ax, 23
add ax, bx
mov y, ax
jmp final

greater:
    mov ax, z
    sub ax, 54
    shr ax, 1
    sub ax, x

final:
    mov ah, 4Ch
    int 21h
end start