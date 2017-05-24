.stack 100h
.data
x db 1 dup(?)
ex db 1 dup(?)
y db 1 dup(?)
ey db 1 dup(?)
z dw 1 dup(?)
ez db 1 dup(?)

message1 db "Input first number:$"
message1b db "Input first number exponent:$"
message2 db "Input second number:$"
message2b db "Input second number exponent:$"
message3 db "Result mantissa:$"
message3b db "Result exponent:$"

.code

start:
    mov ax, @data
    mov ds, ax
    
    lea dx, message1
    mov ah, 09h
    int 21h
    call newLine
    
    call input
    call binaryOutput8bits
    mov x, bl
    call newLine
    
    lea dx, message1b
    mov ah, 09h
    int 21h
    call newLine
    
    call input
    call binaryOutput8bits
    mov ex, bl
    call newLine
    
    lea dx, message2
    mov ah, 09h
    int 21h
    call newLine  
    
    call input
    call binaryOutput8bits
    mov y, bl
    call newLine
    
    lea dx, message2b
    mov ah, 09h
    int 21h
    call newLine  
    
    call input
    call binaryOutput8bits
    mov ey, bl
    call newLine
     
    xor ax, ax
    xor bx, bx
    mov al, x
    mov bl, y
    call getSign 
    push si 
    
    xor dx, dx
    xor cx, cx
    mov cl, ex
    mov dl, ey
    add cx, dx
    push cx
    
    call getAbs
    call getMantissa
    call normMantissa
    
    pop bx
    dec cx
    sub bx, cx
    mov ez, bl
    
    pop cx
    call setMantissaSign
    mov z, dx
    mov bx, dx
    
    lea dx, message3
    mov ah, 09h
    int 21h
    call newLine
    
    call hexOutput
    call binaryOutput16bits 
    
    lea dx, message3b
    mov ah, 09h
    int 21h
    call newLine
    
    xor bx, bx
    mov bl, ez
    call hexOutput
    call binaryOutput8bits   
    
    mov ah, 4Ch
    int 21h    

proc newLine
    mov ah, 06h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ret
endp newLine

proc hexOutput
    mov ah, 06h
    mov si, 4
    mov cx, 4

loop1:    
    rol bx, cl
    mov dl, bl
    and dl, 0Fh
    cmp dl, 0Ah
    jge letter1
    add dl,30h
    jmp finalp 
letter1:
    add dl, 37h
finalp:
    int 21h
    dec si
    cmp si, 0
    jne loop1        
    ret
endp hexOutput    

proc input
    xor si, si
    xor di, di
    xor dx, dx
    xor bx, bx
    mov cx, 4
l3:
    mov ah, 01h
    int 21h
    cmp al, 0Dh
    je skip
    cmp al, 2Dh
    je minus
    mov si, ax
    cmp al, 3Ah
    jg letter
    shl bx, cl
    sub al, 30h
    jmp end
minus:
    mov di, 1
    jmp l3
letter:
    sub al, 37h
    shl bx, cl
end:
    add bl, al
    inc dx
    cmp dx, 2
    jne l3
    jmp fin2
skip: 
    mov ah, 06h
    cmp di, 1
    jne dontAddMinus    
    mov dl, 2Dh
    int 21h
dontAddMinus:    
    mov dx, si
    int 21h
fin2:
    cmp di, 1
    je negate
    jmp fin3
negate:
    neg bl
fin3:    
    ret
endp input

proc binaryOutput16bits ;outputs from bx    
    mov ah, 06h   
    mov dl, 09h
    int 21h    
    
    push bx
    mov cx, 16
    
l5:
    test bx, 8000h
    jz zero1
    mov dl, 31h
    int 21h
    jmp fin5
zero1:
    mov dl, 30h
    int 21h    

fin5:
    shl bx, 1
    loop l5
    pop bx
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ret
endp binaryOutput16bits


proc binaryOutput8bits ;outputs from bl
    mov ah, 06h
    mov cx, 8   
    
    mov dl, 09h
    int 21h    
    
    push bx
    mov cx, 8
    
l4:
    test bl, 80h
    jz zero
    mov dl, 31h
    int 21h
    jmp fin
zero:
    mov dl, 30h
    int 21h    

fin:
    shl bl, 1
    loop l4
    pop bx
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ret
endp binaryOutput8bits

proc getSign ;numbers should be located in ax and bx, res stored in si 
    push ax
    xor ax, bx
    test ax, 80h
    jz positive
    mov si, -1
    jmp continue
positive:
    mov si, 1  
    
continue:
    pop ax
    ret
endp getSign   

proc getMantissa
    mov cx, 7
    mov dx, 0
    clc
l1:
    shl bl, 1
    jnc nocarry
    add dx, ax
nocarry:
    shl dx, 1
    loop l1
    shl bl, 1
    jnc nocarry2
    add dx, ax
nocarry2:
    ret
endp getMantissa

proc getAbs
    test al, al
    jns absResA
    neg al
absResA:
    test bl, bl
    jns absResB
    neg bl
absResB:
    ret
endp getAbs

proc normMantissa
    mov cx, 0
    mov si, 16h
l2:
    test dx, 8000h
    jnz normalised
    shl dx, 1
    inc cx
    dec si
    cmp si, 0
    jne l2
    
normalised:
    ret
endp normMantissa

proc setMantissaSign
    shr dx, 1
    cmp cx, 1
    jz done
    neg dx
    
done:
    ret
endp setMantissaSign