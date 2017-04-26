.model small
.data
x dw 5 dup(?)
a db 0FFh
b db 0h

.code
start:
mov ax, @data
mov ds, ax

mov bx, 4

xor ax, ax
mov al, a
sub al, b
mul bx
mov di, ax
mov x[0], ax
mov dx, ax

mov si, 2
mov cx, 4

rec: 
    xor ax, ax
    mov ax, di
    add ax, dx
    mov x[si], ax
    mov dx, ax
    add si, 2
    loop rec    
    
mov ah, 4Ch
int 21h
end start