#Inventory Management With Login

.data
#Create file path
fileName: .asciiz "Client/Database/Authentication.txt"
fileWords: .space 1024

.text

main:

#Print file data:

li $v0, 4		#Read String from given space
la $a0, fileWords	#Hand over space to v0 register
syscall

j TerminateProgram	#Terminate Program


#------------------------|Route 2|---------------------------#
HandleInventory:	
#Calls FetchItems on load
#Switch case: 1,2,3
#Calls UpdateInventory


#------------------------------------------------------------#
UpdateInventory:	#Perform CRUD on Inventory File

#Takes 1,2,3 as argument for:
#1. Increment Item, call FetchItems
#2. Decrement Item, call FetchItems
#3. Delete Item, call FetchItems



#--------------------------|Route 1|-------------------------#
HandleAuth:		#Handle User Auth
#Take username and password, set in register?
#Call Validate User 

#Select the auth file:
li $v0, 13 		#Prepare the descriptor to open file path using OPEN_FILE() syscall
la $a0, fileName		#Hand over file path to Open_File
li $a1,0			#Put into read mode (0)		
syscall
move $s0, $v0		#Hand over the readied descriptor to $s0 register




			
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

#Parse the data


#------------------------------------------------------------#
TerminateProgram:	#End the program

li $v0, 10
syscall







