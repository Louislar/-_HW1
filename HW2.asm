.data

	change_line: .asciiz "\n"
     text:  .asciiz "\nInput: \n"
  turn: .word 0
  k: .word 0
  x: .word 0


.text

 main:
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall
    
    
read:
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall
    #read in integer, k, which is the number of a_i's i also m_i's i
    li      $v0, 5
    syscall
    # store k in $s0 (always)
    move $s0, $v0
    
    # We will input k*2 data
    addu $t0, $s0, $s0
input:
    #read in integer
    li      $v0, 5
    syscall
    #push the input integer in stack
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    
    
    subi $t0, $t0, 1  # loop 2*k times
    bne $t0, 0, input
	
	#we input k a_i first, then input k m_i
	#, but we need m_i first
	# store the $sp at $s1
	move $s1, $sp
	addu $t0, $s0,$zero # loop k times 
s1_adjust:	# adjust $s1 to storing m_i's data's address (always)
	addi $s1, $s1, 4
	subi $t0, $t0, 1
	bne $t0, 0, s1_adjust
	
	
	#we need to multiply k m_i, to get m, and store it in $s2
	move $t0, $s0 # loop k times
	move $t1, $sp # store m_i's data's address (temp)
	li $s2, 1 # store m at $s2 (always)
cal_m:
	lw $t2, 0($t1) # load m_i to $t2
	mul $s2, $s2, $t2 # mlutiply s2 by t2, then store the result in s2
	addi $t1, $t1, 4
	subi $t0, $t0, 1
	bne $t0, 0, cal_m
	
	

	#we ned to count k Y_i, so loop k times
	# At the same time, we add all a_i*M_i*Y_i to x
	move $t0, $s0
	move $t1, $s1 # store m_i's data's address (temp)
count_Y_i: # $t0 cannot use
	addi $t1, $t1, -4 # make $t1 point to m_i
	lw $t2, 0($t1) # load m_i to $t2 (temp)
	
	#calulate M_i
	div $s2, $t2 # m/m_i
	mflo $t3 # $t3 stores M_i
	
    move $a0, $t3 # $a0 is M_i
    move $a1, $t2 # $a1 is m_i
    jal gcd # i will store in $v0, and j will store in $v1
    		# 1 = i*M_i + j*m_i
    		# so, $v0 stores Y_i
    
adjust_i: # check i is positive, otherwise, add m_i to i, until i is positive
	
	#pop a_i from stack
	subi $t4, $t0, 2 # $t4 stores the offset of the a_i
	mul $t4, $t4, 4
	move $t5, $s1 # $t5 stores the address of stack's top
	add $t5, $t5, $t4
	lw $t5, 0($t5) # $t5 stores the a_i
	
	
    #add a_i*M_i*Y_i to x
    mul $t6, $t5, $t3 # a_i*M_i
    mul $t6, $t6, $v0 # (a_i*M_i) *Y_i
    # save x to memory
    lw $t7, x
    add $t7, $t7, $t6
    sw $t7, x 
    
    #print i
    move $t8, $v0 #$s1=i
    move $t9, $v1 #$s2=j
    li $v0, 1
    move $a0, $t8
    syscall
    
    # Printing out the \n
    li $v0, 4
    la $a0, change_line
    syscall
    
    #print j
    li $v0, 1
    move $a0, $t9
    syscall
    
    # Printing out the \n
    li $v0, 4
    la $a0, change_line
    syscall
    
    #print x
    lw $a0, x
    jal print_
    
    
    subi $t0, $t0, 1
    bne $t0, 0, count_Y_i
    
    
    j end
    
    
    
    
    
    
    
    
    
gcd:
	# cal gcd(A, B), assume that A>B
	# $a0=A=c(first), $a1=B=d(first)
	# $t0=c, $t1=d(always)
	# $t2=q, $t3=r, $t4=t , $t5=i_, $t6=j_, $t7=i, $t8=j (will be change in each loop)
	
	#push all the t0~t8
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $sp, $sp, -4
	sw $t7, 0($sp)
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	
	move $t0, $a0 # first c is A
	move $t1, $a1 # first d is B
	li $t5, 1 #i_=1
	li $t6, 0 #j_=0
	li $t7, 0 #i=0
	li $t8, 1 #j=1

loop_gcd:
	div $t0, $t1 #c/d
	mflo $t2 #q
	mfhi $t3 #r
	li $t4, 0 #t=0
	
	beq $t3, $zero, gcd_end # if(r==0)break;
	
	move $t0, $t1 #c=d,  prepare for next loop
	move $t1, $t3 #d=r
	#claculate i
	move $t4, $t5 #t=i_
	move $t5, $t7 #i_=i
	#i=t-q*i
	mul $t7, $t2, $t7 # i=q*i
	sub $t7, $t4, $t7 #i=t-i
	#calculate j
	move $t4, $t6 #t=j_
	move $t6, $t8 #j_=j
	#j=t-q*j
	mul $t8, $t2, $t8 #j=q*j
	sub $t8, $t4, $t8 #j=t-j
	
	j loop_gcd
	
gcd_end:
	move $v0, $t7 #save i at v0
	move $v1, $t8 #save j at v1
	
	#pop all the t0~t8
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	lw $t7, 0($sp)
	addi $sp, $sp, 4
	lw $t6, 0($sp)
	addi $sp, $sp, 4
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
	
print_: # integer put in $a0
	li $v0, 1
    syscall
    jr $ra
    
    
    
end:
	li      $v0, 10 #exit
        syscall
    
