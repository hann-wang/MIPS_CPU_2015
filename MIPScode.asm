j MAIN
j INTERRUPT
j EXCEPTION

MAIN: 
	##########################################
	# $s0: UART_CON ADDRESS 	0x40000020
	# $s1: PARAMETER 1
	# $s2: PARAMETER 2
	# $s3: GREATEST COMMON DIVISOR
	# $s4: DECODE AN0
	# $s5: DECODE AN1
	# $s6: DECODE AN2
	# $s7: DECODE AN3
	# $t7: INDEX OF AN TO SHOW
	##########################################
	
	lui  $t0, 0x4000 			# $t0 = 0x40000000
	addi $s0, $t0, 0x0020 		# $s0 = 0x40000020 (addr of UART_CON)

READ_LOOP_1:
	# Read 1st argument from UART
	lw  $t0, 0($s0)
	sll $t0, $t0, 30
	srl $t0, $t0, 31 	# $t0: 0 bit is RX_EFF
	bne $t0, $zero, EXIT_READ_LOOP_1
	j READ_LOOP_1

EXIT_READ_LOOP_1:
	# Collect the 1st argument
	lw  $s1, -4($s0)

READ_LOOP_2:
	# Read 2nd argument from UART
	lw  $t0, 0($s0)
	sll $t0, $t0, 30
	srl $t0, $t0, 31 	# $t0: 0 bit is RX_EFF
	bne $t0, $zero, EXIT_READ_LOOP_2
	j READ_LOOP_2

EXIT_READ_LOOP_2:
	# Collect the 2nd argument
	lw 	$s2, -4($s0)

###########################################################
# Use $s4(AN0), $s5(AN1) to store the 1st argument
# Use $s6(AN2), $s7(AN3) to store the 2nd argument
###########################################################

DECODEPARAMS: 
	sll $a0, $s1, 24
	srl $a0, $a0, 28
	jal DECODER
	sll $s4, $v0, 5
	addi $t0, $zero, 0x0007   	# $t0 = ..._0000000_00111
	or $s4, $s4, $t0			# $s4 = ..._xxxxxxx_00111

	sll $a0, $s1, 28
	srl $a0, $a0, 28
	jal DECODER
	sll $s5, $v0, 5
	addi $t0, $zero, 11   		# $t0 = ..._0000000_01011
	or $s5, $s5, $t0			# $s5 = ..._xxxxxxx_01011

	sll $a0, $s2, 24
	srl $a0, $a0, 28
	jal DECODER
	sll $s6, $v0, 5
	addi $t0, $zero, 13   		# $t0 = ..._0000000_01101
	or $s6, $s6, $t0			# $s6 = ..._xxxxxxx_01101

	sll $a0, $s2, 28
	srl $a0, $a0, 28
	jal DECODER
	sll $s7, $v0, 5
	addi $t0, $zero, 14   		# $t0 = ..._0000000_01110
	or $s7, $s7, $t0			# $s7 = ..._xxxxxxx_01110

	# set $t7 to 0
	add $t7, $zero, $zero

	# find the greatest common divisor
	add $a0, $s1, $zero
	add $a1, $s2, $zero
	jal GCD
	add $s3, $v0, $zero

	# use the LEDs to show the result
	sw  $s3, -20($s0)

	# save the result to UART_TXD
	sw  $s3, -8($s0)

SEND_LOOP:
	# this loop is to send the result through UART
	lw  $t0, 0($s0)
	sll $t0, $t0, 29
	srl $t0, $t0, 31 	# $t0: 0 bit is TX_STATUS
	bne $t0, $zero, SEND
	j SEND_LOOP 

SEND:
	# now the UART_Sender is available
	# set TX_EN to send the result in UART_TXD
	addi $t0, $zero, 1
	sw   $t0, 0($s0)
	sw 	 $zero, 0($s0)
	j READ_LOOP_1

###########################################################
# $v0 = GCD($a0, $a1)
###########################################################

GCD:
	# Preserve $s0, $s1 using stack
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)

	# load $a0, $a1 into $s0, $s1
	add $s0, $a0, $zero
	add $s1, $a1, $zero

GCD_LOOP:
	slt $t0, $s0, $s1
	beq $t0, $zero, NOT_SWITCH

	# switch $s0 and $s1 to make sure $s0 > $s1
	add $t0, $s0, $zero
	add $s0, $s1, $zero
	add $s1, $t0, $zero

NOT_SWITCH:
	sub $t0, $s0, $s1

	# if $t0 == 0, then we have found the greatest common divisor
	beq $t0, $zero, GCD_RETURN
	add $s0, $t0, $zero
	j GCD_LOOP

GCD_RETURN:
	add $v0, $s0, $zero

	# Restore $s0, $s1 status
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8

	jr $ra

