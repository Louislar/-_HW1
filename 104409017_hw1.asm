.data
	
	text_change_line:  .asciiz "\n"
     text:  .asciiz "\nInput: \n"
     text_a:.asciiz "A"
  text_b:.asciiz "B\n"
  text_win:  .asciiz "You Win!\n"
   text_over:  .asciiz "Game over!\n"
   text_warning:  .asciiz "WARNING: redundant digits\n"
  answer_int: .word 0
  answer_int01: .word 0
  answer_int02: .word 0
  answer_int03: .word 0
  answer_int04: .word 0
  input_int: .word 0
  turn: .word 0
  As: .word 0
  Bs: .word 0
  counter_read: .word 1
     
.text

 main:
    # Printing out the text
    #li $v0, 4
    #la $a0, text
    #syscall
    #jal print
    
L2:
	#random int01
    li $v0, 42
    li $a1, 10
    syscall
    
    move $s0, $a0
    la $t1, answer_int01 #load address of random_int01 to $t1
    sw $a0, 0($t1) #store the random number in random_int01
    # Printing out the randim int01
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores random_int's address
    syscall
   
random02: 
    #random int02
    li $v0, 42
    li $a1, 10
    syscall
    beq $a0, $s0, random02
    move $s1, $a0
    
    la $t1, answer_int02 #load address of random_int02 to $t1
    sw $a0, 0($t1) #store the random number in random_int02
    # Printing out the randim int02
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores random_int's address
    syscall

random03:        
    #random int03
    li $v0, 42
    li $a1, 10
    syscall
    beq $a0, $s0, random03
    beq $a0, $s1, random03
    move $s2, $a0
    
    la $t1, answer_int03 #load address of random_int03 to $t1
    sw $a0, 0($t1) #store the random number in random_int03
    # Printing out the randim int03
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores random_int's address
    syscall
    
    
random04:
    #random int04
    li $v0, 42
    li $a1, 10
    syscall
    beq $a0, $s0, random04
    beq $a0, $s1, random04
    beq $a0, $s2, random04
    
    la $t1, answer_int04 #load address of random_int04 to $t1
    sw $a0, 0($t1) #store the random number in random_int04
    # Printing out the randim int04
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores random_int's address
    syscall
    
j L1
    
    
L1:    
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall
    
    
read:
    
    #read in integer
    li      $v0, 5
    syscall
    
    #store integer to input_int
    la $t1, input_int #load address of input_int to $t1
    sw $v0, 0($t1) #store the input number in input_int
    move $s1, $v0 #store the input number in $s1
    
    # Printing out the input int
    #li $v0, 1
    #lw $a0, 0($t1) # $t1 stores input_int's address
    #syscall
    
    # Printing out the '\n'
    #li $v0, 4
    #la $a0, text_change_line
    #syscall
    
    
    # separate 4 digits of the input
    #match each input's digit with answer's digit
    li $s0, 4
    li $s2, 10 # store 10 in $s2
    
    div $s1, $s2
    mflo $s1#quotent
    mfhi $a2#reminder
    move $s4, $a2
    move $a1, $s0 # pass current digit to function by $a1
    jal function
    subi $s0, $s0, 1
    
    
    
    div $s1, $s2
    mflo $s1#quotent
    mfhi $a2#reminder
    move $s5, $a2
    move $a1, $s0 # pass current digit to function by $a1
    jal function
    subi $s0, $s0, 1
    beq $s4, $s5, warning
    
    
    div $s1, $s2
    mflo $s1#quotent
    mfhi $a2#reminder
    move $s6, $a2
    move $a1, $s0 # pass current digit to function by $a1
    jal function
    subi $s0, $s0, 1
    beq $s5, $s6, warning
    beq $s4, $s6, warning
    
    
    div $s1, $s2
    mflo $s1#quotent
    mfhi $a2#reminder 
    move $s7, $a2
    move $a1, $s0 # pass current digit to function by $a1
    jal function
    beq $s4, $s7, warning
    beq $s5, $s7, warning
    beq $s6, $s7, warning

    
    jal print
    
    #check win 
    la $t0, As
    lw $t1, 0($t0)
    beq $t1, 4, happy_end
    
    #initial As and Bs
    la $t0, As
    sw $zero, 0($t0)
    la $t0, Bs
    sw $zero, 0($t0) 
    la $t0, counter_read
    lw $t1, 0($t0)
    addi $t1, $t1, 1
    sw $t1, 0($t0)
    bne $t1, 10, read # run read 9 times
    
    
j end
    
    
print:
    
	# Printing out As 
	la $t1, As
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores A's address
    syscall
    
    # Printing out the 'A'
    li $v0, 4
    la $a0, text_a
    syscall
    
    # Printing out Bs 
	la $t1, Bs
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores B's address
    syscall
    
    # Printing out the 'B'
    li $v0, 4
    la $a0, text_b
    syscall
    
    jr $ra
    
function: #two argument $a1, $a2
	la $t1, answer_int01
	lw $t2, 0($t1) #store snawer_int01 in $t2
	bne $t2, $a2, check02
	beq $a1, 1,A01
	# Bs add one
	la $t5, Bs
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	j check02
A01:
	#As add one
	la $t5, As
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	
	
check02:
	la $t1, answer_int02
	lw $t2, 0($t1) #store snawer_int02 in $t2
	bne $t2, $a2, check03 #If the number isn't equal, then jump to next check03
	beq $a1, 2,A02 #If digit is same then A add 1
	# Bs add one
	la $t5, Bs
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	j check03
A02:
	#As add one
	la $t5, As
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	
	
check03:
	la $t1, answer_int03
	lw $t2, 0($t1) #store snawer_int03 in $t2
	bne $t2, $a2, check04 #If the number isn't equal, then jump to next check04
	beq $a1, 3,A03 #If digit is same then A add 1
	# Bs add one
	la $t5, Bs
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	j check04
A03:
	#As add one
	la $t5, As
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	
check04:
	la $t1, answer_int04
	lw $t2, 0($t1) #store snawer_int04 in $t2
	bne $t2, $a2, function_end #If the number isn't equal, then jump to function_end
	beq $a1, 4,A04 #If digit is same then A add 1
	# Bs add one
	la $t5, Bs
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	j function_end
A04:
	#As add one
	la $t5, As
	lw $t6, 0($t5)
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	


	
function_end:
jr $ra #back to callee
    
    
    
    
end:
	# Printing out the text
    li $v0, 4
    la $a0, text_over
    syscall
	li      $v0, 10 #exit
        syscall

happy_end:
	# Printing out the text
    li $v0, 4
    la $a0, text_win
    syscall
	li      $v0, 10 #exit
        syscall
        
        
warning:
	# Printing out the text
    li $v0, 4
    la $a0, text_warning
    syscall
	li      $v0, 10 #exit
        syscall
