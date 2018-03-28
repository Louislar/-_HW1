.data

	change_line: .asciiz "\n"
     text:  .asciiz "\nInput: \n"
  turn: .word 0
  k: .word 0


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
    
    
    subi $t0, 1  # loop 2*k times
    bne $t0, 0, input
	
	#we input k a_i first, then input k m_i
	#, but we need m_i first
	# store the $sp at $s1
	move $s1, $sp
	addu $t0, $s0,$s0 # loop k*2 times 
s1_adjust:	# adjust $s1 to storing m_i's data's address (always)
	addi $s1, 4
	subi $t0, 1
	bne $t0, 0, s1_adjust
	
	
	#we need to multiply k m_i, to get m, and store it in $s2
	move $t0, $s0 # loop k times
	move $t1, $s1 # store m_i's data's address (temp)
	li $s2, 0 # store m at $s2 (always)
cal_m:
	lw $t2, 0($t1) # load m_i to $t2
	mul $s2, $s2, $t2 # mlutiply s2 by t2, then store the result in s2
	addi $t1, -4
	subi $t0, 1
	bne $t0, 0, cal_m
	
	

	#we ned to count k Y_i, so loop k times
	move $t0, $s0
	move $t1, $s1 # store m_i's data's address (temp)
count_Y_i: # $t0 cannot use
	addi $t1, -4 # make $t1 point to m_i
	lw $t2, 0($t1) # load m_i to $t2 (temp)
	
	#calulate M_i
	div $s2, $t2 # m/m_i
	mflo $t3 # $t3 stores M_i
	
    li $a0, $t3 # $a0 is M_i
    li $a1, 5 # $a1 is m_i
    jal gcd # i will store in $v0, and j will store in $v1
    		# 1 = i*M_i + j*m_i
    
    
    #print i
    move $s1, $v0 #$s1=i
    move $s2, $v1 #$s2=j
    li $v0, 1
    move $a0, $s1
    syscall
    
    # Printing out the \n
    li $v0, 4
    la $a0, change_line
    syscall
    
    #print j
    li $v0, 1
    move $a0, $s2
    syscall
    
    #push
    
    subi $t0, 1
    bne $t0, 0, count_Y_i
    
    
    j end
    
    
    
    
    
    
    
    
    
gcd:
	# cal gcd(A, B), assume that A>B
	# $a0=A=c(first), $a1=B=d(first)
	# $t0=c, $t1=d(always)
	# $t2=q, $t3=r, $t4=t , $t5=i_, $t6=j_, $t7=i, $t8=j (will be change in each loop)
	
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
	mulu $t7, $t2, $t7 # i=q*i
	subu $t7, $t4, $t7 #i=t-i
	#calculate j
	move $t4, $t6 #t=j_
	move $t6, $t8 #j_=j
	#j=t-q*j
	mulu $t8, $t2, $t8 #j=q*j
	subu $t8, $t4, $t8 #j=t-j
	
	j loop_gcd
	
gcd_end:
	move $v0, $t7 #save i at v0
	move $v1, $t8 #save j at v1
	jr $ra
	
	
	
	
	
    
    
    
end:
	li      $v0, 10 #exit
        syscall
    
