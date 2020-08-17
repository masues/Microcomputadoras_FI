;Mario ALberto Suárez Espinoza
;masues64@gmail.com

; PORTB BUS DE DATOS B0-D0 ... B7-D7
; RS - A0
; E - A1
; R/W - GND

;Puerto A: Control display (2 pines de 6)
;Puerto B: Datos display (8 pines de 8)
;Puerto D: Entrada de datos al uC (8 pines de 8)
;Puerto E: Selección de modo (2 pines de 3)

    processor 16f877
    include<p16f877.inc>
valor equ h'20'
valor1 equ h'21'
valor2 equ h'22'
contador equ h'23'
dato equ h'24'
constA:  equ d'255'
constB:  equ d'255'
constC:  equ d'255'
regA:  equ h'25'
regB:  equ h'26'
regC:  equ h'27'
indice: equ h'28'
input: equ h'29'
deco_var: equ h'30'
numerador:  equ h'30'; registro que almacena al numerador
deno_hex:  equ h'10'; literal denominador hexadecimal
deno_dec:  equ h'0A'; literal denominador decimal
cocien_hex:  equ h'34'; registro que almacena el resultado de la operación hexadecimal
res_hex:  equ h'33'; registro que almacena al resto hexadecimal
cocien_dec:  equ h'31'; registro que almacena el resultado de la operación hexadecimal
res_dec:  equ h'32'; registro que almacena al resto hexadecimal

    org 0
    goto inicio
    org 5
inicio
    clrf PORTA
    CLRF PORTB 
    banksel TRISB
    movlw b'000000000'
    movwf TRISB
    banksel ADCON1
    movlw 0x07
    movwf ADCON1
    banksel TRISA
    movlw b'000000000'
    movwf TRISA
    banksel TRISD
    movlw h'FF'
    movwf TRISD
    banksel TRISE
    movlw b'111'
    movwf TRISE

    bcf STATUS, RP1; Cambia a banco 0
    bcf STATUS, RP0
    
    call inicia_lcd
    
main:
    ;Caso0 
	movlw h'00'
	subwf PORTE,0
	btfsc STATUS, Z
	goto caso0
	;Caso1
	movlw h'01'
	subwf PORTE,0
	btfsc STATUS, Z
	goto caso1
    ;Caso2
	movlw h'02'
	subwf PORTE,0
	btfsc STATUS, Z
	goto caso2
    ;Caso3
	movlw h'03'
	subwf PORTE,0
	btfsc STATUS,Z
	goto caso3
    ;Caso4
	movlw h'04'
	subwf PORTE,0
	btfsc STATUS,Z
	goto caso4
    ;Caso5
	movlw h'05'
	subwf PORTE,0
	btfsc STATUS,Z
	goto caso5

    goto main


caso0: ; Imprime Hola Mundo
    movlw 0x80
    call comando
    movlw a'H'
    call datos
    movlw a'o'
    call datos
    movlw a'l'
    call datos
    movlw a'a'
    call datos
    movlw a' '
    call datos
    movlw a'M'
    call datos
    movlw a'u'
    call datos
    movlw a'n'
    call datos
    movlw a'd'
    call datos
    movlw a'o'
    call datos
    movlw a'!'
    call datos
    ;Ciclo para imprimir 6 espacios
    movlw d'5'
    movwf indice
c0_loop:
    movlw a' '
    call datos
c0_endLoop:
    decfsz indice 
    goto c0_loop
    
    movlw 0xC0; Selecciona la dirección 0x40 de la DDRAM
    call comando

    ;Ciclo para imprimir 16 espacios
    movlw d'16'
    movwf indice
c0_2_loop:
    movlw a' '
    call datos
c0_2_endLoop:
    decfsz indice 
    goto c0_2_loop

 	goto main


caso1:	; Imprime Mario Suarez
    movlw 0x80
    call comando
    movlw a'M'
    call datos
    movlw a'a'
    call datos
    movlw a'r'
    call datos
    movlw a'i'
    call datos
    movlw a'o'
    call datos
    movlw a' '
    call datos
    movlw a'S'
    call datos
    movlw a'u'
    call datos
    movlw a'a'
    call datos
    movlw a'r'
    call datos
    movlw a'e'
    call datos
    movlw a'z'
    call datos
    ;Ciclo para imprimir 4 espacios
    movlw d'4'
    movwf indice
c1_loop:
    movlw a' '
    call datos
c1_endLoop:
    decfsz indice 
    goto c1_loop
    
    movlw 0xC0; Selecciona la dirección 0x40 de la DDRAM
    call comando

    ;Ciclo para imprimir 16 espacios
    movlw d'16'
    movwf indice
c1_2_loop:
    movlw a' '
    call datos
c1_2_endLoop:
    decfsz indice 
    goto c1_2_loop

 	goto main


caso2:	; Imprime entrada en hexadecimal
    movlw 0x80
    call comando
    ;Salva la entrada en el registro numerador
    movf PORTD,0
    movwf numerador
    ;Divide el contenido del numerador en dos registros, cocien_hex y res_hex
    call division_hexa
    ;Decodifica a las variables para imprimirlas
    movf cocien_hex,0
    call deco_num
    movf res_hex,0
    call deco_num
    movlw a'H'
    call datos
    ;Ciclo para imprimir 13 espacios
    movlw d'13'
    movwf indice
c2_loop:
    movlw a' '
    call datos
c2_endLoop:
    decfsz indice 
    goto c2_loop

    movlw 0xC0; Selecciona la dirección 0x40 de la DDRAM
    call comando

    ;Ciclo para imprimir 16 espacios
    movlw d'16'
    movwf indice
c2_2_loop:
    movlw a' '
    call datos
c2_2_endLoop:
    decfsz indice 
    goto c1_2_loop

 	goto main

division_hexa:
    clrf cocien_hex; coloca un cero en concien_hex

    movf numerador,0; coloca el contenido de numerador en W
    movwf res_hex; mueve el contenido de W a res_hex
    xorlw 0x00; compara el contenido de W con 0
    btfsc STATUS, Z; revisa si fue cero la operación anterior
    return; termina el algoritmo porque el numerador fue cero

    movlw deno_hex; coloca deno_hex en W
    subwf numerador,0; a 'numerador' le resta el contenido de W y lo almacena en W
    btfsc STATUS, C; revisa si 'deno_hex' es mayor que 'numerador'
	goto numerador_hexa_mayor; numerador>=deno_hex
    return; numerador<deno_hex, termina el algoritmo

numerador_hexa_mayor:
    movf numerador,0; mueve el contenido de numerador a W
    movwf res_hex; guarda el contenido de W en res_hex
    goto loop_division_hex

loop_division_hex:
    movlw deno_hex; coloca deno_hex en W
    subwf res_hex,1; resta el contenido de W a res_hex, y se almacena el resultado en res_hex
    incf cocien_hex,1; incrementa en 1 a cocien_hex, el resultado se almacena en cocien_hex
    movlw deno_hex; coloca deno_hex en W
    subwf res_hex,0; a 'res_hex' le resta el contenido de W y lo almacena en W
    btfsc STATUS, C; revisa si 'y' es mayor que 'x'
	goto loop_division_hex; c>=y
    return;termina el algoritmo

deco_num: ;Subrutina que imprime el número hexadecimal en la pantalla LCD
    movwf deco_var
    movlw h'0A'; coloca 0x0A en W
    subwf deco_var,0; a 'deco_var' le resta el contenido de W y lo almacena en W
    btfss STATUS, C; revisa si '0x0A' es mayor o igual que 'deco_var'
	goto imp_dec; deco_var<0x0A, por lo tanto imprime  deco_var + 0x30
    goto imp_hex; deco_var>=0x0A, por lo tanto imprime  deco_var + 0x37
imp_dec:
    movlw h'30'; W <- 0x30
    addwf deco_var,0; W <- deco_var + W
    call datos
    return
imp_hex:
    movlw h'37'; W <- 0x37
    addwf deco_var,0; W <- deco_var + W
    call datos
    return


caso3:	; Imprime la entrada en binario
    movlw 0x80
    call comando
    ;Ciclo para recorrer todos los bits de los datos de entrada
    movlw d'8'
    movwf indice
    movf PORTD,0
    movwf input
c3_loop:
    btfss input,7
    goto c3_0
    goto c3_1
c3_endLoop:
    call datos
    rlf input,1
    decfsz indice 
    goto c3_loop

    movlw a'B'
    call datos
    ;Ciclo para imprimir 7 espacios
    movlw d'7'
    movwf indice
c3_loop2:
    movlw a' '
    call datos
c3_endLoop2:
    decfsz indice 
    goto c3_loop2

    movlw 0xC0; Selecciona la dirección 0x40 de la DDRAM
    call comando

    ;Ciclo para imprimir 16 espacios
    movlw d'16'
    movwf indice
c3_2_loop:
    movlw a' '
    call datos
c3_2_endLoop:
    decfsz indice 
    goto c3_2_loop

 	goto main

c3_0:
    movlw a'0'
    goto c3_endLoop
c3_1:
    movlw a'1'
    goto c3_endLoop


caso4:	; Imprime entrada en decimal
    movlw 0x80
    call comando
    ;Salva la entrada en el registro numerador
    movf PORTD,0
    movwf numerador
    ;Divide el contenido del numerador en dos registros, cocien_hex y res_hex
    call division_dec1
    ;Salva el contenido del cocien_hex en el regitro numerador
    movf cocien_hex,0
    movwf numerador
    ;Divide el contenido de cocien_hex en dos registros, cocien_dec y res_dec
    call division_dec2
    ;Decodifica a las variables para imprimirlas
    movf cocien_dec,0
    call deco_num
    movf res_dec,0
    call deco_num
    movf res_hex,0
    call deco_num
    movlw a'D'
    call datos
    ;Ciclo para imprimir 12 espacios
    movlw d'12'
    movwf indice
c4_loop:
    movlw a' '
    call datos
c4_endLoop:
    decfsz indice 
    goto c4_loop

    movlw 0xC0; Selecciona la dirección 0x40 de la DDRAM
    call comando

    ;Ciclo para imprimir 16 espacios
    movlw d'16'
    movwf indice
c4_2_loop:
    movlw a' '
    call datos
c4_2_endLoop:
    decfsz indice 
    goto c4_2_loop

 	goto main

division_dec1:
    clrf cocien_hex; coloca un cero en concien_hex

    movf numerador,0; coloca el contenido de numerador en W
    movwf res_hex; mueve el contenido de W a res_hex
    xorlw 0x00; compara el contenido de W con 0
    btfsc STATUS, Z; revisa si fue cero la operación anterior
    return; termina el algoritmo porque el numerador fue cero

    movlw deno_dec; coloca deno_dec en W
    subwf numerador,0; a 'numerador' le resta el contenido de W y lo almacena en W
    btfsc STATUS, C; revisa si 'deno_dec' es mayor que 'numerador'
	goto numerador_dec1_mayor; numerador>=deno_dec
    return; numerador<deno_dec, termina el algoritmo

numerador_dec1_mayor:
    movf numerador,0; mueve el contenido de numerador a W
    movwf res_hex; guarda el contenido de W en res_hex
    goto loop_division_dec1

loop_division_dec1:
    movlw deno_dec; coloca deno_dec en W
    subwf res_hex,1; resta el contenido de W a res_hex, y se almacena el resultado en res_hex
    incf cocien_hex,1; incrementa en 1 a cocien_hex, el resultado se almacena en cocien_hex
    movlw deno_dec; coloca deno_dec en W
    subwf res_hex,0; a 'res_hex' le resta el contenido de W y lo almacena en W
    btfsc STATUS, C; revisa si 'y' es mayor que 'x'
	goto loop_division_dec1; c>=y
    return;termina el algoritmo

division_dec2:
    clrf cocien_dec; coloca un cero en concien_hex

    movf numerador,0; coloca el contenido de numerador en W
    movwf res_dec; mueve el contenido de W a res_dec
    xorlw 0x00; compara el contenido de W con 0
    btfsc STATUS, Z; revisa si fue cero la operación anterior
    return; termina el algoritmo porque el numerador fue cero

    movlw deno_dec; coloca deno_dec en W
    subwf numerador,0; a 'numerador' le resta el contenido de W y lo almacena en W
    btfsc STATUS, C; revisa si 'deno_dec' es mayor que 'numerador'
	goto numerador_dec2_mayor; numerador>=deno_dec
    return; numerador<deno_dec, termina el algoritmo

numerador_dec2_mayor:
    movf numerador,0; mueve el contenido de numerador a W
    movwf res_dec; guarda el contenido de W en res_dec
    goto loop_division_dec2

loop_division_dec2:
    movlw deno_dec; coloca deno_dec en W
    subwf res_dec,1; resta el contenido de W a res_dec, y se almacena el resultado en res_dec
    incf cocien_dec,1; incrementa en 1 a cocien_dec, el resultado se almacena en cocien_dec
    movlw deno_dec; coloca deno_dec en W
    subwf res_dec,0; a 'res_dec' le resta el contenido de W y lo almacena en W
    btfsc STATUS, C; revisa si 'y' es mayor que 'x'
	goto loop_division_dec2; c>=y
    return;termina el algoritmo


caso5:
    ; Inicializa a los caracteres que se van a ocupar para imprimir al puma
    call set_custom_characters

    movlw 0x80; Selecciona la dirección 0x00 de la DDRAM
    call comando

    ;Ciclo para imprimir 6 espacios
    movlw d'6'
    movwf indice
c5_1_loop:
    movlw a' '
    call datos
c5_1_endLoop:
    decfsz indice 
    goto c5_1_loop
    movlw h'00'; código de la primera dirección de la CGRAM
    call datos
    movlw h'01'
    call datos
    movlw h'02'
    call datos
    movlw h'03'
    call datos
    ;Ciclo para imprimir 6 espacios
    movlw d'6'
    movwf indice
c5_2_loop:
    movlw a' '
    call datos
c5_2_endLoop:
    decfsz indice 
    goto c5_2_loop

    movlw 0xC0; Selecciona la dirección 0x40 de la DDRAM
    call comando

    ;Ciclo para imprimir 6 espacios
    movlw d'6'
    movwf indice
c5_3_loop:
    movlw a' '
    call datos
c5_3_endLoop:
    decfsz indice 
    goto c5_3_loop
    movlw h'04'; código de la primera dirección de la CGRAM
    call datos
    movlw h'05'
    call datos
    movlw h'06'
    call datos
    movlw h'07'
    call datos
    ;Ciclo para imprimir 6 espacios
    movlw d'6'
    movwf indice
c5_4_loop:
    movlw a' '
    call datos
c5_4_endLoop:
    decfsz indice 
    goto c5_4_loop

    goto main

set_custom_characters:
    movlw 0x40; selecciona a la primera dirección de la CGRAM
    call comando
    ;Caracter 1
    movlw b'00000'
    call datos
    movlw b'00011'
    call datos
    movlw b'00111'
    call datos
    movlw b'00111'
    call datos
    movlw b'00111'
    call datos
    movlw b'00011'
    call datos
    movlw b'00011'
    call datos
    movlw b'00011'
    call datos
    ;Caracter 2
    movlw b'00111'
    call datos
    movlw b'11111'
    call datos
    movlw b'11111'
    call datos
    movlw b'11111'
    call datos
    movlw b'11111'
    call datos
    movlw b'00011'
    call datos
    movlw b'10011'
    call datos
    movlw b'11011'
    call datos
    ;Caracter 3
    movlw b'11100'
    call datos
    movlw b'11111'
    call datos
    movlw b'11111'
    call datos
    movlw b'11111'
    call datos
    movlw b'11111'
    call datos
    movlw b'11000'
    call datos
    movlw b'11001'
    call datos
    movlw b'11011'
    call datos
    ;Caracter 4
    movlw b'00000'
    call datos
    movlw b'11000'
    call datos
    movlw b'11100'
    call datos
    movlw b'11100'
    call datos
    movlw b'11100'
    call datos
    movlw b'11000'
    call datos
    movlw b'11000'
    call datos
    movlw b'11000'
    call datos
    ;Caracter 5
    movlw b'00001'
    call datos
    movlw b'00001'
    call datos
    movlw b'00001'
    call datos
    movlw b'00001'
    call datos
    movlw b'00000'
    call datos
    movlw b'00000'
    call datos
    movlw b'00000'
    call datos
    movlw b'00000'
    call datos
    ;Caracter 6
    movlw b'11011'
    call datos
    movlw b'11011'
    call datos
    movlw b'11011'
    call datos
    movlw b'11000'
    call datos
    movlw b'11000'
    call datos
    movlw b'11110'
    call datos
    movlw b'00000'
    call datos
    movlw b'00111'
    call datos
    ;Caracter 7
    movlw b'11011'
    call datos
    movlw b'11011'
    call datos
    movlw b'11011'
    call datos
    movlw b'00011'
    call datos
    movlw b'00011'
    call datos
    movlw b'01111'
    call datos
    movlw b'00000'
    call datos
    movlw b'11100'
    call datos
    ;Caracter 8
    movlw b'10000'
    call datos
    movlw b'10000'
    call datos
    movlw b'10000'
    call datos
    movlw b'10000'
    call datos
    movlw b'00000'
    call datos
    movlw b'00000'
    call datos
    movlw b'00000'
    call datos
    movlw b'00000'
    call datos

    return


inicia_lcd
    movlw 0x30
    call comando
    call ret100ms
    movlw 0x30
    call comando
    call ret100ms
    movlw 0x38
    call comando
    movlw 0x0c
    call comando
    movlw 0x01
    call comando
    movlw 0x06
    call comando
    movlw 0x02
    call comando
    return

comando
    movwf PORTB 
    call ret200
    bcf PORTA,0
    bsf PORTA,1
    call ret200
    bcf PORTA,1
    return

datos
    movwf PORTB
    call ret200
    bsf PORTA,0
    bsf PORTA,1
    call ret200
    bcf PORTA,1
    call ret200
    call ret200
    return

ret200
    movlw 0x02
    movwf valor1 
loop  
    movlw d'164'
    movwf valor
loop1
    decfsz valor,1
    goto loop1
    decfsz valor1,1
    goto loop
    return

ret100ms 
    movlw 0x03 
rr  movwf valor
tres movlw 0xff
    movwf valor1
dos movlw 0xff
    movwf valor2
uno decfsz valor2
    goto uno
    decfsz valor1
    goto dos
    decfsz valor
    goto tres
    return
    end
