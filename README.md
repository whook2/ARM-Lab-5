# ARM Lab 5 SPRING 2024
## This program was written and compiled on a Raspberry Pi Zero using the GNU debugger.
This program simulates the operation of a teller machine. The teller will dispense, uppon request, $20 and $10 bills up to $200 total per customer. The program displays a welcome message, rejects invalid withdraw requests (must be multiples of 10 and not greater than $200), dispenses $20
bills first, then $10 bills, limits the total withdraws to 10, informs customer if there are insufficient funds, and prints out the total number of 
transactions, # of $20's and $10's distributed, total amount of money distributed, and remaining funds on hand. The initial inventory of each bill
is 50 bills. There is also a secret code, -9, that displays the inventory of bills, remaining balance, current # of transactions, and total
distributions made so far, when entered.
