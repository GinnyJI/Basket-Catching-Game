    .include "address_map_nios2.s"
	
	.text
/* Motor 0 */
    .global MOTOR0_FORWARD
MOTOR0_FORWARD:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
	movia		r10, 0xFFFFFFFE
    and         r9, r9, r10    #turn on motor 0      (bit0 -> 0)
    ori         r9, r9, 0x0002    #motor 0 move forward (bit1 -> 1)
    stwio       r9, 0(r8)
    
    stw     ra,  0(sp)
    ldw     r8,  4(sp)
    ldw     r9,  8(sp)
    ldw     r10, 12(sp)
    addi    sp, sp, 16 
ret
    
    .global MOTOR0_BACKWARD
MOTOR0_BACKWARD:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
	movia		r10, 0xFFFFFFFC
    and         r9, r9, r10   #set value of motor0 to 00 (0->backward, 0->on)
    stwio       r9, 0(r8)
    
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16     
ret
    
    .global MOTOR0_OFF
MOTOR0_OFF:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
    ori         r9, r9, 0x0001    #turn off motor 0      (bit0 -> 1)
    stwio       r9, 0(r8)
    
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret

/* Motor 1 */
    .global MOTOR1_FORWARD
MOTOR1_FORWARD:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
	movia		r10, 0xFFFFFFFB
    and         r9, r9, r10       #turn on motor 1      (bit2 -> 0)
    ori         r9, r9, 0x0008    #motor 1 move forward (bit3 -> 1)
    stwio       r9, 0(r8)
    
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret
      
    .global MOTOR1_BACKWARD
MOTOR1_BACKWARD:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
	movia		r10, 0xFFFFFFF3
    and         r9, r9, r10  	  #set value of motor1 to 00 (0->backward, 0->on)
    stwio       r9, 0(r8)
        
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret
    
    .global MOTOR1_OFF
MOTOR1_OFF:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
    ori         r9, r9, 0x0004    #turn off motor 1      (bit2 -> 1)
    stwio       r9, 0(r8)
        
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret

/* Motor 2 */
    .global MOTOR2_FORWARD
MOTOR2_FORWARD:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
	movia		r10, 0xFFFFFFEF
    and         r9, r9, r10 	  #turn on motor 2      (bit4 -> 0)
    ori         r9, r9, 0x0020    #motor 2 move forward (bit5 -> 1)
    stwio       r9, 0(r8)
    
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret
      
    .global MOTOR2_BACKWARD
MOTOR2_BACKWARD:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
    movia       r10, 0xFFFFFFCF
    and         r9, r9, r10    #set value of motor2 to 00 (0->backward, 0->on)
    stwio       r9, 0(r8)
    
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret
    
    .global MOTOR2_OFF
MOTOR2_OFF:
    subi    sp, sp, 16                  /* reserve space on the stack */
    stw     ra,  0(sp)
    stw     r8,  4(sp)
    stw     r9,  8(sp)
    stw     r10, 12(sp)
    
    movia       r8, JP2_BASE
    ldwio       r9, 0(r8)
    ori         r9, r9, 0x0010    #turn off motor 2      (bit4 -> 1)
    stwio       r9, 0(r8)
        
    stw     ra,  0(sp)
    ldw     r8,  4(sp)    
    ldw     r9,  8(sp)    
    ldw     r10, 12(sp)    
    addi    sp, sp, 16 
ret