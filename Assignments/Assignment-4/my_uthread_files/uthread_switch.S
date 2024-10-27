	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	/* First parameter in a0, second is in a1, stack pointer reg is sp  */
	/* Saving all of the saved registers from the current_thread*/
	addi sp, sp, -104 /* Moving the stack pointer to give it space */
	sd sp, 0(a0)
	sd ra, 8(sp)	
	sd s0, 16(sp)	
	sd s1, 24(sp)
	sd s2, 32(sp)
	sd s3, 40(sp)
	sd s4, 48(sp)
	sd s5, 56(sp)
	sd s6, 64(sp)
	sd s7, 72(sp)
	sd s8, 80(sp)
	sd s9, 88(sp)
	sd s10, 96(sp)
	sd s11, 104(sp)
	
	ld sp, 0(a1) /* store next one */
	ld ra, 8(sp)
	ld s0, 16(sp)
	ld s1, 24(sp)
	ld s2, 32(sp)
	ld s3, 40(sp)
	ld s4, 48(sp)
	ld s5, 56(sp)
	ld s6, 64(sp)
	ld s7, 72(sp)
	ld s8, 80(sp)
	ld s9, 88(sp)
	ld s10, 96(sp)
	ld s11, 104(sp)
	
	addi sp, sp, 104 /* Adding the stack pointer back */
	ret    /* return to ra */
