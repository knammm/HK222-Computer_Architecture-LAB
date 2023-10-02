##############################################################################################
# Write a MIPS program that receives 10 integer numbers from users through the terminal and
# store these numbers into an array. Print the sum of all array elements to the terminal.
##############################################################################################

# Data declarations
	.data
Array: .space 40 # 20 byte for 5 integer of array
Input: .asciiz "\nPlease add a number to array: "
Output: .asciiz "\nSum of all array elements: "

# Code
	.text

# Print request
	li $v0, 4
	la $a0, Input
	syscall
	la $t0, Array
	add $t1, $0, $0 # counter variable
	add $t3, $0, $0 # sum variable
# Storing array data
Loop1:
	beq $t1, 10, EndLoop1
	li $v0, 5
	syscall
	sll $t2, $t1, 2
	addi $t1, $t1, 1
	sw $v0, Array($t2)
	j Loop1
	
EndLoop1:
	add $t1, $0, $0
	sll $t2, $t1, 2
	
# Calculate sum	
Loop2:
	beq $t1, 10, Exit
	lw $t4, Array($t2)
	add $t3, $t3, $t4
	addi $t1, $t1, 1
	sll $t2, $t1, 2
	j Loop2

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