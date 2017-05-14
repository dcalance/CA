.data
x dw 1h, -2h, -2h, -1h, -1h, -1h, -2h, -2h ,-1h, -1h
res dw 10 dup(?)

.code
start:
mov ax, @data
mov ds, ax

call sum
cmp ax, 0
jng smaller

    call genEven
    jmp final

smaller:
    call genOdd

final:
    mov ah, 4Ch
    int 21h
   

sum proc
    mov si, 2
    mov cx, 9
    mov ax, x[0]
    repeat:
        add ax, x[si]
        add si, 2
        loop repeat
    ret
sum endp

genEven proc
    mov si, 0
    mov di, 0
    mov cx, 10
    r1:
        mov ax, x[si]
        test ax, 1
        jnz f1
        mov ax, x[si]
        mov res[di], ax
        add di, 2
    f1:
    add si, 2
    loop r1
    ret
genEven endp

genOdd proc
    mov si, 0
    mov di, 0
    mov cx, 10
    r2:
        mov ax, x[si]
        test ax, 1
        jz f2
        mov ax, x[si]
        mov res[di], ax
        add di, 2
    f2:
    add si, 2
    loop r2
    ret
genOdd endp

end start