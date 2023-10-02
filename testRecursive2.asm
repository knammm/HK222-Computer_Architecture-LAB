.data

printResult: .asciiz "\n Factorial: "

.text
	li $v0, 4
	la $a0, printResult
	syscall
	
	li $a0, 6
	jal findFact
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
findFact:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	bne $a0, 1, callRecursive
	# base case
	li $v0, 1 # return 1
	jr $ra

callRecursive:
	addi $a0, $a0, -1
	
	jal findFact
	
	# get back $a0 from stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	
	mul $v0, $v0, $a0 # return n * fact(n-1)
	jr $ra
	