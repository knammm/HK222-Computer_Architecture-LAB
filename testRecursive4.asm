.data

boardArray: .byte ' ', ' ',' ',' ',' ',' ',' '
	    .byte ' ', ' ',' ',' ',' ',' ',' '
	    .byte ' ', ' ',' ',' ',' ',' ',' '
	    .byte ' ', ' ',' ',' ',' ',' ',' '
	    .byte ' ', ' ',' ',' ',' ',' ',' '
	    .byte ' ', ' ',' ',' ',' ',' ',' ' 	# Array represent for board
size: .word 6, 7 # row and column
Xchar: .byte 'X'
Ochar: .byte 'O'
spaceChar: .byte ' '
removeCount: .word 1, 1, 1, 1
.eqv DATA_SIZE 1

printWelcome: .asciiz "\n Welcome to 4 In A Row game developed by Nguyen Khanh Nam ! \n This game used MIPS to run the process.\n Here are some information that you should know before starting the game: "
printGuide: .asciiz "\n Four in a Row is the classic two player game where you take turns to place a counter in an upright grid and try and beat your opponent to place 4 counters in a row. \n 1. The game is played with a seven-column and six-row grid, which is arranged upright. \n 2. The players choose their name, and a game piece (X or O) is assigned to them randomly. \n 3. The aim is to be the first of the two players to connect four pieces of the same colour vertically, horizontally or diagonally. \n 4. If each cell of the grid is filled and no player has already connected four pieces, the game ends in a draw, so no player wins.\n Finally, have fun and enjoy the game !"
printStartGame: .asciiz "\n\n\n -------------------- Now let the game begin --------------------\n\n"
selectName1: .asciiz "\n Please enter Player 1's name: "
selectName2: .asciiz "\n Please enter Player 2's name: "
userName1: .space 25
userName2: .space 25
printWall: .asciiz " | "
printEndl: .asciiz "\n"
printFloor: .asciiz " +---+---+---+---+---+---+---+\n"
printCommand1: .asciiz " <--- Pick a number from this interval\n"
printCommand2: .asciiz " It's your turn. Please choose a number 1-7: "
printCommand3: .asciiz " Player "
printRandom: .asciiz "\n Randomly selected X or O to each player: "
printRandom1: .asciiz " Player 1 will be X and Player 2 will be O.\n"
printRandom2: .asciiz " Player 1 will be O and Player 2 will be X.\n"
firstMoveError1: .asciiz "\n First move must be in center(number 4) ! Please enter again. "
firstMoveError2: .asciiz "\n Oops, you've entered wrong 3 times. Good luck for the next game ~~"
setError: .asciiz " The column is full ! Please enter again.\n"
playerWin: .asciiz "\n Game is over ! The winner is: "
MoveError: .asciiz "\n The number is out of range, please enter again !\n"
Winner: .asciiz "\n We have found the winner: "
DrawGame: .asciiz "\n The game ended up in a tie !\n"
callUndo: .asciiz " Do you want to undo your move ? If yes, press 1, else press any number to quit: "
undoRemaining: .asciiz "\n Undo remaining: "
clearConsole: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
violentRemaining: .asciiz "\n Your violent remaining: "
removeCommand1: .asciiz " Please enter the column number 1-7: "
removeCommand2: .asciiz " Please enter the row number 1-6: "
removeRemaining: .asciiz "\n Your remove remaining: "
printCommand4: .asciiz "\n Please select a choice as follow:\n 1. Move.\n 2. Remove opponent's piece."
printCommand5: .asciiz "\n Your choice: "
blockRemaining: .asciiz "\n Your block remaining: "
callBlock: .asciiz " Do you want to block opponent's move ? If yes, press 1, else press any number to quit: "
.text
############ main ###################
main:
	li $s5, 3 # player1's undo
	li $s6, 3 # player2's undo
	la $s7, removeCount # Players' remove count
	li $t8, 3 # Counter violent p2
	li $t7, 3 # Counter violent p1
	jal greeting
	jal printRandomSelect
	jal drawTable
	# Player 1 first turn
	jal printPlayer1Turn
	jal first1Move
	beq $t9, 1,  ExitProgram
	add $a0, $t0, $0
	addi $a1, $0, 1 # player 1 choose
	jal setInTable
	jal clean # clear concole
	jal drawTable
	# Player 2 first turn
	jal printPlayer2Turn
	jal first2Move
	beq $t9, 1,  ExitProgram
	add $a0, $t1, $0
	addi $a1, $0, 2 # player 1 choose
	jal setInTable
	jal clean # clear concole
	jal drawTable
	
