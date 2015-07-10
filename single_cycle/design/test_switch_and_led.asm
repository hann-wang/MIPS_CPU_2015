lui $t0,0x4000
addiu $t0,$t0,0x000c
lw $a0,4($t0)
sw $a0,0($t0)
stop: j stop