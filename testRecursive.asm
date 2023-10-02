.data

Array: .word 1,2,3,4,5,6,7,8,9,10
Output: .asciiz "Sum of array elements: "

.text

# print output
	li $v0, 4
	la $a0, Output
	syscall
	
# calculate sum
	la $a0, Array
	li $a1, 10
	jal sum
	move $t0, $v0
	# print sum
	li $v0, 1
	move $a0, $t0
	syscall
	# end program
	li $v0, 10
	syscall
	
sum:
	addi $sp, $sp, -12
	sw $ra, 0($sp) # return address
	sw $a0, 4($sp) # array address
	sw $a1, 8($sp) # k
	
	bne $a1, 1, recursiveCall
	# base case
	lw $t0, 4($sp) # t0 store address array
	lw $t0, 0($t0)
	move $v0, $t0

	addi $sp, $sp, 12
	jr $ra

 recursiveCall:
 	addi $a0, $a0, 4
 	addi $a1, $a1, -1
 	
 	jal sum
 	
 	# return v + ...
 	lw $a0, 4($sp)
 	lw $a1, 8($sp)
 	lw $ra, 0($sp)
 	
 	lw $t0, 0($a0)
 	add $v0, $v0, $t0
 	addi $sp, $sp, 12
 	
 	jr $ra