LoopGame:

player1Set:
	li $t9, 0 # Check violent
	li $t3, 0 # set flag for remove
	ViolentLoop1:
		jal printPlayer1Turn
		# flag check remove $t3
		beq $t3, 1, chooseRemove_p1
		dontRemove_p1:
			jal player1Move
			add $a0, $t0, $0
			addi $a1, $0, 1 # player 1 choose
			jal setInTable
			beq $t9, 0, ExitViolent1 # if the player enter correct, exit loop
		
			addi $t7, $t7, -1
			# print endl
			li $v0, 4
			la $a0, printEndl
			syscall
		
			beq $t7, -1, throwExceptionV_p1 # wrong 3 times -> other player win
		j ViolentLoop1
	ExitViolent1:
	jal clean
	jal drawTable
	jal checkEnd
	# Undo call
	beq $s5, 0, chooseNoUndo_p1 # undo counter
	# print player's name
	li $v0, 4
	la $a0, printCommand3
	syscall
	
	li $v0, 4
	la $a0, userName1
	syscall
	# undo func
	jal Undo # call undo 1
	beq $t0, 1, undoSuccess_p1 # if flag = 1, call back player's turn
	j chooseNoUndo_p1 # else, player dont undo
	# If case
	undoSuccess_p1:
		addi $s5, $s5, -1 # undo turn - 1
		li $t9, 0 # Check violent
		ViolentLoop3:
			jal printPlayer1Turn
			jal player1Move
			add $a0, $t0, $0
			addi $a1, $0, 1 # player 1 choose
			jal setInTable
			beq $t9, 0, ExitViolent3 # if the player enter correct, exit loop
			addi $t7, $t7, -1
			# print endl
			li $v0, 4
			la $a0, printEndl
			syscall
			beq $t7, -1, throwExceptionV_p1 # wrong 3 times -> other player win
			j ViolentLoop3
		ExitViolent3:
		j chooseNoUndo_p1
		
	# player 1 choose remove will teleport to this
	chooseRemove_p1:
		li $t3, 0 # set back flag to false
		jal clean # clear concole
		jal drawTable
		checkEndLoop1: # case remove but there's a player win
			beq $s2, 0, exitCheckEndLoop1
			jal checkEnd
			addi $s2, $s2, -1
			j checkEndLoop1
		exitCheckEndLoop1:
		j finishPlayer1
		
	chooseNoUndo_p1:
		jal clean # clear concole
		jal drawTable
		jal checkEnd
		# print endl
		li $v0, 4
		la $a0, printEndl
		syscall
		
	# block function
	blockPlayer1:
		lw $t0, 8($s7)
		beq $t0, 0, finishPlayer1 # if player's block turn = 0, jump straight
		# print player name
		li $v0, 4
		la $a0, printCommand3
		syscall
		
		li $v0, 4
		la $a0, userName1
		syscall
		
		# call block func
		jal blockFunc # the input will store to $t0
		beq $t0, 1, blockSuccess_p1
		j finishPlayer1
	
		blockSuccess_p1:
			li $t0, 0
			sw $t0, 8($s7) # block turn = 0
			jal clean
			jal drawTable
			j player1Set
		
	finishPlayer1:
	# for decoration
	jal clean
	jal drawTable
