#######################################################################
# Write a MIPS program with the following requirements:
# 1. Declare an integer array with 10 data elements;
# 2. Request data elements from users and store into the array;
# 3. Sort the elements of the array in the descending order;
# 4. Print the results to the terminal.
#######################################################################


	.data
Array: .space 40
Input: .asciiz "\nPlease enter a number: "
Output1: .asciiz "\nArray after sorting: "
Output2: .asciiz ", "

	.text
#print request
	li $v0, 4
	la $a0, Input
	syscall
	add $t1, $0, $0 # counter variable
Loop1:
	li $v0, 5
	syscall
	add $t0, $v0, $0 
	sll $t2, $t1, 2 
	sw $t0, Array($t2)
	addi $t1, $t1, 1
	beq $t1, 10, ExitLoop1
	j Loop1

ExitLoop1:
#print output
	li $v0, 4
	la $a0, Output1
	syscall

# set back counter values
	add $t0, $0, $0 # int i = 0
	add $t1, $0, $0 # int j = 0

Loop2:
	beq $t0, 10, ExitLoop2
	sll $t2, $t0, 2 # t2 = 4 * t0
	addi $t1, $t0, 1 # int j = i + 1
	Loop3:
	beq $t1, 10, ExitLoop3 # j = 10 exit
	sll $t3, $t1, 2 # t3 = 4 * t1
	lw $t4, Array($t2) # a[i]
	lw $t5, Array($t3) # a[j]
	slt $t6, $t5, $t4 # t5 < t4 ? store to t6
	beq $t6, 0, Swapping # swap
	j afterSwap # if not jump to afterSwap
	
		Swapping: # swapping area
		sw $t4, Array($t3)
		sw $t5, Array($t2)
		j afterSwap
		
	afterSwap:
	addi $t1, $t1, 1 # j++
	j Loop3
	ExitLoop3:
	addi $t0, $t0, 1 # i++
	j Loop2
	
# Printing array	
ExitLoop2:
	# Set back values to 0 to print array
	add $t0, $0, $0
	add $t1, $0, $0
	# Printing array
PrintLoop:
	sll $t1, $t0,2 
	lw $a0, Array($t1)
	li $v0, 1
	syscall
	addi $t0, $t0, 1
	beq $t0, 10, Exit
	li $v0, 4
	la $a0, Output2
	syscall
	j PrintLoop
Exit:
	li $v0, 10
	syscall