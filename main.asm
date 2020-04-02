include macros.asm
include interface.asm
include math.asm
.model small
.stack 100h

.data
	;Variables para el menu grafico
	graphMenu db 10,13,10,13, '1. Graficar original f(x)'
				db 10,13, '2. Graficar derivada f´(x)'
				db 10,13, '3. Graficar integral F(x)'
				db 10,13, '4. regresar',10,13,'$'
	insertInitial db 10,13,'Ingrese el valor inicial del intervalo: $'
	insertFinal db 10,13,'Ingrese el valor final del intervalo: $'			
	axisError db 10,13,'Error: el valor inicial tiene que ser menor al final$'			
	;advertencias
	noFuncMem db 10,13,'No se ha guardado ninguna funcion en la memoria',10,13,'$'
	;funcionamiento
	newLine db 10,13,'$'
	fXStr db 10,13,' f (x)=     *X4     *X3     *X2     *X1      $'
	;empieza en la posicion 10	
	IfXStr db 10,13,' F(x)=   (   )*X5   (   )*X4   (   )*X3   (   )*X2   (   )*X1 + c$'
	;para ver si ya se guardo una funcion
	hasF db 0
	;Variables para los puntos de los ejes
	x db ?
	y db ?
	NegativeXAxis dw ?
	PositiveXAxis dw ?
	;Variables que guardan Integers en memoria
	x0 dw ?
	x1 dw ?
	x2 dw ?
	x3 dw ?
	x4 dw ?
	;variable para guardar cosas temps
	dotError db 10,13,'Error: No se encuentra el final ; se cancela la lectura$'
	fileName db 'reporte.txt$',0
	handler dW ?
	 count db ?
	 flag db ?
	 number dw ?
	 factor dw ?
	 signVar dw ?
	 plusC db 10,13,' + C$'
	 debugger db 10,13,'Graficar integral$'
	 debugger2 db 10,13,'Pasando una vez$'
	 pageFoot db 10,13,'Reporte de practica No.3, Creado el:',10,13
   ;Las variables del menu principal
   invalidChoice db 10,13,'Opcion invalida, intentelo de nuevo$'	
   header db 10,13,10, 13, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 13, 10 , 'FACULTAD DE INGENIERIA', 13, 10
          db  'CIENCIAS Y SISTEMAS', 13, 10 , 'ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 A', 13, 10
          db  'PRIMER SEMESTRE 2020',10,13,'JAVIER ALEJANDRO MONTERROSO', 13, 10 , '201700831', 13, 10
		  db  'QUINTA PRACTICA$'
   menu db 10,13,10,13, '1. Ingresar funcion f(x)', 10, 13
   		db '2. Funcion en memoria', 10, 13
   		db '3. Derivada f(x)', 10, 13
   		db '4. Integral f(x)', 10, 13
   		db '5. Graficar funciones', 10, 13
   		db '6. Reporte', 10, 13
   		db '7. Modo calculadora', 10, 13
   		db '8. Salir',10,13,'$'
   	invalidCharacter db 10,13,'Caracter invalido: $';	
	okReport db 10,13,'Reporte creado correctamente$'
   coeficientsStr db 10,13, 'Ingrese coeficiente de xn: $'
   exiting db 10, 13, 'Se ha cerrado la calculadora$'
   badEntry db 10,13,'Error lexico en su entrada, intente de nuevo.$'
   ;Variables para hora y fecha 
   finalDate db "00/00/2020 "
   finalHour db  "00:00:00 "
   ;Para guardar la lectura
    buff       db  5        ;MAX NUMBER OF CHARACTERS ALLOWED (5).
            db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
            db  5 dup('$') 	
	;Variables para la calculadora
	errorExtension db 10,13,'Error ruta del archivo con extension no valida, debe ser .arq$'
	errorFormatString db 10,13,'Error ruta del archivo con formato no valido$'
	errorEnd db 10,13,'Error el archivo no tiene final ;$'
	success db 13,'Resultado:  $'
	pathStr db 10,13,'Ingrese la ruta del archivo a calcular (.arq):',10,13,'$'
	errorOpening db 10,13,'Error, no se pudo abrir el archivo$'								
   	filePath  db  20        ;MAX NUMBER OF CHARACTERS ALLOWED (5).
              db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
              db  20 dup(0)
	calcString db 120 dup (0)
	stackCount db 0		   	
