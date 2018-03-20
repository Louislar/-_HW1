.data

     text:  .asciiz "Enter a number: "
  random_int: .word 0
  turn: .word 0
     
.text

 main:
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall
    
    
L1:    
    #random int
    li $v0, 42
    li $a1, 10
    syscall
    
    la $t1, random_int #load address of random_int to $t1
    sw $a0, 0($t1) #store the random number in random_int
    
    # Printing out the randim int
    li $v0, 1
    lw $a0, 0($t1) # $t1 stores random_int's address
    syscall