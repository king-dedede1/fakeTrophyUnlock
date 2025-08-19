entry:
    # Function prolog, allocate 8 bytes on stack
    addi r1, r1, -8

    # Save link register on stack
    mflr r0
    std r0, -8(r1)

check_flag:

    # r3 contains the address to read - 0x8d3e5c
    lis r3, 0x8d
    ori r3, r3, 0x3e5c

    # load flag into r4
    lbz r4, 0(r3)

    # check if flag is equal to 1
    cmpli 0, 0, r4, 1
    beq equal

not_equal:

    # if you get here, the jump wasn't taken, so not equal
    # therefore the flag is 0, and we can return.

    ld r0, -8(r1)
    mtlr r0
    addi r1, r1, 8
    blr

equal:

    # syscall here

    li r11, 0x8d
    lis r3, 0xF
    sc

    b check_flag
    