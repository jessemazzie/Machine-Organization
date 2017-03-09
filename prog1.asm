;Name: Jesse Mazzie
;Program purpose: Flips characters across vertical axis in center of screen. All capital or non-capital letters become blue on white background. All other characters retain original colors. 

MyStack SEGMENT STACK
	DW 256 DUP(?) 
MyStack ENDS

MyData SEGMENT

MyData ENDS

MyCode SEGMENT
	ASSUME CS:MyCode, DS:MyData

mainProc PROC

	MOV AX, MyData
	MOV DS, AX			;This and the line above sets up data segment. 
	MOV AX, 0B800h		
	MOV ES, AX			;This and the line above set up screen memory to be used
	MOV CX, 2000		;2000 Characters on screen. 
	MOV SI, 0			;Beginning of screen
	MOV AH, 01111001b	;Set color to blue on white

	colorLoop: 			;This loops through all screen characters to change color
		MOV AL, ES:[SI] ;next character on screen
		
		;Comparison block checks to make sure character is a letter (lower or uppercase). If not a letter, does not change the color. If a letter, sets color to blue text on white BG
		CMP AL, 'A'
		JL skipColorChange
		CMP AL, 'Z'
		JLE doColorChange
		CMP AL, 'z'
		JG skipColorChange
		CMP AL, 'a'
		JL skipColorChange

		;End comparison block

	doColorChange:
		MOV ES:[SI], AX	
	skipColorChange:
		ADD SI, 2
		LOOP colorLoop	;Repeat if more room on screen. Counter decrement and comparison. 

	MOV CX, (24 * 160) 		;24 rows, 80 characters a row

	rowLoop:
		CALL flipARow
		SUB CX, 160		;Goes "up" a row
		CMP CX, 0
		JG rowLoop

MOV AH, 4Ch
INT 21h

mainProc ENDP

;Start of proc to 'flip' row across vertical axis. 
flipARow PROC 
	
	MOV DI, CX
	MOV SI, CX					;Sets SI to first character on line
	ADD DI, 158					;Sets DI to last character on line

	flipLoop:
		PUSH ES:[SI] ES:[DI]
		POP ES:[SI] ES:[DI]

		ADD SI, 2				;Moves SI to next character
		SUB DI, 2				;Moves DI to previous character
		CMP SI, DI				;Checks to make sure they haven't met in the middle yet. 
		JL flipLoop
	RET

flipARow ENDP
;End of proc

MyCode ENDS
END mainProc