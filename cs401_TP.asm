.data
Prompt: .asciiz "1- Encrypt a message\n2- Decrypt a message\n0- Exit\nInput: "
Message_Prompt: .asciiz "Message: "
PT_Prompt: .asciiz "Plain Text: "
CT_Prompt: .asciiz "Cipher Text: "
Plain_Text: .space 100
Cipher_Text: .space 100
Newline: .asciiz "\n"
Space: .asciiz " "

# S-Box Small Tables
S0: .byte 0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7
S1: .byte 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB
S2: .byte 0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2
S3: .byte 0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3

# Inverse S-Box Small Tables
IS0: .byte 0xC, 0x3, 0x0, 0xA, 0xB, 0x4, 0x5, 0xF, 0x9, 0xE, 0x6, 0xD, 0x2, 0x7, 0x8, 0x1
IS1: .byte 0xA, 0x7, 0x6, 0x9, 0x1, 0x2, 0xC, 0x5, 0x3, 0x4, 0x8, 0xF, 0xD, 0xE, 0xB, 0x0
IS2: .byte 0x9, 0x2, 0xF, 0x8, 0x0, 0xC, 0x3, 0x6, 0x4, 0xD, 0x1, 0xE, 0x7, 0xB, 0xA, 0x5
IS3: .byte 0xB, 0x5, 0x4, 0xF, 0xC, 0x6, 0x9, 0x0, 0xD, 0x3, 0xE, 0x8, 0x1, 0xA, 0x2, 0x7

# Permutation Table 
P: .byte 7, 6, 1, 5, 3, 4, 0, 2

# Inverse Permutation Table
IP: .byte 6, 2, 7, 4, 5, 3, 1, 0

# Key
K: .word 0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032

# Initial Vector
IV: .word 0x3412, 0x7856, 0xBC9A, 0xF0DE

# State Vector
R: .word 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000

# Temporary Values
T: .word 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
.text

State_Vector:		
	la $s0, IV
	la $s1, R
	li $t0, 0
	
Initialize_State_Vector:
	beq $t0, 8, Initialized_State_Vector
	move $t2, $t0
	slti $t1, $t0, 4
	beq $t1, 1, Continued

	addi $t2, $t0, -4
Continued:
	add $t2, $t2, $t2
	add $t2, $t2, $t2
	add $t2, $t2, $s0
	lw $t3, 0($t2)
	add $t5, $t0, $t0
	add $t5, $t5, $t5
	add $t4, $t5, $s1
	sw $t3, 0($t4)
	addi $t0, $t0, 1
	j Initialize_State_Vector
Initialized_State_Vector:
	la $s2, K
	li $t4, 0