player2Set:
	li $t9, 0 # Check violent
	li $t3, 0
	ViolentLoop2:
		jal printPlayer2Turn
		# flag check remove $t3
		beq $t3, 1, chooseRemove_p2
		dontRemove_p2:
			jal player2Move
			add $a0, $t1, $0
			addi $a1, $0, 2 # player 2 choose
			jal setInTable
			beq $t9, 0, ExitViolent2
			addi $t8, $t8, -1
			# print endl
			li $v0, 4
			la $a0, printEndl
			syscall
			beq $t8, -1, throwExceptionV_p2 # wrong 3 times -> other player win
		j ViolentLoop2
		
	ExitViolent2:
	jal clean
	jal drawTable
	jal checkEnd
	# call undo 2
	beq $s6, 0, chooseNoUndo_p2

	# print player's name
	li $v0, 4
	la $a0, printCommand3
	syscall
	
	li $v0, 4
	la $a0, userName2
	syscall
	# undo func
	jal Undo # call undo
	beq $t0, 1, undoSuccess_p2 # if flag = 1, call back player's turn
	j chooseNoUndo_p2 # else, player dont undo
	# If case
	undoSuccess_p2:
		addi $s6, $s6, -1 # undo turn -1
		li $t9, 0 # Check violent
		ViolentLoop4:
			jal printPlayer2Turn
			jal player2Move
			add $a0, $t1, $0
			addi $a1, $0, 2 # player 2 choose
			jal setInTable
			beq $t9, 0, ExitViolent4
			addi $t8, $t8, -1
			# print endl
			li $v0, 4
			la $a0, printEndl
			syscall
			beq $t8, -1, throwExceptionV_p2 # wrong 3 times -> other player win
			j ViolentLoop4
		ExitViolent4:
		j chooseNoUndo_p2
		
		# player 2 choose remove will teleport to this
		chooseRemove_p2:
		li $t3, 0 # set back flag to false
		jal clean # clear concole
		jal drawTable
		checkEndLoop2: # case remove but there's a player win
			beq $s2, 0, exitCheckEndLoop2
			jal checkEnd
			addi $s2, $s2, -1
			j checkEndLoop2
		exitCheckEndLoop2:
		j finishPlayer2
	
	chooseNoUndo_p2:
		jal clean # clear concole
		jal drawTable
		jal checkEnd
		# print endl
		li $v0, 4
		la $a0, printEndl
		syscall
	
	# block function
	blockPlayer2:
		lw $t0, 12($s7)
		beq $t0, 0, finishPlayer2 # if player's block turn = 0, jump straight
		# print player name
		li $v0, 4
		la $a0, printCommand3
		syscall
		
		li $v0, 4
		la $a0, userName2
		syscall
		# call block func
		jal blockFunc # the input will store to $t0
		beq $t0, 1, blockSuccess_p2
		j finishPlayer2
	
		blockSuccess_p2:
			li $t0, 0
			sw $t0, 12($s7) # block turn = 0
			jal clean
			jal drawTable
			j player2Set
	
	finishPlayer2:
	# for decoration
	jal clean
	jal drawTable
	j LoopGame
	
	
######## Block Function  #######################
blockFunc:
	li $v0, 4
	la $a0, callBlock
	syscall
	# get user input
	li $v0, 5
	syscall
	move $t0, $v0
	jr $ra
	
######## Remove Function #######################
removeFunc:
	li $v0, 4
	la $a0, removeCommand1
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $t1, 8
	slt $t2, $t0, $t1 # $t0 < 8
	slt $t3, $0, $t0  # 0 < $t0
	and $t2, $t2, $t3
	bne $t2, 1, throwErrorCol # if now follow throw error 
	j correctCol
throwErrorCol:
	li $v0, 4
	la $a0, MoveError
	syscall
	j removeFunc
	
correctCol:
	li $v0, 4
	la $a0, removeCommand2
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	li $t2, 7
	slt $t3, $t1, $t2 # $t1 < 7
	slt $t4, $0, $t1 # 0 < $t1
	and $t2, $t3, $t4
	bne $t2, 1, throwErrorRow # if not follow the rule throw error
	j correctRow
throwErrorRow:
	li $v0, 4
	la $a0, MoveError
	syscall
	j correctCol
	
correctRow: 
	addi $t0, $t0, -1
	addi $t1, $t1, -1
	# set back $s1, $s2 to check if after remove, there's a winner
	move $s3, $t0 # store the column
	move $s2, $t1 # store the row
	li $t3, 7 # colSize
	# $t0 is column idx
	# $t1 is row idx 

	removeLoop:
		beq $t1, 0, exitRemoveLoop	
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t0 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		
		lb $t5, -7($t4) # load a[i-1][j]
		sb $t5, 0($t4)  # store to a[i][j]
		
		addi $t1, $t1, -1
		j removeLoop
	exitRemoveLoop:
	# $t1 is now = 0
	mul $t4, $t1, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 #  + colIndex
	mul $t4, $t4, DATA_SIZE # * DATASIZE
	add $t4, $t4, $s0 # + base address
	lb $t5, spaceChar
	sb $t5, 0($t4)
	li $t3, 1 # flag check remove
	jr $ra
	
######## Violent Exception #####################
throwExceptionV_p1:
	jal clean
	jal drawTable
	li $v0, 4
	la $a0, firstMoveError2
	syscall
	# add back stack
	# print winner
	li $v0, 4
	la $a0, playerWin
	syscall
	
	li $v0, 4
	la $a0, userName2
	syscall
	
	j ExitProgram
	
throwExceptionV_p2:
	jal clean
	jal drawTable
	li $v0, 4
	la $a0, firstMoveError2
	syscall
	# add back stack
	# print winner
	li $v0, 4
	la $a0, playerWin
	syscall
	
	li $v0, 4
	la $a0, userName1
	syscall
	
	j ExitProgram
	
