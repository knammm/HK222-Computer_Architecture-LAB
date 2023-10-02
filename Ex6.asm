#########################################################################
# Write a MIPS program with the following requirements:
# 1. Declare an integer array with 10 synthetic data elements.
# 2. Calculate the sum of all odd elements (a[1]], a[3],...).
# 3. Calculate the sum of all even elements (a[0], a[2],...).
# 4. Print the results to the terminal.
########################################################################


# Data declarations
	.data
Array: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 # 20 byte for 5 integer of array
Output1: .asciiz "\nSum of all Odd index elements: "
Output2: .asciiz "\nSum of all Even index elements: "

# Code
	.text
	la $t0, Array
	addi $t1, $0, 0 # even index
	addi $t2, $0, 4 # odd index
	# Sum v?iables
	add $t3, $0, $0 # Sum of even 
	add $t4, $0, $0 # Sum of odd
	
	add $t5, $0, $0 # Counter variable
	
Loop:
	beq $t5, 5, ExitLoop
	# sum of even
	lw $t6, Array($t1)
	add $t3, $t3, $t6
	# sum of odd
	lw $t7, Array($t2)
	add $t4, $t4, $t7
	
	addi $t1, $t1, 8
	addi $t2, $t2, 8
	addi $t5, $t5, 1
	j Loop
	
ExitLoop:
	# Print Output1
	li $v0, 4
	la $a0, Output1
	syscall
	# Print sum of odd
	addi $a0, $t4, 0
	li $v0, 1
	syscall
	# Print Output2
	li $v0, 4
	la $a0, Output2
	syscall
	# Print sum of Even
	addi $a0, $t3, 0
	li $v0, 1
	syscall

# End Program
	li $v0, 10
	syscall
	  
	
