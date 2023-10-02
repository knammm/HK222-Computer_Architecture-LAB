.data
Array: .word 1,2,3,4,5,11,7,8,9,13
printResult: .asciiz "Max element: "
.text
	li $v0, 4
	la $a0, printResult
	syscall
	
	la $a0, Array
	li $a1, 10
	jal findMax
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
findMax:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	bne $a1, 1, callRecursive
	# base case
	lw $t0, 4($sp) # address of array
	lw $t0, 0($t0)
	move $v0, $t0
	
	jr $ra

callRecursive:
	
	addi $a0, $a0, 4
	addi $a1, $a1, -1
	
	jal findMax
	# get back from stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	lw $t1, 0($a0) # temp variable
	slt $t2, $v0, $t1
	beq $t2, 1, changeV0 # $v0 < $t1, set max to $t1
	j dontChange
	
	changeV0:
		move $v0, $t1
		
	dontChange:
	addi $sp, $sp, 12
	jr $ra