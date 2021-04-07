############## Christos Axelos, AEM 1814 ##############
# - To programma afto dexetai demomena kai ta apo8hkevei se mia lista, me ta3inomhmenh seira
# - Provlhmata:
#	2) To programma ektypwnei enan epipleon xarakthra ','

.data
	insert_msg: .asciiz "Please insert an element or press 0 to exit: "
	error_msg: .asciiz "Error memory allocation!"
	output1_msg: .asciiz "List: ("
	output2_msg: .asciiz ")"
	
        .extern counter 4
.text

.globl main

main:
	li $s0, 0x0 
	insert_element_loop:
		# each time I insert
		la $t0, insert_msg
		li $v0, 4
		move $a0, $t0
		syscall
		
		#read the integer
		li $v0, 5
		syscall
		move $t0, $v0
		beq $t0, 0, stop_insert
		
		# call the function here :p
		move $a0, $s0
		move $a1, $t0
		jal insertElement
		move $s0, $v0
		
		
		j insert_element_loop
	stop_insert:
	# call function void print_list(nodeL *head)
	move $a0, $s0
	jal print_list
	
	move $a0, $s0
	jal clear_memory

	# exit programm
	li $v0, 10
	move $a0, $v0
	syscall
#########################################################################
# synarthsh insert element
# - Me thn synarthsh afth eisagw stoixeia sth lista kata ta3inomhmenh seira
# - Xrhsimopoiw enan pointer, ton prev me arxikopoihsh NULL
# -	A) AN prev = NULL...eisagoume to 1o stoixeio...ektelesh katallhlou kwdika
# -	B) AN prev != NULL...exoume eisagei hdh ena...ektelesh katallhlou kwdika
		
insertElement:  #nodeL *insertElement(nodeL *head, int data);
	move $t0, $a0
	move $t1, $a1
	li $t7, 8 # number of bytes of each node
	
	move $t2, $t0# curr = head;
	li $t3, 0x0# prev = NULL;
	
	while: # (curr != NULL && curr->num < value
		beq $t2, 0x0, exit_while
		lw $t4, 0($t2)
		bge $t4, $t1, exit_while#curr->nun, value
		
		move $t3, $t2 # prev = curr
		lw $t2, 4($t2) # curr = curr->next
		
		
		j while
	exit_while:
	
	## malloc proxedure and $t7 is malloc pointer
	li $v0 ,9
	move $a0, $t7
	syscall
	move $t7, $v0
	
	bne $t7, 0x0, OK_ALLOCATION
	li $v0, 4
	la $t8, error_msg
	move $a0, $t8
	syscall
	
	OK_ALLOCATION:
	
	sw $t1, 0($t7) # newnode->num = value;
	sw $t2, 4($t7)  # newnode->next = curr;
	
	beq $t3, 0x0, first_element  # if (prev == NULL), 1st element
	sw $t7, 4($t3) # prev->next = newnode 
	move $v0, $t0
	jr $ra
	
	first_element:
		move $t0, $t7 # head = newnode;
		move $v0, $t0
		jr $ra
			
###########################################################
# SYNARTHSH print_list
#	- H synarthsh afth dexetai ws orisma thn kefalh mias listas
#	- Xrhsimopoihw mia global dief8ynsh "counter" thn opoia exw dhlwsei
#	sto pedio .data
#	- Me thn metavlhth afth metraw poses fores ginetai h anadromh kai analoga
#	me thn timh pou exei to periexomeno ths dief8inshs, ektypwnw to katallhlo mynhma
#	epeidh to Mynhma List: (a, b, .., z) ektypwnetai mesa apo afthn thn Anadromikh synarthsh
#	-Alliws 8a ektypwnontan..oses fores ginetai kai h anadromh
#
#	- Kanonika den h8ela na thn dhlwsw ws Global, alla ws STATIC, alla den h3era pws ginetai
#	- Gia paradeigma..to mynhma "List :(" ektypwnetai otan *counter = 0
#	- To *counter pairnei mia megisth timh kai meta peftei sto 1
#	-Molis ginei 1, ektypwnetai to mynhma ")" gia na kleisei h lista

print_list: # void print_list(listT *head)
	move $t0, $a0
	li $t3, ','
	
	lw $t6, counter
	bne $t6, 0, continue1 # if (counter != )...don't print the message
	#print output message1 here
	la $t8, output1_msg
	li $v0, 4
	move $a0, $t8
	syscall
	
	continue1:
	addi $t6, $t6, 1
	sw $t6, counter 
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
		
	beq $t0, 0x0, stop_print # if (curr->next == NULL)..dont call the function again
	# print the list's number
	li $v0, 1
	lw $a0, 0($t0)
	syscall

	li $v0, 11
	move $a0, $t3
	syscall
	
	
	lw $t0, 4($t0)
	move $a0, $t0
	jal print_list
	
	stop_print:
	
	lw $t6, counter
	bne $t6, 1, continue2  # if (counter != 1), don't print the message
	# print here
	la $t8, output2_msg
	li $v0, 4
	move $a0, $t8
	syscall
	
	continue2:
	addi $t6, $t6, -1
	sw $t6, counter
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra		
#################################################################
# SYNARTHSH clear_memory
# Mhdenizei tis perioxes mnhmhs pou exoume xrhsimopoihsei

clear_memory:
	move $t0, $a0
	move $t1, $t0  # curr = head
	for:
		beq $t1, 0x0, exit_for 
		
		lw  $t2, 4($t1) # next = curr->next
		sw $zero, 0($t1) # free the node
		sw $zero, 4($t1) #
		move $t1, $t2 # curr = next
		
		j for
	exit_for:	
	
	jr $ra
