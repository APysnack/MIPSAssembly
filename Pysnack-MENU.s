# Filename: Pysnack-MENU.s
# Target:  MIPS ISA Simulator
# Author: Alan Pysnack
# Description: Create a menu to allow a user to check, reset, set, or view a bit of an integer.
#-----------------------------------------------------------------------------------#

.data
prompt: .asciiz "\nPlease enter an integer: \n"
prompt2: .asciiz "\nPlease enter a character - \n 'a' to start over \n 'd' to view the current integer in its decimal value \n 'q' to quit \n 'r' to set the indicated bit to 0 \n 's' to set the indicated bit to 1 \n 't' to toggle the indicated bit \n"
prompt3: .asciiz "\nThe integer you originally entered was: "
prompt4: .asciiz "\nWould you like to see the menu again? Enter 1 for yes, 0 for no\n"
bit_prompt: .asciiz "\nPlease enter which bit you would like to modify (1 being the LSB and 32 being the MSB)\n"

restart: .byte 'a'
decimal: .byte 'd'
quit: .byte 'q'
reset: .byte 'r'
set: .byte 's'
toggle: .byte 't'
#-----------------------------------------------------------------------------------#

.text 
# loading registers s0 - s5 with all possible menu options to compare with the register that stores the user's value
lb $s0, restart
lb $s1, decimal
lb $s2, quit
lb $s3, reset
lb $s4, set
lb $s5, toggle
#-----------------------------------------------------------------------------------#

Start:
li $v0, 4 		# Syscall command to print a string
la $a0, prompt		# Loads a0 with the address containing the ascii value of prompt
syscall			# executes print "Please enter an integer: "

li $v0, 5		# Syscall command to read an integer, takes user int and stores in $v0
syscall 		# executes the above command
move $t9, $v0		# moves the user's inputted integer into register $t9
#-----------------------------------------------------------------------------------#

MainLoop:
li $v0, 4		# Syscall command to print a string
la $a0, prompt2		# Loads a0 with address containing ascii value of prompt 2
syscall			# Executes command to print the list of menu options

li $v0, 12		# Syscall command to read a char, takes user input and stores char in $v0
syscall			# executes above command
move $t8, $v0		# moves user inputted character (menu option) to $t8

beq $t8, $s0, Start		# if user input char stored in $t0 == 'a', branches to Start
beq $t8, $s1, Print_Decimal 	# if user input char stored in $t0 == 'd', branches to Print_Decimal
beq $t8, $s2, Exit		# if user input char stored in $t0 == 'q', branches to Exit
beq $t8, $s3, Get_Bit		# if user input char stored in $t0 == 'r', branches to getBit
beq $t8, $s4, Get_Bit		# if user input char stored in $t0 == 's', branches to getBit
beq $t8, $s5, Get_Bit		# if user input char stored in $t0 == 't', branches to getBit
#-----------------------------------------------------------------------------------#

Print_Decimal:
li $v0, 4		# Syscall command to print a string
la $a0, prompt3		# Loads address with address storing ascii for prompt3 
syscall			# Executes print "The integer you originally entered was: "

li $v0, 1		# Syscall command to print an integer
la $a0, ($t9)		# Loads address with address of t9, which contains the integer inputted by the user
syscall			# Executes print of user's integer

li $v0, 4		# Syscall command to print a string
la $a0, prompt4		# Loads address with address storing ascii for prompt4
syscall			# Executes print "Would you like to see the menu again? 1 for yes, 0 for no"

li $v0, 5		# Syscall command to read an integer
syscall 		# Executes above command and stores user-inputted int in v0
move $t7, $v0		# moves user's boolean response (1 or 0) to register $t7

beqz $t7, Exit		# if user chose 0, branches to exit program
j MainLoop		# else, jumps back to the main menu
#-----------------------------------------------------------------------------------#

Get_Bit:
li $v0, 4 		# Syscall command to print a string
la $a0, bit_prompt	# Loads a0 with the address containing the ascii value of bit_prompt
syscall			# executes print "Please enter which bit you would like to modify (1 - 32 from left to right):"

li $v0, 5		# Syscall command to read an integer, takes user int and stores in $v0
syscall 		# executes the above command
move $t6, $v0		# moves the user's inputted integer into register $t6

beq $t8, $s4, Set		# if user input char stored in $t0 == 'r', branches to Reset
beq $t8, $s3, Reset		# if user input char stored in $t0 == 's', branches to Set
beq $t8, $s5, Toggle		# if user input char stored in $t0 == 't', branches to Toggle
j Exit

#-----------------------------------------------------------------------------------#
# Set/Reset/Toggle:
# t9 contains original int.
# t8 contains character input (r, s, or t)
# t6 contains the bit the user wants to modify (1 - 32)
# s0 will contain the bit mask
#-----------------------------------------------------------------------------------#

Reset:
jal Shift_Left
li $t0, -1		# loads immediate with -1 in binary (e.g. 1111111...)
xor $a2, $v0, $t0	# perform an xor operation on the bit the user chose to invert (e.g. 0010..)
and $a2, $a2, $t9	# performs and operation with integer and the above (e.g. 0010..) to set the digit to 0

li $v0, 1
la $a0, ($a2)
syscall

j Exit
#-----------------------------------------------------------------------------------#

Set:
jal Shift_Left
or $a2, $v0, $t9

li $v0, 1
la $a0, ($a2)
syscall

j Exit
#-----------------------------------------------------------------------------------#

Toggle:
jal Shift_Left
xor $a2, $v0, $t9	  # xors 1 at the bit specified by the user and stores in a2

li $v0, 1
la $a0, ($a2)
syscall

j Exit

#-----------------------------------------------------------------------------------#
Shift_Left:
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

li $s0, 1		# stores binary bit of ...0001
addi $s1, $zero, 1	# Counter

Shift_Loop:
beq $s1, $t6, continue # loops through shift until counter reaches the digit specified by the user
sll $s0, $s0, 1		  # Shifts the 1 in the binary bit by 1 digit each loop
addi $s1, $s1, 1	  # increments the counter
j Shift_Loop

continue:
move $v0, $s0

lw $s0, 0($sp)
lw $s1, 4 ($sp)
addi $sp, $sp, 8

jr $ra

Exit:
li $v0, 10		# Syscall command to exit program
syscall			# Executes exit
