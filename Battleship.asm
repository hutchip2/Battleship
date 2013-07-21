################################################################################################
# Author: Paul Hutchinson
# Creation Date: October 21, 2011
# Last Modified By and Date: -
# Program Name: Battleship
# Objective: Create a battleship game where a user can play against a computer on a 10x10 board.
# Features: 
################################################################################################

.data
	welcome:	.asciiz		"Welcome to BattleShip!\n   You have three ships: ** , *** , **** \nUser - Begin by placing your ships\n"
	askShip:	.asciiz		"Enter a ship size to place (2, 3, or 4): \n"
	askCol:		.asciiz		"Enter a column number (0-9): \n"
	askRow:		.asciiz		"Enter a row letter (A-J): \n"			
	askDir:		.asciiz		"Enter a direction letter (N, S, E, W): \n"
	ERROR:		.asciiz		"ERROR: Please follow the following formats:\nShip size (2, 3, or 4)\nColumn number (0-9)\nRow letter (A-J)\nDirection letter (N, S, E, or W)\n"
	newLine:	.asciiz		"\n"
	userBoard:	.byte	0:650	# needs to be 635, give some extra space
	compBoard:	.byte	0:650	# needs to be 635, give some extra space
	viewBoard:	.byte	0:650
	userRow:	.byte	0	# [65 - 74]
	userDir:	.byte	0	# 78, 83, 69, 87
	boardPos:	.byte	0
	attackInput:	.asciiz		"Enter your attack coordinates in the following form: ('col letter', 'row number'), i.e. (B,2) \n"
	attackCoor:	.byte	0:5
	missMessage:	.asciiz		"Miss!"
	hitMessage:	.asciiz		"Hit!"
	userAttacking:	.asciiz		"User's turn!"
	compAttacking:	.asciiz		"Computer's turn!"
	userWin:	.asciiz		"Congratulations!  You won!"
	userLose:	.asciiz		"You have been defeated by the computer!"
	playAgain:	.asciiz		"Would you like to play again?"
	redoTurnMsg:	.asciiz		"You have already attacked this position!"
	sunkTwoMsg:	.asciiz		"You sunk the computer's small ship!"
	sunkThreeMsg:	.asciiz		"You sunk the computer's medium ship!"
	sunkFourMsg:	.asciiz		"You sunk the computer's large ship!"
	
	printedSunk2:	.byte	0
	printedSunk3:	.byte	0
	printedSunk4:	.byte	0
.text

main:
	li	$v0, 55
	la	$a0, welcome		# Print welcome message
	la	$a1, 1
	syscall
	jal	makeCompBoard	
	jal	makeBoard
	jal	askUser
	jal	updateBoard
	jal	return			# prints board
	jal	askUser
	jal	updateBoard
	jal	return			# prints board
	jal	askUser
	jal	updateBoard
	jal	return			# prints board
	jal	startGame
	b	end	
end:
	li	$v0, 10			# Prepare to exit the program
	syscall				# Exit the program
	
askPlayAgain:
	li	$v0, 50
	la	$a0, playAgain
	la	$a1, 3
	syscall
	beq	$a0, 0, main
	bne	$a0, 0, end
	
userWins:
	li	$v0, 55
	la	$a0, userWin
	la	$a1, 1
	syscall
	b 	askPlayAgain
