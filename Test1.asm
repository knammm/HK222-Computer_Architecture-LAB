# Write a MIPS program that requests a positive integer number, calls n (1 <= n <= 10),
# from users (please check if it satisfies the requirements).
# a) Request data elements from users and store them in the array.
# b) Find the most frequent element in an array.

.data
Array: .space 40
input1: .asciiz "Please enter a number n (1 <= n <= 10): "
input2: .asciiz "Please enter a number: "
output: .asciiz "Most frequent number: "

.text
	li $v0, 4
	la $a0, input1
	syscall
	
	# get user input
	li $v0, 5
	syscall
	move $s1, $v0
	
	li $t1, 0 # counter
	li $t2, 0 # counter idx
	la $s0, Array

Loop:	
	beq $t1, $s1, outLoop
	li $v0, 5
	syscall
	add $t2, $s0, $t2
	move $t3, $v0
	sw $t3, 0($t2)
	addi $t1, $t1, 1
	sll $t2, $t1, 2
	j Loop
	
outLoop:
	li $t1, 0 # i = 0
	li $t2, 0 # j = 0
printLoop:
	beq $t1, 10, outPrint
	add $t2, $t2, $s0
	lw $a0, ($t2)
	li $v0, 1
	syscall
	addi $t1, $t1, 1
	sll $t2, $t1, 2
	j printLoop
	
outPrint:
	li $t1, 0 # i = 0
	li $t2, 0 # j = 0
	li $t3, 0 # prevCount
	li $t4, 0 # Count
	li $t5, 0
	li $t6, 0
	move $t0, $s1
	addi $t0, $t0, -1 # n - 1
	move $s2, $t0
	
Loop2:
	beq $t1, $s2, exitLoop2 # i < n-1
	add $t5, $t5, $s0
	lw $t7, ($t5) # a[i]
	
	Loop3:
	beq $t2, $s1, exitLoop3 # j < n
	add $t6, $t6, $s0
	lw $t8, ($t6) # a[j]
	
	beq $t7, $t8, countUp
	j noCount
	countUp:
		addi $t4, $t4, 1
	noCount: 
	addi $t2, $t2, 1 # j++
	sll $t6, $t2, 2
	j Loop3
	
	exitLoop3:
	# check prev count < count
	slt $t9, $t3, $t4
	beq $t9, 1, getNum
	j dontGetNum
	
	getNum:
		move $t3, $t4 # prevCount = count
		move $s3, $t7 # get the number at $s3
		
	dontGetNum:
	li $t4, 0
	addi $t1, $t1, 1 # i++
	sll $t5, $t1, 2
	j Loop2
exitLoop2:
	# print output
	li $v0, 4
	la $a0, output
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	