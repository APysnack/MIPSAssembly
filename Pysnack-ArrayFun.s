# Filename: Pysnack-ArrayFun.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description: Takes user input 5 times for array elements then fills the additional elements with calculated values 

.data
prompt: .asciiz "] has this value: "
precursor: .asciiz "index ["
iterator: .word 0
size: .word 9
half_size: .word 4
array: .space 40
linebreak: .byte '\n'
#------------------------------------------------------------------------#
.text
la $s0, prompt
la $t0, array
lw $t1, iterator
lw $t2, half_size
lw $t3, size
lw $s6, linebreak
#------------------------------------------------------------------------#
getLoop:
bgt $t1, $t2, exitGetLoop # exits if the iterator is greater than half the array size
sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)

li $v0, 5
syscall

sw $v0, 0($t5)

addi $t1, $t1, 1 # increments the iterator by 1
j getLoop
#------------------------------------------------------------------------#
exitGetLoop:
sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)
lw $t8, 8($t0)
lw $t9, 0($t0)
add $s5, $t8, $t9

sw $s5, 0($t5)
addi $t1, $t1, 1 

sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)
lw $t8, 20($t0)
lw $t9, 16($t0)
add $s5, $t8, $t9

sw $s5, 0($t5)
addi $t1, $t1, 1 

sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)
lw $t8, 24($t0)
lw $t9, 20($t0)
sub $s5, $t8, $t9

sw $s5, 0($t5)
addi $t1, $t1, 1 

sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)
lw $t8, 4($t0)
lw $t9, 12($t0)
add $s5, $t8, $t9

sw $s5, 0($t5)
addi $t1, $t1, 1 

sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)
lw $t8, 32($t0)
lw $t9, 28($t0)
add $s5, $t8, $t9

sw $s5, 0($t5)
addi $t1, $t1, 1 

j re_init

re_init:
add $t1, $zero, $zero
add $t4, $zero, $zero

j printArray
#------------------------------------------------------------------------#
printArray:
bgt $t1, $t3, exitProgram # if iterator is great than size, exit program
sll $t4, $t1, 2 # iterates using 4i (e.g. 4, 8, 12, 16, etc.)
addu $t5, $t4, $t0 # sticks the address in front of the above value (e.g. 1000, 1004, 1008, etc.)

li $v0, 4
la $a0, precursor
syscall

li $v0, 1
la $a0, ($t1)
syscall


li $v0, 4
la $a0, prompt 
syscall

li $v0, 1
lw $a0, 0($t5)
syscall

li $v0, 11
lb $a0, linebreak
syscall


addi $t1, $t1, 1

j printArray
#------------------------------------------------------------------------#
exitProgram:
li $v0, 10
syscall
