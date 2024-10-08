.align 2
.extern saveThreadContext
.globl saveThreadContext
.text
saveThreadContext:
 mflr 0
 stw 0, 0(3)
 stw 1, 4(3)
 stmw 13, 8(3)
 lil 3, 17
 br
.align 2
.extern .startNewThread
.globl .startNewThread
.text
startNewThread:
 .set linkarea, 32
 addic 1, 4, -linkarea
 mtlr 3
 brl
.align 2
.extern returnToThread
.globl returnToThread
.text
returnToThread:
 lmw 13, 8(3)
 lwz 1, 4(3)
 lwz 0, 0(3)
 mtlr 0
 lil 3, 0
 br
.align 2
.extern stackPointer
.globl stackPointer
.text
.set SP,1
.set BO_ALWAYS,20
.set r0,0
.set r3,3
.set CR0_LT,0
stackPointer:
 stwu SP, -64(SP)
 lwz r3, 0(SP)
 stw r3, 56(SP)
 addi SP, SP, 64
 bcr BO_ALWAYS, CR0_LT
