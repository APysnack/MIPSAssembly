# Filename: Pysnack-AddArray.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description:  Take numbers from Array and add them
#               Output each element and the total sum of array A[]


# store preloaded data here
.data
result_text:  .asciiz "The final sum of array elements is"
cur_ele_text: .asciiz "The current index is ["
value: .asciiz "] and the value inside A is: "
valueB: .asciiz ". The value inside B is: "
combined: .asciiz "Adding these indices gives you: "
sumAll: .asciiz "The sum of all the array indices in A and B: "
sumAllA: .asciiz "The sum of all the array indices in A: "
sumAllB: .asciiz "The sum of all the array indices in B: "
newline:	.byte '\n'

# this program assumes both arrays are the same size, to change this, add separate iterators and sizes for each array
# address for Array, allocates 5 x 4 bytes of memory 
ArrayA:       .word 4, 8, 12, 16, 20
ArrayB:		.word 3, 5, 7, 11, 13
Iterator: .word 0
Size: .word 5 # uses array size + 1 since we're counting from 0 and assignment requires slt

#----------------------------------------------------------------#
.text
.globl	main

main:
la $s0, result_text
la $s1, cur_ele_text
la $s2, newline
la $t0, ArrayA
la $t7 ArrayB
lw $t1, Iterator
lw $t2, Size

# Add the array elements
printArrayLoop:
slt $t4, $t1, $t2 # if iterator is greater than the size of the array, sets t4 to 0
beq $t4, $zero, exit_loop # when t4 is 0, branches to exit_loop
sll $t5, $t1, 2 # multiplies the iterator by 4i (e.g. 4, 8, 12, 16...)
addu $t6, $t0, $t5 # stores address of arrayA index plus the above iterator (e.g. 1004, 1008, 1012..) in t6
addu $t8, $t7, $t5 # stores address of arrayB index plus the above iterator (e.g. 2004, 2008, 2012..) in t8
jal print_current # jumps to print current function 
addi $t1, $t1, 1 # increments iterator by one
j printArrayLoop # jumps to top of loop

print_current:
li $v0, 4 # loads syscall command to print string
la $a0, cur_ele_text # loads address for cur_ele_text "The current index is "
syscall # executes syscall 4 to print cur_ele_text

li $v0, 1 # loads syscall command to print int
la $a0, ($t1) # loads the current number for the iterator
syscall #prints the iterator

li $v0, 4 # loads syscall command to print string 
la $a0, value # loads address for ascii string designated for value, "And the value inside A is "
syscall # executes syscall 4 to print value

li $v0, 1 # loads syscall to print int
lw $a0, ($t6) # loads the number in the current index address for ArrayA
syscall # prints the number in the current index address for ArrayA

li $v0, 4 # loads syscall to print string
la $a0, valueB #loads address of value ascii string, "And the value inside B is "
syscall # prints "value" string

li $v0, 1 # loads syscall to print int
lw $a0, ($t8) # loads the number in the current index address for ArrayA
syscall # prints the number in the current index address for ArrayA

li $v0, 11 # loads syscall to print a character
lb $a0, newline # loads the newline character as a byte
syscall # prints the newline

j Calculate # jump to calculate 

Calculate:
lw $s0, ($t6) # loads int at index i stored in t6 (ArrayA) into s0
lw $s1, ($t8) # loads int at index i stored in t8 (ArrayB) into s1
add $s2, $s1, $s0 # adds index i from A and index i from B to be saved in s2

li $v0, 4 # loads syscall command to print a string
la $a0, combined # loads address of ascii "Adding these values gives you: "
syscall # prints string

li $v0, 1 # loads syscall command to print integer
la $a0, ($s2) # loads the value of the two combined indices to be printed from s2
syscall # prints the sum of A[i] + B[i]

li $v0, 11 # loads syscall command to print character
lb $a0, newline # loads ascii to enter a linebreak
syscall # prints linebreak

add $s4, $s4, $s0 #s4 accumulates the running sum of A indices
add $s5, $s5, $s1 #s5 accumulates the running sum of B indices
add $s6, $s6, $s2 #s6 accumulates the running sum of all indices
jr $ra # returns to jal call in printArrayLoop

exit_loop: 
jal printSum # now that all the running totals of index A and B are totaled, jumps to print sum function

li $v0, 10
syscall

printSum: # prints out the running total sums of index A, index B, and A + B
li $v0, 4 # loads syscall command to print a string
la $a0, sumAllA # loads address of ascii "Adding these values gives you: "
syscall # prints string

li $v0, 1 # loads syscall command to print int
la $a0, ($s4) # loads the running total of A indices
syscall #prints the number

li $v0, 11 # loads syscall command to print character
lb $a0, newline # loads ascii to enter a linebreak
syscall # prints linebreak

li $v0, 4 # loads syscall command to print a string
la $a0, sumAllB # loads address of ascii "Adding these values gives you: "
syscall # prints string

li $v0, 1 # loads syscall command to print int
la $a0, ($s5) # loads the running total of B indices
syscall #prints the number

li $v0, 11 # loads syscall command to print character
lb $a0, newline # loads ascii to enter a linebreak
syscall # prints linebreak

li $v0, 4 # loads syscall command to print a string
la $a0, sumAll # loads address of ascii "Adding these values gives you: "
syscall # prints string

li $v0, 1 # loads syscall command to print int
la $a0, ($s6) # loads the running total of all indices
syscall #prints the number
jr $ra