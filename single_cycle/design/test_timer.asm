j main
j interrupt
error: j error

interrupt: lw $t1, 8($a0)
andi $t1, $t1, 0xfff9
sw $t1, 8($a0)			#TCON &= 0xfff9
sw $26, 12($a0)			#display the addr to return
addi $t1, $t1, 2
sw $t1, 8($a0)			#TCON |= 0x0002
addiu $26, $26, -4
jr $26

main: la $t9, start_point
jr $t9				#clear PC[31]
start_point: lui $a0, 0x4000
sw $zero, 8($a0)		#TCON=0
lui $t0, 0xffff
addiu $t0, $t0, 0x3caf
sw $t0, 0($a0)			#TH=0xffff3caf
nor $t0,$zero,$zero
sw $t0, 4($a0)			#TL=0xffffffff
addiu $t0, $zero, 3
sw $t0, 8($a0)			#TCON=3
stop: j stop

