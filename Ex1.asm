######################################################################################
#	Write a simple MIPS program that can execute these steps:
#	1. Print a sentence to terminal to request an integer number from user;
#	2. Collect the number and increase it by 1;
#	3. Print the result to terminal.
######################################################################################

# Data declarations
	.data
Input: .asciiz "Please enter a number: "
Output: .asciiz "\nAfter increase the number by 1: "

# Code
	.text

# Print request
	li $v0, 4
	la $a0, Input
	syscall
	
# Get integer
	li $v0, 5
	syscall
	addi $t0, $v0, 0 # store into t0
	
# Print respond
	li $v0, 4 
	la $a0, Output
	syscall
	
 #Increase by one and print
 	addi $a0, $t0, 1
 	li $v0, 1
 	syscall
 	
# End program
	li $v0, 10
	syscall

 	
 	 
