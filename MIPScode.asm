###########################################################
#---------------- Assignment of Registers ----------------#
# $s0: UART_CON ADDRESS     0x40000020
# $s1: PARAMETER 1
# $s2: PARAMETER 2
# $s3: GREATEST COMMON DIVISOR
# $s4: 7-segment DISPLAY CODE of AN0
# $s5: 7-segment DISPLAY CODE of AN1
# $s6: 7-segment DISPLAY CODE of AN2
# $s7: 7-segment DISPLAY CODE of AN3
# $t7: INDEX OF AN TO SHOW
###########################################################
#--------------- Addresses of Peripherals ----------------#
# UART_CON:             0X40000020 = 0($s0)
# LEDs:                 0x4000000C = -20($s0)
# 7-segment display:    0x40000014 = -12($s0)
# UART_RX:              0x4000001C = -4($s0)
# UART_TX:              0x40000018 = -8($s0)
###########################################################

    j MAIN
    j INTERRUPT
    j EXCEPTION

MAIN:     
    lui  $t0, 0x4000            # $t0 = 0x40000000
    addi $s0, $t0, 0x0020       # $s0 = 0x40000020

READ_LOOP_1:
    # Read 1st argument from UART
    lw  $t0, 0($s0)
    sll $t0, $t0, 30
    srl $t0, $t0, 31    # $t0: 0 bit is RX_EFF
    bne $t0, $zero, EXIT_READ_LOOP_1
    j READ_LOOP_1

EXIT_READ_LOOP_1:
    # Collect the 1st argument
    lw  $s1, -4($s0)

READ_LOOP_2:
    # Read 2nd argument from UART
    lw  $t0, 0($s0)
    sll $t0, $t0, 30
    srl $t0, $t0, 31    # $t0: 0 bit is RX_EFF
    bne $t0, $zero, EXIT_READ_LOOP_2
    j READ_LOOP_2

EXIT_READ_LOOP_2:
    # Collect the 2nd argument
    lw  $s2, -4($s0)

###########################################################
# SPECs SUBJECT TO CHANGE
###########################################################
# Using 7-segment display, format ..._xxxxxxx_0mmmm
# xxxxxxx is the corresponding 7-segments
# mmmm is the index of value to display
###########################################################

DECODEPARAMS: 
    sll $a0, $s1, 24
    srl $a0, $a0, 28            # $a0 = $s1[7:4]
    jal DECODE
    sll $s4, $v0, 5
    addi $t0, $zero, 0x0007     # $t0 = ..._0000000_00111
    or $s4, $s4, $t0            # $s4 = ..._xxxxxxx_00111

    sll $a0, $s1, 28
    srl $a0, $a0, 28            # $a0 = $s1[3:0]
    jal DECODE
    sll $s5, $v0, 5
    addi $t0, $zero, 11         # $t0 = ..._0000000_01011
    or $s5, $s5, $t0            # $s5 = ..._xxxxxxx_01011

    sll $a0, $s2, 24
    srl $a0, $a0, 28            # $a0 = $s2[7:4]
    jal DECODE
    sll $s6, $v0, 5
    addi $t0, $zero, 13         # $t0 = ..._0000000_01101
    or $s6, $s6, $t0            # $s6 = ..._xxxxxxx_01101

    sll $a0, $s2, 28
    srl $a0, $a0, 28            # $a0 = $s2[3:0]
    jal DECODE
    sll $s7, $v0, 5
    addi $t0, $zero, 14         # $t0 = ..._0000000_01110
    or $s7, $s7, $t0            # $s7 = ..._xxxxxxx_01110

    # set $t7 to 0
    add $t7, $zero, $zero

    # Find GCD (Greatest Common Divisor)
    add $a0, $s1, $zero
    add $a1, $s2, $zero
    jal GCD
    add $s3, $v0, $zero

    # Display result with LED
    sw  $s3, -20($s0)

    # Save result to UART_TXD
    sw  $s3, -8($s0)

SEND_LOOP:
    # this loop is to send the result through UART
    lw  $t0, 0($s0)
    sll $t0, $t0, 29
    srl $t0, $t0, 31    # $t0: 0 bit is TX_STATUS
    bne $t0, $zero, SEND
    j SEND_LOOP 

SEND:
    # now the UART_Sender is available
    # set TX_EN to send the result in UART_TXD
    addi $t0, $zero, 1
    sw   $t0, 0($s0)
    sw   $zero, 0($s0)
    j READ_LOOP_1

###########################################################
# $v0 = GCD($a0, $a1)
###########################################################

GCD:
    # $t8, $t9 are temp variables storing the arguments. 
    addi $t8, $a0, 0             # $t8 = $a0
    addi $t9, $a1, 0             # $t9 = $a1

GCD_LOOP:
    slt $t0, $t8, $t9
    beq $t0, $zero, NOT_SWAP_CONTINUE

    # Swap $t8 and $t9 to make sure $t8 > $t9
    addi $t0, $t8, 0
    addi $t8, $t9, 0
    addi $t9, $t0, 0

NOT_SWAP_CONTINUE:
    # If $t8 == $t9, then exit loop and return
    sub $t0, $t8, $t9
    beq $t0, $zero, GCD_RETURN
    # Else $t8 = $t8 - $t9, and continue to loop
    add $t8, $t0, $zero
    j GCD_LOOP

