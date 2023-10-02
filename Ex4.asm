##############################################################################################
# Write a small program that allows users to input 5 different integer numbers. The program
# then prints those numbers in reverse. For example, users input 1, 2, 3, 4, 5; the program 
# should print 5, 4, 3, 2, 1.
##############################################################################################

# Data declarations
	.data
Array: .space 20 # 20 byte for 5 integer of array
Input: .asciiz "\nPlease add a number to array: "
Output1: .asciiz "\nArray in reverse: "
Output2: .asciiz ", "

# Code
	.text
# Print request
	li $v0, 4
	la $a0, Input
	syscall
	# Move t0 to array's address
	la $t0, Array
	add $t1, $0, $0 # Counter variable

# Loop
Loop1:
	beq $t1, 5, ExitLoop1
	li $v0, 5
	syscall
	sll $t2, $t1, 2 # shift left counter by 2 -> t2 = 0, 4, 8, 12...
	addi $t1, $t1, 1
	sw $v0, Array($t2) # storing input to array
	j Loop1
	
# Print output1	
ExitLoop1:
	li $v0, 4
	la $a0, Output1
	syscall

	# Set t1 value to 4
	addi $t1, $0, 4
# Print output2
Loop2:
	lw $a0, Array($t2)
	li $v0, 1
	syscall # Print integer
	addi $t1, $t1, -1
	addi $t2, $t2, -4
	# Stop loop2 condition
	beq $t1, -1, Exit
	li $v0, 4
	la $a0, Output2
	syscall # Print comma
	j Loop2

# End program
Exit:
	li $v0, 10
	syscall
	 
	
	
