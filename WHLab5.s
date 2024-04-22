@ Will Hooker
@ This program simulates the operation of a teller machine. The teller will dispense, uppon request, $20 and $10 bills up to $200 total per customer.                                                                                                                                                                                                                             .global _start
@ The program displays a welcome message, rejects invalid withdraw requests (must be multiples of 10 and not greater than $200), dispenses $20
@ bills first, then $10 bills, limits the total withdraws to 10, informs customer if there are insufficient funds, and prints out the total number of 
@ transactions, # of $20's and $10's distributed, total amount of money distributed, and remaining funds on hand. The initial inventory of each bill
@ is 50 bills. There is also a secret code, -9, that displays the inventory of bills, remaining balance, current # of transactions, and total
@ distributions made so far, when entered.
@
@ Use these commands to assemble, link, and run
@  as -o WHLab5.o WHLab5.s
@  gcc -o WHLab5 WHLab5.o
@  ./WHLab5 ;echo $?
@  gdb --args ./WHLab5
@
@

.global main
main:

welcome:
	@ Printing the welcome message
	LDR	r0, =welcome_msg
	BL	printf

withdraw_loop:
	@ Checking if the total transactions equal allowed amount
	LDR	r0, =total_transactions
	LDR	r1, [r0]
	CMP	r1, #10
	BEQ	program_end

	@ Checking if the balance has been depleted
	LDR	r0, =balance
	LDR	r1, [r0]
	CMP	r1, #0
	BEQ	program_end

	@ Printing the instructions
	LDR	r0, =instructions
	BL 	printf

	@ Reading user input
	LDR	r0, =user_input_format
	LDR	r1, =user_input_num
	BL	scanf

	@ Checking user input
	LDR	r1, =user_input_num
	LDR	r1, [r1]
	
	@ If secret code entered, branch to secret menu function
	CMP	r1, #-9	
	BEQ	secret_menu

	@ Checking in the user input is valid or invalid	
	CMP 	r1, #0
	BLE 	invalid_request
	CMP 	r1, #200
	BGT 	invalid_request
	@ Checking if the user input is a multiple of 10	
	BL	divisible_by_10
	
	@ Checking if there are sufficient funds for the transaction
	LDR	r0, =balance
	LDR	r2, [r0]
	CMP	r2, r1
	BLT	insufficient_funds	

	@ Input is valid and there are sufficient funds, so transaction count is incremented	
	LDR	r0, =total_transactions
	LDR	r3, [r0]	
	ADD	r3, r3, #1
	STR	r3, [r0]

valid_request:	
	@ Valid withdrawal request	
	CMP	r1, #0				@ If remaining amount to be dispensed is 0, transaction is done
	BEQ	withdraw_loop	
	CMP	r1, #20
	BLT 	dispense_ten

dispense_twenty:
	LDR	r0, =twenty_count		@ Checking the amount of $20's remaining, if out, dispense $10's
	LDR 	r2, [r0]
	CMP 	r2, #0
	BEQ	dispense_ten

	SUB 	r1, r1, #20			@ subtracting 20 from the amount to be dispensed
	LDR	r0, =twenty_count
	LDR 	r2, [r0]
	SUB	r2, r2, #1			@ subtracting 1 $20 bill from the total amount of $20's
	STR	r2, [r0]
	LDR	r0, =balance 			@ updating the balance after dispersing a 20
	LDR	r2, [r0]
	SUB	r2, r2, #20
	STR	r2, [r0]
	LDR	r0, =total_money_dist		@ updating the amount of money distributed by 20
	LDR	r2, [r0]
	ADD	r2, r2, #20
	STR	r2, [r0]
	LDR	r0, =total_twenty		@ updating the amount of $20's distributed
	LDR	r3, [r0]
	ADD	r3, r3, #1
	STR	r3, [r0]
	LDR	r0, =total_distributions	@ updating the amount of bills distributed
	LDR	r3, [r0]
	ADD	r3, r3, #1
	STR	r3, [r0]
	B	valid_request