GCD_RETURN:
    add $v0, $t8, $zero
    jr $ra

###########################################################
# $v0 = 7-segment display code of $a0
# e.g. $a0 = 2 => $v0 = 0x00000012
###########################################################

DECODE:
    # 0 -> 000_0001 ($v0 = 0x00000001)
    bne $a0, $zero, DECODE_NOT_0
    addi $v0, $zero, 1
    j DECODE_RETURN

DECODE_NOT_0:
    addi $t0, $zero, 1
    bne $a0, $t0, DECODE_NOT_1

    # 1 -> 100_1111 ($v0 = 0x0000004E)
    addi $v0, $zero, 79
    j DECODE_RETURN

DECODE_NOT_1:
    addi $t0, $zero, 2
    bne $a0, $t0, DECODE_NOT_2

    # 2 -> 001_0010 ($v0 = 0x00000012)
    addi $v0, $zero, 18
    j DECODE_RETURN

DECODE_NOT_2:
    addi $t0, $zero, 3
    bne $a0, $t0, DECODE_NOT_3

    # 3 -> 000_0110 ($v0 = 0x00000006)
    addi $v0, $zero, 6
    j DECODE_RETURN

DECODE_NOT_3:
    addi $t0, $zero, 4
    bne $a0, $t0, DECODE_NOT_4

    # 4 -> 100_1100 ($v0 = 0x0000004C)
    addi $v0, $zero, 76
    j DECODE_RETURN

DECODE_NOT_4:
    addi $t0, $zero, 5
    bne $a0, $t0, DECODE_NOT_5

    # 5 -> 010_0100 ($v0 = 0x00000024)
    addi $v0, $zero, 36
    j DECODE_RETURN

DECODE_NOT_5:
    addi $t0, $zero, 6
    bne $a0, $t0, DECODE_NOT_6

    # 6 -> 010_0000 ($v0 = 0x00000020)
    addi $v0, $zero, 32
    j DECODE_RETURN

DECODE_NOT_6:
    addi $t0, $zero, 7
    bne $a0, $t0, DECODE_NOT_7

    # 7 -> 000_1111 ($v0 = 0x0000000E)
    addi $v0, $zero, 15
    j DECODE_RETURN

DECODE_NOT_7:
    addi $t0, $zero, 8
    bne $a0, $t0, DECODE_NOT_8

    # 8 -> 000_0000 ($v0 = 0x00000000)
    addi $v0, $zero, 0
    j DECODE_RETURN

DECODE_NOT_8:
    addi $t0, $zero, 9
    bne $a0, $t0, DECODE_NOT_9

    # 9 -> 000_0100 ($v0 = 0x00000004)
    addi $v0, $zero, 4
    j DECODE_RETURN

DECODE_NOT_9:
    addi $t0, $zero, 10
    bne $a0, $t0, DECODE_NOT_A

    # A -> 000_1000 ($v0 = 0x00000008)
    addi $v0, $zero, 8
    j DECODE_RETURN

DECODE_NOT_A:
    addi $t0, $zero, 11
    bne $a0, $t0, DECODE_NOT_B

    # B -> 110_0000 ($v0 = 0x00000060)
    addi $v0, $zero, 96
    j DECODE_RETURN

DECODE_NOT_B:
    addi $t0, $zero, 12
    bne $a0, $t0, DECODE_NOT_C

    # C -> 011_0001 ($v0 = 0x00000031)
    addi $v0, $zero, 49
    j DECODE_RETURN

DECODE_NOT_C:
    addi $t0, $zero, 13
    bne $a0, $t0, DECODE_NOT_D

    # D -> 100_0010 ($v0 = 0x00000042)
    addi $v0, $zero, 66
    j DECODE_RETURN

DECODE_NOT_D:
    addi $t0, $zero, 14
    bne $a0, $t0, DECODE_NOT_E

    # E -> 011_0000 ($v0 = 0x00000030)
    addi $v0, $zero, 48
    j DECODE_RETURN

DECODE_NOT_E:
    # F -> 011_1000 ($v0 = 0x00000038)
    addi $v0, $zero, 56
    j DECODE_RETURN

DECODE_RETURN:
    jr $ra
    
###########################################################
# Interrupt to show DIGITs on 7-segment display. 
# Jump to $26 afterwards. 
###########################################################

INTERRUPT:
    # use the DIGITs to show the parameters
    bne  $t7, $zero, INTERRUPT_NOT_0
    sw   $s4, -12($s0)
    addi $t7, $zero, 1
    j INTERRUPT_RETURN

INTERRUPT_NOT_0:
    addi $t0, $zero, 1
    bne  $t7, $t0, INTERRUPT_NOT_1
    sw   $s5, -12($s0)
    addi $t7, $zero, 2
    j INTERRUPT_RETURN

INTERRUPT_NOT_1:
    addi $t0, $zero, 2
    bne  $t7, $t0, INTERRUPT_NOT_2
    sw   $s6, -12($s0)
    addi $t7, $zero, 3
    j INTERRUPT_RETURN

INTERRUPT_NOT_2:
    sw   $s7, -12($s0)
    addi $t7, $zero, 0
    j INTERRUPT_RETURN

INTERRUPT_RETURN:
    jr $26

###########################################################
# Do NOT handle exceptions currently, just stop here. 
###########################################################

EXCEPTION:
    j EXCEPTION