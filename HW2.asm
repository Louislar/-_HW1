.data

	change_line: .asciiz "\n"
     text:  .asciiz "\nInput: \n"
  turn: .word 0


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
    #read in integer
    li      $v0, 5
    syscall
    
    
    li $a0, 7
    li $a1, 5
    jal gcd
    
    #print i, j
    move $s0, $v0 #$s0=i
    move $s1, $v1 #$s1=j
    li $v0, 1
    move $a0, $s0
    syscall
    
    # Printing out the \n
    li $v0, 4
    la $a0, change_line
    syscall
    
    li $v0, 1
    move $a0, $s1
    syscall
    
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
    
