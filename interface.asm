switchGraphMenu macro
   startGraphMenu:
   readChar x; Lee un digito ingresado y lo carga a x 
   cmp x, '1'
   je PRINTORIGINAL
   cmp x,'2'
   je PRINTDERIVED
   cmp x,'3'
   je PRINTINTEGRAL 
   cmp x,'4'
   je DISPLAY_MENU
   
   printStr invalidChoice
   jmp startGraphMenu
endm

switchChoiceMenu macro
   startMenu:
   readChar x; Lee un digito ingresado y lo carga a x 
   cmp x, '1'
   je ENTERCOEF
   cmp x,'2'
   je DISPLAYMEMORY
   cmp x,'3'
   je DERIVATEF
   cmp x,'4'
   je INTEGRATE
   cmp x,'5'
   je SHOWGRAFICMENU
   cmp x, '6'
   je MAKEREPORT
   cmp x, '7'
   je OPENCALC
   cmp x,'8'
   je EXITPROGRAM
   
   printStr invalidChoice
   jmp  startMenu
   
endm


closeVideoMode macro
   ;presiona una tecla para salir
   mov ah, 10h
   int 16h
   ;regresar a modo texto
   mov ax, 0003h
   int 10h
endm

openVideoMode macro 
    mov ax, 13h;incia  modo video
    int 10h

    mov cx, 13eh ;dibujar eje de las abscisas 318
    eje_x:
     pixel cx, 5fh, 4fh
    loop eje_x

    mov cx, 0c6h ;dibujar eje de las ordenadas 198
    eje_y:
     pixel 9ah, cx, 4fh
    loop eje_y
endm

pixel macro x0, y0, color
    push cx
    mov ah, 0ch
    mov al, color
    mov bh, 00h
    mov dx, y0
    mov cx, x0
    int 10h
    pop cx
endm

putPoint macro x,y
	push cx
    push dx
    push ax
    
    cmp y,99
    jg exitPoint
    cmp y,-99
    jl exitPoint
    
    
    ;imprimiendo el pixel
    mov ah, 0ch
    mov al, 5fh
    mov bh, 00h
    mov dx,95    ;y
    sub dx,y
    mov cx,154    ;x
    add cx,x
    int 10h
    
    exitPoint: 
    pop ax
    pop dx
    pop cx
endm