######## Undo move #############################
	# s2 store the row index
	# s3 store the column index
	# s4 store the character of player
Undo:
	# call stack
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	add $t1, $s2, $0 # t1 store row idx
	add $t2, $s3, $0 # t2 store col idx
	li $t3, 7 # colSize
	# call undo
	li $v0, 4
	la $a0, callUndo
	syscall
	
	li $v0, 5
	syscall
	add $t0, $v0, $0 # t0 store the value of choice
	
	beq $t0, 1, doUndo
	j notUndo
	
	doUndo:
	lb $t0, spaceChar # t0 = ' '
	# Load address
	mul $t4, $t1, $t3 # rowIndex * colSize
	add $t4, $t4, $t2 #  + colIndex
	mul $t4, $t4, DATA_SIZE # * DATASIZE
	add $t4, $t4, $s0 # + base address
	# Replace by ' '
	sb $t0, 0($t4)

	# draw table
	jal clean
	jal drawTable
	li $t0, 1 # flag variables
	# return stack
	lw $ra, 0($sp)
	add $sp, $sp, 4 
	jr $ra
	
	notUndo:
	jal clean # clear concole
	jal drawTable
	li $t0, 0 # flag variable
	lw $ra, 0($sp)
	add $sp, $sp, 4 
	jr $ra
		

######## Print Welcome and Guide ###############
greeting:
	li $v0, 4
	la $a0, printWelcome
	syscall
	
	li $v0, 4
	la $a0, printGuide
	syscall
	
	li $v0, 4
	la $a0, printStartGame
	syscall
	# Get player 1's name
	li $v0, 4
	la $a0, selectName1
	syscall
	
	li $v0, 8
	la $a0, userName1
	li $a1, 35
	syscall
	# Get player 2's name
	li $v0, 4
	la $a0, selectName2
	syscall
	
	li $v0, 8
	la $a0, userName2
	li $a1, 35
	syscall
	
	jr $ra
############ Draw table #############
drawTable:
	la $s0, boardArray
	la $t0, size
	lw $t3, 0($t0)  # rowNum
	lw $t4, 4($t0)  # colNum
	
	add $t0, $0, $0 # i = 0
	add $t1, $0, $0 # j = 0
	j printBoard
	exitPrintBoard:
		# print endl
		li $v0, 4
		la $a0, printEndl
		syscall
		jr $ra
printBoard:
		# print floor
		li $v0, 4
		la $a0, printFloor
		syscall
	Loop1:
		beq $t0, $t3, ExitLoop1  # if i == numRow, exit loop
		
	Loop2:
		# Print wall
		li $v0, 4
		la $a0, printWall
		syscall
		
		beq $t1, $t4, ExitLoop2 # if j == numCol, exit loop 
		# cout << arr[i][j]
		mul $t2, $t0, $t4      # rowIndex * colSize
		add $t2, $t2, $t1      # + colIndex
		mul $t2, $t2, DATA_SIZE # * dataSize
		add $t2, $t2, $s0       # + baseAddr
		
		lb $a0, 0($t2)  # value of arr[i][j]
		li $v0, 11  # print value
		syscall
		addi $t1, $t1, 1 # j++
		j Loop2
	ExitLoop2:
		addi $t0, $t0, 1 # i++
		add $t1, $0, $0  # j == 0
		li $v0, 4
		la $a0, printEndl  # cout << endl;
		syscall
		# print floor
		li $v0, 4
		la $a0, printFloor
		syscall
		j Loop1
	ExitLoop1:
		# Print number to pick
		addi $t0, $0, 1
		addi $t1, $t1, 0
	Loop3: # Printing |1|2|3|4|5|...
		# Print wall
		li $v0, 4
		la $a0, printWall
		syscall
		beq $t1, 7, ExitLoop3
		# Print num
		add $a0, $t0, $0
		li $v0, 1 
		syscall
		# num++, count++
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j Loop3
	ExitLoop3:
		li $v0, 4
		la $a0, printCommand1
		syscall
		
		li $v0, 4
		la $a0, printFloor
		syscall
		j exitPrintBoard

