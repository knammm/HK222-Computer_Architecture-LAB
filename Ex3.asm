.data
	file: .asciiz "C:\\Users\\84909\Desktop\\testout.txt"
.text
	#  OPEN FILE
	li $v0, 13 
	la $a0, file	
	li $a1, 0  # read mode
	li $a2, 0 
	syscall 
	move $s6, $v0 
	
	# String dynamic allocate memory
	li $v0, 9 
	li $a0, 100
	syscall
	
	# Save the address of the allocated memory
	move $s0, $v0	
	
	
	# Read the file into the allocated memory
	li $v0, 14 
	move $a0, $s6 
	la $a1, ($s0)
	li $a2, 100 # hardcore buffer length
	syscall 
	
	# Print 
	li $v0, 4
	la $a0, ($s0)
	syscall
	
	# Close file
	
	li $v0, 16 # system call for close file
	move $a0, $s6 # file descriptor to close
	syscall # close file
	# Close the program
	li $v0, 10
	syscall