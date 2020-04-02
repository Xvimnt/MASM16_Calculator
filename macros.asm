
getAxisRange macro
	printStr insertInitial
	readString buff
	;me regresa en la variable number el valor numerico
	call STRINGTOINT
	mov dx, number
	mov NegativeXAxis,dx
	
	printStr insertFinal
	readString buff
	;me regresa en la variable number el valor numerico
	call STRINGTOINT
	
	;comprobar que la inicial sea mas peque que el final
	mov dx,NegativeXAxis
	cmp dx,number
	jg errorAxis
	mov dx,number
	mov PositiveXAxis,dx
	jmp okAxis 
	
	errorAxis:
	printStr axisError
	readString buff
	call SHOWGRAFICMENU
	okAxis:
endm

makeIntegralFx macro
	;en el 10 empieza 1 char
	mov si,9
   
   addFracToFx x4,4
   addFracToFx x3,3
   addFracToFx x2,2
   addFracToFx x1,1
   addFracToFx x0,0
   
endm

makeDerivedFx macro

	;en el 4 hacer que se vea como derivada
	mov si,4
	mov fxStr[si],39
	;empezar a meter en la funcion
	mov si,10
   
   ;para cada numero de la funcion derivarlo
   ;como no hay x5, x4 queda en 0
   mov number,0
   addCoeficientToDisplay number
   derivate number,x4,4
   mov cx,number
   call addTwoDigits
   derivate number,x3,3
   mov cx,number
   call addTwoDigits
   derivate number,x2,2
   mov cx,number
   call addTwoDigits
   derivate number,x1,1
   mov cx,number
   call addTwoDigits
   
endm

makeOriginalFx macro

	;en el 10 empieza 1 char
	mov si,10
	;anadir coeficiente 
	addCoeficientToDisplay x4
	;anadir coeficiente
	addCoeficientToDisplay x3
	;anadir coeficiente
	addCoeficientToDisplay x2
	;anadir coeficiente
	addCoeficientToDisplay x1
	;anadir coeficiente
	addCoeficientToDisplay x0
	
endm

openFile macro fName
 local makeHandler

 mov ah,3dh
 mov al,0
 lea dx,fName
 int 21h
 jnc makeHandler
 ;hubo un error
 printStr errorOpening
 readString buff
 call DISPLAY_MENU
 ;todo correcto guarda el manejador
 makeHandler:
 mov handler,ax
endm

readFile macro var,sizeVar
    push cx
    push bx
    push dx
    push ax
    
	mov bx, handler
    mov cx, sizeVar
    lea dx, var
    mov ah, 3fh
    int 21h
    
	pop ax
	pop dx
	pop bx
	pop cx
endm

writeFile macro string, sizeS
   mov ah,40h
   mov bx,handler
   lea dx,string
   mov cx,sizeS
   int 21h
endm

createfile macro fName
    mov ah,3ch
    mov cx,0
    lea dx, fName
    int 21h
    mov handler,ax
endm

closeFile macro
    mov bx, handler
    mov ah,3eh
    int 21h
endm

hasMemoryFunc macro
   local hasFunc
    
   cmp hasF,1
   je hasFunc
   ;imprimir que no tiene funcion y regresar al menu
   printStr noFuncMem
   readString buff
   call DISPLAY_MENU
   
   hasFunc:
endm

saveCoeficient macro coe
	local index0,index1,index2,index3,index4,exitSave
	
	mov dx,number
	
	;switch coe
	cmp coe,0
	je index0
	cmp coe,1
	je index1
	cmp coe,2
	je index2
	cmp coe,3
	je index3
	cmp coe,4
	je index4         
	
	
	;save index 0
	index0:
	mov x0,dx 
	jmp exitSave
	
	;save index 1
	index1:
	mov x1,dx
	jmp exitSave
	
	;save index 2
	index2:
	mov x2,dx 
	jmp exitSave
	
	;save index 3
	index3:
	mov x3,dx 
	jmp exitSave
	
	;save index 4
	index4:
	mov x4,dx
	
	
	exitSave:
endm

isANumber macro index
    mov si,index
	cmp buff[2 + si], '0'
	jl  retFalseLexicalAnalisis
	cmp buff[2 + si], '9'
	jg  retFalseLexicalAnalisis
endm

validateEntry macro
	local  retTrueLexicalAnalisis, validateCharIndex, retTrueFirstChar  
	;Analisis Lexico
	;Primer caracter (Numeros o simbolo +-)
	mov si,0
	cmp buff[2 + si], '+'
	je retTrueFirstChar
	cmp buff[2 + si], '-'
	je retTrueFirstChar
	;es un numero el index 0?
	isANumber 0
	;la entrada el primer char esta 
    retTrueFirstChar:
	;para cada posicion ver si es numero
	;la cantidad de caracteres ingresados
	mov ch,buff[1]
	cmp ch,1
	je retTrueLexicalAnalisis
	;de lo contrario iterar los chars que faltan			
	mov di,1
	validateCharIndex:
	isANumber di
	;Continuando validando la cadena
	inc di
	dec ch
	cmp ch,1
	jg validateCharIndex
	;sale del ciclo de validacion y todo esta correcto
	jmp retTrueLexicalAnalisis
	;La entrada tiene un error 
	retFalseLexicalAnalisis:
	printStr badEntry
	jmp enterCof 
	;continuar la ejecucion del programa	
	retTrueLexicalAnalisis:
