.equ    KEY0, 0
.equ    KEY1, 1
.equ    KEY2, 2
.equ    KEY3, 3
.equ    NONE, 4
    
.equ    RIGHT, 0
.equ    LEFT,  1

.equ    TEMP_RIGHT, 0b0001
.equ    TEMP_LEFT,  0b0010
.equ    GRABBER_RELEASE_KEY, 2


.equ    GRABBER_LEFT,       0x61
.equ    GRABBER_RIGHT,      0x6A
.equ    GRABBER_RELEASE,    0x29

.equ    GRABBER_STAGE_PULL, 0
.equ    GRABBER_STAGE_WAIT, 1
.equ    GRABBER_STAGE_PUSH, 2

/* Motor Status codes */
.equ    MOTOR0_STATUS_FORWARD,  0
.equ    MOTOR0_STATUS_BACKWARD, 1
.equ    MOTOR0_STATUS_OFF,      2

.equ    MOTOR1_STATUS_FORWARD,  0
.equ    MOTOR1_STATUS_BACKWARD, 1
.equ    MOTOR1_STATUS_OFF,      2

.equ    MOTOR2_STATUS_FORWARD,  0
.equ    MOTOR2_STATUS_BACKWARD, 1
.equ    MOTOR2_STATUS_OFF,      2

/* Keyboard codes */
.equ    KB_LETTER_A,        0x1C
.equ    KB_LETTER_D,        0x23
.equ    KB_BREAK,           0xF0
