entry:
    # Function prolog, allocate 8 bytes on stack
    addi r1, r1, -8

    # Save link register on stack
    mflr r0
    std r0, -8(r1)

    # set flag to 1
    lis r6, 0x8d
    ori r6, r6, 0x3e5c
    li r3, 0x1
    stb r3, 0(r6)

    # wait ~11 seconds
    li r11, 0x8d
    lis r3, 0xad
    sc

    # set flag to 0
    lis r6, 0x8d
    ori r6, r6, 0x3e5c
    li r3, 0x0
    stb r3, 0(r6)

    # sys_ppu_thread_exit
    bla 0xaef824

    # return
    ld r0, -8(r1)
    mtlr r0
    addi r1, r1, 8
    blr
