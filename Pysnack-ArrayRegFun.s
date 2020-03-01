# Filename: Pysnack-ArrayRegFun.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description: Same as ArrayFun, but uses each temporary register as an element of the array

.data
prompt: .asciiz "] has this value: "
precursor: .asciiz "index ["
linebreak: .byte '\n'

.text
main:
li $v0, 5
syscall

move $t0, $v0

li $v0, 5
syscall

move $t1, $v0

li $v0, 5
syscall

move $t2, $v0

li $v0, 5
syscall

move $t3, $v0

li $v0, 5
syscall

move $t4, $v0

add $t5, $t0, $t2
add $t6, $t5, $t4
sub $t7, $t6, $t5
add $t8, $t1, $t3
add $t9, $t8, $t7

#-------------------------------------------------------------------#
#0
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 0
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t0)
syscall

li $v0, 11
lb $a0, linebreak
syscall

#-------------------------------------------------------------------#
#1
li $v0, 4
la $a0, precursor
syscall

li $v0, 1 
li $a0, 1
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t1)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#2
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 2
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t2)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#3
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 3
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t3)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#4
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 4
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t4)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#5
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 5
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t5)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#6
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 6
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t6)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#7
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 7
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t7)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#8
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 8
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t8)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#
#9
li $v0, 4
la $a0, precursor
syscall

li $v0, 1
li $a0, 9
syscall

li $v0, 4
la $a0, prompt
syscall

li $v0, 1
la $a0, ($t9)
syscall

li $v0, 11
lb $a0, linebreak
syscall
#-------------------------------------------------------------------#

j exitProgram

exitProgram:
li $v0, 10
syscall
