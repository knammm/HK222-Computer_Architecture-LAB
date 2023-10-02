##############################################################################################
# Write a MIPS program that reverses an 10 elements integer array. For example, the array
# initially stores 1, 3, 5, 7, 9, 11, 13, 15, 17, 19; then the program will change the 
# array to be 19, 17, 15, 13, 11, 9, 7, 5, 3, 1.
##############################################################################################

# Data declarations
	.data
Array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
Output1: .asciiz "Array before reverse: "
Output2: .asciiz "\nArray after reverse: "
Output3: .asciiz ", "

# Code
	.text
	add $t0, $0, $0 # Temp1 variable to swap
	add $t4, $0, $0 # Temp2 variable to swap
	add $t1, $0, $0 # Pointer at a[0]
	addi $t2, $0, 36 # Pointer at a[9]
	add $t3, $0,$0 # Counter variable

# Print Output1 
	li $v0, 4
	la $a0, Output1
	syscall 
	
# Print previous data
Loop1:
	lw $t0, Array($t1)
	add $a0, $t0, 0
	li $v0, 1
	syscall
	addi $t1, $t1, 4
	addi $t3, $t3, 1
	beq $t3, 10, ExitLoop1
	# Print space
	li $v0, 4
	la $a0, Output3
	syscall
	j Loop1

ExitLoop1:
	# Set back to 0
	add $t0, $0, $0 
	add $t1, $0, $0 
	add $t3, $0,$0 
# Swapping Loop
Loop2:
	beq $t3, 5, EndLoop2
	# Swapping
	lw $t0, Array($t1) # storing array data to temp
	lw $t4, Array($t2) # storing array data to temp
	sw $t0, Array($t2) # changing array data
	sw $t4, Array($t1) # changing array data
	# Step
	addi $t3, $t3, 1
	addi $t1, $t1, 4
	addi $t2, $t2, -4
	j Loop2
	
EndLoop2:
	add $t1, $0, $0 # set back t1 to 0 to print array data
	add $t3, $0, $0 # set counter back to 0
	# Print Output1
	li $v0, 4
	la $a0, Output2
	syscall
	
Loop3:
	# Print data
	lw $t0, Array($t1)
	add $a0, $t0, 0
	li $v0, 1
	syscall
	addi $t1, $t1, 4
	addi $t3, $t3, 1
	beq $t3, 10, Exit
	# Print comma
	li $v0, 4
	la $a0, Output3
	syscall
	j Loop3
	
Exit:
	li $v0, 10
	syscall

	
	
	
	
	
