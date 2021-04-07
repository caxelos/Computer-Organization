################## Axelos Christos, AEM 1814 ############
# -To programma afto diavazei apo to xrhsth enan tetragwniko pinaka
# kai elegxei an aftos o pinakas einai symmetrikos
# -To diavasma kai o elegxos ginontai mesa apo 3exwristes diadikasies
# - Provlhma: Den 3erw pws na apelef8erwsw thn dynamikh mnhmh pou desmeuw parakatw gia ton pinaka
.data
	input_msg: .asciiz "How many rows contain your square array? "
	fill_in_msg: .asciiz "Fill in your array, line by line\n"
	symmetric_msg: .asciiz "The array is Symmetric!"
	not_symmetric_msg: .asciiz "The array is not symmetric!"
	
	.align 2
	nums_array:
		
.text	
.globl main

##### main #######
# $s0	- N grammes tou pinaka 
# $s1	- N^N
# $s2	- h dief8insh tou pinaka aftou
main:
	la $s2, nums_array
	la $t0, input_msg
	li $v0, 4
	move $a0, $t0
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0	#$s0 = N
	### allocate here memory in the heap  ####
	mul $s1, $s0, $s0
	
	li $v0, 9
	move $a0, $s1
	syscall
	move $s2, $v0
	
	######### fill in the array #########
	la $t0, fill_in_msg
	li $v0, 4
	move $a0, $t0
	syscall
	
	#move $t2, $s2	# copy the adress of the array
	## san parametro pernietai automata to $s2
	move $a0, $s2
	move $a1, $s1
	jal  read_array_PROCESS
	
	move $a0, $s0
	move $a1, $s2
	jal find_if_symmetric_PROCESS
	
	move $s3, $v0
	beq  $s3, 1, square
	
	not_square:
	li $v0, 4
	la $a0, not_symmetric_msg
	syscall
	
	li $v0, 10
	move $a0, $v0
	syscall
	
		
	square:
	li $v0, 4
	la $a0, symmetric_msg
	syscall

	li $v0, 10
	move $a0, $v0
	syscall
	
#######################################################################

read_array_PROCESS:  # int *fill_the_array(int *array, int N^2)
	move $t1, $a1 	# N^N
	move $t2, $a0   #adrress
	li $t3, 0	# number of Loops
	
	num_read_Loop:
		##### read ###
		li $v0, 5
		syscall
		move $t4, $v0
	
		### save ###
		sw $t4, 0($t2)	
		addi $t2, $t2, 4
	
		#### check in the array is full ####
		addi $t3, $t3, 1
		beq $t3, $t1, exit_read
		j num_read_Loop
	exit_read:
	
	jr $ra
####################################################################################################################	
		
find_if_symmetric_PROCESS: # int find_if_ symmetric_PROCESS(int N, int *adrress);
	move $t8, $a0
	move $t9, $a1
	
	li $t1, 0	# counts the current line
	for_each_line:
		addi  $t1, $t1, 1
		beq   $t1, $t8, array_square
		
		######################## j = (i - 1) * N + i #########################	
		sub $t2, $t1, 1  # $t2 = i - 1
		mul $t3, $t2, $t8  #  $t4 = N(i - 1)
		add $t4, $t3, $t1  #  $t4 = (i - 1) * N + i = j
		
		mul $t4, $t4, 4
		add $t4, $t9, $t4  #  $t4 = 1st + j
		
		# k = N - 1
		addi $t5, $t8, -1
		
		#loops per line counter
		sub $t6, $t8, $t1  # t6 = N - 1(for the 1st loop) 
		each_element:
			lw  $t2, 0($t4)	# fortwse to a[j]
			mul  $t7, $t5, 4
			#mul $t5, $t5, 4  # 4 bytes each position
			#add $t0, $t4, $t5
			add $t0, $t4, $t7	# t5 = k  		
			lw  $t3, 0($t0)		# fortwse to a[j + k]
			
			bne  $t2, $t3, array_not_square
			mul  $t5, $t5, 2
			
			addi $t6, $t6, -1
			beqz $t6, finish_line
			
			addi $t4, $t4, 4			
			j each_element
		
		finish_line:
		j for_each_line	
	
	array_not_square:
	li $v0, 0
	jr $ra
	
	array_square:
	li $v0, 1
	jr $ra
	
