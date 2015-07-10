j main
j interrupt
error: j error

##########Interrupt Service#########
interrupt:
	lw	$t9, 8($s7)
	andi	$t9, $t9, 0xfff9
	sw	$t9, 8($s7)			#TCON &= 0xfff9
	#####Process#####
digit_select:
	beq	$s6, $zero, display_0_0
	addiu	$t7, $zero, 1
	beq	$s6, $t7, display_1_0
	addiu	$t7, $t7, 1
	beq	$s6, $t7, display_2_0
	addiu	$t7, $t7, 1
	beq	$s6, $t7, display_3_0
	addi	$s6, $s6, -4
	j digit_select
display_0_0:
	addiu	$t8, $zero, 0x0140
	sw	$t8, 20($s7)
	j interrupt_return
display_1_0:
	addiu	$t8, $zero, 0x0240
	sw	$t8, 20($s7)
	j interrupt_return
display_2_0:
	addiu	$t8, $zero, 0x0440
	sw	$t8, 20($s7)
	j interrupt_return
display_3_0:
	addiu	$t8, $zero, 0x0840
	sw	$t8, 20($s7)
	j interrupt_return
interrupt_return:
	addiu	$s6, $s6, 1
	#################
	ori	$t9, $t9, 0x0002
	sw	$t9, 8($s7)			#TCON |= 0x0002
	addi	$26, $26, -4			#Do not return to the next line!
	jr	$26				#return

#############Main Program###########
main:
	la	$t9, start_point
	jr	$t9				#clear PC[31]
start_point:
	lui	$s7, 0x4000			#S7 is the base address of devices
	addu	$s6, $zero, $zero
	#####Timer Start#####
	sw	$zero, 8($s7)			#TCON=0
	addu	$t9, $zero, $zero
	lui	$t9, 0xffff
	ori	$t9, $t9, 0xffcd
	sw	$t9, 0($s7)			#TH=0xfffffcd
	nor	$t9,$zero,$zero
	sw	$t9, 4($s7)			#TL=0xffffffff
	addiu	$t9, $zero, 3
	sw	$t9, 8($s7)			#TCON=3
	######################
stop:
	j	stop

