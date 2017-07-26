    .include "address_map_nios2.s"
    .include "key_codes.s"			/* defines values for KEY0, KEY1, KEY2, KEY3 */
/********************************************************************************
 *		KEY[0]: car going right
 *		KEY[1]: car going left
********************************************************************************/
#declare global variable
    .data
    .global KEY_PRESSED
KEY_PRESSED:
    .word       KEY3
    .global MOTOR0_STATUS
MOTOR0_STATUS:
    .word       MOTOR0_STATUS_FORWARD
    .global MOTOR1_STATUS
MOTOR1_STATUS:
    .word       0
    .global SCORE
SCORE:
    .word       0
    
MESSANGE:
	.string "    Welcome to the game!"
	.align 2
MESSANGE2:
	.string "Player 1: Press SPACE to throw eggs down."
	.align 2
MESSANGE3:
	.string "Player 2: Press A/D to control the left/right movement of the car. Try to catch as many eggs as possible. Your score is displayed on HEX."
	.align 2
MESSANGE4:
	.string "    Good luck have fun!"
	

    .text                           /* executable code follows */
    .global _start
_start:
    #initialize stack pointer
    movia sp, SDRAM_END - 3           /* stack starts from largest memory address */
    #initialize interrupt device
	/* pushbutton */
	movia		r16, KEY_BASE			/* pushbutton key base address */
	movi		r17, 0b1111				/* set interrupt mask bits */
	stwio		r17, 8(r16)				/* interrupt mask register is (base + 8) */

	/* Lego Controller */
    movia       r17, JP2_BASE
    movia       r16, 0x07f557ff       # set direction for motors to all output 
    stwio       r16, 4(r17)
    # load sensor3 threshold value 5 and enable sensor3
	movia  r16,  0xFDBEFFFF       # set motors off enable threshold load sensor 3
	stwio  r16,  0(r17)           # store value into threshold register	
	# disable threshold register and enable state mode
    movia  r16,  0xFDDFFFFF      # keep threshold value same in case update occurs before state mode is enabled
    stwio  r16,  0(r17)
 	# enable interrupts
    movia  r22, 0x40000000       # enable interrupts on sensor 3
    stwio  r22, 8(r17)
	
	/* Timer 1 for motor1 */
    movia		r16, TIMER_BASE		/* interval timer base address */
	/* set the interval timer period for scrolling the HEX displays */
	movia		r22, 10000000			/* 1/(100 MHz) x (1 x 10^7) = 100 msec */
	sthio		r22, 8(r16)				/* store the low half word of counter start value */
	srli		r22, r22, 16
	sthio		r22, 0xC(r16)			/* high half word of counter start value */ 
    movi		r15, 0b0111				/* START = 1, CONT = 1, ITO = 1 */
	sthio		r15, 4(r16)
	
	/* Timer 2 for motor0 */
    movia		r16, TIMER_2_BASE		/* interval timer base address */
	/* set the interval timer period for scrolling the HEX displays */
	movia		r22, 0x03FFFFFF			/* 1/(100 MHz) x (0x09FFFFFF) = xxx msec */
	sthio		r22, 8(r16)				/* store the low half word of counter start value */
	srli		r22, r22, 16
	sthio		r22, 0xC(r16)			/* high half word of counter start value */ 
    movi		r15, 0b0111				/* START = 1, CONT = 1, ITO = 1 */
	sthio		r15, 4(r16)
	
    /* Keyboard */
    movia		r15, PS2_BASE			/* ps2 base address */
	movi		r7, 0x0001				/* set control bits */
	stwio		r7, 4(r15)				/* interrupt mask register is (base + 4) */
    
    
    /* enable Nios II processor interrupts */
	movi		r17, 0x1087				/* set interrupt mask bits for levels, level 0 (timer_1), level 1 (pushbutton)*/
	wrctl		ienable, r17			/* level 2 (timer_2), level 12 (Lego Sensor), level 7 (keyboard)*/
	movi		r17, 1
	wrctl		status, r17				/* turn on Nios II interrupt processing */
    movia       r17, JP2_BASE   
    
VGA_output:
	call Initial
	movia r3, FPGA_CHAR_BASE /*print text*/
	movui r4, 0xffff    /* White pixel */
	stbio r5, 0(r3)    
	movia r2, MESSANGE
	movia r3, FPGA_CHAR_BASE
    addi  r3, r3, 1280
	call print
	movia r2, MESSANGE2
	movia r3, FPGA_CHAR_BASE
	addi  r3, r3, 1536
	call print
	movia r2, MESSANGE3
	movia r3, FPGA_CHAR_BASE
	addi  r3, r3, 1792
	call print
	movia r2, MESSANGE4
	movia r3, FPGA_CHAR_BASE
	addi  r3, r3, 2304
	call print
End: br Event_Loop
    
Initial:
	movia r2,  FPGA_ONCHIP_BASE   /*print pixel*/
    movia r11, 0x0803BE7E         /*end of address*/
    movia r12, 0x0000
Black:
    beq r2,r11, Done_Black
    sthio r12, 0(r2)
    addi r2, r2, 2
    br Black
Done_Black:
	sthio r12, 0(r2)
ret
	
print:
	mov   r11, r0       # r11 counts number of characters in the current line
	movi  r12, 80
load:
    ldb r10,0(r2)
    beq r0,r10, Done_print
    stbio r10, 0(r3)
    addi r3, r3, 1
    addi r2, r2, 1
	addi r11, r11, 1
	blt  r11, r12, load
	addi r3, r3, 176     # 128*2 - 80 = 176
	mov  r11, r0
    br load
Done_print:
	ret
    
    
Event_Loop:
    call Hex_display
    movia   r23, MOTOR1_STATUS
    ldw     r22, 0(r23)
    mov     r20, r0
    
    beq     r20, r22, STATUS0
    addi    r20, r20, 1
    beq     r20, r22, STATUS1
    addi    r20, r20, 1
    beq     r20, r22, STATUS2
    addi    r20, r20, 1
    beq     r20, r22, STATUS3
br Event_Loop
STATUS0:
    call MOTOR2_OFF
    movia   r20, KEY_PRESSED				
    ldwio   r21, 0(r20)
    movi    r20, KEY2
    beq     r21,  r20, RELEASE_GRABBER_START
    br Event_Loop
RELEASE_GRABBER_START:
    movia   r20, KEY_PRESSED				
    stwio   r0, 0(r20)
    movi    r20, 1
    stw     r20, 0(r23)
    br Event_Loop
STATUS1:
    call MOTOR2_BACKWARD
    br Event_Loop
STATUS2:
    call MOTOR2_OFF
    br Event_Loop
STATUS3:
    call MOTOR2_FORWARD
    br Event_Loop

    
 