endm



printInt macro integer
   push ax
   push bx
   mov dx,integer
   
   ;X sera nuestra variable a imprimir
   mov x[0],13

   cmp integer,100
   jl printTwoD
   
   ;guarda en al el resultado
   mov ax,integer
   mov bl,100
   div bl

   ;guardar en integer el modulo
   module integer,100
   
   add al,'0'
   mov x[0], al 
   
   printTwoD:
   
   ;guarda en al el resultado
   mov ax,integer
   mov bl,10
   div bl

   ;guardar en dx el modulo
   mov dx,integer
   module dx,10
   
   ;imprime el resultado
   
   add al,'0'
   mov x[1],al
   add dl,'0'
   mov x[2],dl
   mov x[3],'$'
   printStr newLine
   printStr x
   
   pop dx
   mov integer,dx
   pop bx
   pop ax

endm

readString macro bufVar
    mov ah, 0Ah ;SERVICE TO CAPTURE STRING FROM KEYBOARD.
    mov dx, offset bufVar
    int 21h 
endm


printStr macro aString
    push ax
    push dx
	
	mov ah,9h
    lea dx,aString
    int 21h
    
    pop dx
    pop ax
endm

printChar macro var
    push ax
    push dx
    
	mov ah,2h
    mov dl, var
    int 21h
    mov ah,0
    
    pop dx
    pop ax
endm

fixPath macro
 local errorFormat,success,compFinal	

	mov si,0
	cmp filePath[2 + si],'@'
	jne errorFormat
	
	inc si
	cmp filePath[2 + si],'@'
	jne errorFormat
	
	mov cl,filePath[1]  ; el size del path
	sub cl,2
	mov di,0
	appendPath:
		inc si
	    
	    ;encontrar la primera arroba
	     cmp filePath[2 + si],'@'
	     je compFinal
	    
	    ;formando nueva string
  		mov al,filePath[2 + si]
  		mov flag[di],al
  		
  		;continuando el siclo
  		inc di
		loop appendPath
	
	jmp errorFormat
	
	compFinal:
	inc si
	cmp filePath[2 + si],'@'
    je success

	
	errorFormat:
	printStr errorFormatString
	readString buff
	call OPENCALC
	
	success:
	mov cl, filePath[1]
	sub cl,4

endm

validateExt macro path
	local errorExt, success
	
	;el path debe tener al menos 5 caracteres
	cmp cl,5
	jl errorExt
	;validar que sea .arq
	mov ch,0
	mov si,cx
	dec si
	cmp flag[si],'q'
	jne errorExt
	dec si
	cmp flag[si],'r'
	jne errorExt
	dec si
	cmp flag[si],'a'
	jne errorExt
	dec si
	cmp flag[si],'.'
	jne errorExt

	jmp success

	errorExt:
		printStr errorExtension
		readString buff
		call OPENCALC
	success:	
endm

printCharWord macro var
    push ax
    push dx
    
	mov ah,2h
    mov dx, var
    int 21h
    mov ah,0
    
    pop dx
    pop ax
endm

addFracToFx MACRO  base, originalPower
	  mov ax,base
	  
	  ;ingresar a si el signo
      call ISWITCHSIGN
	  inc si
	   
	  mov count,al
	  add count,'0' 
	  
	  
	  mov bx,originalPower
	  inc bx 
	  add bx, '0'
	  
	  mov al,count
	  mov IfxStr[si], al
	  inc si
	  mov IfxStr[si],'/'
	  inc si
	  mov Ifxstr[si], bl
	  
	  add si,6
   
ENDM


getDate MACRO
    MOV AH, 2AH ;
    INT 21H

    MOV x, DL
    MOV y, DH

    MOV AL, x
    AAM ;AX SE CONVIERTE A BCD
    ADD AL, '0'
    MOV finalDate[1], AL
    ADD AH, '0'
    MOV finalDate[0], AH

    MOV AL, y
    AAM
    ADD AL, '0'
    MOV finalDate[4], AL
    ADD AH, '0'
    MOV finalDate[3], AH

ENDM

addCoeficientToDisplay macro var

	;mover al acumulador la variable a mostrar
	mov ax,var
	;ver su signo
 	call SWITCHSIGN
 	;para mostrar el verdadero numero
	add ax,'0'
	
	;ingresar al string el valor del char
	mov fxStr[si],al
	add si,6
	
endm

getHour macro
    mov ah,2ch
    int 21h

    mov x,ch
    mov y,cl

    mov al,x
    aam
    add al,'0'
    mov finalHour[1],al
    add ah,'0'
    mov finalHour[0],ah

    mov al,y
    aam
    add al,'0'
    mov finalHour[4],al
    add ah,'0'
    mov finalHour[3],ah

    mov x,dh
    mov al,x
    aam
    add al,'0'
    mov finalHour[7],al
    add ah,'0'
    mov finalHour[6],ah
endm

readChar macro var
    mov ah,1h
    int 21h
    mov var,al
endm

begin macro
    mov ax, @data
    mov ds,ax
endm

exit macro
    mov   ax,4c00h; Function (Quit with exit code (EXIT))
    int   21h; Interruption DOS Functions
endm
