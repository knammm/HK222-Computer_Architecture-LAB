	.data
Array: .word 41, 40, 21, 29, 10, 93, 23, 64, 74, 94, 28, 25
Output: .asciiz "Max element in array: "

	.text
main:
	la $s0, Array
	# Print output
	li $v0, 4
	la $a0, Output
	syscall
	
	# Call function
	addi $a0, $s0, 0
	addi $a1, $0, 12
	jal Max
	
	# Print max number
	addi $a0, $v0, 0
	li $v0, 1
	syscall
	
	# Exit program
	li $v0, 10
	syscall
	
Max:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	bne $a1, 1, callRecursion
	
	# Case k = 1
	lw $t0, 4($sp)
	lw $t0, ($t0)
	add $v0, $t0, $0
	addi $sp, $sp, 12
	jr $ra
	
callRecursion:
	addi $a0, $a0, 4 # Array[k+1]
	addi $a1, $a1, -1 # k - 1
	
	jal Max
	
	# Load from stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	# Temp variable
	addi $t1, $v0, 0
	
	# Compare
	lw $t2, ($a0)
	slt $t3, $t2, $t1
	bne $t3, 1, else
	
	# if temp > Array[k]
	addi $sp, $sp, 12
	jr $ra
	
else: # if not
	addi $v0, $t2, 0 # t1 = t2
	addi $sp, $sp, 12
	jr $ra
	