############ Select random #############
printRandomSelect:
	li $v0, 4
	la $a0, printRandom
	syscall
	# sleep 1.5s
	li $a0, 1500
	li $v0, 32
	syscall
	# Pick a random number
	li $v0, 41
	syscall
	add $t0, $a0, $0	
	andi $t0, $t0, 1
	beq $t0, 1, case2
	case1:
		addi $s1, $0, 1 # bien danh dau
		li $v0, 4
		la $a0, printRandom1
		syscall
		li $v0, 4
		la $a0, printEndl
		syscall
		# sleep 1s
		li $a0, 1000
		li $v0, 32
		syscall
		j exitCase
	case2:
		addi $s1, $0, 2 # bien danh dau
		li $v0, 4
		la $a0, printRandom2
		syscall
		li $v0, 4
		la $a0, printEndl
		syscall
		# sleep 1s
		li $a0, 1000
		li $v0, 32
		syscall
	exitCase:
		jr $ra

############### Print player's turn ##############
############### Print player 1's turn ##############
printPlayer1Turn:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
printChoice_p1:
	li $v0, 4
	la $a0, printCommand3
	syscall
	# Print player1 name
	li $v0, 4
	la $a0, userName1
	syscall
	
	# print violent remaining
	li $v0, 4
	la $a0, violentRemaining
	syscall
	li $v0, 1
	move $a0, $t7
	syscall
	# print number of undo turns
	li $v0, 4
	la $a0, undoRemaining
	syscall
	
	move $a0, $s5
	li $v0, 1
	syscall
	# print remove remaining
	li $v0, 4
	la $a0, removeRemaining
	syscall
	
	li $v0, 1
	lw $t1, 0($s7) # take the remove remaining in array
	move $a0, $t1
	syscall
	# print block remaining
	li $v0, 4
	la $a0, blockRemaining
	syscall
	
	li $v0, 1
	lw $t0, 8($s7) # take the block remaining in array
	move $a0, $t0
	syscall
	
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	# Check possible remove
	beq $t1, 1, twoChoices_p1
	j moveChoice_p1

twoChoices_p1:
	# print 2 choices
	li $v0, 4
	la $a0, printCommand4
	syscall
	
	li $v0, 4
	la $a0, printCommand5
	syscall
	
	# get input
	li $v0, 5
	syscall
	move $t1, $v0
	
	beq $t1, 1, moveChoice_p1
	beq $t1, 2, removeChoice_p1
	j invalidNum_p1

removeChoice_p1:
	# set remove count = 0
	li $t1, 0
	la $t2, removeCount
	sw $t1, 0($t2)
	# remove
	jal removeFunc
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

moveChoice_p1:	
	li $v0, 4
	la $a0, printCommand2
	syscall
	# Get input from player
	li $v0, 5
	syscall
	add $t0, $v0, $0 # t0 contains the input of player 1
	
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

invalidNum_p1:
	addi $t7, $t7, -1 # violent -1
	beq $t7, -1, throwExceptionV_p1
	jal clean
	# print Error message
	li $v0, 4
	la $a0, MoveError
	syscall
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable
	j printChoice_p1

############### Print player 2's turn ##############
printPlayer2Turn:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
printChoice_p2:
	li $v0, 4
	la $a0, printCommand3
	syscall
	# Print player2 name
	li $v0, 4
	la $a0, userName2
	syscall
	
	# print violent remaining
	li $v0, 4
	la $a0, violentRemaining
	syscall
	li $v0, 1
	move $a0, $t8
	syscall	
	# print number of undo turns
	li $v0, 4
	la $a0, undoRemaining
	syscall
	
	move $a0, $s6
	li $v0, 1
	syscall
	# print remove remaining
	li $v0, 4
	la $a0, removeRemaining
	syscall
	
	li $v0, 1
	lw $t1, 4($s7) # take the move remaining in array
	move $a0, $t1
	syscall
		
	# print block remaining
	li $v0, 4
	la $a0, blockRemaining
	syscall
	
	li $v0, 1
	lw $t0, 12($s7) # take the block remaining in array
	move $a0, $t0
	syscall

	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	# Check possible remove
	beq $t1, 1, twoChoices_p2
	j moveChoice_p2

twoChoices_p2:
	# print 2 choices
	li $v0, 4
	la $a0, printCommand4
	syscall
	
	li $v0, 4
	la $a0, printCommand5
	syscall
	
	# get input
	li $v0, 5
	syscall
	move $t1, $v0
	
	beq $t1, 1, moveChoice_p2
	beq $t1, 2, removeChoice_p2
	j invalidNum_p2

removeChoice_p2:
	# set remove count = 0
	li $t1, 0
	la $t2, removeCount
	sw $t1, 4($t2)
	# remove
	jal removeFunc
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

moveChoice_p2:
	li $v0, 4
	la $a0, printCommand2
	syscall
	# Get input from player
	li $v0, 5
	syscall
	add $t1, $v0, $0 # t1 contains the input of player 2
	
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

