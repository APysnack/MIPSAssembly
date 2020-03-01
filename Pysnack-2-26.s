# Filename: Pysnack-2-26.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description:  Loops 10 times and increments s2 by 2 on each loop

.data

.text
addi, $t1, $zero, 10 #stores the number 10 in t1. t1[10]

LOOP: 
slt $t2, $0, $t1 # if zero is less than t1 then t2 contains 1. Otherwise, it contains 0 (exit condition)
beq $t2, $0, DONE # when t2 equals zero, branch to DONE 
subi $t1, $t1, 1 # decrements the value of t1 by 1 in each loop until t1 = 0 (10 loops total)
addi $s2, $s2, 2 # increments the value of s2 by 1 in each loop until t1 = 0 (10 loops * 2 = 20)
j LOOP

DONE:

la $a0, ($s2) #loads the address of s2 into argument to be printed
li $v0, 1 # loads command to print integer stored in a0
syscall # prints integer

li $v0, 10 # exits program
syscall
