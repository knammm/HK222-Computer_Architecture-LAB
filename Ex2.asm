######################################################################################
#	Write a small program that is able collect two integer numbers 
#	from users and print out the sum of the two numbers.
######################################################################################

# Data declarations
	.data
Input: .asciiz "\nPlease enter a number: "
Output: .asciiz "\nSum of two numbers: "

# Code
 	.text
 
# Print 1st request
	li $v0, 4
	la $a0, Input
	syscall

# Get first number
	li $v0, 5
	syscall
	addi $t0, $v0, 0 # store the number in t0

# Print 2nd request
	li $v0, 4
	la $a0, Input
	syscall
	
# Get second number
	li $v0, 5
	syscall
	addi $t1, $v0, 0 # store the number in t1

# Print respond
	li, $v0, 4
	la $a0, Output
	syscall

# Print sum
	add $a0, $t0, $t1
	li $v0, 1
	syscall

# End program
	li $v0, 10
	syscall
 