invalidNum_p2:
	addi $t8, $t8, -1 # violent -1
	beq $t8, -1, throwExceptionV_p2
	jal clean
	# send Error message
	li $v0, 4
	la $a0, MoveError
	syscall
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable
	j printChoice_p2
	
####################### FIRST MOVE PLAYER 1 #####################
first1Move:
	add $t2, $0, $0 # count
	addi $sp, $sp, -4
	sw $ra, 0($sp)
LoopF1M:  
	beq $t0, 4, SUCCESS1
	addi $t2, $t2, 1
	jal clean
	# print error 1
	li $v0, 4
	la $a0, firstMoveError1
	syscall
	
	addi $t7, $t7, -1
	beq $t7, -1, overThree1 # if more than 3, other player win
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable # draw table then print player turn
	jal printPlayer1Turn
	j LoopF1M

SUCCESS1:
	# load back $ra
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
overThree1:
	# draw table and print win message
	jal clean
	jal drawTable
	
	li $v0, 4
	la $a0, firstMoveError2
	syscall
	# add back stack
	# print winner
	li $v0, 4
	la $a0, playerWin
	syscall
	
	li $v0, 4
	la $a0, userName2
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j ExitProgram
####################### FIRST MOVE PLAYER 2 #####################
first2Move:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
LoopF2M:  
	beq $t1, 4, SUCCESS2
	addi $t2, $t2, 1
	jal clean
	# print error 1
	li $v0, 4
	la $a0, firstMoveError1
	syscall
	
	addi $t8, $t8, -1
	beq $t8, -1, overThree2 # if more than 3, other player win
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable
	jal printPlayer2Turn
	j LoopF2M

SUCCESS2:
	# load back $ra
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
overThree2:
	# draw table and print win message
	jal clean
	jal drawTable
	li $v0, 4
	la $a0, firstMoveError2
	syscall
	# add back stack
	# print winner
	li $v0, 4
	la $a0, playerWin
	syscall
	
	li $v0, 4
	la $a0, userName1
	syscall
	
	li $t9, 1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j ExitProgram
####################### PLAYER 1 MOVE #####################
player1Move:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
LoopP1M:
	li $t5, 8
	slt $t3, $t0, $t5 # t1 < 8
	slt $t4, $0, $t0 # 0 < t1
	and $t3, $t3, $t4
	beq $t3, 1, SUCCESSP1M
	addi $t7, $t7, -1
	beq $t7, -1, overThree3 # if more than 3, other player win
	# print error 1
	jal clean
	li $v0, 4
	la $a0, MoveError
	syscall
	li $v0, 4
	la $a0, printEndl
	syscall
	# draw table
	jal drawTable
	jal printPlayer1Turn
	j LoopP1M

SUCCESSP1M:
	# load back $ra
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
overThree3:
	jal clean
	jal drawTable
	# Print sorry message
	li $v0, 4
	la $a0, firstMoveError2
	syscall
	# add back stack
	# print winner
	li $v0, 4
	la $a0, playerWin
	syscall
	
	li $v0, 4
	la $a0, userName2
	syscall
	
	addi $sp, $sp, 4
	j ExitProgram

####################### PLAYER 2 MOVE #####################
player2Move:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
LoopP2M:  
	li $t5, 8  
	slt $t3, $t1, $t5 # t1 < 8
	slt $t4, $0, $t1 # 0 < t1
	and $t3, $t3, $t4
	beq $t3, 1, SUCCESSP2M
	addi $t8, $t8, -1
	beq $t8, -1, overThree4 # if more than 3, other player win
	# print error 1
	jal clean
	li $v0, 4
	la $a0, MoveError
	syscall
	
	li $v0, 4
	la $a0, printEndl
	syscall
	# draw table
	jal drawTable
	jal printPlayer2Turn
	j LoopP2M

SUCCESSP2M:
	# load back $ra
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
overThree4:
	jal clean
	jal drawTable
	# Print sory message
	li $v0, 4
	la $a0, firstMoveError2
	syscall
	# add back stack
	# print winner
	li $v0, 4
	la $a0, playerWin
	syscall
	
	li $v0, 4
	la $a0, userName1
	syscall
	
	addi $sp, $sp, 4
	j ExitProgram
############## SET TABLE #################
setInTable:
	li $t9, 0
	move $t0, $a0 # column choice
	addi $t0, $t0, -1
	# move $t1, $a1 # player ?
	
	beq $t0, 1, setFor_1
	beq $t0, 2, setFor_2
	beq $t0, 3, setFor_3
	beq $t0, 4, setFor_4
	beq $t0, 5, setFor_5
	beq $t0, 6, setFor_6
	beq $t0, 7, setFor_7

