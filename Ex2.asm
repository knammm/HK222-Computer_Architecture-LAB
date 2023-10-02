#################################################################################################
# Write a MIPS program that request a positive integer number, call n, from users (please check
# if it’s positive or not). The program then prints n first elements of the Fibonacci Sequence.
#################################################################################################
	.data
Input: .asciiz "\nEnter a number: "
Output: .asciiz "\The number is negaive !"
Output1: .asciiz "\nFibonacii Sequence: "
Output2: .asciiz ", "

	.text
# print input
	li $v0, 4
	la $a0, Input
	syscall
	
# read int
	li $v0, 5
	syscall
	add $t0, $v0, $0 # t0 = input
	
# Print output
	slt $t5, $t0, $0
	beq $t5, 1, printNegativeOutput
	add $t0, $t0, -1

# declare variables
	add $t1, $0, $0	# t1 = 1
	addi $t2, $0, 1 # t2 = 2
	add $t3, $0, $0 # counter variables
	
# print output
	li $v0, 4
	la $a0, Output1
	syscall

# print sequence
Loop:
	add $a0, $t1, $0
	li $v0, 1
	syscall
	beq $t3, $t0, Exit
	addi $t3, $t3, 1
	add $t4, $t2, 0 # temp variable
	add $t2, $t1, $t2
	add $t1, $t4, 0 # set back $t1 is the previous $t2
	# Print output2
	li $v0, 4
	la $a0, Output2
	syscall
	j Loop

printNegativeOutput:
	li $v0, 4
	la $a0, Output
	syscall
	j Exit

Exit:
	li $v0, 10
	syscall

	