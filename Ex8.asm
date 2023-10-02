##############################################################################################
# Write a MIPS program with the following requirements:
# 1. Declare an integer array with 10 synthetic data elements.
# 2. Print a sentence to terminal to request an integer number that is greater than 0 
# and less than 10 (assume that user strictly follow this rule).
# 3. Print value of the element at index collected from the previous step.
##############################################################################################

# Data declarations
	.data
Array: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
Input: .asciiz "\nEnter a number that's greater than 0 and less than 10: "
Output1: .asciiz "\nValue of element at index "
Output2: .asciiz ": "

# Code
	.text

# Print request
	li $v0, 4
	la $a0, Input
	syscall
# Get number
	li $v0, 5
	syscall
	addi $t0, $v0, 0
	sll $t1, $t0, 2 # Shift t0
	lw $t2, Array($t1)
# Print Output1
	li $v0, 4
	la $a0, Output1
	syscall
	# Print index
	addi $a0, $t0, 0
	li $v0, 1
	syscall	
	# Print Output2
	li $v0, 4
	la $a0, Output2
	syscall
	# Print index value
	addi $a0, $t2, 0
	li $v0, 1
	syscall
# End Program
	li $v0, 10
	syscall
