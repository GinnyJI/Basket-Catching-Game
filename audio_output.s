    .include "address_map_nios2.s"
	
	.equ AUDIOCOUNTER, 72820
	
.section .data 
	.align 2
AUDIOFILE: .incbin "score_sound_effect.wav"
	
.section .text 
.global Audio_output

Audio_output:  
	#save registers since being called in interrupt
	subi sp, sp, 24
    stw  ra,  0(sp)
	stw  r3,  4(sp)
	stw  r8,  8(sp)
	stw  r9,  12(sp)
	stw  r10, 16(sp)
	stw  r15, 20(sp)
	
	#get audio information
	movia r15, AUDIO_BASE
	movia r8, AUDIOFILE           # r8 stores the audio file
	movia r9, AUDIOCOUNTER
Audio_check:
	ldwio r3,4(r15)               # Read fifospace register
	andhi r3,r3,0xFFFF 
	beq r3, r0, Audio_check      # Check valid 

Audio_loop:
	ldw r10, 0(r8)
	stwio r10,8(r15)      # Store to left channel 
	stwio r10,12(r15)     # Store to right channel 
	addi r8,r8,4
	addi r9,r9,-1
	bgtu r9,r0,Audio_check
  
    #restore registers
    ldw  ra,  0(sp)
	ldw  r3,  4(sp)
	ldw  r8,  8(sp)
	ldw  r9,  12(sp)
	ldw  r10, 16(sp)
	ldw  r15, 20(sp)
	addi sp,  sp, 24
	
ret
	