setFor_1:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet1:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t5 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet1

setFor_2:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet2:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t5 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet2

setFor_3:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet3:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t4 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet3

	
setFor_4:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet4:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t4 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet4

setFor_5:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet5:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t4 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet5

setFor_6:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet6:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t4 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet6

setFor_7:
	li $t2, 5 # row index
	add $t3, $0, 7 # column size
LoopSet7:
	mul $t4, $t2, $t3 # rowIndex * colSize
	add $t4, $t4, $t0 # + colIndex
	mul $t4, $t4, DATA_SIZE # * dataSize
	add $t4, $t4, $s0  # + baseAddress
	lb $t5, 0($t4) #t5 is now store the value a[t2][colChoice]
	beq $t5, 32, handleRandom
	addi $t2, $t2, -1 # if there's an character != 0, row--
	beq $t2, -1, throwSetError
	j LoopSet7

throwSetError:
	li $t9, 1 # flag variable
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal clean
	# print full column message
	li $v0, 4
	la $a0, setError
	syscall
	
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	

# Handling random X and O	
handleRandom:
	addi $s2, $t2, 0 # store the newwest row index
	addi $s3, $t0, 0 # store the newest column index
	beq $s1, 1, SetXO1
	beq $s1, 2, SetXO2
# Case 1
SetXO1:
	beq $a1, 1, SETp1_1
	beq $a1, 2, SETp2_1
	
SETp1_1:
	la $t5, Xchar
	lb $t6, 0($t5)
	sb $t6, ($t4)
	# store character of player
	add $s4, $t6, 0 
	
	jr $ra
SETp2_1:
	la $t5, Ochar
	lb $t6, 0($t5)
	sb $t6, ($t4)
	# store character of player
	add $s4, $t6, 0
	
	jr $ra
# Case 2
SetXO2:
	beq $a1, 1, SETp1_2
	beq $a1, 2, SETp2_2
	
SETp1_2:
	la $t5, Ochar
	lb $t6, 0($t5)
	sb $t6, ($t4)
	# store character of player
	add $s4, $t6, 0
	
	jr $ra
SETp2_2:
	la $t5, Xchar
	lb $t6, 0($t5)
	sb $t6, ($t4)
	# store character of player
	add $s4, $t6, 0
	
	jr $ra		

############## Check End Game ############
checkEnd:
	# s2 store the row index
	# s3 store the column index
	# s4 store the character of player
CheckHorizontal:
	li $t6, 1 # counter variables
	add $t1, $s2, $0 # t1 is row idx
	add $t2, $s3, $0 # t2 is column idx
	li $t3, 7 # colSize
	# load address to get character
	mul $t4, $t1, $t3 # rowIndex * colSize
	add $t4, $t4, $t2 #  + colIndex
	mul $t4, $t4, DATA_SIZE # * DATASIZE
	add $t4, $t4, $s0 # + base address	
	lb $s4, 0($t4) # load byte
	
	# check if space
	la $t5, spaceChar
	lb $t5, ($t5)
	beq $s4, $t5, checkDraw
	
	checkLeft:
		# check from behind ( column-- )
		addi $t2, $t2, -1 # column--
		beq $t2, -1, outCheckLeft
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address	
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, outCheckLeft # if the character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j checkLeft
	outCheckLeft:
		add $t2, $s3, 0 # load back the column index
	checkRight:
		addi $t2, $t2, 1 # column++
		beq $t2, 7, checkVertical
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address	
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, checkVertical # if the character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j checkRight

checkVertical:
	li $t6, 1 # set back counter
	add $t1, $s2, $0 # t1 is row idx
	add $t2, $s3, $0 # t2 is column idx
	li $t3, 7 # colSize
	
	# Check if row is less than 3
	li $t4, 3
	slt $t4, $t1, $t4
	bne $t4, 1, checkRDiagonal
	
	LoopV:
		addi $t1, $t1, 1 # row++
		beq $t1, 6, checkRDiagonal
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, checkRDiagonal # if character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j LoopV
	
