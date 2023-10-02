.data
choice: .asciiz "\nPlease make a choice: \n1. Circle  \n2. Triangle \n3. Rectangle  \n4. Square\n"
user_choice: .asciiz "\nPlease input in range 1-4: "
invalid: .asciiz "\nThe input is out of range ! Please enter again"
getCircleRadius:.asciiz "\nPlease input the radius of circle: "
getTriBase: .asciiz "\nPlease input the base of triangle: "
getTriHeight:.asciiz "\nPlease input the height of triangle: "
getRecHeight:.asciiz "\nPlease input the height of rectangle: "
getRecWidth:.asciiz "\nPlease input the width of rectangle: "
getSquareLength:.asciiz "\nPlease input the length of square: "
return_S: .asciiz "Your area is: "
pi:.float 3.14
half:.float 0.5

.text
begin:
	li $v0, 4
	la $a0, choice
	syscall
	
	li $v0, 4
	la $a0, user_choice
	syscall
	# get user input
	li $v0, 5
	syscall
	move $s0, $v0
	
	beq $s0, 1, Circle
	beq $s0, 2, Triangle
	beq $s0, 3, Rectangle
	beq $s0, 4, Square
	
	outOfRange:
		li $v0, 4
		la $a0, invalid
		syscall
		j begin
	
	Circle:
		li $v0, 4
		la $a0, getCircleRadius
		syscall
		# get user radius
		li $v0, 6
		syscall
		mov.s $f1, $f0
		lwc1 $f2, pi # get pi
		
		# calculate area
		mul.s $f9, $f1, $f1 # $f9 store data
		mul.s $f9, $f9, $f2 # r^2 * pi
		j endCal
		
	Triangle:
		# get base
		li $v0, 4
		la $a0, getTriBase
		syscall
		
		li $v0, 6
		syscall
		mov.s $f1, $f0
		
		# get height
		li $v0, 4
		la $a0, getTriHeight
		syscall
		
		li $v0, 6
		syscall
		mov.s $f2, $f0
		
		lwc1 $f3, half
		
		# calculate area
		
		# $f1 store base
		# $f2 store height
		# $f3 store half
		mul.s $f9, $f1, $f2
		mul.s $f9, $f9, $f3
		j endCal
			
	Rectangle:
		# get height
		li $v0, 4
		la $a0, getRecHeight
		syscall
		
		li $v0, 6
		syscall
		mov.s $f1, $f0
		
		# get width
		li $v0, 4
		la $a0, getRecWidth
		syscall
		
		li $v0, 6
		syscall
		mov.s $f2, $f0
		
		# calculate area
		mul.s $f9, $f1, $f2
		j endCal
		
	Square:
		li $v0, 4
		la $a0, getSquareLength
		syscall
		
		li $v0, 6
		syscall
		mov.s $f1, $f0
		
		# calculate area
		mul.s $f9, $f1, $f1
		j endCal
	
	endCal:
		li $v0, 4
		la $a0, return_S
		syscall
		
		li $v0, 2
		mov.s $f12, $f9
		syscall
		
		li $v0, 10
		syscall
