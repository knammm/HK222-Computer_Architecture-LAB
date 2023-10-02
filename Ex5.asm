##############################################################################################
# Write a MIPS program with the following requirements:
# 1. Declare an integer array with 10 synthetic data elements.
# 2. Calculate the sum of all array elements.
# 3. Print the result to the terminal.
##############################################################################################

# Data declarations
	.data
Array: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
Output: .asciiz "\nSum of all array elements: "

# Code
	.text

	la $t0, Array
	add $t1, $0, $0 # counter variable
	add $t3, $0, $0 # sum variable
	sll $t2, $t1, 2
	
# Calculate sum	
Loop:
	beq $t1, 10, Exit
	lw $t4, Array($t2)
	add $t3, $t3, $t4
	addi $t1, $t1, 1
	sll $t2, $t1, 2
	j Loop

Exit:	
# Print Output
	li $v0, 4
	la $a0, Output
	syscall
# Print sum
	addi $a0, $t3, 0
	li $v0, 1
	syscall
# End Program
	li $v0, 10
	syscall
