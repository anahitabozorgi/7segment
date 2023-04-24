

   .INCLUDE "M32DEF.INC"
	.ORG $00
	RJMP main
	.ORG $100
	.DB $01,$02,$04,$08,$10,$20
	.ORG $200
	.DB $11,$21,$41,$81,$12,$22,$42,$82,$14,$24,$44,$84,$18,$28,$48,$88
	.ORG $300
main:	LDI R16,$0F
		OUT DDRA,R16	;PORTA 0..3 output & 4..7 input
		CLR R16
		OUT SFIOR,R16	;PUD=0
		SER R16
		ANDI R16,$0F
		OUT PORTA,R16
		SER R16
        OUT DDRB,R16
		OUT DDRC,R16
		CLR R18	
wait1:	IN R16,PINA
		ANDI R16,$F0	;R16= XXXX 0000
		CPI R16,$00		;check if all the columns are 0
		BRNE wait1
loop1:	LDI R17,$01		;R17=0000 0001 Row0= 1
wait2:	OUT PORTA,R17
		IN R16,PINA		
		ANDI R16,$F0	;R16  CCCC 0000
		CPI R16,$00		
		BRNE serch		
		INC R18
		LSL R17			
		CPI R18,4
		BRNE wait2
		CLR R18
		RJMP loop1
serch:	ANDI R17,$0F	
		OR R16,R17		
		CLR R18			
		CLR R30
		LDI R31,$04	
loop2:	LPM R17,Z
		CP R17,R16
		BREQ end1
		INC R30
		INC R18
		CPI R18,16
        BRNE loop2
		RJMP wait1
		BRNE loop2
		RJMP wait1
end1:   CPI R16,$12
        BREQ segmn
end2:   LDI R19,$FF ;halqe binahayat baraye proteus k dorost kar kone
        CPI R19,$00
	    BRNE end2

        CLR R21
segmn:  LDI R20,$66 ;moadele adade 4 dar 7seg ra dae R21 zakhire mikonim
        LDI R16,00
		OUT SPL,R16 ;tanzime stack pointer
		LDI R16,$02
		OUT SPH,R16
        SBI PORTC,0   ;motmaen mishim 7seg khamooshe
    	OUT PORTB,R20 ;be porte motasel be 7seg R20 ra ersal mikonim
		CBI PORTC,0   ;roshan
		RCALL rout1
		SBI PORTC,0   ;khamoosh
		RCALL rout1
		INC R21
        CPI R21,8     ;bayad 8 bar adade 4 tekrar shavad pas 8 bar bayad halqe segmn tey shavad
		BREQ end2     ;bad az 8 bar namayeshe adade 4 7seg betore koli khamoosh mishavad
        RJMP segmn

rout1:  LDI R17,$FF
L3:     LDI R18,$FF
L2:		DEC R18
		CPI R18,0
		BRNE L2
		DEC R17
		CPI R17,0
		BRNE L3
		RET
