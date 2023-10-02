##############################################################################################################
# Write a MIPS program with the following requirements:
# 1. Declare an string and its length in memory, for example: ”Ho Chi Minh City - University of Technology”,
# length = 42
# 2. Print the string in a reverse order to the terminal, ie. ”ygolonhceT fo ytisrevinU - ytiC hniM ihC oH”
##############################################################################################################

	.data
Input: .asciiz "\nFirst string: "
string: .asciiz "Ho Chi Minh City - University of Technology"
length: .word 42
Output: .asciiz "\nString in reverse: "

	.text

#Print input
	li $v0, 4
	la $a0, Input
	syscall
# Print string
	li $v0, 4
	la $a0, string
	syscall

# Load length
	li $v0, 1
	move $a0, $t0
	syscall
	add $t1, $0, $0 # t1 = 0
	addi $t0, $t0, -1 # t0 = 41
	
# Print Output
	li $v0, 4
	la $a0, Output
	syscall
Loop:
	lb $a0, length($t0) # t0 = 41
	li $v0, 11
	syscall
	beq $t1, 43, Exit
	addi $t1, $t1, 1
	addi $t0, $t0, -1
	j Loop

Exit:
	li $v0, 10
	syscall