.code

COMPUTECALC proc
;----------ALGORITMO DE 5 PASOS---------;
;1)Primero valida que sea numero
;2)Si es entonces pasar al siguiente numero
;3)Si es ver si es ; o Espacio
;4)Push sign
;5)Validar solo espacio vacio	

	    ;Primer paso 
		isInteger calcString[si],number
		cmp number,'n'
		je numberError
		
		 
		;Segundo paso
		inc si
		isInteger calcString[si],factor
		cmp factor,'n'
		je numberError
		
		
		;Metodo para calcular el numero
		mov ax,number
		mov bx,10
		mul bx
		add ax,factor
		
				
		;Si tiene un signo en el stack operarlo sino pushearlo
		;Operar solo * y / 
		pop signVar
		mov dx,signVar
		isOpSign dl,bx
		cmp bx,'n'
		jne operate
		
		;se agrega lo que estuviera en el stack + el nuevo numero
		push signVar
		push ax ; se guarda el numero en el stack
		inc stackCount ; solo se agrego un dato nuevo al stack
		jmp thirdPhase
		
		;se procede a operar las * y /
		operate:
		;tengo el segundo operando en AX
		;tengo el signo en SignVar
		pop factor ; tengo el primer operando en factor
		;El valor sera regresado en ax
		performOperation factor, ax, signVar
		push ax
		dec stackCount; se quitan 2 datos de la stack
						
		thirdPhase:
		;Tercer paso
		inc si
		cmp calcString[si],';'
		je endAlgorithm 
		cmp calcString[si],32 
		jne numberError
		
		 
		;Cuarto paso
		inc si
		isSign calcString[si],signVar
		cmp signVar, 'n'
		je numberError
		push signVar 
		inc stackCount
		
		;Quinto Paso
		inc si
		cmp calcString[si], 32 
		jne numberError

		inc si ; incrementar para el proximo recorrido
		
		 ;Si se paso de la cuenta entonces no traia final
		  inc count
		  cmp count,20
		  jl COMPUTECALC
		  
		 printStr errorEnd
		 readString buff
		 call DISPLAY_MENU
		  
		
	numberError:
	mov ax,factor
	add al,'0'
	mov invalidCharacter[20],al
	printStr invalidCharacter
	readString buff
	call DISPLAY_MENU
	
	endAlgorithm:
	printStr success
	;calcular el stack y dejarlo en la stack
	operateStack
	;guarda el resultado en number
	pop number
	printInt number
	;imprimir number
	readString buff
	call DISPLAY_MENU	
COMPUTECALC endp


OPENCALC proc
	 ;mov si,0
;	 mov count,0
;	 mov stackCount,0
;	 call COMPUTECALC

		
	 ;solicitando ruta al usuario
	 printStr pathStr
	 readString filePath
	 ;arreglar nuestro path
	 fixPath    ; Me devuelve un path arreglado en Flag
	 ;comprobar la extension del archivo
	 validateExt flag
	 ;abrir el archivo con la path descrita
	 openFile flag
	 ;leyendo toda la fila
	 mov cx,120
	 mov si,0
	 readFromFile:
	    ;leyendo 1 char y guardandolo en factor
	 	readFile factor,1
	 	;concatenando en la string
	 	mov ax, factor
 	 	mov calcString[si],al
 	 	inc si
	 	loop readFromFile
    ;Termina la operacion
    printStr newLine
    mov calcString[si + 1],'$'
    printStr calcString
	closeFile
	mov si,0	
	call COMPUTECALC 	 
OPENCALC endp

