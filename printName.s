
.data
jiname: .asciz "Name: Ji Darwish\nNetID: jdarwish\n"
irtaza: .asciz "Name: Irtaza Hashmi\nNetID: ihashmi \nAssignment: 0\n"
formatin: .asciz "%d"
formatout: .asciz "%d\n"


.global main

main:

  movq  $0, %rax        # No victor args
  movq  $jiname, %rdi   # first arg
  call  printf          # call the printf function from c
  pop   %rdx            # remove the call from the stack
  movq  $irtaza, %rdi   # print arg
  call  printf          # call print
  pop   %rdx            # remove call from stack

  call  inout           # call the inoput subroutine
  call   end


inout:
  push  %rbp            # save the location of the pointer on the stack
  movq  %rsp, %rbp      # put stack pointer's address in base pointer

  subq  $8, %rsp        # allocate space for the to be scanned number
  leaq  -8(%rbp), %rsi  # load the memory address onto the rsi to use it
  movq  $formatin, %rdi # use the fomratin
  movq  $0, %rax        # no victor args
  call scanf            # call scanf from c

  pop %rsi              # pop the call of scanf
  
  addq  $1, %rsi        # increment the number

  movq  $0, %rax        # no vector arguments
  movq  $formatout, %rdi# use the format to print it out
  call  printf          # call printf from c

  movq  %rbp, %rsp      # return the rsp to the state before the call
  pop   %rbp            # return the rbp to the state before the call


end:
  movq $0, %rdi         # exit code 0
  call exit             # call exit