Loop:
	beq $t4, 4, Main
	lhu $t0, 0($s1)
	add $t0, $t0, $t4
	andi $a0, $t0, 0x0000FFFF
	lhu $a1, 4($s2)
	lhu $a2, 12($s2)
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t0, $v0
	
	lhu $t1, 4($s1)
	add $t1, $t1, $t0
	andi $a0, $t1, 0x0000FFFF
	lhu $a1, 20($s2)
	lhu $a2, 28($s2)
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t1, $v0
	
	lhu $t2, 8($s1)
	add $t2, $t2, $t1
	andi $a0, $t2, 0x0000FFFF
	lhu $a1, 0($s2)
	lhu $a2, 8($s2)
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t2, $v0
	
	lhu $t3, 12($s1)
	add $t3, $t3, $2
	andi $a0, $t3, 0x0000FFFF
	lhu $a1, 16($s2)
	lhu $a2, 24($s2)
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t3, $v0
	
	lhu $t5, 0($s1)
	add $t5, $t5, $t3
	andi $t6, $t5, 0x0000FE00
	sll $t5, $t5, 7
	srl $t6, $t6, 9
	andi $t5, $t5, 0x0000FFFF
	or $t5, $t5, $t6
	sw $t5, 0($s1)
	
	lhu $t5, 4($s1)
	add $t5, $t5, $t0
	andi $t5, $t5, 0x0000FFFF
	andi $t6, $t5, 0x0000000F
	srl $t5, $t5, 4
	sll $t6, $t6, 12
	or $t5, $t5, $t6
	sw $t5, 4($s1)
	
	lhu $t5, 8($s1)
	add $t5, $t5, $t1
	andi $t6, $t5, 0x0000C000
	sll $t5, $t5, 2
	srl $t6, $t6, 14
	andi $t5, $t5, 0x0000FFFF
	or $t5, $t5, $t6
	sw $t5, 8($s1)
	
	lhu $t5, 12($s1)
	add $t5, $t5, $t2
	andi $t5, $t5, 0x0000FFFF
	andi $t6, $t5, 0x000001FF
	srl $t5, $t5, 9
	sll $t6, $t6, 7
	or $t5, $t5, $t6
	sw $t5, 12($s1)
	
	lhu $t5, 16($s1)
	lhu $t6, 12($s1)
	xor $t5, $t5, $t6
	sw $t5, 16($s1)
	
	lhu $t5, 20($s1)
	lhu $t6, 4($s1)
	xor $t5, $t5, $t6
	sw $t5, 20($s1)
	
	lhu $t5, 24($s1)
	lhu $t6, 8($s1)
	xor $t5, $t5, $t6
	sw $t5, 24($s1)
	
	lhu $t5, 28($s1)
	lhu $t6, 0($s1)
	xor $t5, $t5, $t6
	sw $t5, 28($s1)
	
	addi $t4, $t4, 1
	j Loop
	
Main:	
	li $v0, 4
	la $a0, Prompt
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	beq $t0, 0, End
	
	beq $t0, 1, Encryption
	
	beq $t0, 2, Decryption
	
	j Main
	
Encryption:
	li $v0, 4
	la $a0, Message_Prompt
	syscall
	
	li $v0, 8
	la $a0, Plain_Text
	li $a1, 100
	syscall
	
	li $v0, 4
	la $a0, PT_Prompt
	syscall 
	
	la $a0, Plain_Text
	syscall

	la $t0, Plain_Text
	li $t7, 0
	
PT_Length_Loop:
    lb $t2, 0($t0)                 
    beqz $t2, PT_Length_Done       
    addi $t0, $t0, 1               
    addi $t7, $t7, 1               
    j PT_Length_Loop                 

PT_Length_Done:
	li $t3, 0
	la $s3, Plain_Text
	la $s4, Cipher_Text
	la $s5, T
	
