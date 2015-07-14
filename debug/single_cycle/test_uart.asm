j main
interrupt: j interrupt
error: j error

#############Main Program###########
main:	addu $s7, $zero, $zero
	lui $s7, 0x4000
	##### UART Receiver #####
	addiu $t8, $zero, 0x0002
	sw $t8, 32($s7)				#enable receiver
check_rx_status:
	lw $t8, 32($s7)
	andi $t8, $t8, 0x0008
	addi $t8, $t8, -8
	bne $t8, $zero, check_rx_status		#wait until 0x0008 get
	lw $a0, 28($s7)				#data received
	#######################
	addiu $a0, $a0, 1
	##### UART Sender #####
check_tx_status:
	lw $t8, 32($s7)
	andi $t8, $t8, 0x0010
	addi $t8, $t8, -16
	beq $t8, $zero, check_tx_status		#wait until 0x0010 disappear
	addiu $t8, $zero, 0x0001
	sw $t8, 32($s7)				#enable sender
	sw $a0, 24($s7)				#data to send
	#######################
stop:
	j	stop
