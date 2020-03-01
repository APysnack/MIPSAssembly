# Filename: Pysnack-OddSpacing.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description: Outputs character with (ascii value) spaces before it


# store preloaded data here
.data
linebreak: .byte '\n'
terminator: .byte '0'
string_space: 1024
space: .byte ' '

# Program body
.text
.globl	main

main:	
	la $s0, linebreak
	lb $s3, terminator
	add $t5, $zero, $zero
	li $t9, 32
	li $v0, 8 # syscall command to read user input (string)
	la $a0, string_space # tell syscall where the buffer is  
	li $a1, 1024 # tell syscall how big the buffer is
	syscall  # syscall to execute the above
	
	la $t0, string_space

	# inserts linebreak
	li $v0, 11
	lb $a0, ($s0)
	syscall
	
	RunLoop: #Label 
	lb $a0, ($t0)	#loads the byte at address t0
	beq $a0, $s3, EndLoop #branches to EndLoop when t0 has been incremented 11 times (number of chars)
	beq $a0, $t9, convertspace
	add $s5, $zero, $a0
	jal printSpace
	lb $a0, ($t0)	#loads the byte at address t0
	addi $t0, $t0, 0x01 #increments the address in t0 by 1
	add $t5, $zero, $zero
	
	li $v0, 11	  # code for print_character
	syscall # calls print_character
	
	li $v0, 11
	lb $a0, ($s0)
	syscall
	j RunLoop
	
	EndLoop:
	li $v0, 10	# code for exit
	syscall
	
	printSpace:
	spaceLoop:
	sra $s6, $s5, 2
	bgt $t5, $s6, exitSpace
	
	li $v0, 11
	li $a0, 32
	syscall
	
	addi $t5, $t5, 1
	j spaceLoop
	
	exitSpace:
	jr $ra
	
	convertspace:
	li $a0, 35
	li $v0, 11
	syscall
	
	lb $a0, ($t0)	#loads the byte at address t0
	addi $t0, $t0, 0x01 #increments the address in t0 by 1
	add $t5, $zero, $zero
	
	li $v0, 11
	lb $a0, ($s0)
	syscall
	j RunLoop