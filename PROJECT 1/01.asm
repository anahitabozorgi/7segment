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
end1:   CPI R16,$14
        BREQ segmn
end2:   LDI R19,$FF ;halqe binahayat baraye proteus k dorost kar kone
        CPI R19,$00
	    BRNE end2
        

segmn:  LDI R20,$01  ;ebteda avalin LED k bayad roshan shavad ra meqdarash ra dar R21 mirizim
SI:     CPI R20,$40  ;agar be vasati dar 7seg resid halqe motevaqef shavad 
        BREQ nopp
        LDI R16,00   ;tanzime stack pointer
		OUT SPL,R16
		LDI R16,$02
		OUT SPH,R16  ;motmaen mishsim 7seg aval khamoosh bashe
        SBI PORTC,0
    	OUT PORTB,R20
		CBI PORTC,0  ;ba portc k porte controlie 7seg ra roshan mikonim 
        RCALL rout1
		RCALL rout1
		RCALL rout1
		SBI PORTC,0  ;7seg khamoosh mishvad
		ROL R20      ;ba hardafe shift be chap be LED haye badi rafte va meqdare anhara dar R20 zakhire mikonim
		RJMP SI      ;in loop enqad tekrar mishavad ta hame LED ha roshan va khamush shavand
nopp:   LDI R16,00   ;vaqti hame hame LED ha roshan va khamoosh shodand dar enteha 7seg khamoosh mishavad
        RJMP nopp
		;baraye inke zamane roshan shodan 1sec tool bekashad az halqe rout1 estefade mikonim		
rout1:  LDI R17,$F4
L3:     LDI R18,$FF
L2:		DEC R18
		CPI R18,0
		BRNE L2
		DEC R17
        SER R19
new:	DEC R19
		CPI R19,$A0
		BRNE new
		CPI R17,0
		BRNE L3
		RET

      

