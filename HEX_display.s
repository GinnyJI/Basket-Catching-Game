    .include "address_map_nios2.s"
	
	.extern	SCORE					/* externally defined variable */
	
.section .text
.global Hex_display

Hex_display:
	subi  sp,  sp, 4
	stw   ra,  0(sp)

	movia r10, SCORE
	ldw   r13, 0(r10)
    movi  r14, 10
    div r12, r13, r14 #r12 = r13/r14
    #todo - should've made them into functions
	call Single_num_display
    mov     r15, r9
    slli    r15, r15, 8
    mul r12, r12, r14
    sub r12, r13, r12
	call Single_num_display
    or  r9, r9, r15
    movia r8, HEX3_HEX0_BASE
    stwio r9, 0(r8)        # Write to 7-seg display 
END_DISPLAY:
	ldw   ra, 0(sp)
	addi  sp, sp, 4
	ret
	
Single_num_display:
	bne   r0,  r12, Check_one
    movia r9, 0x0000003F   # bits 0000110 will activate segments 1 and 2 
#ZERO
	ret
Check_one:
	movi  r10, 1
	bne   r10, r12, Check_two
    
	movia r9, 0x00000006   # bits 0000110 will activate segments 1 and 2 
    ret
Check_two:
	movi  r10, 2
	bne   r10, r12, Check_three
    
	movia r9, 0x0000005b 
	ret
Check_three:
	movi  r10, 3
	bne   r10, r12, Check_four
    	
	movia r9, 0x0000004f  
	ret
Check_four:
	movi  r10, 4
	bne   r10, r12, Check_five
    
	movia r9, 0x00000066 
	ret
Check_five:
	movi  r10, 5
	bne   r10, r12, Check_six
    
	movia r9, 0x0000006d 
	ret
Check_six:
	movi  r10, 6
	bne   r10, r12, Check_seven
    
	movia r9, 0x0000007d 
	ret
Check_seven:
	movi  r10, 7
	bne   r10, r12, Check_eight
    
	movia r9, 0x00000007 
	ret
Check_eight:
	movi  r10, 8
	bne   r10, r12, Check_nine
    
	movia r9, 0x0000007f 
	ret
Check_nine:
	movi  r10, 9
	bne   r10, r12, END_DISPLAY
    
	movia r9, 0x0000006f 
	ret
