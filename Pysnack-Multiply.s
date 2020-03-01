# Filename: Pysnack-Multiply.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description:  Multiply a hardcoded register value by 30 using only shifts and a simple add 

# store preloaded data here if needed  (not used in this program).
.data



result_text: .asciiz "The value of the multiplication is:  "

# Program body
.text
.globl	main

main:

# initialization	
add $t0, $zero, $zero # initializes counter to 0
add $s2, $zero, $zero # initializes $s2 (register that will store our final value) to 0 
addi $s0, $0, 5   # initialize $s0 = 5 Use this value to multiply by 49
		
#implement your multipliciation scheme
RunLoop:
slti $t1, $t0, 24 # when t0 (counter) has looped 24 times, set t1 to zero for exit condition
beq $t1, $zero, EndLoop # exits loop when above condition is false
sll $s1, $s0, 1 # multiplies base number by 2 on each iteration (24 iterations)
add $s2, $s1, $s2 # s2 will contain final number to be printed: accumulates a value of (n*2) each iteration
addi $t0, $t0, 1 # increments counter
j RunLoop

EndLoop:
add $s2, $s2, $s0 # adds base value ($s0) once more for 49th iteration

# Print the result
la $a0, ($s2)
li $v0, 1
syscall	

# program exit
li $v0, 10
syscall
