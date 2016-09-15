# Homework #4
# name: Noah Young
# sbuid: 109960711

# Helper macro for printing the header for the bears function
.macro print_bears_open_par(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, bears_open_par
	li $a2, 7
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing the header for the recursiveFindMajorityElement function
.macro print_recursive_find_majority_element_open_par(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, recursive_find_majority_element_open_par
	li $a2, 30
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing the header for the recursiveFindLoneElement function
.macro print_recursive_find_lone_element_open_par(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, recursive_find_lone_element_open_par
	li $a2, 26
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing candidate
.macro print_candidate(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, candidate
	li $a2, 11
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing majority element
.macro print_majority_element(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, majority_element
	li $a2, 18
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing a comma
.macro print_comma(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, comma
	li $a2, 2
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing a comma
.macro print_close_par(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, close_par
	li $a2, 3
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing return
.macro print_return(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, return
	li $a2, 8
	li $v0, 15
	syscall
.end_macro

# Helper macro for printing new line
.macro print_newline(%file_descriptor)
	move $a0, %file_descriptor
	la $a1, newline
	li $a2, 1
	li $v0, 15
	syscall
.end_macro

.text

#Part 1

#itof function
# a0 holds the integer to write to the file
# a1 holds the file descriptor to write to

itof:
	li $t0, 0	# t0 will contain our counter for number of digits
	li $t1, 0	# t1 will contain our flag determining whether or not the number is negative
	
	bgez $a0, not_negative
		li $t1, 1
		li $t2, -1	# If a0 is negative, set our flag to 1 and divide a0 by -1
		div $a0, $t2
		mflo $a0
	not_negative:
	
	itof_parse_loop:
		li $t2, 10
		div $a0, $t2
		mflo $a0
		mfhi $t2	# Set a0 to the quotient and t2 to the remainder
		
		addi $t2, $t2, 48	# Normalize t2 to its ascii character value
		
		addi $sp, $sp, -1	# Store the digit to the stack and increment the digit counter
		sb $t2, 0($sp)
		addi $t0, $t0, 1

		blez $a0, parse_loop_end	# if a0 is not positive, break from the loop
		j itof_parse_loop
	
	parse_loop_end:
	
	beqz $t1, not_negative_flag
		li $t2, '-'	# Set t2 equal to the ascii character value for '-'
		
		addi $sp, $sp, -1	# Store the '-' character to the stack and increment the digit counter
		sb $t2, 0($sp)
		addi $t0, $t0, 1
	not_negative_flag:
	
	li $t1, 0	# t1 will be our counter when popping off the stack
	
	move $a0, $a1	# Set a0 to the file descriptor, which was previously held in a1
	li $a2, 1	# Set a2 to the number of bytes to be read (1)
	
	itof_pop_and_write_loop:
		beq $t0, $t1, pop_and_write_loop_end	# When counter equals number of digits, break from the loop
		
		la $a1, ($sp)	# Set a1 to the address of the buffer to write from (in this case, stack pointer)
		li $v0, 15
		syscall		# Execute syscall 15 to write to file
		
		addi $sp, $sp, 1	# Pop the byte which has just been written off the stack
		addi $t1, $t1, 1	# Increment counter for number of bytes popped off the stack
		
		j itof_pop_and_write_loop
		
	pop_and_write_loop_end:
	
	jr $ra


#Part 2

#bears function
bears:
	lw $t0, 0($sp)		# Load the file descriptor from the stack
	
	addi $sp, $sp, -24	# Store the save registers that we will be using
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0	# Store initial in s0
	move $s1, $a1	# Store goal in s1
	move $s2, $a2	# Store increment in s2
	move $s3, $a3	# Store n in s3
	move $s4, $t0	# Store the file descriptor in s4

	print_bears_open_par($s4)	# Write the header to the given file
	la $a0, ($s0)
	la $a1, ($s4)
	jal itof
	print_comma($s4)
	la $a0, ($s1)
	la $a1, ($s4)
	jal itof
	print_comma($s4)
	la $a0, ($s2)
	la $a1, ($s4)
	jal itof
	print_comma($s4)
	la $a0, ($s3)
	la $a1, ($s4)
	jal itof
	print_close_par($s4)


	# This is the start of the if-else block which determines what this function returns
	
	bne $s0, $s1, initial_not_equal_goal	# If initial == goal, return 1
		print_return($s4)
		li $a0, 1
		la $a1, ($s4)
		jal itof
		print_newline($s4)
		j bears_return_attainable
	initial_not_equal_goal:
	
	
	bnez $s3, n_not_equal_zero	# If n == 0, return 0
		print_return($s4)
		li $a0, 0
		la $a1, ($s4)
		jal itof
		print_newline($s4)
		j bears_return_unattainable
	n_not_equal_zero:
	
	
	add $t0, $s0, $s2	# Add initial and increment
	addi $t1, $s3, -1	# Decrement n by 1
	
	move $a0, $t0		# Set a0 to (inital + increment)
	move $a1, $s1
	move $a2, $s2
	move $a3, $t1		# Set n to (n-1)
	
	addi $sp, $sp, -4	# Move the stack pointer and store 5th argument (file descriptor) onto stack
	sw $s4, 0($sp)
	
	jal bears		# Call bears with given arguments
	addi $sp, $sp, 4	# Put the stack pointer back
	
	move $t0, $v0	# Set t0 to the return of bears
	beqz $t0, bears_return_not_one
		print_return($s4)
		li $a0, 1
		la $a1, ($s4)
		jal itof
		print_newline($s4)
		j bears_return_attainable
	bears_return_not_one:
	
	
	li $t0, 2	# Check whether or not initial % 2 == 0
	div $s0, $t0
	mfhi $t0
	bnez $t0, bears_dual_condition_not_met
	
	li $t0, 2	# Divide initial by 2
	div $s0, $t0
	mflo $t0
	addi $t1, $s3, -1	# Decrement n by 1
	
	move $a0, $t0		# Set a0 to (inital / 2)
	move $a1, $s1
	move $a2, $s2
	move $a3, $t1		# Set n to (n-1)
	
	addi $sp, $sp, -4	# Move the stack pointer and store 5th argument (file descriptor) onto stack
	sw $s4, 0($sp)
	
	jal bears		# Call bears with given arguments
	addi $sp, $sp, 4	# Put the stack pointer back
	
	move $t0, $v0
	beqz $t0, bears_dual_condition_not_met	# If bears does not return 1, continue in the if-else block
		print_return($s4)
		li $a0, 1
		la $a1, ($s4)
		jal itof
		print_newline($s4)
		j bears_return_attainable
	bears_dual_condition_not_met:
	
		print_return($s4)	# If we hit the else case, return 0
		li $a0, 0
		la $a1, ($s4)
		jal itof
		print_newline($s4)
		j bears_return_unattainable
	
	
	# All of this code is performed after the if-else block terminates
	bears_return_attainable:
		li $v0, 1
		j end_bears
	bears_return_unattainable:
		li $v0, 0
	end_bears:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24	# Put the stack pointer and save registers back
	
	jr $ra


#Part 3

#recursiveFindMajorityElement function
recursiveFindMajorityElement:

	lw $t0, 0($sp)		# Load the file descriptor from the stack
	
	addi $sp, $sp, -36	# Store the save registers that we will be using
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0	# Store array address in s0
	move $s1, $a1	# Store candidate in s1
	move $s2, $a2	# Store start index in s2
	move $s3, $a3	# Store end index in s3
	move $s4, $t0	# Store the file descriptor in s4

	sub $s5, $s3, $s2
	addi $s5, $s5, 1	# Store array_length in s5
	
	print_recursive_find_majority_element_open_par($s4)	# Write the header to the given file
	la $a0, ($s2)
	la $a1, ($s4)
	jal itof
	print_comma($s4)
	la $a0, ($s3)
	la $a1, ($s4)
	jal itof
	print_comma($s4)
	la $a0, ($s5)
	la $a1, ($s4)
	jal itof
	print_close_par($s4)
	
	li $t0, 1
	bne $s5, $t0, find_majority_not_stopping_case
		li $t7, 4	# Multiply end_index by 4 to get word address
		mult $s2, $t7
		mflo $t7
		add $t1, $s0, $t7
		lw $t6, ($t1)
		bne $t6, $s1, candidate_not_equal_array
			print_return($s4)
			li $a0, 1
			la $a1, ($s4)
			jal itof
			print_newline($s4)
			j find_majority_return_one
		candidate_not_equal_array:
			print_return($s4)
			li $a0, 0
			la $a1, ($s4)
			jal itof
			print_newline($s4)
			j find_majority_return_zero
	find_majority_not_stopping_case:
		li $t0, 2
		div $s5, $t0
		mflo $s5	# Set s5 equal to mid
		
		li $s6, 0	# s6 will hold LHS_sum
		li $s7, 0	# s7 will hold RHS_sum
		
		# Calculate LHS_sum
		add $t0, $s2, $s5
		addi $t0, $t0, -1
		
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $t0
		
		addi $sp, $sp, -4
		sw $s4, 0($sp)
		jal recursiveFindMajorityElement
		move $s6, $v0
		
		# Calculate RHS_sum
		add $t0, $s2, $s5
		
		move $a0, $s0
		move $a1, $s1
		move $a2, $t0
		move $a3, $s3

		jal recursiveFindMajorityElement
		move $s7, $v0
		addi $sp, $sp, 4	# Put stack pointer back
		
		# Print return
		add $s5, $s6, $s7	# Set s5 equal to (LHS_sum + RHS_sum)
		print_return($s4)
		move $a0, $s5
		la $a1, ($s4)
		jal itof
		print_newline($s4)
		j find_majority_return_integer
	
	
	# All of this code is performed after the if-else block terminates
	find_majority_return_one:
		li $v0, 1
		j end_find_majority
	find_majority_return_zero:
		li $v0, 0
		j end_find_majority
	find_majority_return_integer:
		move $v0, $s5	
	end_find_majority:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36	# Put the stack pointer and save registers back
	
	jr $ra


#iterateCandidates function
iterateCandidates:
	addi $sp, $sp, -28	# Store the save registers that we will be using
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0	# Store array address in s0
	move $s1, $a1	# Store file descriptor in s1
	li $s2, 0	# Store end_index in s2
	li $s3, 0	# Store start_index in s3
	
	# Get the end_index value
	calc_end_index_loop:
		li $t0, -1
		li $t7, 4	# Multiply end_index by 4 to get word address
		mult $s2, $t7
		mflo $t7
		add $t1, $s0, $t7
		lw $t6, ($t1)
		beq $t6, $t0, end_calc_end_index_loop	# If input_array[end_index] == -1, break from loop
		
		addi $s2, $s2, 1	# Otherwise, increment end_index and loop
		j calc_end_index_loop
	end_calc_end_index_loop:
	
	addi $s2, $s2, -1	# Decrement end_index
	
	li $s4, 0	# s4 will hold the counter (i) for the below for loop
	iterate_candidates_loop:
		bgt $s4, $s2, end_iterate_candidates_loop	# If i > end_index, break from loop
		
		print_candidate($s1)	# Print out candidate
		li $t7, 4	# Multiply end_index by 4 to get word address
		mult $s4, $t7
		mflo $t7
		add $t6, $s0, $t7
		lw $a0, ($t6)
		move $a1, $s1
		jal itof
		print_newline($s1)
		
		li $t7, 4	# Multiply end_index by 4 to get word address
		mult $s4, $t7
		mflo $t7
		add $t1, $s0, $t7
		lw $t6, ($t1)	# t6 now holds the integer value at input_array[i]
		
		move $a0, $s0
		move $a1, $t6
		move $a2, $s3
		move $a3, $s2
		
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		jal recursiveFindMajorityElement
		addi $sp, $sp, 4		# Put stack pointer back
		
		move $s5, $v0	# Put candidate_sum (return from recursiveFindMajorityElement) into s5 
		
		addi $t0, $s2, 1
		li $t1, 2
		div $t0, $t1
		mflo $t0	# Set t0 to ((end_index + 1)/ 2)
		
		ble $s5, $t0, no_majority_element_found
			print_majority_element($s1)
			li $t7, 4	# Multiply end_index by 4 to get word address
			mult $s4, $t7
			mflo $t7
			add $t1, $s0, $t7
			lw $s0, ($t1)		# Overwrite s0 with input_array[i] value
			move $a0, $s0
			move $a1, $s1
			jal itof
			print_newline($s1)
			j iterate_candidates_return_majority_element
		no_majority_element_found:
		
		addi $s4, $s4, 1
		j iterate_candidates_loop
	end_iterate_candidates_loop:
	
	print_majority_element($s1)		# If no majority element was found in the for loop, print -1 and return -1
	li $a0, -1
	move $a1, $s1
	jal itof
	print_newline($s1)
	j iterate_candidates_return_negative
	
	iterate_candidates_return_majority_element:
		move $v0, $s0
		j end_iterate_candidates
	iterate_candidates_return_negative:
		li $v0, -1
	
	end_iterate_candidates:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28	# Put the stack pointer and save registers back
	
	jr $ra


#Part 4

#recursiveFindLoneElement function
recursiveFindLoneElement:

	addi $sp, $sp, -36	# Store the save registers that we will be using
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0	# Store the address of input_array in s0
	move $s1, $a1	# Store startIndex in s1
	move $s2, $a2	# Store endIndex in s2
	move $s3, $a3	# Store the file descriptor in s3
	
	print_recursive_find_lone_element_open_par($s3)		# Write the header to the given file
	move $a0, $s1
	move $a1, $s3
	jal itof
	print_comma($s3)
	move $a0, $s2
	move $a1, $s3
	jal itof
	print_close_par($s3)
	
	sub $t0, $s2, $s1
	addi $t0, $t0, 1	# t0 will hold array_length
	li $t1, 2
	div $t0, $t1
	mfhi $t1		# t1 will hold (array_length % 2)
	
	bnez $t1, not_divisible
		print_return($s3)
		li $s0, -1		# Overwrite s0 with ret, since the function is about to return and exit
		move $a0, $s0
		move $a1, $s3
		jal itof
		print_newline($s3)
		j return_find_lone_element
		
	not_divisible:
	sub $t0, $s2, $s1
	addi $t0, $t0, 1	# t0 will hold array_length
	li $t1, 1
	
	bne $t0, $t1, array_length_not_equal_one
		li $t7, 4
		mult $s1, $t7
		mflo $t7
		add $t7, $s0, $t7
		lw $s0, ($t7)		# Overwrite s0 with ret, since the function is about to return and exit
		print_return($s3)
		move $a0, $s0
		move $a1, $s3
		jal itof
		print_newline($s3)
		j return_find_lone_element
	array_length_not_equal_one:
		sub $t0, $s2, $s1
		addi $t0, $t0, 1	# t0 will hold array_length
		li $t1, 2
		div $t0, $t1
		mflo $s4		# Store mid in s4
		
		add $t0, $s4, $s1
		li $t7, 4
		mult $t0, $t7
		mflo $t7
		add $t7, $s0, $t7
		lw $s5, ($t7)		# Store target in s5
		
		addi $t6, $t7, -4
		lw $s6, ($t6)		# Store left in s6
		
		addi $t6, $t7, 4
		lw $s7, ($t6)		# Store right in s7
		
		
		beq $s5, $s6, and_not_true
		beq $s5, $s7, and_not_true
			move $s0, $s5		# Overwrite s0 with target, since the function is about to return and exit
			print_return($s3)
			move $a0, $s0
			move $a1, $s3
			jal itof
			print_newline($s3)
			j return_find_lone_element
		and_not_true:
		bne $s5, $s6, target_not_equal_left
		beq $s5, $s7, target_not_equal_left
			addi $t0, $s4, -2		# t0 will hold left_half_length
			sub $t0, $t0, $s1
			addi $t0, $t0, 1
			
			li $t1, 2
			div $t0, $t1
			mfhi $t1
			bnez $t1, left_half_length_not_divisible
				addi $t1, $s4, 1
				add $t1, $t1, $s1	# t1 will hold child_start_index
				move $t2, $s2		# t2 will hold child_end_index
				
				move $a0, $s0
				move $a1, $t1
				move $a2, $t2
				move $a3, $s3
				jal recursiveFindLoneElement
				
				move $s0, $v0		# Overwrite s0 with ret, since the function is about to return and exit
				print_return($s3)
				move $a0, $s0
				move $a1, $s3
				jal itof
				print_newline($s3)
				j return_find_lone_element
			left_half_length_not_divisible:
				move $t1, $s1		# t1 will hold child_start_index
				addi $t2, $s4, -2
				add $t2, $t2, $s1	# t2 will hold child_end_index
				
				move $a0, $s0
				move $a1, $t1
				move $a2, $t2
				move $a3, $s3
				jal recursiveFindLoneElement
				
				move $s0, $v0		# Overwrite s0 with ret, since the function is about to return and exit
				print_return($s3)
				move $a0, $s0
				move $a1, $s3
				jal itof
				print_newline($s3)
				j return_find_lone_element	
		target_not_equal_left:
		bne $s5, $s7, target_not_equal_right
		beq $s5, $s6, target_not_equal_right
			addi $t0, $s4, 2
			sub $t0, $s2, $t0
			addi $t0, $t0, 1		# t0 will hold right_half_length
			
			li $t1, 2
			div $t0, $t1
			mfhi $t1
			bnez $t1, right_half_not_divisible
				move $t1, $s1		# t1 will hold child_start_index
				addi $t2, $s4, -1
				add $t2, $t2, $s1	# t2 will hold child_end_index
				
				move $a0, $s0
				move $a1, $t1
				move $a2, $t2
				move $a3, $s3
				jal recursiveFindLoneElement
				
				move $s0, $v0		# Overwrite s0 with ret, since the function is about to return and exit
				print_return($s3)
				move $a0, $s0
				move $a1, $s3
				jal itof
				print_newline($s3)
				j return_find_lone_element	
			right_half_not_divisible:
				move $t1, $s1
				add $t1, $t1, $s4
				addi $t1, $t1, 2	# t1 will hold child_start_index
				move $t2, $s2		# t2 will hold child_end_index
				
				move $a0, $s0
				move $a1, $t1
				move $a2, $t2
				move $a3, $s3
				jal recursiveFindLoneElement
				
				move $s0, $v0		# Overwrite s0 with ret, since the function is about to return and exit
				print_return($s3)
				move $a0, $s0
				move $a1, $s3
				jal itof
				print_newline($s3)
				j return_find_lone_element	
				
		target_not_equal_right:		# IF WE HIT THIS POINT, THERE IS SOMETHING VERY WRONG
	
	return_find_lone_element:
	move $v0, $s0		# s0 has been overwritten with return value, so we can load it into v0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36	# Put the stack pointer and save registers back
	
	jr $ra




### Data Section ###
.data

.align 2

# Strings used for writing to files
bears_open_par: .asciiz "bears( "
recursive_find_majority_element_open_par: .asciiz "recursiveFindMajorityElement( "
recursive_find_lone_element_open_par: .asciiz "recursiveFindLoneElement( "
comma: .asciiz ", "
close_par: .asciiz " )\n"
return: .asciiz "return: "
newline: .asciiz "\n"
candidate: .asciiz "candidate: "
majority_element: .asciiz "majority element: "