dispense_ten:
	SUB	r1, r1, #10			@ subtracting $10 from the amount to be dispensed
	LDR	r0, =ten_count			
	LDR 	r2, [r0]
	SUB	r2, r2, #1			@ subtracting 1 $10 bill from the total amount of $10's
	STR	r2, [r0]
	LDR	r0, =balance 			@ updating the balance after dispersing a 10
	LDR	r2, [r0]
	SUB	r2, r2, #10
	STR	r2, [r0]
	LDR	r0, =total_money_dist		@ updating the amount of money distributed by 10
	LDR	r2, [r0]
	ADD	r2, r2, #10
	STR	r2, [r0]
	LDR	r0, =total_ten			@ updating the amount of $10's distributed
	LDR	r3, [r0]
	ADD	r3, r3, #1
	STR	r3, [r0]	
	LDR	r0, =total_distributions	@ updating the amount of bills distributed
	LDR	r3, [r0]
	ADD	r3, r3, #1
	STR	r3, [r0]
	B	valid_request

invalid_request:
	LDR	r0, =invalid_msg		@ printing the invalid request message
	BL 	printf
	B 	withdraw_loop

insufficient_funds:
	LDR	r0, =insufficient_funds_msg	@ printing the insufficient funds message
	BL	printf
	B 	withdraw_loop

secret_menu:
	LDR	r0, =secret_msg			@ printing the secret menu message with its corresponding values
	LDR	r6, =twenty_count
	LDR	r1, [r6]
	LDR	r6, =ten_count
	LDR	r2, [r6]
	LDR	r6, =balance	
	LDR	r3, [r6]
	BL	printf
	LDR	r0, =secret_msg2		@ printing the last two values, ran into issues printing from r4 and r5
	LDR	r6, =total_transactions
	LDR	r1, [r6]
	LDR	r6, =total_distributions
	LDR	r2, [r6]
	BL	printf
	B	withdraw_loop

program_end:
	LDR	r0, =ending_msg			@printing the ending message with its corresponding values
	BL 	printf
	LDR	r0, =stats_msg	
	LDR	r6, =total_transactions
	LDR	r1, [r6]
	LDR 	r6, =total_twenty
	LDR	r2, [r6]
	LDR	r6, =total_ten
	LDR	r3, [r6]
	BL	printf
	LDR	r0, =stats_msg2			@ printing the rest of the end message, again had issues printing from r4 and r5
	LDR	r6, =total_money_dist
	LDR	r1, [r6]
	LDR	r6, =balance
	LDR	r2, [r6]
	BL 	printf
	
	@ Exiting the program
	MOV	r7, #0X01
	SVC	0

divisible_by_10:
	MOV	r2, r1				@ function to check whether the input is divisible by 10
loop:
	CMP	r2, #0				@ if r2 ends up as 0, it was divisible by 10. branches and then moves the PC to LR
	BEQ	done
	SUB	r2, r2, #10			@ subtracting 10 from the value
	CMP	r2, #0
	BLT	invalid_request			@ if the result is less than 0, it's an invalid request
	B	loop

done:
	MOV	PC, LR

.data
.balign 4
welcome_msg:		.asciz "Welcome to the ATM!\n"

.balign 4
instructions:		.asciz "Please enter a withdrawal amount (multiples of 10, up to $200).\n$"

.balign 4
invalid_msg:		.asciz "Invalid withdrawal request. Please enter a valid request.\n"

.balign 4
insufficient_funds_msg:	.asciz "Insufficient funds. Please enter a lower amount.\n"

.balign 4
ending_msg:		.asciz "Thank you for using the ATM!\n"

.balign 4
stats_msg:		.asciz "Valid transactions: %d\n$20 bills distributed: %d\n$10 bills distributed: %d\n"

.balign 4
stats_msg2:		.asciz "Total amount distributed: $%d\nRemaining funds: $%d\n"		

.balign 4
secret_msg:		.asciz "Inventory of $20 bills: %d\nInventory of $10 bills: %d\nRemaining balance: $%d\n"

.balign 4
secret_msg2:		.asciz "Total transactions: %d\nTotal distributions: %d\n"

.balign 4
balance:		.word 1500

.balign 4
twenty_bill:		.word 20

.balign 4
ten_bill: 		.word 10

.balign 4
twenty_count:		.word 50

.balign 4
ten_count:		.word 50

.balign 4
total_transactions:	.word 0

.balign 4
total_twenty:		.word 0

.balign 4
total_ten:		.word 0

.balign 4
total_distributions:	.word 0

.balign 4
total_money_dist:	.word 0

.balign 4
user_input_format:	.asciz "%d"

.balign 4
user_input_num:		.word 0

.global printf
.global scanf
