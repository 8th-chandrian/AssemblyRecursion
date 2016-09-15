
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

	lw $a0, arg1	# Print the name of the file being written to
	li $v0, 4
	syscall
	
	lw $a0, arg1	# Get the file descriptor of the file being written to
	li $a1, 1
	li $v0, 13
	syscall
	
	la $s0, ($v0)	# Load the file descriptor into s0 so it will not be corrupted
	
	
	# CODE FOR TESTING itof FUNCTION
	
	li $a0, 4563	# Load the integer to write into a0
	la $a1, ($s0)	# Load the file descriptor into a1
	jal itof
	
	la $a0, ($s0)	# Close the file
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



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw4.asm"