Encryption_Loop:
	beq $t3, $t7, End_Encryption_Loop
	
	lhu $t4, 0($s2)
	lhu $t5, 0($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	add $sp, $sp, 4
	move $a1, $v0
	lhu $t4, 4($s2)
	lhu $t5, 4($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	move $a2, $v0
	add $t4, $t3, $t3
	add $t4, $t4, $s3
	lbu $a0, 0($t4)
	lbu $t5, 1($t4)
	sll $a0, $a0, 8
	or $a0, $a0, $t5
	lhu $t4, 0($s1)
	add $a0, $a0, $t4
	andi $a0, $a0, 0x0000FFFF 
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t0, $v0
	
	lhu $t4, 8($s2)
	lhu $t5, 8($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t3, 4($sp)
	jal Linear_Function
	lw $t0, 0($sp)
	lw $t3, 4($sp)
	addi $sp, $sp, 8
	move $a1, $v0
	lhu $t4, 12($s2)
	lhu $t5, 12($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t3, 4($sp)
	jal Linear_Function
	lw $t0, 0($sp)
	lw $t3, 4($sp)
	addi $sp, $sp, 8
	move $a2, $v0
	lhu $t4, 4($s1)
	add $a0, $t0, $t4
	andi $a0, $a0, 0x0000FFFF 
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t1, $v0
	
	lhu $t4, 16($s2)
	lhu $t5, 16($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t3, 8($sp)
	jal Linear_Function
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t3, 8($sp)
	addi $sp, $sp, 12
	move $a1, $v0
	lhu $t4, 20($s2)
	lhu $t5, 20($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t3, 8($sp)
	jal Linear_Function
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t3, 8($sp)
	addi $sp, $sp, 12
	move $a2, $v0
	lhu $t4, 8($s1)
	add $a0, $t1, $t4
	andi $a0, $a0, 0x0000FFFF 
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t2, $v0
	
	lhu $t4, 24($s2)
	lhu $t5, 24($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	jal Linear_Function
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp, $sp, 16
	move $a1, $v0
	lhu $t4, 28($s2)
	lhu $t5, 28($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	jal Linear_Function
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp, $sp, 16
	move $a2, $v0
	lhu $t4, 12($s1)
	add $a0, $t2, $t4
	andi $a0, $a0, 0x0000FFFF 
	jal W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t4, $v0			
	lhu $t5, 0($s1)
	add $t4, $t4, $t5
	andi $t4, $t4, 0x0000FFFF
	add $t5, $t3, $t3
	add $t5, $t5, $s4
	andi $t6, $t4, 0x0000FF00
	andi $t4, $t4, 0x000000FF
	srl $t6, $t6, 8
	sb $t6, 0($t5)
	sb $t4, 1($t5)
	
	lhu $t4, 0($s1)
	add $t4, $t4, $t2
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 0($s5)
	
	lhu $t4, 4($s1)
	add $t4, $t4, $t0
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 4($s5)
	
	lhu $t4, 8($s1)
	add $t4, $t4, $t1
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 8($s5)
	
	lhu $t4, 12($s1)
	lhu $t5, 0($s1)
	add $t4, $t4, $t5
	add $t4, $t4, $t2
	add $t4, $t4, $t0
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 12($s5)
	
	lhu $t5, 16($s1)
	xor $t4, $t4, $t5
	sw $t4, 16($s5)
	
	lhu $t4, 20($s1)
	lhu $t5, 4($s1)
	add $t5, $t5, $t0
	andi $t5, $t5, 0x0000FFFF
	xor $t4, $t4, $t5
	sw $t4, 20($s5)
	
	lhu $t4, 24($s1)
	lhu $t5, 8($s1)
	add $t5, $t5, $t1
	andi $t5, $t5, 0x0000FFFF
	xor $t4, $t4, $t5
	sw $t4, 24($s5)
	
	lhu $t4, 28($s1)
	lhu $t5, 0($s1)
	add $t5, $t5, $t2
	andi $t5, $t5, 0x0000FFFF
	xor $t4, $t4, $t5
	sw $t4, 28($s5)
										
	li $t5, 0
Update_R_Loop:
	beq $t5, 8, End_Update
	add $t0, $t5, $t5
	add $t0, $t0, $t0
	add $t1, $t0, $s5
	lhu $t2, 0($t1)
	add $t1, $t0, $s1
	sw $t2, 0($t1)   
	add $t5, $t5, 1
	j Update_R_Loop
End_Update:
	add $t3, $t3, 1
	j Encryption_Loop
End_Encryption_Loop:
	li $t0, 0
	la $s0, Cipher_Text
	
	li $v0, 4
	la $a0, CT_Prompt
	syscall
	
	j Print_Output
	
Decryption:
	li $v0, 4
	la $a0, Message_Prompt
	syscall
	
	li $v0, 8
	la $a0, Cipher_Text
	li $a1, 100
	syscall

	li $v0, 4
	la $a0, CT_Prompt
	syscall 
	
	la $a0, Cipher_Text
	syscall
	
	la $t0, Plain_Text
	li $t7, 0
	
CT_Length_Loop:
    lb $t2, 0($t0)                 
    beqz $t2, CT_Length_Done       
    addi $t0, $t0, 1               
    addi $t7, $t7, 1               
    j CT_Length_Loop                 

CT_Length_Done:
	li $t3, 0
	la $s3, Plain_Text
	la $s4, Cipher_Text
	la $s5, T
	
Decryption_Loop:
	beq $t3, 8, End_Decryption_Loop	

	lhu $t4, 24($s2)
	lhu $t5, 24($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	move $a1, $v0
	lhu $t4, 28($s2)
	lhu $t5, 28($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	move $a2, $v0
	add $t4, $t3, $t3
	add $t4, $t4, $s4
	lbu $a0, 0($t4)
	lbu $t5, 1($t4)
	sll $a0, $a0, 8
	or $a0, $a0, $t5
	lhu $t4, 0($s1)
	subu $a0, $a0, $t4
	andi $a0, $a0, 0x0000FFFF 
	jal Inverse_W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t4, $v0
	lhu $t5, 12($s1)
	subu $t4, $t4, $t5
	andi $t2, $t4, 0x0000FFFF

	lhu $t4, 16($s2)
	lhu $t5, 16($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -8
	sw $t3, 0($sp)
	sw $t2, 4($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	addi $sp, $sp, 8
	move $a1, $v0
	lhu $t4, 20($s2)
	lhu $t5, 20($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -8
	sw $t3, 0($sp)
	sw $t2, 4($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	addi $sp, $sp, 8
	move $a2, $v0
	move $a0, $t2
	jal Inverse_W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t4, $v0
	lhu $t5, 8($s1)
	subu $t4, $t4, $t5
	andi $t1, $t4, 0x0000FFFF
	
	lhu $t4, 8($s2)
	lhu $t5, 8($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -12
	sw $t3, 0($sp)
	sw $t2, 4($sp)
	sw $t1, 8($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	addi $sp, $sp, 12
	move $a1, $v0
	lhu $t4, 12($s2)
	lhu $t5, 12($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -12
	sw $t3, 0($sp)
	sw $t2, 4($sp)
	sw $t1, 8($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	addi $sp, $sp, 12
	move $a2, $v0
	move $a0, $t1
	jal Inverse_W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t4, $v0
	lhu $t5, 4($s1)
	subu $t4, $t4, $t5
	andi $t0, $t4, 0x0000FFFF
	
	lhu $t4, 0($s2)
	lhu $t5, 0($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -16
	sw $t3, 0($sp)
	sw $t2, 4($sp)
	sw $t1, 8($sp)
	sw $t0, 12($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	move $a1, $v0
	lhu $t4, 4($s2)
	lhu $t5, 4($s1)
	xor $a0, $t4, $t5
	addi $sp, $sp, -16
	sw $t3, 0($sp)
	sw $t2, 4($sp)
	sw $t1, 8($sp)
	sw $t0, 12($sp)
	jal Linear_Function
	lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	move $a2, $v0
	move $a0, $t0
	jal Inverse_W_Function
	lw $t4, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	addi $sp, $sp, 44
	move $t4, $v0
	lhu $t5, 0($s1)
	subu $t4, $t4, $t5
	andi $t4, $t4, 0x0000FFFF
	add $t5, $t3, $t3
	add $t5, $t5, $s3
	andi $t6, $t4, 0x0000FF00
	andi $t4, $t4, 0x000000FF
	srl $t6, $t6, 8
	sb $t6, 0($t5)
	sb $t4, 1($t5)
	
	lhu $t4, 0($s1)
	add $t4, $t4, $t2
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 0($s5)
	
	lhu $t4, 4($s1)
	add $t4, $t4, $t0
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 4($s5)
	
	lhu $t4, 8($s1)
	add $t4, $t4, $t1
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 8($s5)
	
	lhu $t4, 12($s1)
	lhu $t5, 0($s1)
	add $t4, $t4, $t2
	add $t5, $t5, $t0
	add $t4, $t4, $t5
	andi $t4, $t4, 0x0000FFFF
	sw $t4, 12($s5)
	
	lhu $t5, 16($s1)
	xor $t4, $t4, $t5
	sw $t4, 16($s5)
	
	lhu $t4, 20($s1)
	lhu $t5, 4($s5)
	xor $t4, $t4, $t5
	sw $t4, 20($s5)
	
	lhu $t4, 24($s1)
	lhu $t5, 8($s5)
	xor $t4, $t4, $t5
	sw $t4, 24($s5)
	
	lhu $t4, 28($s1)
	lhu $t5, 0($s5)
	xor $t4, $t4, $t5
	sw $t4, 28($s5)
	
	li $t5, 0
Update_R_Loop_Decryption:
	beq $t5, 8, End_Update_Decryption
	add $t0, $t5, $t5
	add $t0, $t0, $t0
	add $t1, $t0, $s5
	lhu $t2, 0($t1)
	add $t1, $t0, $s1
	sw $t2, 0($t1)   
	add $t5, $t5, 1
	j Update_R_Loop_Decryption
End_Update_Decryption:
	add $t3, $t3, 1
	j Decryption_Loop
End_Decryption_Loop:
	li $t0, 0
	la $s0, Plain_Text
	
	li $v0, 4
	la $a0, PT_Prompt
	syscall
	
	j Print_Output

Print_Output:
	li $v0, 4
	move $a0, $s0
	syscall

	li $v0, 4
	la $a0, Newline
	syscall
	
	j End
#---------------
S_Small_Tables:
	la $s0, S0
	la $s1, S1
	la $s2, S2
	la $s3, S3
	
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	move $t3, $a3
	
	add $t4, $t0, $s0
	lbu $t0, ($t4)
	add $t5, $t1, $s1
	lbu $t1, ($t5)
	add $t4, $t2, $s2
	lbu $t2, ($t4)
	add $t5, $t3, $s3
	lbu $t3, ($t5)
	
	sll $t0, $t0, 12
	sll $t1, $t1, 8
	sll $t2, $t2, 4
	
	or $t0, $t0, $t1
	or $t2, $t2, $t3
	or $t0, $t0, $t2
	
	move $v0, $t0
	jr $ra

Inverse_S_Small_Tables:
	la $s0, IS0
	la $s1, IS1
	la $s2, IS2
	la $s3, IS3
	
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	move $t3, $a3
	
	add $t4, $t0, $s0
	lbu $t0, ($t4)
	add $t5, $t1, $s1
	lbu $t1, ($t5)
	add $t4, $t2, $s2
	lbu $t2, ($t4)
	add $t5, $t3, $s3
	lbu $t3, ($t5)
	
	sll $t0, $t0, 12
	sll $t1, $t1, 8
	sll $t2, $t2, 4
	
	or $t0, $t0, $t1
	or $t2, $t2, $t3
	or $t0, $t0, $t2
	
	move $v0, $t0
	jr $ra

Linear_Function:
	move $t0, $a0
	andi $t1, $t0, 0xFC00
	andi $t2, $t0, 0x003F
	sll $t3, $t0, 6
	srl $t1, $t1, 10
	srl $t4, $t0, 6
	sll $t2, $t2, 10
	or $t1, $t1, $t3
	or $t2, $t2, $t4
	andi $t1, $t1, 0xFFFF
	andi $t2, $t2, 0xFFFF
	
	xor $t0, $t0, $t1
	xor $t0, $t0, $t2 
	
	move $v0, $t0
	jr $ra

Inverse_Linear_Function:
	move $t0, $a0
	andi $t1, $t0, 0xFFC0
	andi $t2, $t0, 0x03FF
	sll $t3, $t0, 10
	srl $t1, $t1, 6
	srl $t4, $t0, 10
	sll $t2, $t2, 6
	or $t1, $t1, $t3
	or $t2, $t2, $t4
	andi $t1, $t1, 0xFFFF
	andi $t2, $t2, 0xFFFF
	
	xor $t0, $t0, $t1
	xor $t0, $t0, $t2
	
	andi $t1, $t0, 0xF000
	andi $t2, $t0, 0x000F
	sll $t3, $t0, 4
	srl $t1, $t1, 12
	srl $t4, $t0, 4
	sll $t2, $t2, 12
	or $t1, $t1, $t3
	or $t2, $t2, $t4
	andi $t1, $t1, 0xFFFF
	andi $t2, $t2, 0xFFFF
	
	xor $t0, $t0, $t1
	xor $t0, $t0, $t2
	
	move $v0, $t0
	jr $ra

Permutation_Function:
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	la $s0, P

	move $s1, $a0
	li $s2, 0 
	li $t4, 0
Loop_Permutation_Function:
	beq $s2, 8, Permutation_Function_End
	andi $t0, $s1, 1
	add $t1, $s2, $s0
	lbu $t2, ($t1)
	sllv $t3, $t0, $t2 
	or $t4, $t4, $t3
	srl $s1, $s1, 1	
	addi $s2, $s2, 1
	j Loop_Permutation_Function	
Permutation_Function_End:
	move $v0, $t4
	jr $ra

Inverse_Permutation_Function:
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	la $s0, IP

	move $s1, $a0
	li $s2, 0 
	li $t4, 0
Loop_Inverse_Permutation_Function:
	beq $s2, 8, Inverse_Permutation_Function_End
	andi $t0, $s1, 1
	add $t1, $s2, $s0
	lbu $t2, ($t1)
	sllv $t3, $t0, $t2 
	or $t4, $t4, $t3
	srl $s1, $s1, 1	
	addi $s2, $s2, 1
	j Loop_Inverse_Permutation_Function
Inverse_Permutation_Function_End:
	move $v0, $t4
	jr $ra

F_Function:	
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	move $s0, $a0
	
	srl $s1, $s0, 8
	andi $s2, $s0, 0x00F0
	andi $s3, $s0, 0x000F
	srl $s2, $s2, 4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $a0, $s1
	jal Permutation_Function
	
	move $s1, $v0
	lw $s0, 8($sp)
	lw $s2, 4($sp)
	lw $s3, 0($sp)
	addi $sp, $sp, 12
	
	move $a2, $s1
	move $a0, $s2
	andi $a3, $a2, 0x000F
	move $a1, $s3
	andi $a2, $a2, 0x00F0
	srl $a2, $a2, 4
	
	jal S_Small_Tables
	move $s0, $v0
				
	move $a0, $s0
	jal Linear_Function
	move $s0, $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $v0, $s0
	jr $ra

Inverse_F_Function:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $a0, $s0
	jal Inverse_Linear_Function
	move $s0, $v0

	andi $a0, $s0, 0xF000
	andi $a1, $s0, 0x0F00
	srl $a0, $a0, 12
	andi $a2, $s0, 0x00F0
	srl $a1, $a1, 8
	andi $a3, $s0, 0x000F
	srl $a2, $a2, 4
	
	jal Inverse_S_Small_Tables
	move $s0, $v0
	
	andi $a0, $s0, 0x00FF
	jal Inverse_Permutation_Function
	lw $s0, 8($sp)
	lw $s2, 4($sp)
	lw $s3, 0($sp)
	addi $sp, $sp, 12
	move $t0, $v0
	srl $s0, $s0, 8
	sll $t0, $t0, 8
	or $s0, $s0, $t0
	andi $s0, $s0, 0x0000FFFF

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $v0, $s0
	jr $ra

W_Function:
	addi $sp, $sp, -44
	sw $t4, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $t0, 28($sp)
	sw $t1, 32($sp)
	sw $t2, 36($sp)
	sw $t3, 40($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	xor $s0, $s0, $s1
	move $a0, $s0
	jal F_Function
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	move $s0, $v0
	
	xor $s0, $s0, $s2
	move $a0, $s0
	jal F_Function
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	move $s0, $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

Inverse_W_Function:	
	addi $sp, $sp, -44
	sw $t4, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $t0, 28($sp)
	sw $t1, 32($sp)
	sw $t2, 36($sp)
	sw $t3, 40($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $a0, $s0
	jal Inverse_F_Function
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	move $s0, $v0
	
	xor $a0, $s0, $s2	
	jal Inverse_F_Function
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	move $s0, $v0			
	
	xor $v0, $s0, $s1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
End:
