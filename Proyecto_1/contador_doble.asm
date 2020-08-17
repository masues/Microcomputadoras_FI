	processor 16f877
 	include<p16f877.inc>

contador equ h'20'
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ d'25'
cte2 equ 0xFF
cte3 equ 0xFF
 	org 0
	goto inicio
 
	org 5
inicio bsf STATUS,5;
 	BCF STATUS,6; cambia al banco 1
 	MOVLW H'0'
 	MOVWF TRISB; configura todo el puerto B como salida
 	BCF STATUS,5; cambia al banco 0
 	clrf PORTB ;Limpia el puerto B
	
	movlw 0x9F
	movwf contador

conta:
	incf contador;    contador <- contador + 0x01
  movlw 0x10
  subwf contador,1; contador <- contador - 0x10
	movf contador, 0
	movwf PORTB;      PORTB <- contador
  call retardo
  movlw 0x09
  xorwf PORTB,0
  btfss STATUS,Z;   ¿PORTB = 0x09?
  goto conta;       PORTB != 0x09

conta_inverso:
  decf contador;    contador <- contador - 0x01
  movlw 0x10
  addwf contador,1; contador <- contador + 0x10
	movf contador, 0
	movwf PORTB;      PORTB <- contador
  call retardo
  movlw 0x90
  xorwf PORTB,0
  btfss STATUS,Z;  ¿PORTB = 0x90? 
  goto conta_inverso; PORTB != 0x90
  goto conta;      PORTB = 0x90 

retardo movlw cte1
 	movwf valor1
	
tres movlw cte2
 	movwf valor2
	
dos movlw cte3
 	movwf valor3
	
uno decfsz valor3 ;decrementa el valor 3 y lo guada ah? mismo
 	goto uno
 	decfsz valor2
 	goto dos
 	decfsz valor1
 	goto tres
	return
	END