MAKEREPORT proc
	;comprobar que exista una funcion                             
	hasMemoryFunc

	;Se crea un archivo
   createFile fileName
   ;escribir el encabezado
   writeFile header, 201
   ;;escribir la primer funcion
   ;armar la string de la funcion original y guardarla en fxStr
	makeOriginalFx
	;escribirla en el documento
	writeFile fxStr,47
   ;Armar la string de la derivada
   makeDerivedFx
   ;escribirla en el documento
   writeFile fxStr,47
   ;me arma la funcion de la integral y la guarda en ifxStr
    makeIntegralFx
	;ponerla en el reporte
	writeFile IfxStr,67
	;poner el pie de reporte
	writeFile pageFoot,41
	;escribiendo la fecha
   getDate
   writeFile finalDate, 11
   ;escribiendo la hora
   getHour
   writeFile finalHour, 9	
   ;se cierra el archivo
   closeFile
   
   printStr okReport
   readString buff
   call DISPLAY_MENU
   
MAKEREPORT endp

PRINTINTEGRAL proc 
    ;obteniendo el rango de x  
    getAxisRange
   
   ;abrir el modo video
   openVideoMode
   
   printPoint:
    ;Me regresa el valor evaluado en number
     evaluateIntegral
     
     ;imprime el eje x y funcion evaluada
     putPoint negativeXAxis,number

     ;para continuar con el loop
     inc negativeXAxis
     mov ax,negativeXAxis
     cmp ax,positiveXAxis
     jng printPoint
    printStr plusC   
    readString buff
    closeVideoMode
   	CALL DISPLAY_MENU
PRINTINTEGRAL endp
            
STRINGTOINT proc
	;limpiando la variable
	xor ax,ax
	mov number,ax
    ;guardar el numero de caracteres
	lea si, buff + 1 ;NUMBER OF CHARACTERS ENTERED.
    mov ch,0
	mov cl, [ si ] ;MOVE LENGTH TO CL.
	;llevar la cuenta 
	mov ch,0 
	;para cada caracter de menos significativo a mas significativo
	 addToReg:  
		;Iniciar el factor
		mov bl,10
		
		;ax tendra mi factor
		mov ax, 1
		
		mov count,ch
		;si se eleva a 0 continuar con el uno
		cmp count,0
		je saveFactor
		
		elev:
		;multiplicar por 10
		mul bl		
        ;continua el ciclo
		dec count       
		cmp count,0
		jne elev
		
		saveFactor:
		mov factor, ax
		
				
		;guardando el bit menos significativo en el acumulador
		mov ah,0
		;la cuenta la llevo en cl
		xor ah,ah
		mov al,cl
		mov di,ax
		;mover a ax el input del usuario
 		mov al,buff[1 + di]
 		
 		;ver si no es un signo
 		cmp al,'+'
 		je hasSignP
 		cmp al,'-'
 		je hasSignN
 		;convertir a char el numero
 		sub al,'0'
 		
		;multiplicando por el factor
		mul factor
		
		;guardando el acumulador en la variable de salida
		add number,ax
		
		;continuar con el ciclo
		inc ch
		dec cl
		cmp cl,0
		jg addToReg
	hasSignP:	
	ret	
	hasSignN:
	neg number
	ret	
	
STRINGTOINT endp 
    	
INTEGRATE proc
   ;comprobar que exista una funcion                             
	hasMemoryFunc
    ;me arma la funcion de la integral y la guarda en ifxStr
    makeIntegralFx


   exitingIntegral:
   printStr ifxStr
   readString buff
   call DISPLAY_MENU
   	

INTEGRATE endp	
	   
