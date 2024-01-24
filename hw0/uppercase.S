        .section .data
input_string:   .asciz "Hello world!"
        #a rather complicate test case
#input_string:   .asciz "? ~not a]}usUal Case + haha$%&"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        
        .section .text
        .globl _start
_start:
        # Load the address of the input string into a0
        la a0, input_string
        li s2, 0
        li s4, 97
        li s5, 123
loop:
        lb a1, 0(a0)
        blt a1, s4, after 
        bge a1, s5, after
        addi a1, a1, -32
        sb a1, 0(a0)
after:
        addi a0, a0, 1
        bne a1, s2, loop
        j end_program
        # Your code here!
end_program:
        # jump here when you're done
        j end_program

