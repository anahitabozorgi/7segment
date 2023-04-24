 
    .INCLUDE "M32DEF.INC"
	.ORG $00
	RJMP main
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
		CPI R16,$00		;sotoon haro check mikone hame 0 hast ya na
		BRNE wait1
loop1:	LDI R17,$01		;R17=0000 0001 Row0= 1
wait2:	OUT PORTA,R17
		IN R16,PINA		;store columns status in R16
		ANDI R16,$F0	;R16 = CCCC 0000
		CPI R16,$00		
		BRNE serch		;agar klidi zade shod
		INC R18
		LSL R17			;satre badi
		CPI R18,4
		BRNE wait2
		CLR R18
		RJMP loop1
serch:	ANDI R17,$0F	;R17 = 0000 RRRR
		OR R16,R17		;R16 = CCCC RRRR
		CLR R18			;counter
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
end1:   CPI R16,$24
        BREQ segmn
end2:   LDI R19,$FF ;halqe binahayat baraye proteus k dorost kar kone
        CPI R19,$00
	    BRNE end2

segmn:  CLR R22
        SBI DDRC,0
        LDI R19,$FF
	    CLR R20
		; 2ms = 2000us toole har pals
		; 2000 % 8 = 250
		; 260 - 250 = 6
        LDI R16,6
	    LDI R17,$01
	    LDI R21,$02 ;prescale
	    OUT TCNT0,R16
	    OUT TCCR0,R21
wait:   IN R18,TIFR
	    SBRS R18,0
	    RJMP wait 
	    OUT TCNT0,R16
	    EOR R20,R19   ;port ra mokamel mikonim
		OUT PORTC,R20
        OUT TIFR,R17
		INC R22
		CPI R22,4 ;4 bar taqir vaziat darim pas 4 bar bayad halqe wait ejra shavad
	    BRNE wait
		RJMP end3

end3:   RJMP end3 ;halqe binahayat k be flag TIFR 1 dadim
