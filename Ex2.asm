.data
	greeting: .asciiz "This function return the integral of a*x^2 + b*x + c, from u to v.\nPlease enter the required variables:\n"
	get_u: 	.asciiz "\nEnter u: "
	get_v: 	.asciiz "\nEnter v: "
	get_a: 	.asciiz "\nEnter a: "
	get_b:	.asciiz "\nEnter b: "
	get_c: 	.asciiz "\nEnter c: "
	result:		.asciiz "The result is: "
	return: .asciiz "The result is: "
	const20: .float 20.0
	const0: .float 0.0

.text
	li $v0, 4
	la $a0, greeting
	syscall
	
	# get u
	li $v0, 4
	la $a0, get_u
	syscall
	
	li $v0, 6
	syscall
	mov.s $f1, $f0
	
	# get v
	li $v0, 4
	la $a0, get_v
	syscall
	
	li $v0, 6
	syscall
	mov.s $f2, $f0
	
	# get a
	li $v0, 4
	la $a0, get_a
	syscall
	
	li $v0, 6
	syscall
	mov.s $f3, $f0
	
	# get b
	li $v0, 4
	la $a0, get_b
	syscall
	
	li $v0, 6
	syscall
	mov.s $f4, $f0
	
	# get c
	li $v0, 4
	la $a0, get_c
	syscall
	
	li $v0, 6
	syscall
	mov.s $f5, $f0
	
	# calculating
	
	# $f1 is u
	# $f2 is v
	# $f3 is a
	# $f4 is b
	# $f5 is c
	# $f6 is 20
	lwc1 $f6, const20
	sub.s $f7, $f2, $f1 # (v - u)
	div.s  $f8, $f7, $f6 # (v - u) / 20
	li $t0, 0
loop:
	beq $t0, 20, end
	# find height from u from ax^2 + bx + c
	mul.s $f13, $f1, $f1 # u^2
	mul.s $f13, $f13, $f3 # a * u^2
	mul.s $f14, $f4, $f1 # b * u
	add.s $f13, $f13, $f14 # a * u^2 + b * u 
	add.s $f13, $f13, $f5  # a * u^2 + b * u + c
	# calculate area
	mul.s $f9, $f13, $f8 # area of rectangle
	add.s $f12, $f12, $f9 # sum of areas
	add.s $f1, $f1, $f8 #increase u to (v - u) / 20
	addi $t0, $t0, 1
	j loop

end:
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 2
	syscall
	
	li $v0, 10
	syscall
