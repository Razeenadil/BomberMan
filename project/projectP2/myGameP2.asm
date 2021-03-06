//Muhammad Adil
//UCID: 30069315
//Project Part 2 (assembly version)
///////////////////////////////////////////////////////////////////////////////////////////////////////////

	.text
	input:			.asciz "%d"
	error1:			.asciz "Invalid number of arguments\n"
	promptCoor:		.asciz "Enter x and y coorindates respectively x:%d-%d and y:%d-%d.\n"
	outputNegs:		.asciz "Total negatives number is %d/%d = %.2f%% less than 40%\n"
	outputSpec:		.asciz "Total power up number is %.0f/%d = %.2f%% less than 20%\n"
	error2:			.asciz "Second argumnet is out of bound\n"
	error3:			.asciz "Third argument is out of bounds\n"
	error4:			.asciz "Coordinates out of range\n"
	newLine:		.asciz "\n"
	output:			.asciz "%6.2f "
	power1:			.asciz "   $   " //3 spaces each side
	power2:			.asciz "   @   "
	power3:			.asciz "   &   "
	exiting:		.asciz "   *   "
	gameStarted:		.asciz "===================================================Game Started====================================================\n"
	X:			.asciz "X "
	minus:			.asciz "- "
	plus:			.asciz "+ "
	dollar:			.asciz "$ "
	star:			.asciz "* "
	at:			.asciz "@ "
	ander:			.asciz "& "
	output2:		.asciz "%s "
	S:			.asciz "Score: 0\n"
	L:			.asciz "Lives: 3\n"
	B:			.asciz "Bombs: %d\n" 
	in1:			.asciz "%d %d"
	promptExit:		.asciz "Enter 0 to exit or any other NUMBER to continue\n"
	testing:      		.asciz "These are the start coors %d\n"
	testing2:		.asciz "The end coors are %d\n"
	scoreIs:		.asciz "Score: %.2f\n"
	bombIs:			.asciz "Bomb: %0.f\n"
	livesIs:		.asciz "Lives: %0.f\n"
	power1Found:		.asciz "Bomb range doubled.\n"
	power2Found:		.asciz "Extra 10 points.\n"
	power3Found:		.asciz "Extra life found.\n"
	exitFound:		.asciz "Exit key found. You won.\n"
	bombDone:		.asciz "Out of bombs. You lost\n"
	livesDone:		.asciz "Out of lives. You lost\n"
	lostLive:		.asciz "You lost a life\n"
	total:			.asciz "Total score is: %.2f\n"
	exitTheGame:		.asciz "Thanks for playing\n"

	define(row_r,x19)
	define(col_r,x20)
	define(pName_r,x21)
	define(temp_r,x22)
	define(totalAlloc_r,x23)
	define(offset_r,x24)
	define(offset1_r,x27)
	define(stackPoint_r,x28)
	define(score_dr,d10)
	define(bomb_dr,d11)
	define(range_dr,d12)
	define(lives_dr,d13)
	define(totalScore_dr,d14)

	.balign 4
	.global main

//this is the main function
//calls other funtions
//get command line args
main:
	stp	x29,		x30,		[sp, -16]!	//storing frame pointer and link register on the stack
	mov	x29,		sp				//updating frame pointer
	mov	stackPoint_r,	x29
	
	mov	x2,		x0				//number of command line args
	cmp	x2,		4
	b.ne	invaildArgs
	
	//getting player name
	mov	temp_r,		x1
	ldr	x0,		[temp_r,8]
	mov	pName_r,	x0
		

	//getting number of rows
	ldr	x0,		[temp_r,16]
	bl	atoi						//calling atoi from c
	mov	row_r,		x0
	cmp	row_r,		20				//error checking row
	b.gt	checkRow
	cmp	row_r,		10
	b.lt	checkRow
	
	
	//getting number of cols
	ldr	x0,		[temp_r,24]
	bl	atoi						//calling atoi from c
	mov	col_r,		x0
	cmp	col_r,		20				//error checking cols
	b.gt	checkCol
	cmp	col_r,		10
	b.lt	checkCol
	
	//allocating space for the array
	mov	temp_r,		xzr
	sub	temp_r,		xzr,		row_r		//alloc_r = -row_r 
	mul	temp_r,		temp_r,		col_r		//alloc_r = alloc_r * col_r
	lsl	temp_r,		temp_r,		3		//multiplying by the number of bytes(8)
	and	temp_r,		temp_r,		-0x10		//making sure alloc_r is divisible by 16
	add	totalAlloc_r,	totalAlloc_r,	temp_r		//totalAlloc = totalAlloc_r + alloc_r
	mov	offset1_r,	totalAlloc_r
	mov	temp_r,		xzr

	//calcaulting space for char array
	sub	temp_r,		xzr,		row_r
	mul	temp_r,		temp_r,		col_r
	lsl	temp_r,		temp_r,		3
	and 	temp_r,		temp_r,		-0x10
	add	totalAlloc_r,	totalAlloc_r,	temp_r
	mov	offset_r,	totalAlloc_r
	mov	temp_r,		xzr
	add 	sp,		sp,		totalAlloc_r
	
	//calling rand funtions to generate random numbers
	mov	x0,		xzr
	bl	time						//time from c
	bl	srand						//srand from c
	
	//calling initalizeGame funtion
	mov	x0,		row_r
	mov	x1,		col_r
	mov	x2,		offset_r
	mov	x3,		x25
	mov	x4,		x26
	mov	x5,		stackPoint_r
	bl	initalizeGame

	//calling display function
	mov	x0,		row_r
	mov	x1,		col_r
	mov	x2,		offset1_r
	mov	x3,		stackPoint_r
	bl	display

	//converting to float
	mov	x1,		xzr
	scvtf	d1,		x1
	fmov	score_dr,	d1	

	//getting number of bombs
	mul	x10,		row_r,		col_r
	mov	x2,		10
	mul	x10,		x10,		x2
	mov	x2,		100
	udiv	x10,		x10,		x2
	scvtf	bomb_dr,	x10
	
	//setting inital range
	mov	x1,		xzr
	scvtf	d1,		x1
	fmov	range_dr,	d1
	fmov	totalScore_dr,	d1
	
	//setting lives to 3
	mov	x1,		3
	scvtf	d1,		x1
	fmov	lives_dr,	d1


promptAgain:							//this is the main loop for the game 
	//getting x and y coor
	mov	x0,		row_r
	mov	x1,		col_r
	mov	x2,		stackPoint_r
	bl	getInput

	//getting range
	sub	x2,		row_r,		1
	sub	x3,		col_r,		1
	
	//error checking xCoor
	ldr	temp_r,		=xCoor
	ldr	x1,		[temp_r]
	cmp	x1,		x2				//error checking user input X
	b.gt	promptAgain
	cmp	x1,		xzr
	b.lt	promptAgain
	
	//error checking yCoor
	ldr	temp_r,		=yCoor
	ldr	x1,		[temp_r]
	cmp	x1,		x3				//error checking user input Y
	b.gt	promptAgain
	cmp	x1,		xzr
	b.lt	promptAgain
	
	//calling checker function
	mov	x0,		row_r
	mov	x1,		col_r
	mov	x2,		offset_r
	mov	x3,		offset1_r
	mov	x4,		stackPoint_r
	fmov	d0,		score_dr
	fmov	d1,		bomb_dr
	fmov	d2,		range_dr
	fmov	d3,		lives_dr
	bl	checker

	//variables being returned
	fmov	score_dr,	d0				//returned value
	fmov	bomb_dr,	d1				//returned value
	fmov	range_dr,	d2				//returned value
	fmov	lives_dr,	d3
	
	
	//calling calculateScore
	mov	temp_r,		xzr
	mov	x0,		temp_r				//sending in the flag to exit game
	mov	x1,		row_r
	mov	x2,		col_r
	mov	x3,		offset1_r
	mov	x4,		stackPoint_r
	fmov	d0,		score_dr
	fmov	d1,		bomb_dr
	fmov	d2,		lives_dr
	fmov	d3,		totalScore_dr
	bl	calculateScore
	mov	temp_r,		x0				//flag being returned

checkFlag:							//checking to see if game should exit
	cmp	temp_r,		-1				//if flag == -1
	b.eq	reallocate					//this is end of program
	
	//prompting for loop
	ldr	x0,		=promptExit			//check to see if user wants to exit game
	bl	printf
	//getting in user input
	ldr	x0,		=input
	ldr	x1,		=exitFlag
	bl	scanf
	//checking input
	ldr	temp_r,		=exitFlag
	ldr	x1,		[temp_r]
	cmp	x1,		0
	b.ne	promptAgain					//if they want to the game will exit
	
reallocate:							//exit program
	//calculating space for float array
	mov	temp_r,		xzr
	mov	totalAlloc_r,	xzr
	sub	temp_r,		xzr,		row_r
	mul	temp_r,		temp_r,		col_r
	lsl	temp_r,		temp_r,		3
	and	temp_r,		temp_r,		-0x10
	add	totalAlloc_r,	totalAlloc_r,	temp_r
	
	//calculating space for char array
	mov	temp_r,		xzr
	sub	temp_r,		xzr,		row_r
	mul	temp_r,		temp_r,		col_r
	lsl	temp_r,		temp_r,		3
	and	temp_r,		temp_r,		-0x10
	add	totalAlloc_r,	totalAlloc_r,	temp_r
	sub	totalAlloc_r,	xzr,		totalAlloc_r
	add	sp,		sp,		totalAlloc_r
	b	exit
	
