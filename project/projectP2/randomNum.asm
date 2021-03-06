//randomNum.asm
//second file for the make file
	.text
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



	.balign 4
	.global randomNum



//this funtion returns a random number
//takes in a flag and generates a number accordingly
init_subr_x()
define(first_r,x9)
randomNum:
	stp	x29,		x30,		[sp,-(16+80) & -16]!
	mov	x29,		sp
	store_x()
	
	mov	x0,		temp_r				//taking in first argument
	fmov	d1,		d0				//taking in argument
	bl	rand						//calling rand from c
	mov	x13,		x0				//rand stored in x13
	
	
	and	first_r,	x13,		0xF		//getting the whole number x13 and 15
	scvtf	d8,		first_r				//converting to float
	scvtf	d13,		x13				//conver to float

	mov	x7,		2147483647			//this is value for rand_MAX
	scvtf	d9,		x7				//convert to float
	
	fdiv	d10,		d13,		d9		//getting decimal value
	
	fadd	d1,		d8,		d10		//adding decimal and whole number
	
	cmp	temp_r,		0				//if flag is 0
	b.eq	makeNeg						//go to makeNeg
	
	cmp	temp_r,		1				//if flag is 1
	b.eq	makePos						//go to makePos
	
	cmp	temp_r,		2				//if flag is 2
	b.eq	makeSpecial					//go to makeSpecial

	cmp	temp_r,		3
	b.eq	makeExit
	
	cmp	temp_r,		4
	b.eq	makeSpecial2
	
	cmp	temp_r,		5
	b.eq	makeSpecial3

makeSpecial2:
	mov	x10,		67				//set x10 to 65
	scvtf	d1,		x10				//convert to float 		
	fmov	d0,		d1				//return value
	b	exit1		

makeSpecial3:
	mov	x10,		68				//set x10 to 65
	scvtf	d1,		x10				//convert to float 		
	fmov	d0,		d1				//return value
	b	exit1		

makeExit:
	mov	x10,		66
	scvtf	d1,		x10
	fmov	d0,		d1
	b	exit1

makeSpecial:							//changes value to special value which is 65
	mov	x10,		65				//set x10 to 65
	scvtf	d1,		x10				//convert to float 		
	fmov	d0,		d1				//return value
	b	exit1		

makePos:							//makes number positive
	fmov	d0,		d1				//return value
	b	exit1

makeNeg:							//makes number negative
	fneg	d1,		d1				//d1 = -d1
	fmov	d0,		d1				//return value
	b 	exit1		

exit1:
	load_x()
	ldp	x29,		x30,		[sp], 96
	ret
