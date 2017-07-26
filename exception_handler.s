    .include "address_map_nios2.s"
    .include "key_codes.s"			/* defines values for KEY0, KEY1, KEY2, KEY3 */
	.extern MOTOR0_STATUS
    .extern SCORE
/********************************************************************************
 * RESET SECTION
 * Note: "ax" is REQUIRED to designate the section as allocatable and executable.
 * Also, the Debug Client automatically places the ".reset" section at the reset
 * location specified in the CPU settings in SOPC Builder.
 */
    .section    .reset, "ax"
    movia       r2, _start
    jmp         r2								/* branch to main program */

/********************************************************************************
 * EXCEPTIONS SECTION
 * Note: "ax" is REQUIRED to designate the section as allocatable and executable.
 * Also, the Monitor Program automatically places the ".exceptions" section at the
 * exception location specified in the CPU settings in SOPC Builder.
 */
    .section    .exceptions, "ax"
    .global	EXCEPTION_HANDLER
EXCEPTION_HANDLER:
    subi    sp, sp, 16              /* make room on the stack */
    stw     et,  0(sp)

    rdctl   et, ctl4
	beq		et, r0, SKIP_EA_DEC     /* interrupt is not external */

    subi    ea, ea, 4               /* must decrement ea by one instruction */
                                    /*  for external interrupts, so that the */
                                    /*  interrupted instruction will be run */
SKIP_EA_DEC:
    stw     ea, 4(sp)               /* save all used registers on the Stack */
    stw     ra, 8(sp)               /* needed if call inst is used */
    stw     r22, 12(sp)
    
    rdctl   et, ctl4
    bne     et, r0, CHECK_LEVEL_0   /* interrupt is an external interrupt */

NOT_EI:				                /* exception must be unimplemented instruction or TRAP */
    br		END_ISR	                /* instruction. This code does not handle those cases */

    
CHECK_LEVEL_0:							 	/* interval timer is interrupt level 0 */
	andi		r22, et, 0b1
	beq		r22, r0, CHECK_LEVEL_1


	movia		et, TIMER_BASE		/* interval timer base address */
	sthio		r0,  0(et)				/* clear the interrupt */

    movia et, MOTOR1_STATUS
	ldw et, 0(et)
    mov  r22, r0
    beq  et, r22, END_ISR
    movi r22, 3
    blt  et, r22, LESS
    movi et, -1
LESS:
    addi et,et,1
    movia r22, MOTOR1_STATUS
    stw et,0(r22)
    
    br  END_ISR
    
CHECK_LEVEL_1:                      /* pushbutton port is interrupt level 1 */
    andi    r22, et, 0b010
    beq     r22, r0, CHECK_LEVEL_2  
	
	call PUSHBUTTON_ISR

	br END_ISR
	
CHECK_LEVEL_2:                      /* pushbutton port is interrupt level 1 */
    andi    r22, et, 0b0100
    beq     r22, r0, CHECK_LEVEL_12        
    
    movia	et, TIMER_2_BASE		/* interval timer2 base address */
	sthio	r0,  0(et)	            /* ACK */
    
    movia   r22, MOTOR0_STATUS
    ldw     r2, 0(r22)
    movi    et, MOTOR0_STATUS_FORWARD
    beq     et, r2, M0_FORWARD
#    movi    et, MOTOR0_STATUS_BACKWARD
#   beq     et, r2, M0_BACKWARD
M0_BACKWARD:
    stw     et, 0(r22)
    call MOTOR0_BACKWARD
    br END_ISR
M0_FORWARD:
    addi    et, et, 1
    stw     et, 0(r22)
    call MOTOR0_FORWARD
    br END_ISR
    
CHECK_LEVEL_12:
    andi    r22, et, 0x1000
    beq     r22, r0, CHECK_LEVEL_7
    
    movia r22, ADDR_JP2_EDGE           # check edge capture register from GPIO JP2 
    ldwio et, 0(r22)
    #andhi r22, et, 0x4000              # mask bit 30 (sensor 3)  
    #bne   r22, r0, END_ISR           # exit if sensor 3 did not interrupt 
    movia r22, ADDR_JP2_EDGE  
    movia et, 0xFFFFFFFF
    stwio et, 0(r22) #ACK
    
LED_DEBUG:
    movia et, LEDR_BASE
	ldwio r22, 0(et)
	xori   r22, r16, 0x0010
	stwio r22, 0(et)
    
    call Audio_output
ADD_SCORE:
	movia et, SCORE
	ldw   r22, 0(et)
	addi  r22, r22, 1
	stw   r22, 0(et)
    br END_ISR
CHECK_LEVEL_7:
	call MOTOR1_OFF
    andi    r22, et, 0x080
    beq     r22, r0, END_ISR
    movia   r22, PS2_BASE               
    ldbuio  et, 0(r22)
    movi    r22, KB_BREAK
    beq     r22, et, IS_BREAK
    movi    r22, KB_LETTER_D
    beq     r22, et, MOVE_RIGHT
    movi    r22, KB_LETTER_A
    beq     r22, et, MOVE_LEFT
    br END_ISR
MOVE_RIGHT:
    call MOTOR1_BACKWARD
    br END_ISR
MOVE_LEFT:
    call MOTOR1_FORWARD
    br END_ISR
IS_BREAK:
    
    movia   r22, PS2_BASE               
    ldwio   et, 0(r22)
    movia   r22, 0x00008000
    and     et, et, r22
    movia   r22, 0x00008000
    beq     r22,et,IS_BREAK
 #   call    PUSHBUTTON_ISR				

END_ISR:
    ldw	    et, 0(sp)               /* restore all used register to previous values */
    ldw	    ea, 4(sp)					
    ldw	    ra, 8(sp)               /* needed if call inst is used */
    ldw	    r22, 12(sp)
    addi    sp, sp, 16

    eret
    .end
