#Inventory Management With Login

.data
#Create file path
fileName: .asciiz "Client/Database/Authentication.txt"
fileWords: .space 1024	#1 kb
userName: .space 8	#8 bits (8 characters)
passWord: .space 8	#8 bits (8 characters)

#Statements
welcomeMessage: .asciiz "------Welcome to Inventory Management System------"
currentInventoryM: .asciiz "------Current Inventory------" 

#Prompts:
authQ: .asciiz "1. Login \n2.Register "
userQ: .asciiz "Enter Your Username (8 characters): " 
passQ: .asciiz "Enter Your Password (8 characters): " 
inventoryQ: .asciiz "1. Add New Item \n 2.Remove an Item \n 3. Update Stock of Existing Item"
itemNameQ: .asciiz "Enter name of new item: "
itemQuantityQ: .asciiz "Enter quantity of new item: "
itemRemoveQ: .asciiz "Enter name of item to remove (Case Sensitive): "
itemUpdateQ: .asziiz "Enter name of item to update (Case Sensitive): "
itemUpdateValueQ: .asziiz "Enter new value: "



#Errors:
incorrectAuthE: .asciiz "Incorrect Username Or Password Entered"
noErrorMessageM: .asciiz "No Error"


.text

main:
li $v0, 4
la $a0, welcomeMessage

li $t0, 0		#Set initial value of $t0 to 0
jal HandleAuth		#set $t0 to 0 if doesn't exist, 1 if exists


j TerminateProgram	#Terminate Program


#------------------------|Route 2|---------------------------#
HandleInventory:	
#Calls FetchItems on load
#Switch case: 1,2,3
#Calls UpdateInventory

li $v0,4			#Print heading
la $a0, currentInventoryM
syscall

jal UpdateInventory

jr $ra 

#------------------------------------------------------------#
UpdateInventory:	#Perform CRUD on Inventory File

li $v0, 4
la $a0, 

#Takes 1,2,3 as argument for:
#1. Increment Item, call FetchItems
#2. Decrement Item, call FetchItems
#3. Delete Item, call FetchItems

jr $ra

#--------------------------|Route 1|-------------------------#
HandleAuth:		#Handle User Auth
#Take username and password, set in register?
#Call Validate User 

li $v0,4
la $a0, authQ
syscall

li $v0, 5
move $t0, $v0

beq $t0, 1, HandleLogin
beq $t0, 2, HandleRegister

jr $ra 

#------------------------------------------------------------#
HandleLogin:		#Handles Login Functionality

#Select the auth file:
li $v0, 13 		#Prepare the descriptor to open file path using OPEN_FILE() syscall
la $a0, fileName		#Hand over file path to Open_File
li $a1,0			#Put into read mode (0)		
syscall
move $s0, $v0		#Hand over the readied descriptor to $s0 register

li $v0,4			#Prompt User for Username
la $a0, userQ
syscall

li $v0, 8		#Store 8 character input into userName space
move $a0, userName
move $a1, 8
syscall

li $v0,4			#Prompt User for Password
lw $a0, passQ
syscall

li $v0, 8		#Store 8 character input into passWord space
la $a0, passWord
move $a1, 8
syscall

li $t0, 0		#Set default $t0 value to 0
jal ValidateUser		#Returns $t0. 1 if validated, 0 if not

beq $t0, 1, HandleInventory		#if valid, go to HandleInventory
lw $t9, incorrectAuthE			#Else, set error to incorrectAuthE error
jal PrintError				#Print Error

li $v0, 16				#Close file before looping back to main
move $a0, $s0				#Hand over descriptor to close it as well
syscall

j main			#Loop back to main
				
#------------------------------------------------------------#
ValidateUser:		#Validate through parsed auth.txt
#Take username and password as arguments
#Check arguments against parsed data.
#return true if matched, else return false


#Read Data from the file:
li $v0, 14		#Ready to read file using READ_FILE() syscall
move $a0,$s0		#Hand over descriptor to read file operation.
la $a1, fileWords	#Hand over space where data from file will be used as buffer
la $a2, 1024		#Hard coded buffer lenght
syscall

#Parse the data and validate against userName and passWord spaces with 8 charachters (8 bits)
# When reading each line, it will be in username:password format \n indicates a new user entry

#If matches, set $t0 to 1, else it is 0 by default
jr $ra

#------------------------------------------------------------#
PrintErrror:
li $v0,4			#Prepare to print string
move $a0, $t9		#Hand over string in $t9 (Has to be set before calling this function)
syscall

la $t9, noErrorMessageM	#Reset it back to "No Errors"

jr $ra			

#------------------------------------------------------------#
TerminateProgram:	#End the program

li $v0, 10
syscall







