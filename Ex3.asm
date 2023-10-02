######################################################################################
# Write a small program that allows users to input values for variables a, b, c, and d. 
# The program then calculates the following expressions and prints the results to terminal.
# 	f = (a + b) ? (c ? d ? 2);
#	g = (a + b) ? 3 ? (c + d) ? 2;
######################################################################################

# Data declarations
	.data
Input1: .asciiz "\nPlease enter a number a: "
Input2: .asciiz "\nPlease enter a number b: "
Input3: .asciiz "\nPlease enter a number c: "
Input4: .asciiz "\nPlease enter a number d: "
Output1: .asciiz "\nf =  "
Output2: .asciiz "\ng = "

# Code
 	.text
 
# Print 1st request
	li $v0, 4
	la $a0, Input1
	syscall

# Get 1st integer
	li $v0, 5
	syscall
	addi $s0, $v0, 0 # store the number a in s0
	
# Print 2nd request
	li $v0, 4
	la $a0, Input2
	syscall

# Get 2nd integer
	li $v0, 5
	syscall
	addi $s1, $v0, 0 # store the number b in s1

# Print 3rd request
	li $v0, 4
	la $a0, Input3
	syscall

# Get 3rd integer
	li $v0, 5
	syscall
	addi $s2, $v0, 0 # store the number c in s2

# Print 4th request
	li $v0, 4
	la $a0, Input4
	syscall

# Get 4th integer
	li $v0, 5
	syscall
	addi $s3, $v0, 0 # store the number d in s3
	
# Print 1st output
	li $v0, 4
	la $a0, Output1
	syscall
	
# Print f
	add $t0, $s0, $s1 # a + b
	sub $t1, $s2, $s3 # c - d
	addi $t1, $t1, -2 # c - d - 2
	sub $a0, $t0, $t1
	li $v0, 1
	syscall

# Print 2nd output
	li $v0, 4
	la $a0, Output2
	syscall

# Print g
	add $t0, $s0, $s1 # a + b
	addi $t1, $0, 3 # t1 = 3
	add $t2, $s2, $s3 # c + d
	addi $t3, $0, 2 # t3 = 2
	mult $t0, $t1
	mflo $t0 # store (a+b)*3 to t0(tr??ng h?p s? không b? tràn, n?u b? tràn thì dùng mfhi)
	mult $t2, $t3
	mflo $t1 # store (c+d)*2 to t1
	sub $a0, $t0, $t1
	li $v0, 1
	syscall

# End program
	li $v0, 10
	syscall
		




 
