############################################
# Description:
# 	Simple example program
############################################

############################################
# Main program
############################################

# Variables for main
	.data
greeting: .asciiz "Hello, world!\n"

# Main body
	.text
main:
	li $v0, 4
	la $a0, greeting
	syscall
	
	# return to calling program
	jr $ra