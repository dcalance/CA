.data
x dw 5 dup(?)
a db 0FFh
b db 0h
sm dw 1 dup(?)

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

mov cx, 5
mov si, 0
mov ax, 0    
sum:
    add ax, x[si]
    add si, 2
    loop sum
mov sm, ax
    
mov ah, 4Ch
int 21h
end start