exit:
	ldp	x29,	x30,	[sp], 16			//restoring frame pointer/link register and freeing 16 bytes
	ret							//End of main
//============================================================End of main=========================================================

// calculating space for each macro
define(
	init_subr_x,
	`x19_s = 16
	x20_s = x19_s + 8
	x21_s = x20_s + 8 
	x22_s = x21_s + 8
	x23_s = x22_s + 8
	x24_s = x23_s + 8
	x25_s = x24_s + 8
	x26_s = x25_s + 8
	x27_s = x26_s + 8
	x28_s = x27_s + 8'
)

//storing each each macro in stack. 
define(
	store_x,	
	`str	x19,	[x29, x19_s]
	str	x20,	[x29, x20_s]
	str	x21,	[x29, x21_s]
	str	x22,	[x29, x22_s]
	str	x23,	[x29, x23_s]
	str	x24,	[x29, x24_s]
	str	x25,	[x29, x25_s]
	str	x26,	[x29, x26_s]
	str	x27,	[x29, x27_s]
	str	x28,	[x29, x28_s]'
)

// load macro back from memory
// used to restore values of macros
define(
	load_x,
	`ldr	x19,	[x29, x19_s]
	ldr	x20,	[x29, x20_s]
	ldr	x21,	[x29, x21_s]
	ldr	x22,	[x29, x22_s]
	ldr	x23,	[x29, x23_s]
	ldr	x24,	[x29, x24_s]
	ldr	x25,	[x29, x25_s]
	ldr	x26,	[x29, x26_s]
	ldr	x27,	[x29, x27_s]
	ldr	x28,	[x29, x28_s]'
)
//============================================================updateDiaplay subroutine=========================================
//everytime bomb is dropped this fucntion displays updated board.
//checks score, lives, and bomb.
//calculates score
init_subr_x()
define(iCount_r,x23)
define(jCount_r,x21)
calculateScore:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp
	store_x()
	//initalize variables
	mov	temp_r,		x0
	mov	row_r,		x1
	mov	col_r,		x2
	mov	offset1_r,	x3
	mov	stackPoint_r,	x4
	fmov	score_dr,	d0
	fmov	bomb_dr,	d1
	fmov	lives_dr,	d2
	fmov	totalScore_dr,	d3

	//initalizing counters
	mov	iCount_r,	xzr
	mov	jCount_r,	xzr

updater:
	//checking to see if exit is uncovered
	//if so setting the flag
	ldr	x2,		[stackPoint_r,offset1_r]
	ldr	x4,		[x2]
	ldr	x3,		=star
	ldr	x5,		[x3]
	cmp	x4,		x5				//checking if exit uncovered
	b.eq	exitTile
	b	skipper	

exitTile:
	mov	temp_r,		-1				//setting the flag
	
skipper:	
	//printing results
	ldr	x0,		=output2
	mov	x1,		x2
	bl	printf
	
	//incrementing offset1_r and j_r
	add	offset1_r,	offset1_r,	8
	add	jCount_r,	jCount_r,	1

	//checking to see if counter is in bound
	cmp	jCount_r,	col_r
	b.lt	updater
	
	//if j_r not in bound
	mov	jCount_r,	xzr
	ldr	x0,		=newLine
	bl	printf
	add	iCount_r,	iCount_r,	1
	cmp	iCount_r,	row_r
	b.lt	updater

	//checking if bomb is equal to 0
	mov	x1,		xzr
	scvtf	d1,		x1
	fcmp	bomb_dr,	d1
	b.eq	bombsOut

	//checking if score < 0
	mov	x1,		xzr
	scvtf	d1,		x1
	fcmp	score_dr,	d1
	b.lt	resetScore
	b	skipExit

resetScore:						//reset score to 0 and decrease lives
	//reset score
	mov	x1,		xzr
	scvtf	d1,		x1
	fmov	score_dr,	d1
	
	//decreasing lives
	mov	x1,		1
	scvtf	d1,		x1
	fsub	lives_dr,	lives_dr,	d1
	ldr	x0,		=lostLive
	bl	printf
	//checking to s ee if lives is 0
	mov	x2,		xzr
	scvtf	d2,		x2
	fcmp	lives_dr,	d2
	b.eq	livesOut
	b	skipExit

livesOut:						//set flag when lives = 0
	mov	temp_r,		-1
	ldr	x0,		=livesDone		//tell user lost live
	bl	printf
	b	skipExit

bombsOut:						//set flag for out of bombs
	mov	temp_r,		-1
	ldr	x0,		=bombDone		//tell user out of bombs
	bl	printf
	b	skipExit
	
skipExit:	
	//printing score 
	ldr	x0,		=scoreIs
	fmov	d0,		score_dr
	bl	printf
	fadd	totalScore_dr,	totalScore_dr,	score_dr
	
	//printing bombs
	ldr	x0,		=bombIs
	fmov	d0,		bomb_dr
	bl	printf

	//printing lives
	ldr	x0,		=livesIs
	fmov	d0,		lives_dr
	bl	printf
	
	//total score
	ldr	x0,		=total
	fmov	d0,		totalScore_dr
	bl	printf
	
	//returning temp flag
	mov	x0,		temp_r
	
	load_x()
	ldp	x29,		x30,		[sp], 96
	ret
//============================================================getInput Subroutine==============================================
//this function gets user input using scanf
//gets where bomb is being dropped
init_subr_x()
getInput:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp
	store_x()
	//initalizing variables
	mov	row_r,		x0
	mov	col_r,		x1
	mov	stackPoint_r,	x2
	
	//getting range of x and y coor
	sub	row_r,		row_r,		1
	sub	col_r,		col_r,		1

	//prompt for user input
	ldr	x0,		=promptCoor			//prompt text displayed to user
	mov	x1,		xzr
	mov	x2,		row_r
	mov	x3,		xzr
	mov	x4,		col_r
	bl	printf		
	
	//storing in user input
	ldr	x0,		=in1				//loading in input string
	ldr	x1,		=xCoor
	ldr	x2,		=yCoor
	bl	scanf						//calling scanf from c 
	
	load_x()
	ldp	x29,		x30,		[sp], 96
	ret
	
//=====================================================checker Subroutine===================================================
//calls the getrange funtion
//gets start and end coor of bomb radius
//checks the radius and uncovers tiles accordingly
//updates char at that position accordingly
init_subr_x()
define(sR_r,x21)
define(sC_r,x23)
define(eR_r,x25)
define(eC_r,x26)
define(i_dr,d8)
define(j_dr,d9)
checker:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp				
	store_x()
	//initalizing variable
	mov	row_r,		x0
	mov	col_r,		x1
	mov	offset_r,	x2
	mov	offset1_r,	x3
	mov	stackPoint_r,	x4
	fmov	score_dr,	d0
	fmov	bomb_dr,	d1
	fmov	range_dr,	d2
	fmov	lives_dr,	d3
	
	//decreasing bomb
	mov	x1,		-1
	scvtf	d1,		x1
	fadd	bomb_dr,	bomb_dr,	d1

	//initaling counter. using float so have to convert
	mov	x1,		xzr
	scvtf	d1,		x1
	fmov	i_dr,		d1
	fmov	j_dr,		d1

	
	//sening in parameters to getRange
	mov	x0,		sR_r
	mov	x1,		sC_r
	mov	x2,		eR_r
	mov	x3,		eC_r
	mov	x4,		row_r
	mov	x5,		col_r
	fmov	d0,		range_dr
	bl	getRange
	//returing variables from getRange
	mov	sR_r,		x0
	mov	sC_r,		x1
	mov	eR_r,		x2
	mov	eC_r,		x3

	//reset the counter	
	mov	x1,		xzr
	scvtf	d1,		x1
	fmov	range_dr,	d1
	
check:								//check to see if xCoor/yCoor == i_dr or j_dr
	//checks if yCoor = j_dr						
	scvtf	d1,		sC_r
	fcmp	j_dr,		d1
	b.eq	step1
	b	increment

step1:
	//checks if xCoor = i_dr
	scvtf	d1,		sR_r
	fcmp	i_dr,		d1
	b.eq	step2
	b	increment

step2:
	//checks to see if j_dr is in col bomb radius
	scvtf	d1,		eC_r
	fcmp	j_dr,		d1
	b.le	step3
	b	increment

step3:
	//checks to see if j_dr is in col bomb radius
	scvtf	d1,		sC_r
	fcmp	j_dr,		d1
	b.ge	step4
	b	increment

step4:
	//checks to see if i_dr is in row bom radius
	scvtf	d1,		sR_r
	fcmp	i_dr,		d1
	b.ge	step5
	b	increment
step5:
	//checks to see if i_dr is in row bomb radius
	scvtf	d1,		eR_r
	fcmp	i_dr,		d1
	b.le	step6
	b	increment
step6:
	//if all that is true print number at current position
	ldr	d1,		[stackPoint_r,offset_r]
	//if number ==  65
	mov	x2,		65
	scvtf	d2,		x2
	fcmp	d1,		d2
	b.eq	isPower
	//if number == 66
	mov	x2,		66
	scvtf	d2,		x2
	fcmp	d1,		d2
	b.eq	isExitKey
	//if number == 67
	mov	x2,		67
	scvtf	d2,		x2
	fcmp	d1,		d2
	b.eq	isPower2
	//if number == 68
	mov	x2,		68
	scvtf	d2,		x2
	fcmp	d1,		d2
	b.eq	isPower3
	//if number < 0
	mov	x2,		xzr
	scvtf	d2,		x2
	fcmp	d1,		d2
	b.lt	isNegative
	//if number is > 0
	fcmp	d1,		d2
	b.gt	isPositive

isExitKey:							//updatinf char to *	
	ldr	x0,		=exitFound
	bl	printf
	ldr	temp_r,		=star								
	str	temp_r,		[stackPoint_r,offset1_r]
	b	increment

isPower2:							//updating char to @ and incrementing bomb range
	//cechking to see if board is already uncovered
	ldr	temp_r,		[stackPoint_r,offset1_r]
	ldr	x1,		[temp_r]
	ldr	temp_r,		=at
	ldr	x2,		[temp_r]
	cmp	x1,		x2
	b.eq	increment

	ldr	x0,		=power2Found
	bl	printf
	mov	x1,		10
	scvtf	d1,		x1
	fadd	score_dr,	score_dr,	d1
	//updaing char to @
	ldr	temp_r,		=at
	str	temp_r,		[stackPoint_r,offset1_r]
	b	increment
	
isPower3:
	//if board is already uncovered
	ldr	temp_r,		[stackPoint_r,offset1_r]
	ldr	x1,		[temp_r]
	ldr	temp_r,		=ander
	ldr	x2,		[temp_r]
	cmp	x1,		x2
	b.eq	increment

	ldr	x0,		=power3Found
	bl	printf
	mov	x1,		1
	scvtf	d1,		x1
	fadd	lives_dr,	lives_dr,	d1
	//updating char to &
	ldr	temp_r,		=ander
	str	temp_r,		[stackPoint_r,offset1_r]

isPower:							//updating char to $ and incrementing bomb range
	//chcking to see if board is already uncovered at that position
	ldr	temp_r,		[stackPoint_r,offset1_r]
	ldr	x1,		[temp_r]
	ldr	temp_r,		=dollar
	ldr	x2,		[temp_r]
	cmp	x1,		x2
	b.eq	increment	

	ldr	x0,		=power1Found
	bl	printf
	mov	x1,		1
	scvtf	d1,		x1
	fadd	range_dr,	range_dr,		d1
	//updating char to $
	ldr	temp_r,		=dollar
	str	temp_r,		[stackPoint_r,offset1_r]
	b	increment
	
isPositive:							//updating char to + and incrementing score
	//checking to see if board is already uncovered at that position
	ldr	temp_r,		[stackPoint_r,offset1_r]
	ldr	x1,		[temp_r]
	ldr	temp_r,		=plus
	ldr	x2,		[temp_r]
	cmp	x1,		x2
	b.eq	increment
	
	ldr	d1,		[stackPoint_r,offset_r]
	fadd	score_dr,	score_dr,		d1
	//updating char to +
	ldr	temp_r,		=plus
	str	temp_r,		[stackPoint_r,offset1_r]
	b	increment

isNegative:							//updating char to - and calculating score
	//checking to see if board is already uncovered at that position
	ldr	temp_r,		[stackPoint_r,offset1_r]
	ldr	x1,		[temp_r]
	ldr	temp_r,		=minus
	ldr	x2,		[temp_r]
	cmp	x1,		x2
	b.eq	increment

	ldr	d1,		[stackPoint_r,offset_r]
	fadd	score_dr,	score_dr,		d1
	//updating char to -
	ldr	temp_r,		=minus
	str	temp_r,		[stackPoint_r,offset1_r]
	
	
increment:							//increments counter and checks to see if counter is in bounds
	add	offset_r,	offset_r,	8
	add	offset1_r,	offset1_r,	8
	mov	x1,		1
	scvtf	d2,		x1
	fadd	j_dr,		j_dr,		d2		


	//if j_dr is in bounds
	scvtf	d2,		col_r
	fcmp	j_dr,		d2
	b.lt	step2

	//resetting counter
	mov	x1,		xzr
	scvtf	d2,		x1
	fmov	j_dr,		d2
	
	//if i_dr is in bounds
	mov	x1,		1
	scvtf	d2,		x1
	fadd	i_dr,		i_dr,		d2
	scvtf	d2,		row_r
	fcmp	i_dr,		d2
	b.lt	step2
	fmov	d0,		score_dr
	fmov	d1,		bomb_dr
	fmov	d2,		range_dr
	fmov	d3,		lives_dr
	b	ender
ender:
	load_x()
	ldp	x29,		x30,		[sp], 96
	ret
//=========================================================getRange subroutine=================================================
//takes in inital position where bomb is being dropped
//gets the radius of the bomb depending on the double range powerup
//error checks the radius and updates it accordingly
//bomb radius is returned
init_subr_x()
getRange:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp
	store_x()
	//initalizing variables 
	mov	sR_r,		x0
	mov	sC_r,		x1
	mov	eR_r,		x2
	mov	eC_r,		x3
	mov	row_r,		x4
	mov	col_r,		x5
	fmov	range_dr,	d0

	
	//finding start point x
	ldr	temp_r,		=xCoor
	ldr	x1,		[temp_r]
	fcvtns	x2,		range_dr
	mov	x3,		1
	lsl	x3,		x3,		x2
	
	sub	x1,		x1,		x3
	mov	sR_r,		x1
	//checking start point x
	cmp	sR_r,		0				//chceking xS
	b.lt	rangeLess1
	b	checkStartY

rangeLess1:							//xCoor is less than 0
	mov	sR_r,		xzr				//set to 0
	
checkStartY:
	//finding start point y
	ldr	temp_r,		=yCoor
	ldr	x1,		[temp_r]
	fcvtns	x2,		range_dr
	mov	x3,		1	
	lsl	x3,		x3,		x2

	sub	x1,		x1,		x3
	mov	sC_r,		x1
	//checking start point y
	cmp	sC_r,		0				//checking yS
	b.lt	rangeLess2
	b	findEndX

rangeLess2:							//yCoor is less than 0
	mov	sC_r,		xzr				//set to 0

findEndX:	
	//finding end point x
	ldr	temp_r,		=xCoor
	ldr	x1,		[temp_r]
	fcvtns	x2,		range_dr
	mov	x3,		1
	lsl	x3,		x3,		x2

	add	x1,		x1,		x3
	mov	eR_r,		x1
	//checking end point x
	sub	x1,		row_r,		1
	cmp	eR_r,		x1
	b.gt	rangeMore1
	b	checkEndY

rangeMore1:							//xCoor > row_r
	sub	x1,		row_r,		1	
	mov	eR_r,		x1				//set to row_r-1
	
checkEndY:							//finding end y Coor
	ldr	temp_r,		=yCoor
	ldr	x1,		[temp_r]
	fcvtns	x2,		range_dr
	mov	x3,		1
	lsl	x3,		x3,		x2

	add	x1,		x1,		x3
	mov	eC_r,		x1
	//checking end point y
	sub	x1,		col_r,		1
	cmp	eC_r,		x1
	b.gt	rangeMore2					//yCoor > col
	b	end

rangeMore2:							//if yCoor > col
	sub	x1,		col_r,		1	
	mov	eC_r,		x1				//set to col_r -1
	

end:
	//returing variables
	mov	x0,		sR_r
	mov	x1,		sC_r
	mov	x2,		eR_r
	mov	x3,		eC_r
	load_x()
	ldp	x29,		x30,		[sp], 96
	ret

//==========================================================display subroutine==================================================
//when the game starts this funtions dispalys the inital board and score and lives and bomb
init_subr_x()
define(i_r,x21)
define(j_r,x23)
display:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp
	store_x()
	
	//initalizing the variables
	mov	row_r,		x0
	mov	col_r,		x1
	mov	offset1_r,	x2
	mov	stackPoint_r,	x3
	mov	i_r,		xzr
	mov	j_r,		xzr

printBoard:
	ldr	temp_r,		=X				//loadin asciz value of x into temp
	str	temp_r,		[stackPoint_r,offset1_r]	//storing x in array
	ldr	temp_r,		[stackPoint_r,offset1_r]	//loading x from array
	
	//printing x
	ldr	x0,		=output2
	mov	x1,		temp_r
	bl	printf
	
	//incrememnting offet and j_r
	add	offset1_r,	offset1_r,	8
	add	j_r,		j_r,		1
	
	//checking to see if counter is in bound
	cmp	j_r,		col_r
	b.lt	printBoard
	
	//if not in bounds
	mov	j_r,		xzr				//resetting counter
	ldr	x0,		=newLine			//prints new line
	bl	printf
	add	i_r,		i_r,		1		
	cmp	i_r,		row_r
	b.lt	printBoard
	
	//print statments
	ldr	x0,		=L
	bl	printf
	
	ldr	x0,		=S
	bl	printf

	//number of bombs is 10% of total board	
	mul	x10,		row_r,		col_r
	mov	x2,		10
	mul	x10,		x10,		x2
	mov	x2,		100
	udiv	x10,		x10,		x2
	//prinitng inital bomb
	ldr	x0,		=B
	mov	x1,		x10	
	bl	printf
	
exit3:
	load_x()
	ldp	x29,		x30,		[sp], 96
	ret

//============================================================InitalizeGame subroutine============================================
//this function populates the board and displays it to the user(marker board)
//call randomNum which is in other file to get the randomNum
//checks ratio of negs, poss, and powerups
init_subr_x()
define(totalNeg_r,x21)
define(compareRand_r,x11)
define(exitCount_r,d15)
define(negCounter_r,x23)
define(specialCount_dr,d11)
define(totalSpecial_r,x27)
initalizeGame:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp

	store_x()

	//initalizing variables
	mov	row_r,		x0
	mov	col_r,		x1
	mov	offset_r,	x2
	mov	x25,		x3
	mov	x26,		x4
	mov	stackPoint_r,	x5				
	mov	temp_r,		xzr
	mov	negCounter_r,	xzr
	//initalinig special counter
	mov	x1,		1
	scvtf	specialCount_dr,x1
	
	//total negative numbers 
	mul	totalNeg_r,	row_r,		col_r
	mov	x1,		55					
	mul 	totalNeg_r,	totalNeg_r,	x1
	mov	x2,		100
	udiv	totalNeg_r,	totalNeg_r,	x2

	//total power ups
	mul	totalSpecial_r,	row_r,		col_r
	mov	x1,		20
	mul	totalSpecial_r,	totalSpecial_r,	x1
	mov	x2,		100
	udiv	totalSpecial_r,	totalSpecial_r,	x2
	
	mov	x0,		0				//setting variable
	scvtf	exitCount_r,	x0				//converting to float
	
		
loop:								//start of loop
	
generate:
	//genertaing randNum for flag
	bl 	rand
	mov	compareRand_r,	x0
	and 	compareRand_r,	compareRand_r,		0x7	//generated randNum 0 - 3
	
	cmp	compareRand_r,	0				//if randNum = 0
	b.eq	negative					//go to negative
	
	cmp	compareRand_r,	1				//if randNum = 1
	b.eq	positive					//go to positive
					
	cmp	compareRand_r,	2				//if randNum = 2	
	b.eq	special						//go to special
	
	cmp	compareRand_r,	3
	b.eq	makeExitKey
	
	cmp	compareRand_r,	4
	b.eq	special2
	
	cmp	compareRand_r,	5
	b.eq	special3
	b	generate

decreaseNeg:							//this decreases number of negs if needed
	sub	negCounter_r,	negCounter_r,		1
	b	positive					//go to positive

decreaseSpec:							//this decreases number of power ups if needed
	mov	x1,		1
	scvtf	d1,		x1
	fsub	specialCount_dr,specialCount_dr,	d1
	b	positive
	
makeExitKey:
	//converting to float
	mov	x1,		1
	scvtf	d1,		x1
	
	fadd	exitCount_r,	exitCount_r,		d1	//increment counter
	fcmp	exitCount_r,	d1				//counter shouldnt be more than 1
	b.ne	generate
	mov	temp_r,		3				//setting the flag
	//sending in parameters
	fmov	d0,		d1
	mov	x0,		temp_r
	bl	randomNum
	fmov	d1,		d0
	b	storeArray

special2:
	mov	x1,		1
	scvtf	d1,		x1
	fadd	specialCount_dr,specialCount_dr,	d1	//increment counter
	mov	x1,		totalSpecial_r
	scvtf	d1,		x1
	fcmp	specialCount_dr,d1				//if counter = total special charcters
	b.gt	decreaseSpec					//decrease counter
	mov	temp_r,		4				//set flag
	//sending in parameters to random
	fmov	d0,		d1
	mov	x0,		temp_r
	bl	randomNum
	fmov	d1,		d0
	b	storeArray

special3:
	mov	x1,		1
	scvtf	d1,		x1
	fadd	specialCount_dr,specialCount_dr,	d1	//increment counter
	mov	x1,		totalSpecial_r
	scvtf	d1,		x1
	fcmp	specialCount_dr,d1			//if counter = total special charcters
	b.gt	decreaseSpec					//decrease counter
	mov	temp_r,		5				//set flag
	//sending in parameters to random
	fmov	d0,		d1
	mov	x0,		temp_r
	bl	randomNum
	fmov	d1,		d0
	b	storeArray

special:							//calling random for power up
	mov	x1,		1
	scvtf	d1,		x1
	fadd	specialCount_dr,specialCount_dr,	d1	//increment counter
	mov	x1,		totalSpecial_r
	scvtf	d1,		x1
	fcmp	specialCount_dr,d1				//if counter = total special charcters
	b.gt	decreaseSpec					//decrease counter
	mov	temp_r,		2				//set flag
	//sending in parameters to random
	fmov	d0,		d1
	mov	x0,		temp_r
	bl	randomNum
	fmov	d1,		d0
	b	storeArray
	
negative:							//generates negative
	add	negCounter_r,	negCounter_r,		1	//increment counter
	cmp	negCounter_r,	totalNeg_r			//cmp with max number of powerups
	b.gt	decreaseNeg					//decrease counter
	mov	temp_r,		0				//flag set to 0
	//sending in parameters to random
	fmov	d0,		d1
	mov	x0,		temp_r
	bl	randomNum						//calling random function
	fmov	d1,		d0				//returning the temp_r from random
	b	storeArray

positive:							//generates positive
	mov	temp_r,		1				//setting flag
	//sending in parameters
	fmov	d0,		d1
	mov	x0,		temp_r
	bl	randomNum
	fmov	d1,		d0
	b	storeArray
	

	//storing random numbers in stack
storeArray:
	str	d1,		[stackPoint_r,offset_r]		//storing randNum into stack 
	ldr	d1,		[stackPoint_r,offset_r]
	add	offset_r,	offset_r,	8		//increment offset_r by 8
	add	x25,		x25,		1		//increment j_r by 1
	
	//converting values to float
	mov	x1,		65
	mov	x2,		66
	mov	x3,		67
	mov	x4,		68
	scvtf	d2,		x1
	scvtf	d3,		x2
	scvtf	d4,		x3
	scvtf	d5,		x4
	
	fcmp	d1,		d4
	b.eq	printSpecial2
	fcmp	d1,		d5
	b.eq	printSpecial3
	fcmp	d1,		d2				//seeing if number is equal to powerup
	b.eq	printSpecial
	fcmp	d1,		d3				//seeing if number is equal to exit
	b.eq	printExit
	//if none just print the number
	ldr	x0,		=output
	fmov	d0,		d1
	bl	printf
	b	test2

printExit:							//this prints a star
	ldr	x0,		=exiting
	bl	printf
	b	test2

printSpecial2:
	ldr	x0,		=power2
	bl	printf
	b	test2	

printSpecial3:
	ldr	x0,		=power3
	bl	printf
	b	test2	

printSpecial:							//this prints a $
	ldr	x0,		=power1
	bl	printf
	b	test2						//go to test2


test1:								//test1
	cmp	x25,		col_r				//cmp j_r with col_r
	b.lt	loop						//if less than go to loop
	add	x26,		x26,		1		//increment i_r by 1
	mov	x25,		xzr				//j_r = xzr
	ldr	x0,		=newLine
	bl	printf


test2:								//test2
	cmp	x26,		row_r				//cmp i_r with row_r
	b.lt	test1						//if less than go to test1

	//getting max array size
	mov	x12,		xzr
	mul	x12,		row_r,		col_r		//get max array size
	
	//converting negCounter_r and max array size to float
	scvtf	d2,		negCounter_r			//number of negs converted to float
	scvtf	d12,		x12				//max array size converted to float
			
	//getting percent of negative
	fdiv	d13,		d2,		d12
	mov	x0,		100
	scvtf	d14,		x0
	fmul	d13,		d13,		d14

	//displaying total neg to user
	ldr	x0,		=outputNegs
	mov	x1,		negCounter_r			//counter as input
	mov	x2,		x12				//total array size as input
	fmov	d0,		d13				//% of negs a input
	bl	printf
	
	mul	x12,		row_r,		col_r		//max array size	

	//converting special conter and max array size to float
	fmov	d15,		specialCount_dr
	scvtf	d12,		x12
	
	//calcualting percent of power ups
	fdiv	d13,		d15,		d12
	fmul	d13,		d13,		d14

	//displaying total power up to user
	ldr	x0,		=outputSpec	
	fmov	d0,		specialCount_dr
	mov	x1,		x12
	fmov	d1,		d13
	bl	printf
	
	//game has been started text
	ldr	x0,		=gameStarted
	bl	printf

	//loading back all the variables
	load_x()	
	ldp	x29,		x30,		[sp], 96
	ret

//============================================================Error Checking======================================================

invaildArgs:
	ldr	x0,		=error1
	bl	printf
	b	exit

checkRow:							//checkRow
	ldr	x0,		=error2				//load error1 into x0
	bl	printf						//calling printf from c
	b	exit
	
checkCol:							//checkCol
	ldr	x0,		=error3				//load error2 into x0
	bl	printf						//calling printf from c
	b	exit
	
outOfRange:
	ldr	x0,		=error4
	bl	printf
	b	reallocate

	//data section for input
	.data
	xCoor:		.dword 0
	yCoor:		.dword 0
	exitFlag:	.dword 0