compWins:
	li	$v0, 55
	la	$a0, userLose
	la	$a1, 1
	syscall
	b 	askPlayAgain
	startGame:			# initialize
		la	$s4, 0
		la	$s7, 0
		la	$s0, userBoard
		la	$s1, compBoard
		la	$s2, viewBoard
		move	$s5, $ra
		jal	buildViewBoard
	
		doCompTurn:
			li	$v0, 55
			la	$a0, compAttacking	# print compAttacking message
			la	$a1, 1
			syscall
			#generate random coordinates to attack 	TO-DO: (MAKE SURE IT DOESN'T ATTACK SAME SPOT TWICE)
			#generate row 48 - 57
			li $v0, 42 
			la $a0, 0
			li $a1, 9	
			syscall
			addi	$a0, $a0, 48
			move	$t0, $a0
			#generate col 65 - 74
			li $v0, 42
			la $a0, 0 
			li $a1, 9	
			syscall
			addi $a0, $a0, 65
			move	$t1, $a0
			#mark userBoard where computer struck
			jal	markUserBoard
			#show the updated userBoard to the usesr
			jal	return
			#check for win conditions
			jal	checkWin
		doPlayerTurn:
			# print userAttacking message
			li	$v0, 55
			la	$a0, userAttacking
			la	$a1, 1
			syscall
			#show view board (makeBoard)
			jal	printViewBoard
			#ask for col,row to attack
			jal	userAttack
			#show updated view board
			jal	printViewBoard
			#check for win
			jal	checkWin
			#end turn
			b	doCompTurn
	markUserBoard:
		li	$t2, 0	#index to mark
		#get index pos for userBoard
		beq	$t0, 48, rowNum0
		beq	$t0, 49, rowNum1
		beq	$t0, 50, rowNum2
		beq	$t0, 51, rowNum3
		beq	$t0, 52, rowNum4
		beq	$t0, 53, rowNum5
		beq	$t0, 54, rowNum6
		beq	$t0, 55, rowNum7
		beq	$t0, 56, rowNum8
		beq	$t0, 57, rowNum9
	rowNum0:
		addi	$t2, $t2, 52
		b	doCOLUMN
	rowNum1:
		addi	$t2, $t2, 111
		b	doCOLUMN
	rowNum2:
		addi	$t2, $t2, 170
		b	doCOLUMN
	rowNum3:
		addi	$t2, $t2, 229
		b	doCOLUMN
	rowNum4:
		addi	$t2, $t2, 288
		b	doCOLUMN
	rowNum5:
		addi	$t2, $t2, 347
		b	doCOLUMN
	rowNum6:
		addi	$t2, $t2, 406
		b	doCOLUMN
	rowNum7:
		addi	$t2, $t2, 465
		b	doCOLUMN
	rowNum8:
		addi	$t2, $t2, 524
		b	doCOLUMN
	rowNum9:
		addi	$t2, $t2, 583
		b	doCOLUMN
	doCOLUMN:
		beq	$t1, 65, colLetA
		beq	$t1, 66, colLetB
		beq	$t1, 67, colLetC
		beq	$t1, 68, colLetD
		beq	$t1, 69, colLetE
		beq	$t1, 70, colLetF
		beq	$t1, 71, colLetG
		beq	$t1, 72, colLetH
		beq	$t1, 73, colLetI
		beq	$t1, 74, colLetJ
	colLetA:
		addi	$t2, $t2, 0
		b	finishMark
	colLetB:
		addi	$t2, $t2, 5
		b	finishMark
	colLetC:
		addi	$t2, $t2, 10
		b	finishMark
	colLetD:
		addi	$t2, $t2, 15
		b	finishMark
	colLetE:
		addi	$t2, $t2, 20
		b	finishMark
	colLetF:
		addi	$t2, $t2, 25
		b	finishMark
	colLetG:
		addi	$t2, $t2, 30
		b	finishMark
	colLetH:
		addi	$t2, $t2, 35
		b	finishMark
	colLetI:
		addi	$t2, $t2, 40
		b	finishMark
	colLetJ:
		addi	$t2, $t2, 45
		b	finishMark
	finishMark:
		la	$s0, userBoard
		add	$s3, $s0, $t2	
		li	$t0, 0
		lb	$t0, 0($s3)
		beq	$t0, 77, doCompTurn
		beq	$t0, 72, doCompTurn
		beq	$t0, 42, compHit
		#print miss
		li	$v0, 55
		la	$a0, missMessage
		la	$a1, 1
		syscall	
		li	$t0, 77 # 'M'	# store 'M' on userBoard for a computer miss
		sb	$t0, ($s3)
		jr	$ra
	compHit:
		#print hit
		li	$v0, 55
		la	$a0, hitMessage
		la	$a1, 1
		syscall
		li	$t0, 72 # 'H'	# store 'H' on userBoard for a computer miss
		sb	$t0, ($s3)
		#INCREMENT COMPUTER HIT
		addi	$s7, $s7, 1
		jr	$ra
	checkWin:
		beq	$s4, 9, userWins	#s4 is user hit count
		beq	$s7, 9, compWins	#s7 is comp hit count
		jr	$ra
	
	
	userAttack:
		li	$v0, 54		# prepare to print string input dialog
		la	$a0, attackInput# load question to print
		la	$a1, attackCoor	# store user's answer into userRow
		la	$a2, 6		# allow a max of 4 characters to be entered (4 + newLine)
		syscall			# display the input dialog
		beq	$a1, -2, end	# 'cancel' is chosen
		beq	$a1, -3, end	# 'ok' was chose but input field is blank
		beq	$a1, -4, end	# input exceeds length
		la	$s0, attackCoor
		lb	$t0, 1($s0)	# get attack column letter
		lb	$t1, 3($s0)	# get attack row number
		la	$s2, viewBoard
		#update viewBoard
		li	$t7, 0	# contains first index number to place on board
		beq	$t1, 48, row0a
		beq	$t1, 49, row1a
		beq	$t1, 50, row2a
		beq	$t1, 51, row3a
		beq	$t1, 52, row4a
		beq	$t1, 53, row5a
		beq	$t1, 54, row6a
		beq	$t1, 55, row7a
		beq	$t1, 56, row8a
		beq	$t1, 57, row9a
			row0a:
				addi	$t7, $t7, 52
				b 	doCola
			row1a:
				addi	$t7, $t7, 111
				b 	doCola
			row2a:
				addi	$t7, $t7, 170
				b 	doCola
			row3a:
				addi	$t7, $t7, 229
				b 	doCola
			row4a:
				addi	$t7, $t7, 288
				b 	doCola
			row5a:
				addi	$t7, $t7, 347
				b 	doCola
			row6a:
				addi	$t7, $t7, 406
				b 	doCola
			row7a:
				addi	$t7, $t7, 465
				b 	doCola
			row8a:
				addi	$t7, $t7, 524
				b 	doCola
			row9a:
				addi	$t7, $t7, 583
				b 	doCola
		doCola:
			beq	$t0, 65, colAa
			beq	$t0, 66, colBa
			beq	$t0, 67, colCa
			beq	$t0, 68, colDa
			beq	$t0, 69, colEa
			beq	$t0, 70, colFa
			beq	$t0, 71, colGa
			beq	$t0, 72, colHa
			beq	$t0, 73, colIa
			beq	$t0, 74, colJa
			colAa:
				addi	$t7, $t7, 0
				b	finishShipa
			colBa:
				addi	$t7, $t7, 5
				b	finishShipa
			colCa:
				addi	$t7, $t7, 10
				b	finishShipa
			colDa:
				addi	$t7, $t7, 15
				b	finishShipa
			colEa:
				addi	$t7, $t7, 20
				b	finishShipa
			colFa:
				addi	$t7, $t7, 25
				b	finishShipa
			colGa:
				addi	$t7, $t7, 30
				b	finishShipa
			colHa:
				addi	$t7, $t7, 35
				b	finishShipa
			colIa:
				addi	$t7, $t7, 40
				b	finishShipa
			colJa:
				addi	$t7, $t7, 45
				b	finishShipa
		finishShipa:	# s2 is the user board, t7 is the position on the board, s6 is '*'	
			add	$t8, $t7, $s2	# t8 is the user board + position on board
			li	$s6, 42
			la	$s1, viewBoard
			add	$t8, $t7, $s1
			lb	$t9, ($t8)
			li	$s6, 72 		# load 'H' into s6
			beq	$t9, $s6, redoTurn	# if this position is an 'H' (72), ask user to redo turn 
			li	$s6, 77			# load 'M' into s6
			beq	$t9, $s6, redoTurn	# if this position is an 'M' (77), ask user to redo turn
			la	$s1, compBoard
			add	$t8, $t7, $s1
			lb	$t9, ($t8)
			li	$s6, 42
			beq	$t9, $s6, hit		# if this position is a '*', it's a hit
			la	$s1, viewBoard
			add	$t8, $t7, $s1
			lb	$t9, ($t8)
			#print miss
			la	$s1, viewBoard
			add	$t8, $t7, $s1
			li	$s6, 77
			sb	$s6, ($t8)
			li	$v0, 55
			la	$a0, missMessage
			la	$a1, 1
			syscall
			jr	$ra
			hit:
				la	$s1, viewBoard
				add	$t8, $t7, $s1
				li	$s6, 72
				sb	$s6, ($t8)
				li	$v0, 55
				la	$a0, hitMessage
				la	$a1, 1
				syscall
				addi	$s4, $s4, 1
				b	checkShipSunk
				returnAfterSunkCheck:
				jr	$ra
		redoTurn:
			li	$v0, 55
			la	$a0, redoTurnMsg
			la	$a1, 0
			syscall
			b	userAttack
	checkShipSunk:
		la	$s0, viewBoard
		li	$t0, 0
		li	$t1, 0
		li	$t2, 0
		li	$t3, 0
		li	$t4, 0
		
		
		checkShip2:
		lb	$t0, printedSunk2
		beq	$t0, 1, checkShip3 
		
		lb	$t0, 254($s0)	#reading dash?
		lb	$t1, 259($s0)
		add	$t2, $t0, $t1
		beq	$t2, 144, userSunk2		# 72 + 72
		
		
		checkShip3:
		lb	$t0, printedSunk3
		beq	$t0, 1, checkShip4
		
		lb	$t0, 367($s0)
		lb	$t1, 426($s0)
		lb	$t2, 485($s0)
		add	$t3, $t0, $t1
		add	$t3, $t3, $t2
		beq	$t3, 288, userSunk3		# 72 + 72 + 72
		
		checkShip4:
		lb	$t0, printedSunk3
		beq	$t0, 1, finishSunkCheck
		
		lb	$t0, 62($s0)
		lb	$t1, 121($s0)
		lb	$t2, 180($s0)
		lb	$t3, 239($s0)
		add	$t4, $t0, $t1
		add	$t4, $t4, $t2
		add	$t4, $t4, $t3
		beq	$t4, 432, userSunk4		# 72 + 72 + 72 + 72
		b	finishSunkCheck
		userSunk2:
		li	$t0, 1
		sb	$t0, printedSunk2
		
		li	$v0, 55
		la	$a0, sunkTwoMsg
		la	$a1, 1
		syscall
		b	finishSunkCheck
		userSunk3:
		li	$t0, 1
		sb	$t0, printedSunk3
		
		li	$v0, 55
		la	$a0, sunkThreeMsg
		la	$a1, 1
		syscall
		b	finishSunkCheck
		userSunk4:
		li	$t0, 1
		sb	$t0, printedSunk4
		
		li	$v0, 55
		la	$a0, sunkFourMsg
		la	$a1, 1
		syscall
		b	finishSunkCheck
		finishSunkCheck:
			b 	returnAfterSunkCheck
	updateBoard:
		li	$s6, 42
		la	$s7, userBoard
		lb	$s1, ($sp)	# s1 contains direction 	(N = 78, S = 83, E = 69, W = 87)
		addi	$sp, $sp, 4
		lb	$s2, ($sp)	# s2 contains col letter	([65 - 	74])
		addi	$sp, $sp, 4
		lb	$s3, ($sp)	# s3 contains row number	(0-9)
		addi	$sp, $sp, 4
		lb	$s4, ($sp)	# s4 contains ship size		(2, 3, or 4)
		addi	$sp, $sp, 4
		beq	$s4, 2, placeShip2
		beq	$s4, 3, placeShip3
		beq	$s4, 4, placeShip4
		placeShip2:
			li	$t7, 0	# contains first index number to place on board
			beq	$s3, 0, row02
			beq	$s3, 1, row12
			beq	$s3, 2, row22
			beq	$s3, 3, row32
			beq	$s3, 4, row42
			beq	$s3, 5, row52
			beq	$s3, 6, row62
			beq	$s3, 7, row72
			beq	$s3, 8, row82
			beq	$s3, 9, row92
			row02:
				addi	$t7, $t7, 52
				b 	doCol2
			row12:
				addi	$t7, $t7, 111
				b 	doCol2
			row22:
				addi	$t7, $t7, 170
				b 	doCol2
			row32:
				addi	$t7, $t7, 229
				b 	doCol2
			row42:
				addi	$t7, $t7, 288
				b 	doCol2
			row52:
				addi	$t7, $t7, 347
				b 	doCol2
			row62:
				addi	$t7, $t7, 406
				b 	doCol2
			row72:
				addi	$t7, $t7, 465
				b 	doCol2
			row82:
				addi	$t7, $t7, 524
				b 	doCol2
			row92:
				addi	$t7, $t7, 583
				b 	doCol2
		doCol2:
			beq	$s2, 65, colA2
			beq	$s2, 66, colB2
			beq	$s2, 67, colC2
			beq	$s2, 68, colD2
			beq	$s2, 69, colE2
			beq	$s2, 70, colF2
			beq	$s2, 71, colG2
			beq	$s2, 72, colH2
			beq	$s2, 73, colI2
			beq	$s2, 74, colJ2
			colA2:
				addi	$t7, $t7, 0
				b	finishShip2
			colB2:
				addi	$t7, $t7, 5
				b	finishShip2
			colC2:
				addi	$t7, $t7, 10
				b	finishShip2
			colD2:
				addi	$t7, $t7, 15
				b	finishShip2
			colE2:
				addi	$t7, $t7, 20
				b	finishShip2
			colF2:
				addi	$t7, $t7, 25
				b	finishShip2
			colG2:
				addi	$t7, $t7, 30
				b	finishShip2
			colH2:
				addi	$t7, $t7, 35
				b	finishShip2
			colI2:
				addi	$t7, $t7, 40
				b	finishShip2
			colJ2:
				addi	$t7, $t7, 45
				b	finishShip2
		finishShip2:	# s7 is the user board, t7 is the position on the board, s6 is '*'	
			add	$t8, $t7, $s7	# t8 is the user board + position on board
			sb	$s6, ($t8)
			beq	$s1, 78, North2
			beq	$s1, 83, South2
			beq	$s1, 69, East2
			beq	$s1, 87, West2 
			b 	finishUpdate
			North2:
				sb	$s6, -59($t8)	# store above
				b 	finishUpdate
			South2:
				sb	$s6, 59($t8)	# store below
				b 	finishUpdate
			East2:
				sb	$s6, 5($t8)	# store to the right
				b 	finishUpdate
			West2:
				sb	$s6, -5($t8)	# store to the left
				b 	finishUpdate
		placeShip3:
			li	$t7, 0	# contains first index number to place on board
			beq	$s3, 0, row03
			beq	$s3, 1, row13
			beq	$s3, 2, row23
			beq	$s3, 3, row33
			beq	$s3, 4, row43
			beq	$s3, 5, row53
			beq	$s3, 6, row63
			beq	$s3, 7, row73
			beq	$s3, 8, row83
			beq	$s3, 9, row93
			row03:
				addi	$t7, $t7, 52
				b 	doCol3
			row13:
				addi	$t7, $t7, 111
				b 	doCol3
			row23:
				addi	$t7, $t7, 170
				b 	doCol3
			row33:
				addi	$t7, $t7, 229
				b 	doCol3
			row43:
				addi	$t7, $t7, 288
				b 	doCol3
			row53:
				addi	$t7, $t7, 347
				b 	doCol3
			row63:
				addi	$t7, $t7, 406
				b 	doCol3
			row73:
				addi	$t7, $t7, 465
				b 	doCol3
			row83:
				addi	$t7, $t7, 524
				b 	doCol3
			row93:
				addi	$t7, $t7, 583
				b 	doCol3
		doCol3:
			beq	$s2, 65, colA3
			beq	$s2, 66, colB3
			beq	$s2, 67, colC3
			beq	$s2, 68, colD3
			beq	$s2, 69, colE3
			beq	$s2, 70, colF3
			beq	$s2, 71, colG3
			beq	$s2, 72, colH3
			beq	$s2, 73, colI3
			beq	$s2, 74, colJ3
			colA3:
				addi	$t7, $t7, 0
				b	finishShip3
			colB3:
				addi	$t7, $t7, 5
				b	finishShip3
			colC3:
				addi	$t7, $t7, 10
				b	finishShip3
			colD3:
				addi	$t7, $t7, 15
				b	finishShip3
			colE3:
				addi	$t7, $t7, 20
				b	finishShip3
			colF3:
				addi	$t7, $t7, 25
				b	finishShip3
			colG3:
				addi	$t7, $t7, 30
				b	finishShip3
			colH3:
				addi	$t7, $t7, 35
				b	finishShip3
			colI3:
				addi	$t7, $t7, 40
				b	finishShip3
			colJ3:
				addi	$t7, $t7, 45
				b	finishShip3
		finishShip3:	# s7 is the user board, t7 is the position on the board, s6 is '*'	
			add	$t8, $t7, $s7	# t8 is the user board + position on board
			sb	$s6, ($t8)
			beq	$s1, 78, North3
			beq	$s1, 83, South3
			beq	$s1, 69, East3
			beq	$s1, 87, West3 
			b 	finishUpdate
			North3:
				sb	$s6, -59($t8)	# store above
				sb	$s6, -118($t8)	# store above
				b 	finishUpdate
			South3:
				sb	$s6, 59($t8)	# store below
				sb	$s6, 118($t8)	# store below
				b 	finishUpdate
			East3:
				sb	$s6, 5($t8)	# store to the right
				sb	$s6, 10($t8)	# store to the right
				b 	finishUpdate
			West3:
				sb	$s6, -5($t8)	# store to the left
				sb	$s6, -10($t8)	# store to the left
				b 	finishUpdate
		placeShip4:
			li	$t7, 0	# contains first index number to place on board
			beq	$s3, 0, row04
			beq	$s3, 1, row14
			beq	$s3, 2, row24
			beq	$s3, 3, row34
			beq	$s3, 4, row44
			beq	$s3, 5, row54
			beq	$s3, 6, row64
			beq	$s3, 7, row74
			beq	$s3, 8, row84
			beq	$s3, 9, row94
			row04:
				addi	$t7, $t7, 52
				b 	doCol4
			row14:
				addi	$t7, $t7, 111
				b 	doCol4
			row24:
				addi	$t7, $t7, 170
				b 	doCol4
			row34:
				addi	$t7, $t7, 229
				b 	doCol4
			row44:
				addi	$t7, $t7, 288
				b 	doCol4
			row54:
				addi	$t7, $t7, 347
				b 	doCol4
			row64:
				addi	$t7, $t7, 406
				b 	doCol4
			row74:
				addi	$t7, $t7, 465
				b 	doCol4
			row84:
				addi	$t7, $t7, 524
				b 	doCol4
			row94:
				addi	$t7, $t7, 583
				b 	doCol4
		doCol4:
			beq	$s2, 65, colA4
			beq	$s2, 66, colB4
			beq	$s2, 67, colC4
			beq	$s2, 68, colD4
			beq	$s2, 69, colE4
			beq	$s2, 70, colF4
			beq	$s2, 71, colG4
			beq	$s2, 72, colH4
			beq	$s2, 73, colI4
			beq	$s2, 74, colJ4
			colA4:
				addi	$t7, $t7, 0
				b	finishShip4
			colB4:
				addi	$t7, $t7, 5
				b	finishShip4
			colC4:
				addi	$t7, $t7, 10
				b	finishShip4
			colD4:
				addi	$t7, $t7, 15
				b	finishShip4
			colE4:
				addi	$t7, $t7, 20
				b	finishShip4
			colF4:
				addi	$t7, $t7, 25
				b	finishShip4
			colG4:
				addi	$t7, $t7, 30
				b	finishShip4
			colH4:
				addi	$t7, $t7, 35
				b	finishShip4
			colI4:
				addi	$t7, $t7, 40
				b	finishShip4
			colJ4:
				addi	$t7, $t7, 45
				b	finishShip4
		finishShip4:	# s7 is the user board, t7 is the position on the board, s6 is '*'	
			add	$t8, $t7, $s7	# t8 is the user board + position on board
			sb	$s6, ($t8)
			beq	$s1, 78, North4
			beq	$s1, 83, South4
			beq	$s1, 69, East4
			beq	$s1, 87, West4 
			b 	finishUpdate
			North4:
				sb	$s6, -59($t8)	# store above
				sb	$s6, -118($t8)	# store above
				sb	$s6, -177($t8)	# store above
				b 	finishUpdate
			South4:
				sb	$s6, 59($t8)	# store below
				sb	$s6, 118($t8)	# store below
				sb	$s6, 177($t8)	# store below
				b 	finishUpdate
			East4:
				sb	$s6, 5($t8)	# store to the right
				sb	$s6, 10($t8)	# store to the right
				sb	$s6, 15($t8)	# store to the right
				b 	finishUpdate
			West4:
				sb	$s6, -5($t8)	# store to the left
				sb	$s6, -10($t8)	# store to the left
				sb	$s6, -15($t8)	# store to the left
				b 	finishUpdate
		finishUpdate:
			jr	$ra
	makeCompBoard:
		li	$t0, 124	# '|'
		li	$t1, 45		# '-'
		li	$t2, 32		# ' '
		lb	$t3, newLine	# load the new line character
		li	$t4, 0		# counter
		la	$s2, compBoard	# load the address of the board
		li	$t5, 65		# 'A', used to label rows
		li	$t6, 48		# '1', used to label cols
		doColsc:
			# A
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t2, 4($s2)	# store ' '
			sb	$t2, 5($s2)	# store ' '
			sb	$t2, 6($s2)	# store ' '
			sb	$t5, 7($s2)	# store 'A'
			addi	$s2, $s2, 8	# increment the board array by 8
			addi	$t5, $t5, 1	# increment the counter by 1
			# B
			sb	$t2, 0($s2)	# store ' '	
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'B'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# C
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'C'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# D
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'D'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# E
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'E'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# F
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'F'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# G
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'G'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# H
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'H'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# I
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'I'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# J
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'J'
			sb	$t3, 4($s2)	# store new line
			addi	$s2, $s2, 5	# increment user board array by 5
			addi	$t5, $t5, 1	# increment row letter by 1
		doRowc:
			beq	$t4, 10, returnc	# if $t4 = 10, finish building board
			sb	$t6, 0($s2)	# store row number [0-9]			
			sb	$t2, 1($s2)	# store ' '
			addi	$t6, $t6, 1
			addi	$s2, $s2, 2
			sb	$t0, 0($s2)	# store |
			addi	$s2, $s2, 1
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t0, 4($s2)	# store |
			sb	$t3, 5($s2)	# store new line
			addi	$s2, $s2, 6	# increment board array by 6
			addi	$t4, $t4, 1	# increment counter by 1
			b 	doRowc		# iterate
			returnc:
				la	$s2, compBoard	# load computer board into $s2
				li	$t0, 42		# load '*' into $t0
				# Place ship 2
				sb	$t0, 254($s2)
				sb	$t0, 259($s2)
				# Place ship 3
				sb	$t0, 367($s2)
				sb	$t0, 426($s2)
				sb	$t0, 485($s2)
				# Place ship 4
				sb	$t0, 62($s2)
				sb	$t0, 121($s2)
				sb	$t0, 180($s2)
				sb	$t0, 239($s2)
				jr	$ra
	askUser:
		# Ask the user for ship
		li	$v0, 51		# prepare to print an integer input dialog
		la	$a0, askShip	# load the address of the question
		syscall			# show the dialog to the user
		beq	$a1, -1, end	# data cannot be parsed
		beq	$a1, -2, end	# 'cancel' is chosen
		beq	$a1, -3, end	# 'ok' was chose but input field is blank
		blt 	$a0, 2, error	# print error if user inputs a number less than 2
		bgt	$a0, 4, error	# print error if user inputs a number greather than 4
		addi	$sp, $sp, -4	# decrement the stack pointer by 4
		sw	$a0, ($sp)	# store the user's response into the stack
		# Ask the user for column
		li	$v0, 51		# prepare to print an integer input dialog
		la	$a0, askCol	# load the address of the question
		syscall			# show the dialog to the user
		beq	$a1, -1, end	# data cannot be parsed
		beq	$a1, -2, end	# 'cancel' is chosen
		beq	$a1, -3, end	# 'ok' was chose but input field is blank
		blt 	$a0, 0, error	# print error if the user inputs a number less than 0
		bgt	$a0, 9, error	# print error if the user inputs a number greater than 9
		addi	$sp, $sp, -4
		sw	$a0, ($sp)
		# Ask the user for row
		li	$v0, 54		# prepare to print string input dialog
		la	$a0, askRow	# load question to print
		la	$a1, userRow	# store user's answer into userRow
		la	$a2, 2		# allow a max of 2 characters to be entered (1 + newLine)
		syscall			# display the input dialog
		beq	$a1, -2, end	# 'cancel' is chosen
		beq	$a1, -3, end	# 'ok' was chose but input field is blank
		beq	$a1, -4, end	# input exceeds length
		la	$t0, userRow	# load the user's entry into $s0		
		lb	$t0, ($t0)	# load the letter of the user's entry
		blt 	$t0, 65, error	# print error if the letter is less than 'A'
		bgt	$t0, 74, error	# print error if the letter is greater than 'J'
		addi	$sp, $sp, -4
		sb	$t0, ($sp) #lw $xx, ($sp) to get
		# Ask the user for direction
		li	$t1, 0		# counter for error checking
		li	$v0, 54		# prepare to print a string input dialog
		la	$a0, askDir	# load question to print
		la	$a1, userDir	# store the user's answer into userDir
		la	$a2, 2		# allow a max of 2 characters to be entered (1 + newLine)
		syscall			# display the input dialog
		beq	$a1, -2, end	# 'cancel' is chosen
		beq	$a1, -3, end	# 'ok' was chose but input field is blank
		beq	$a1, -4, end	# input exceeds length
		la	$t0, userDir	# load the user's entry into $s0
		lb	$t0, ($t0)	# load the letter of the user's entry
		check1:	
			bne	$t0, 69, increment1	# check if the user's answer is 'E'
		check2:	
			bne	$t0, 78, increment2	# check if the user's answer is 'N'
		check3:
			bne	$t0, 83, increment3	# check if the user's answer is 'S'
		check4:
			bne	$t0, 87, increment4	# check if the user's answer is 'W'
		errorCheckDone:
			beq	$t1, 4, error		# if the user's answer isn't 'E, N, S, or W', then print error
			addi	$sp, $sp, -4
			sb	$t0, ($sp) #lw $xx, ($sp) to get
			jr	$ra			# jump back to return address in $ra
	makeBoard:
		li	$t0, 124	# '|'
		li	$t1, 45		# '-'
		li	$t2, 32		# ' '
		lb	$t3, newLine	# load the new line character
		li	$t4, 0		# counter
		la	$s0, userBoard	# load the address of the board
		li	$t5, 65		# 'A', used to label rows
		li	$t6, 48		# '1', used to label cols
		doCols:
			# A
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t2, 4($s0)	# store ' '
			sb	$t2, 5($s0)	# store ' '
			sb	$t2, 6($s0)	# store ' '
			sb	$t5, 7($s0)	# store 'A'
			addi	$s0, $s0, 8	# increment the board array by 8
			addi	$t5, $t5, 1	# increment the counter by 1
			# B
			sb	$t2, 0($s0)	# store ' '	
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'B'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# C
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'C'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# D
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'D'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# E
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'E'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# F
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'F'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# G
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'G'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# H
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'H'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# I
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'I'
			addi	$s0, $s0, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# J
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t5, 3($s0)	# store 'J'
			sb	$t3, 4($s0)	# store new line
			addi	$s0, $s0, 5	# increment user board array by 5
			addi	$t5, $t5, 1	# increment row letter by 1
		doRow:
			beq	$t4, 10, return	# if $t4 = 10, finish building board
			sb	$t6, 0($s0)	# store row number [0-9]			
			sb	$t2, 1($s0)	# store ' '
			addi	$t6, $t6, 1
			addi	$s0, $s0, 2
			sb	$t0, 0($s0)	# store |
			addi	$s0, $s0, 1
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t1, 4($s0)	# store -
			addi	$s0, $s0, 5
			sb	$t2, 0($s0)	# store ' '
			sb	$t2, 1($s0)	# store ' '
			sb	$t2, 2($s0)	# store ' '
			sb	$t2, 3($s0)	# store ' '
			sb	$t0, 4($s0)	# store |
			sb	$t3, 5($s0)	# store new line
			addi	$s0, $s0, 6	# increment board array by 6
			addi	$t4, $t4, 1	# increment counter by 1
			b 	doRow		# iterate
			return:
				li	$v0, 55
				la	$a0, userBoard
				la	$a1, 1
				syscall
				jr	$ra
	buildViewBoard:
		li	$t0, 124	# '|'
		li	$t1, 45		# '-'
		li	$t2, 32		# ' '
		lb	$t3, newLine	# load the new line character
		li	$t4, 0		# counter
		la	$s2, viewBoard	# load the address of the board
		li	$t5, 65		# 'A', used to label rows
		li	$t6, 48		# '1', used to label cols
		doCols2:
			# A
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t2, 4($s2)	# store ' '
			sb	$t2, 5($s2)	# store ' '
			sb	$t2, 6($s2)	# store ' '
			sb	$t5, 7($s2)	# store 'A'
			addi	$s2, $s2, 8	# increment the board array by 8
			addi	$t5, $t5, 1	# increment the counter by 1
			# B
			sb	$t2, 0($s2)	# store ' '	
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'B'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# C
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'C'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# D
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'D'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# E
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'E'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# F
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'F'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# G
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'G'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# H
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'H'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# I
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'I'
			addi	$s2, $s2, 4	# increment the board array by 4
			addi	$t5, $t5, 1	# increment row letter by 1
			# J
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t5, 3($s2)	# store 'J'
			sb	$t3, 4($s2)	# store new line
			addi	$s2, $s2, 5	# increment user board array by 5
			addi	$t5, $t5, 1	# increment row letter by 1
		doRow2:
			beq	$t4, 10, finish2	# if $t4 = 10, finish building board
			sb	$t6, 0($s2)	# store row number [0-9]			
			sb	$t2, 1($s2)	# store ' '
			addi	$t6, $t6, 1
			addi	$s2, $s2, 2
			sb	$t0, 0($s2)	# store |
			addi	$s2, $s2, 1
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t1, 4($s2)	# store -
			addi	$s2, $s2, 5
			sb	$t2, 0($s2)	# store ' '
			sb	$t2, 1($s2)	# store ' '
			sb	$t2, 2($s2)	# store ' '
			sb	$t2, 3($s2)	# store ' '
			sb	$t0, 4($s2)	# store |
			sb	$t3, 5($s2)	# store new line
			addi	$s2, $s2, 6	# increment board array by 6
			addi	$t4, $t4, 1	# increment counter by 1
			b 	doRow2		# iterate
			finish2:
				jr	$ra
			printViewBoard:
				li	$v0, 55
				la	$a0, viewBoard
				la	$a1, 1
				syscall
				jr	$ra		
error:
	li	$v0, 55		# prepare to print an information dialog
	la	$a0, ERROR	# load the address of the string
	la	$a1, 0		# set the dialog to an 'error' dialog
	syscall			# print the error
	b 	askUser		
increment1:
	addi	$t1, $t1, 1	# increment error variable, user's answer didn't match 'E'
	b 	check2	
increment2:	
	addi	$t1, $t1, 1	# increment error variable, user's answer didn't match 'N'
	b 	check3	
increment3:
	addi	$t1, $t1, 1	# increment error variable, user's answer didn't match 'S'
	b 	check4	
increment4:
	addi	$t1, $t1, 1	# increment error variable, user's answer didn't match 'W'
	b 	errorCheckDone