DECODER:
	# take in an 4 bits number in $a0
	# decode it to an 7 bits DIGITs
	# retrun it in $v0

	# 0 -> 000_0001 (1)
	bne $a0, $zero, DECODER_NOT_0
	addi $v0, $zero, 1
	j DECODER_RETURN

DECODER_NOT_0:
	addi $t0, $zero, 1
	bne $a0, $t0, DECODER_NOT_1

	# 1 -> 100_1111 (79)
	addi $v0, $zero, 79
	j DECODER_RETURN

DECODER_NOT_1:
	addi $t0, $zero, 2
	bne $a0, $t0, DECODER_NOT_2

	# 2 -> 001_0010 (18)
	addi $v0, $zero, 18
	j DECODER_RETURN

DECODER_NOT_2:
	addi $t0, $zero, 3
	bne $a0, $t0, DECODER_NOT_3

	# 3 -> 000_0110 (6)
	addi $v0, $zero, 6
	j DECODER_RETURN

DECODER_NOT_3:
	addi $t0, $zero, 4
	bne $a0, $t0, DECODER_NOT_4

	# 4 -> 100_1100 (76)
	addi $v0, $zero, 76
	j DECODER_RETURN

DECODER_NOT_4:
	addi $t0, $zero, 5
	bne $a0, $t0, DECODER_NOT_5

	# 5 -> 010_0100 (36)
	addi $v0, $zero, 36
	j DECODER_RETURN

DECODER_NOT_5:
	addi $t0, $zero, 6
	bne $a0, $t0, DECODER_NOT_6

	# 6 -> 010_0000 (32)
	addi $v0, $zero, 32
	j DECODER_RETURN

DECODER_NOT_6:
	addi $t0, $zero, 7
	bne $a0, $t0, DECODER_NOT_7

	# 7 -> 000_1111 (15)
	addi $v0, $zero, 15
	j DECODER_RETURN

DECODER_NOT_7:
	addi $t0, $zero, 8
	bne $a0, $t0, DECODER_NOT_8

	# 8 -> 000_0000 (0)
	addi $v0, $zero, 0
	j DECODER_RETURN

DECODER_NOT_8:
	addi $t0, $zero, 9
	bne $a0, $t0, DECODER_NOT_9

	# 9 -> 000_0100 (4)
	addi $v0, $zero, 4
	j DECODER_RETURN

DECODER_NOT_9:
	addi $t0, $zero, 10
	bne $a0, $t0, DECODER_NOT_A

	# A -> 000_1000 (8)
	addi $v0, $zero, 8
	j DECODER_RETURN

DECODER_NOT_A:
	addi $t0, $zero, 11
	bne $a0, $t0, DECODER_NOT_B

	# B -> 110_0000 (96)
	addi $v0, $zero, 96
	j DECODER_RETURN

DECODER_NOT_B:
	addi $t0, $zero, 12
	bne $a0, $t0, DECODER_NOT_C

	# C -> 011_0001 (49)
	addi $v0, $zero, 49
	j DECODER_RETURN

DECODER_NOT_C:
	addi $t0, $zero, 13
	bne $a0, $t0, DECODER_NOT_D

	# D -> 100_0010 (66)
	addi $v0, $zero, 66
	j DECODER_RETURN

DECODER_NOT_D:
	addi $t0, $zero, 14
	bne $a0, $t0, DECODER_NOT_E

	# E -> 011_0000 (48)
	addi $v0, $zero, 48
	j DECODER_RETURN

DECODER_NOT_E:
	# F -> 011_1000 (56)
	addi $v0, $zero, 56
	j DECODER_RETURN

DECODER_RETURN:
	jr $ra
	
###########################################################
# Interrupt to display on DIGITs. 
# Jump to $26 afterwards. 
###########################################################

INTERRUPT:
	# use the DIGITs to show the parameters
	bne  $t7, $zero, INTERRUPT_NOT_0
	sw 	 $s4, -12($s0)
	addi $t7, $zero, 1
	j KERNAL_RETURN

INTERRUPT_NOT_0:
	addi $t0, $zero, 1
	bne  $t7, $t0, INTERRUPT_NOT_1
	sw 	 $s5, -12($s0)
	addi $t7, $zero, 2
	j KERNAL_RETURN

INTERRUPT_NOT_1:
	addi $t0, $zero, 2
	bne  $t7, $t0, INTERRUPT_NOT_2
	sw 	 $s6, -12($s0)
	addi $t7, $zero, 3
	j KERNAL_RETURN

INTERRUPT_NOT_2:
	sw 	 $s7, -12($s0)
	addi $t7, $zero, 0
	j KERNAL_RETURN

EXCEPTION:
	j KERNAL_RETURN

KERNAL_RETURN:
	jr $26

###########################################################
# Donot handle exceptions currently, just stop here. 
###########################################################

EXCEPTION:
	j EXCEPTION