checkRDiagonal: # (/)
	li $t6, 1 # set back counter
	add $t1, $s2, $0 # t1 is row idx
	add $t2, $s3, $0 # t2 is column idx
	li $t3, 7 # colSize
		
	# Check lower (row++, column--)
	Loop_RDiagonal_1:
		# row++, col--
		addi $t1, $t1, 1
		addi $t2, $t2, -1
		# Check wrong conditions
		beq $t1, 6, checkUpperRD
		beq $t2, -1, checkUpperRD
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, checkUpperRD # if character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j Loop_RDiagonal_1
	# Check upper (row--, column++)
	checkUpperRD:
	# Set back row and col
	add $t1, $s2, $0 # t1 is row idx
	add $t2, $s3, $0 # t2 is column idx
	Loop_RDiagonal_2:
		# row--, col++
		addi $t1, $t1, -1
		addi $t2, $t2, 1
		# Check wrong conditions
		beq $t1, -1, checkLDiagonal
		beq $t2, 7, checkLDiagonal
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, checkLDiagonal # if character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j Loop_RDiagonal_2
		
checkLDiagonal: # (\)
	li $t6, 1 # set back counter
	add $t1, $s2, $0 # t1 is row idx
	add $t2, $s3, $0 # t2 is column idx
	li $t3, 7 # colSize
		
	# Check lower (row++, column++)
	Loop_LDiagonal_1:
		# row++, col++
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		# Check wrong conditions
		beq $t1, 6, checkUpperLD
		beq $t2, 7, checkUpperLD
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, checkUpperLD # if character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j Loop_LDiagonal_1
	# Check upper (row--, column--)
	checkUpperLD:
	# Set back row and col
	add $t1, $s2, $0 # t1 is row idx
	add $t2, $s3, $0 # t2 is column idx
	Loop_LDiagonal_2:
		# row--, col--
		addi $t1, $t1, -1
		addi $t2, $t2, -1
		# Check wrong conditions
		beq $t1, -1, checkDraw
		beq $t2, -1, checkDraw
		# Load address
		mul $t4, $t1, $t3 # rowIndex * colSize
		add $t4, $t4, $t2 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		lb $t5, 0($t4) # load byte
		bne $t5, $s4, checkDraw # if character is not the same
		addi $t6, $t6, 1 # count++
		beq $t6, 4, Win
		j Loop_LDiagonal_2
	
checkDraw:
	# 32
	li $t0, 0 # int i = 0
	li $t1, 0 # int j = 0
	li $t2, 7 # colSize
	li $t3, 0 # check variables
	loopDraw_1:
		beq $t0, 6, endLoopDraw1
	loopDraw_2:
		beq $t1, 7, endLoopDraw2
		# Load address
		mul $t4, $t0, $t2 # rowIndex * colSize
		add $t4, $t4, $t1 #  + colIndex
		mul $t4, $t4, DATA_SIZE # * DATASIZE
		add $t4, $t4, $s0 # + base address
		lb $t5, 0($t4) # load byte
		# if $t5 == ' ' return false
		beq $t5, 32, IF
		j ELSE
		IF:
			li $t3, 1
		ELSE:	
		addi $t1, $t1, 1
		j loopDraw_2
	endLoopDraw2:
		addi $t0, $t0, 1
		j loopDraw_1
	endLoopDraw1:
		# Check if it's draw
		beq $t3, 0, isDraw
		jr $ra # if it's not draw, continue the game

Win:
	# print winner
	li $v0, 4
	la $a0, Winner
	syscall
	# print name, there will be 2 cases to print name. Each case 2 has 2 more cases.
	beq $s1, 1, caseWin1
	j caseWin2
	caseWin1:
		la $t0, Xchar
		lb $t0, 0($t0)
		beq $t0, $s4, p1_Win_case1
		j p2_Win_case1
		p1_Win_case1: 
			li $v0, 4
			la $a0, userName1
			syscall
			j after_winner_name
			
		p2_Win_case1:
			li $v0, 4
			la $a0, userName2
			syscall
			j after_winner_name
			
	caseWin2:
		la $t0, Xchar
		lb $t0, 0($t0)
		beq $t0, $s4, p2_Win_case2
		j p1_Win_case2
		p1_Win_case2: 
			li $v0, 4
			la $a0, userName1
			syscall
			j after_winner_name
			
		p2_Win_case2:
			li $v0, 4
			la $a0, userName2
			syscall
			j after_winner_name
			
	after_winner_name:
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable
	j ExitProgram

isDraw:
	# print draw
	li $v0, 4
	la $a0, DrawGame
	syscall
	# print endl
	li $v0, 4
	la $a0, printEndl
	syscall
	jal drawTable
	j ExitProgram
############# Clear Console ##############
clean:
	li $v0, 4
	la $a0, clearConsole
	syscall
	jr $ra
		
############## Exit Program ##############
ExitProgram:
	li $v0, 10
	syscall
