# Filename: Pysnack-Acker.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description: Performs Ackermann's function on two different user-input values

.data
userPrompt:	.asciiz	  "Please enter two positive values to Calculate the Ackermann Value or -1 to exit program\n"
mPrompt: 	.asciiz   "Enter the m value: "
nPrompt: 	.asciiz   "Enter the n value: "
result0:  	.asciiz   "Ackermann(" 
result1:	.asciiz   ", "	
result2:	.asciiz   ") is "
newLine:	.asciiz   "\n\n"
error: 	.asciiz   "Error: Please enter a positive integer"	
.text

#-------------------------------------------------------------------------------------#
# int ack(int m, int n)
# {
#   if (m == 0) return n+1;
#   if (n == 0) return ack( m - 1, 1 );
#   return ack( m - 1, ack( m, n - 1 ) );
# }
#-------------------------------------------------------------------------------------#
main: 

li $v0, 4    			# loads sys command to print string
la $a0, userPrompt 		# stores userPrompt .ascii string to the argument to be printed
syscall				# executes print command
		
programInstructions:
li $v0, 4    			# loads sys command to print string	
la $a0, mPrompt 		# loads string to prompt user to enter m value
syscall	 			# output the prompt
 
li $v0, 5 			# loads syscall command to read an integer from user input
syscall				# executes read
		
move $s0, $v0  			# moves user-inputted m value into register $s0
move $t0, $v0			# makes another copy of user input to store in $t0
bltz $s0, exit			# if user input is negative, exits program
		
li $v0, 4 			# loads syscall command to print a string
la $a0, nPrompt 		# loads a0 with the prompt for user to enter n  
syscall 			# prints prompt for n
 
li $v0, 5 			# loads system call code 5 for reading an integer from the user input into register $v0
syscall 			# calling the OS to read an interger for the n value
		
move $s1, $v0  			# copies user-inputted n value into s1
move $t1, $v0			# another copy of user-inputted n value for t1
bltz $s1, exit			# if n value is 0, exits program
 		
move 	$a0, $s0   		# assigning m ($s0) to $a0
move 	$a1, $s1   		# assigning n ($s1) to $a1

jal Ackermann			# jumps to perform the Ackermann function and links a return address
#-------------------------------------------------------------------------------------#
# SO FAR: prompted user to enter m and n
# if either value was 0, outputs an error message
# made copies of m in registers $t0, $s0, and $a0. 
# made copies of n in registers $t1, $s1, and $a1, n still contained in $v0
# called ackermann function 
#-------------------------------------------------------------------------------------#
# After returning to $ra: 

addi 	$sp, $sp, -16 			# moves stackpointer down to store 4 more words
sw   	$s0, 4($sp) 			# stores $s0 in the stack -- value of m
sw   	$s1, 8($sp) 			# stores $s1 in the stack -- value of n
sw   	$s2, 12($sp)			# stores $s2 in the stack
sw   	$ra, 0($sp) 			# stores return address register $ra

move  	$a2, $v0			# move the value in $v0 to $a2 (final answer)
addi 	$sp, $sp, -4  			# make room to add another register to the stack
sw 	$a0, 0($sp)  			# stores $a0 in the stack
 
la 	$a0, result0 			# loads address for the first part of the result string to be printed
li 	$v0, 4    			# loads syscall command to print 
syscall					# executes print
		
move 	$a0, $t0 			# loads address for the user's original m value 
li 	$v0, 1    			# syscall command to print an integer
syscall					# executes print		
		
la 	$a0, result1 			# loads address for the second part of the result string to be printed
li 	$v0, 4    			# loads syscall command to print string
syscall					# executes print

move 	$a0, $t1 			# loads address for the user's original n value 
li 	$v0, 1    			# syscall command to print an integer
syscall					# executes print	
 		
la 	$a0, result2 			# loads address for the third part of the result string to be printed
li 	$v0, 4    			# loads syscall command to print string
syscall					# executes print
		
move 	$a0, $a2  			# prints the calculates answer to Ackermann's function
li 	$v0, 1    			# loads syscall command to print int
syscall					# executes print
		
la 	$a0, newLine 			# loading address for the linebreak to be printed
li 	$v0, 4    			# syscall command to print string
syscall					# executes print
 
lw 	$a0, 0($sp) 			# restores $a0 from stack
addi 	$sp, $sp, 4  			# restores $sp, the stack pointer
 
lw 	$ra, 0($sp) 			# restores $ra from stack
lw 	$s0, 4($sp)			# restores $s0 from stack  
lw 	$s1, 8($sp)			# restores $s1 from stack
lw 	$s2, 12($sp)			# restores $s2 from stack
addi 	$sp, $sp, 16  			# restores $sp, the stack pointer
 		
j programInstructions	# calling the programInstructions to restart the program instructions again

#-------------------------------------------------------------------------------------#
# current: copies of m in registers $t0, $s0, and $a0. 
# current: copies of n in registers $t1, $s1, and $a1
Ackermann:
addi $sp, $sp, -8 			# moves stack pointer down to store 2 words (4 bytes each)
sw $s0, 4($sp) 				# stores $s0 (m) in stack with an offset of 4
sw $ra, 0($sp) 				# stores return address in stack with an offset of 0
#-------------------------------------------------------------------------------------# 
mZero: 			# handles the case that m = 0
bne $a0, $zero, nZero  # if m is not equal to 0, branches to nZero to check if n is equal to 0
addi $v0, $a1, 1 	# n + 1 stored in $v0
j done 			# jumps to done, where data will be reset from the stack
#-------------------------------------------------------------------------------------# 
nZero:    	
bne $a1, $zero, bothAreGreater	# if n is zero, execute the code below. Else, branches to bothAreGreater
addi $a0, $a0, -1 		# Loads m - 1 as the first argument to be passed recursively to the ackermann function 
addi $a1, $zero, 1 		# Loads 1 as the second argument to be passed recursively to ackermann
jal   Ackermann 		# Recursive jump to Ackermann(m-1, 1), will return to this point once finished 
j done 				# once the above call is completed, program continues with a jump to "done" label
#-------------------------------------------------------------------------------------#        	
bothAreGreater:	 		# this point of the program only active if both m and n are greater than zero
add $s0, $a0, $zero		# Saves m into $s0
addi $a1, $a1, -1		# Puts n - 1 into the second argument to be passed to Ackermann
jal Ackermann			# Ackermann(m, (n -1))
#-------------------------------------------------------------------------------------#
addi $a0, $s0, -1	# $a0 = m - 1
add $a1, $v0, $zero	#  
jal Ackermann		# Ackermann(m-1, A(m, (n - 1)))
#-------------------------------------------------------------------------------------#
j   done		# complete the function call
#-------------------------------------------------------------------------------------#		
done:        	
lw $s0, 4($sp) 		# loads the original value of m from the stack to put it back in $s0
lw $ra, 0($sp)		# loads the return address from the stack
addi $sp, $sp, 8 	# resets the stack pointer
jr $ra 			# returns to the spot in programInstructions where jal was called to finish execution
#-------------------------------------------------------------------------------------#		
exit:		
li 	$v0, 4		# loads the syscall command for printing a string
la 	$a0, error 	# loads "Error" ascii string "Please Enter a Positive integer" to be printed
syscall			# prints "Please Enter a Positive Integer"
		
li $v0, 10		# syscall command to exit the program
syscall			# exits the program
