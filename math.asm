evaluateDerived macro
	  ;el punto a evaluar esta en negative axis
	  
	  ;Elevar a la 3 y mul por su derivada
      pow negativeXAxis,3
	  ;el valor se guarda en ax
	  derivate factor,x4,4
	  imul factor 
	  mov number,ax
	  
	  pow negativeXAxis,2
	  ;el valor se guarda en ax
	  derivate factor,x3,3
	  imul factor 
	  add number,ax
	  
	  mov ax,negativeXAxis
	  ;el valor se guarda en ax
	  derivate factor,x2,2
	  imul factor 
	  add number,ax
	  
	  mov ax,x1
	  add number,ax
	  
endm

isOpSign macro var, sign
   local finishSign, signed
	;switch case de los signos
	cmp var,'*'
	je signed
	cmp var, '/'
	je signed
	;no encuentra ningun signo guardar n
	mov sign,'n'
	jmp finishSign	
	;encontro un signo entonces guardarlo
 	signed:
 	push ax
 	mov al,var
 	mov sign,ax
 	pop ax
 	
 	finishSign:
endm

evaluateIntegral macro 

	pow negativeXAxis,5 ; El valor se queda en ax
	integrateAprox x4,4,factor ; guardo la fraccion en factor
	imul factor
	mov number,ax
	
	pow negativeXAxis,4 ; El valor se queda en ax
	integrateAprox x3,3,factor ; guardo la fraccion en factor
	imul factor
	add number,ax
	
	pow negativeXAxis,3 ; El valor se queda en ax
	integrateAprox x2,2,factor ; guardo la fraccion en factor
	imul factor
	add number,ax
	
	pow negativeXAxis,2 ; El valor se queda en ax
	integrateAprox x1,1,factor ; guardo la fraccion en factor
	imul factor
	add number,ax
	
	add ax,negativeXAxis ; El valor se queda en ax
	imul x0
	add number,ax

endm

integrateAprox macro base,power,toSave
 local finishIntegrate, isZero	
	
	cmp base,0
	je isZero
	 	
	push ax 
	push bx
	
	mov bl,power
	inc bl
	
	mov ax,base
	idiv bl
	
	mov ah,0
	mov toSave,ax
	
	pop bx
	pop ax
	
	jmp finishIntegrate
	isZero:
	mov toSave,0
	finishIntegrate:

endm

module macro base,modu
 local loopMod, exitModule	
	push ax
	push bx
	
	mov ax,base
	mov bx,modu
	loopMod:
		sub ax,bx
		js exitModule
		mov base,ax
		jmp loopMod	
		
	exitModule:	
	pop bx
	pop ax			
endm


isSign macro var, sign
   local finishSign, signed
	;switch case de los signos
	cmp var,'+'
	je signed
	cmp var, '-'
	je signed
	cmp var, '–'
	je signed
	cmp var,'*'
	je signed
	cmp var, '/'
	je signed
	;no encuentra ningun signo guardar n
	mov sign,'n'
	jmp finishSign	
	;encontro un signo entonces guardarlo
 	signed:
 	push ax
 	mov al,var
 	mov sign,ax
 	pop ax
 	
 	finishSign:
endm

performOperation macro first,second,operand
local suma,multiplicar,dividir,resta,endOperation	 
	 
	 cmp operand,'+'
	 je suma
	 cmp operand,'-'
	 je resta
	 cmp operand,'–'
	 je resta
	 cmp operand,'*'
	 je multiplicar
	 cmp operand,'/'
	 je dividir
	 
	 suma:
	 push bx
	 mov bx,first
	 add second,bx
	 pop bx
	 jmp endOperation
	 
	 multiplicar:
	 mul first
	 jmp endOperation
	 
	 dividir:
	 push bx
	 mov bx,second ; guardar ax en bx
	 mov ax,first
	 div bl
	 pop bx
	 jmp endOperation
	 
	 resta:
	 push bx
	 mov bx,first
	 sub second,bx
	 pop bx

	 endOperation:
endm

isInteger macro  var, integer
	local noParse, parsed
	
	
	cmp var,'0'
	jl noParse
	cmp var, '9'
	jg noParse
	

	push ax
	
	xor ax,ax
	mov al, var
	sub al,'0'
	mov integer,ax 
	
	pop ax
	jmp parsed
	noParse:
	mov integer,'n'
	parsed:
endm

operateStack macro
 local makeOperation,resultDone
   
   makeOperation:
   ;Si solo hay uno en la stack ese es el resultado
   cmp stackCount,1
   je resultDone
   ;saca el primer numero
   pop number
   ;saca el operando
   pop signVar
   ;sace el segundo numero
   pop factor   
   ;realiza la operacion
   performOperation number, factor, signVar ;resultado queda en factor
   ;mete el resultado a la stack
   push factor
   ;modifica la cantidad de objetos en stack
   sub stackCount, 2
   ;sigue el ciclo
   jmp makeOperation
   
    resultDone:
endm


pow MACRO x, n
	LOCAL startP

	push bx
	push cx
	push dx

	mov ax, x
	mov bx, ax
	mov cx, n
	dec cx

startP:
	mul bx
	loop startP

	pop dx
	pop cx
	pop bx
ENDM

derivate MACRO toSaveResultBase, base, originalPower
		push bx
        push ax; limpiamos el registro
        
        mov ax,base ;colocamos para multiplicar
		mov bx,originalPower 
        mul bx ;multiplicamos
        mov toSaveResultBase,ax ;sustituimos
        
        pop ax
        pop bx
ENDM



evaluateOriginal macro
	  ;el punto a evaluar esta en negative axis 
	  ;1) elevar a la 4 y mul por su coef
      pow negativeXAxis,4
	  ;el valor se guarda en ax
	  imul x4 
	  mov number,ax
	  
	  pow negativeXAxis,3
	  ;el valor se guarda en ax
	  imul x3 
	  add number,ax
	  
	  pow negativeXAxis,2
	  ;el valor se guarda en ax
	  imul x2 
	  add number,ax
 	 
	  mov ax,x1
	  mul negativeXAxis
	  add number,ax
	  
	  mov bx,x0
	  add number,bx  
	  
endm
