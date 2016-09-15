
# Helper macro for grabbing one command line argument
.macro load_one_arg
	lw $t0, 0($a1)
	sw $t0, arg1
.end_macro

############################################################################
##
##  TEXT SECTION
##
############################################################################
.text
.globl main

main:
#check if command line args are provided
#if zero command line arguments are provided exit
beqz $a0, exit_program

#Otherwise, save argument into memory using macro
load_one_arg()


# TEST CODE STARTS HERE

	lw $a0, arg1	# Get the file descriptor of the file being written to
	li $a1, 1
	li $v0, 13
	syscall
	
	la $s0, ($v0)	# Load the file descriptor into s0 so it will not be corrupted
	
	
	# CODE FOR TESTING recursiveFindLoneElement FUNCTION
	
	la $a0, input_array
	li $a1, 0
	li $a2, 28
	move $a3, $s0
	jal recursiveFindLoneElement
	
	move $t0, $v0	# Put the return in t0
	
	move $a0, $t0	# Print the return
	li $v0, 1
	syscall
	
	la $a0, ($s0)	# Close the file (THIS ACTION SHOULD ALWAYS BE PERFORMED AFTER WRITING TO FILE)
	li $v0, 16
	syscall

exit_program:
li $v0, 10
syscall


############################################################################
##
##  DATA SECTION
##
############################################################################
.data

.align 2

#for arguments read in
arg1: .word 0

#negative value to indicate the end of the array
end_array: .word -1

.align 2

#array to be used for testing
input_array: .word 1, 1, 3, 3, 5, 5, 8, 8, 10, 10, 12, 12, 20, 20, 33, 33, 34, 35, 35, 42, 42, 51, 51, 55, 55, 66, 66, 67, 67, -1


#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw4.asm"