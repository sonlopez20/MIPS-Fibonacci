
.data
msg1: .asciiz "\nProgramming Assigment 2 \n"
msg2: .asciiz ","
msg3: .asciiz "Array Values:"
msg4: .asciiz "Fibonacci Values:"
msg5: .asciiz "\n"
msg6: .asciiz "Sonia Lopez\n\n"

.align 4
len:  .word 8
array:.word 19, 25, 10, 0, 15, 1, 22, 2

.text
.globl main
main:
	li 		$v0,4				#print msg6
	la		$a0, msg6			# address where msg6 is msg6
	syscall
    li      $v0,4           	# print msg3
    la      $a0,msg3        	# address where msg3 is stored
    syscall
    jal     printall       	 	# print the array before sorting

    li      $v0,4           	# print msg4
    la      $a0,msg4        	# address where msg3 is stored
    syscall

    la      $a0,array       	# first parameter is v[] (address of the array)
    lw      $a1,len         	# second parameter is n (length of the array)
    jal     sort       			# jump to sort and save position to $ra

print_1:
    jal     printall        	# print the array 

    li      $v0,10          	# code for syscall: exit
	syscall                		# The program exits here!


# =============== Your code starts here ============
sort:
	move $s0,$zero				# copies the value in $zero to $s1
	
firstfor:
	slt $t0,$s0,$a1				# reg $t0 = 0 if $s1 >= $a1(i>=n)
	beq $t0,$zero,print_1		# go to print_1 if $t0>=$zero (i>=n)
	lw  $t1,0($a0)				# reg $t1 = v[i]
	move $a2,$zero				# copies the value in $zero to $a2
	add $a2,$a2,$t1				# reg $a2 = $a2 + $t1
	jal fib						# jump to fib
	sw $v0,0($a0)				# save $v0 on stack
	addi $a0,$a0,4				# make room on stack for 1 registers
	addi $s0,$s0,1				# i += 1
	j firstfor					# jump to firstfor

fib:
	addi $sp,-12				# make room on stack for 3 registers
	sw   $ra,8($sp)				# save $ra on stack
	sw   $a2,4($sp)				# save $a2 on stack
	sw   $s1,0($sp)				# save $s0 on stack
	bgt  $a2,$0,secondfor		# go to secondfor if $a2>$1
	add  $v0,$0,$a2				# reg $v0 = $0 + $a2
	j restore					# jump to return

secondfor:
	addi $t0,$0,1				# j += 1
	bne  $t0,$a2,gen			# go to gen if $t0 != $a2
	add  $v0,$0,$a2				# reg $v0 = $0 + $a2
	j restore					# jump to return

gen:
	addi $a2,$a2,-1				# i -= 1
	jal fib						# jump to fib
	add  $s1,$v0,0				# reg $s0 = $v0 + 0
	addi $a2,$a2,-1				# i -= 1
	jal fib						# jump to fib
	add $v0,$v0,$s1				# reg $v0 = $v0 + $s0

restore:
	lw $s1,0($sp)				# restore $s0 from stack
	lw $a2,4($sp)				# restore $a2 from stack
	lw $ra,8($sp)				# restore $ra from stack
	addi $sp,$sp,12				# restore stack pointer
	jr $ra						# return to calling routine
	

# ================ Your code ends  here ==================
# ================ Print Array Function ====================
printall:
    la      $t0,array
    ld      $t1,len
    add     $t4,$zero,$zero
    li      $v0,4           	# system call to print the string
    la      $a0,msg5
    syscall
imprime:
    li      $v0,1          		# system call to print integer
    lw      $a0,0($t0)
    syscall
    li      $v0,4          		# system call to print ","
    la      $a0,msg2
    syscall
    addi    $t4,1
    addi    $t0,4
    bne     $t4,$t1,imprime
    li      $v0,4           	# change line
    la      $a0,msg5
    syscall
    jr      $ra             	# return to calling routine
