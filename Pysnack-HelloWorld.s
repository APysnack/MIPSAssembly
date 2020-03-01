# Filename: Pysnack-HelloWorld.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description:  Outputs "Hello World" in individual characters with line breaks in between


# store preloaded data here
.data
message:	.asciiz "Hell0 World!"
linebreak: .byte '\n'


# Program body
.text
.globl	main

main:	
	la $s0, linebreak
	li $t0, 0x10010000 #loads t0 register with the first address in memory
	
	RunLoop: #Label 
	beq $t0, 0x1001000c, EndLoop #branches to EndLoop when t0 has been incremented 11 times (number of chars)
	lb $a0, ($t0)	#loads the byte at address t0
	addi $t0, $t0, 0x01 #increments the address in t0 by 1
	li $v0, 11	  # code for print_character
	syscall # calls print_character
	
	li $v0, 11
	lb $a0, ($s0)
	syscall
	j RunLoop
	
	EndLoop:

	# program exit
	li $v0, 10	# code for exit
	syscall
