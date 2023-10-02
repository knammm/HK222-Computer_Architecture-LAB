	.data
Array: 	.word 0, 2, 3, 4, 5, 6, 7, 8, 9, 10
Output: .asciiz "Sum of 10 elements in array: "

	.text
main:
	la $s0, Array
	# Print output
	li $v0, 4
	la $a0, Output
	syscall
	
	# Call function
	addi $a0, $s0, 0
	addi $a1, $0, 10
	jal Sum
	
	# Print result
	move $a0, $v0
	li $v0, 1
	syscall
	
	# Exit program
	li $v0, 10
	syscall
	 
Sum:
	addi $sp, $sp, -12
	sw $ra, 0($sp)	# store return address
	sw $a0, 4($sp) # store *v
	sw $a1, 8($sp) # store k
	
	bne $a1, 1, callRecursion
	
	lw $t0, 4($sp) # t0 will store address of Array
	lw $t1, 0($t0) # t1 store the value
	addi $v0, $t1, 0
	addi $sp, $sp, 12
	jr $ra
	
callRecursion:
	addi $a0, $a0, 4    # Array[k + 1]
	addi $a1, $a1, -1   # k - 1
	
	jal Sum
	# Load stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	# Return result
	lw $t0, 0($a0)
	add $v0, $v0, $t0
	addi $sp, $sp, 12
	
	jr $ra
	
	
