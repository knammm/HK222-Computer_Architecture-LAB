.data

.text
	li $t0, 0
	li $t1, 0
	
	div $t0, $t1
	mflo $s0 # quotient
	mfhi $s1 # remainder
	
	move $a0, $s1 # print quotient
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall