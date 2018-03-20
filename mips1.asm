.data

     text:  .asciiz "\nInput: \n"
  answer_int: .word 0
  input_int: .word 0
  turn: .word 0
  As: .word 0
  Bs: .word 0
     
.text

 main:
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall
    
L1:    
    #random int
    li $v0, 42
    li $a1, 10000
    syscall
    
    la $t1, answer_int #load address of random_int to $t1
    sw $a0, 0($t1) #store the random number in random_int
    
    # Printing out the randim int
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores random_int's address
    syscall
    
read:
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall
    #read in integer
    li      $v0, 5
    syscall
    
    
    
    
    
    
    
    
    
    
    
    
    
end:
	li      $v0, 10 #exit
        syscall
    
