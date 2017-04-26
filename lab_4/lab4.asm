.stack 100h  
.data
x db 'Calancea Daniel', 0
y db 'asdaswqeasdqwjijqirjiasdaCalancea Daniel', 0
notFound db 'String Not Found', 0
resIndex dw 20 dup(0)
xlen dw 1 dup(?)
ylen dw 1 dup(?)
notFoundLen dw 1 dup(0)

getLength macro s1
    local l1, f1
    mov si, 0
    mov al, s1[si]
    l1:
        cmp al, 0
        je f1
        add si, 1
        mov al, s1[si]
        jmp l1
    f1:    
endm

printString macro string, length, color, startPos
    local loop1
    mov si, 0
    mov di, length
    mov bp, startPos
    loop1:
        mov dh, 0   ;row
	    mov dx, bp  ;column
	    mov bh, 0   ;page
	    mov ah, 2
	    int 10h
        
        mov al, string[si]
        xor bx, bx
        mov bl, color ;color
        mov ah, 09h
        mov cx, 1
        int 10h
        
	    inc si
	    inc bp
	    dec di
	    cmp di, 0
        jne loop1    
endm

printDiagonal macro string, length, color, startPos
    local loop1
    mov si, 0
    mov di, length
    mov bp, startPos
    loop1:
        mov ax, bp
        mov dh, al  ;row
	    mov dl, al  ;column
	    mov bh, 0   ;page
	    mov ah, 2
	    int 10h
        
        mov al, string[si]
        xor bx, bx
        mov bl, color ;color
        mov ah, 09h
        mov cx, 1
        int 10h
        
	    inc si
	    inc bp
	    dec di
	    cmp di, 0
        jne loop1    
endm

printColumn macro string, length, color, startPos
    local loop1
    mov si, 0
    mov di, length
    mov bp, startPos
    loop1:
        mov ax, bp
        mov dh, al  ;row
	    mov dl, 0   ;column
	    mov bh, 0   ;page
	    mov ah, 2
	    int 10h
        
        mov al, string[si]
        xor bx, bx
        mov bl, color ;color
        mov ah, 09h
        mov cx, 1
        int 10h
        
	    inc si
	    inc bp
	    dec di
	    cmp di, 0
        jne loop1    
endm

.code
start:   
    mov ax, @data
    mov ds, ax
    	
    getLength x
    mov xlen, si
    getLength y
    mov ylen, si
    getLength notFound
    mov notFoundLen, si
    mov bx, 0
    call checkStrings
    cmp bx, 0
    je nFound
        sub bx, 2
        push bx
        printString y, ylen, 0Fh, 0h
        loop2:
            pop bx
            cmp bx, -2
            je final
            mov ax, resIndex[bx]
            push bx
            printString x, xlen, 0Eh, resIndex[bx]
            pop bx
            sub bx, 2
            push bx
            jmp loop2
    nFound:
        printString notFound, notFoundLen, 0Eh, 0h
        
    final:
        
        
        mov ah, 4ch
        int 21h
    
    
    
checkStrings proc
    mov si, 0
    mov di, 0
    mov bx, 0
    l2:
        cmp si, ylen
        jg f2
        mov al, y[si]
        cmp al, x[di]
        je eq
        mov di, 0
        inc si
        jmp l2
        eq:
            inc si
            inc di
            cmp di, xlen
            je found
        jmp l2
        found:
            mov ax, si
            sub ax, di
            mov resIndex[bx], ax
            add bx, 2
            jmp l2       
    f2:
    ret
checkStrings endp

end start