ENTERCOEF proc
	mov flag , 0
	enterCof:
		;Para cambiar el xn mostrado al usuario
		mov cl, flag
		add cl, '0'
		mov coeficientsStr[26],cl
		;mensaje de ingrese valor
		printStr coeficientsStr
		;leyendo string de usuario   
		readString buff
		;Analisis lexico y sintatico de la entrada
		validateEntry
		;convierte mi buffer a entero y lo guarda en number
		call STRINGTOINT
		;Guardando coeficientes
  		saveCoeficient flag
		;Continuando con el ciclo
		inc flag
		cmp flag , 5
	jl enterCof
	mov hasF,1  
    call DISPLAY_MENU 		 
ENTERCOEF  endp

PRINTDERIVED proc
   ;obteniendo el rango de x  
   getAxisRange
   
   ;abrir el modo video
   openVideoMode
   
   printPoint:
    ;Me regresa el valor evaluado en number
     evaluateDerived
     
     ;imprime el eje x y funcion evaluada
     putPoint negativeXAxis,number

     ;para continuar con el loop
     inc negativeXAxis
     mov ax,negativeXAxis
     cmp ax,positiveXAxis
     jng printPoint
       
     readString buff
     closeVideoMode
   	CALL DISPLAY_MENU
PRINTDERIVED endp


PRINTORIGINAL proc
   ;obteniendo el rango de x  
   getAxisRange
   
   ;abrir el modo video
   openVideoMode
   
   printPoint:
    ;Me regresa el valor evaluado en number
     evaluateOriginal
     
     ;imprime el eje x y funcion evaluada
     putPoint negativeXAxis,number

     ;para continuar con el loop
     inc negativeXAxis
     mov ax,negativeXAxis
     cmp ax,positiveXAxis
     jng printPoint
       
     readString buff
     closeVideoMode
   	CALL DISPLAY_MENU
   	
PRINTORIGINAL endp

EXITPROGRAM proc
   printStr exiting
   exit
EXITPROGRAM endp

SHOWGRAFICMENU proc
   ;comprobar que exista una funcion                             
	hasMemoryFunc
   
	printStr header
	printStr graphMenu
	switchGraphMenu
	
SHOWGRAFICMENU endp

ADDTWODIGITS proc
   		
	mov ax, cx
	
	call SWITCHSIGN
	mov cx,ax
	
	mov bl,10
	div bl
	
	mov count,al
	add count,'0'
	
	xor bx,bx
	mov bl,count

	mov fxStr[si],bl
	inc si
	
	mov ax, cx 
	
	sub10:
	sub ax,10
	js modulus
	mov cx,ax
	jmp sub10
	
	modulus:
	mov bl,cl
	add bl,'0'
	mov fxStr[si],bl
	add si, 5
	
	ret
	
ADDTWODIGITS endp

DERIVATEF proc
   ;comprobar que exista una funcion                             
	hasMemoryFunc
   
   ;Armar la string de la derivada
   makeDerivedFx 

   exitingDerivate:
   printStr fxStr
   readString buff
   call DISPLAY_MENU
   		
DERIVATEF endp

SWITCHSIGN proc
	;comprobar que tenga signo
	test ax,ax
	jns insertPositive

	mov fxStr[si],'-'
	add si,2
	neg ax
	ret
	insertPositive:
	;ingresar a si el signo
	mov fxStr[si],'+'
	add si,2
	ret	
SWITCHSIGN endp

ISWITCHSIGN proc
	;comprobar que tenga signo
	test ax,ax
	jns insertPositive

	mov IfxStr[si],'-'
	add si,2
	neg ax
	ret
	insertPositive:
	;ingresar a si el signo
	mov IfxStr[si],'+'
	add si,2
	ret	
ISWITCHSIGN endp

DISPLAYMEMORY proc
	;comprobar que exista una funcion                             
	hasMemoryFunc
	;armar la string de la funcion original y guardarla en fxStr
	makeOriginalFx
	
	printStr fxStr
	;para regresar al presionar enter
	readString buff
	call DISPLAY_MENU
DISPLAYMEMORY endp
	 
DISPLAY_MENU  proc
   begin
   printStr header
   printStr menu
   switchChoiceMenu
DISPLAY_MENU  endp;
			   
end DISPLAY_MENU
