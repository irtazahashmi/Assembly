.data

format: .asciz "%d\n%s %d%%"

str: .asciz "biatch%%\n"

str2: .asciz "damnboi"

num: .quad -30





.text



#macro to initialize stack frame

.macro isf

push %rbp

movq %rsp, %rbp

.endm



#macro to clear stack frame

.macro csf

movq %rbp, %rsp

pop %rbp

.endm





.global main



main:

#initialize stack frame

isf



movq num, %rcx

movq $str, %rdx

movq num, %rsi #

movq $format, %rdi #first arg- format

call printff



#clear stack frame

csf

end:

movq $0, %rdi

call exit





printff:

popq %rax #pop the ret address into rax

#push the args to the stack in reverse order so that we can pop them in correct order

push %r9

push %r8

push %rcx

push %rdx

push %rsi

push %rax #push the ret address onto the stack

isf #initialize stack frame

movq $16, %r12 #which arg to use



movq %rdi, %r10





start:

#check for '\0'

cmpb $0, (%r10) #compare the current byte with '\0'

je print_end



#check for '%'

cmpb $0x25, (%r10) #25 is ascii hex for '%'

je format_specifier



next:

movq $1, %rax #syscall 1, ie sys_write

movq $1, %rdi # write to 1, ie stdout

movq %r10, %rsi

movq $1, %rdx # write 1 byte

syscall



addq $1, %r10

jmp start



format_specifier:

addq $1, %r10 #move rdi to next byte



cmpb $'%' , (%r10)

je next



cmpb $'s', (%r10)

je print_s



cmpb $'d', (%r10)

je print_d



cmpb $'u', (%r10)

je print_u



subq $1, %r10

jmp next #if there is nothing valid(d,u,s,%) after '%' then print that



print_end:

#clear stack frame

csf

ret







#print a string

print_s:



movq (%rbp, %r12), %rsi #move the arg which is r12 below rbp, into rsi

addq $8, %r12 #add 8 to r12 so that the next arg is used from now

loop1:

cmpb $0, (%rsi) #check for null-char, compare byte

je loop1end

#print a char

movq $1, %rax #syscall 1 is sys_write

movq $1, %rdi #where to write- 1 ie, stdout

#what to write- already in rsi

movq $1, %rdx #num of bytes to write- 1

syscall

incq %rsi #move to next char

jmp loop1 #continue printing

loop1end:

addq $1, %r10

jmp start;





#printing a signed integer

print_d:

movq (%rbp, %r12), %rax #move the current arg into rax

addq $8, %r12 #so that next arg is used from now

cmpq $0, %rax

jl print_d_neg_num

print_d_pos_num:

call convert_num

jmp print_num



print_d_neg_num:

movq $-1, %rbx

imulq %rbx

call convert_num

pushq $'-'

jmp print_num





#print unsigned integers

print_u:

movq (%rbp, %r12), %rax #move the current arg into rax

addq $8, %r12 #so that next arg is used from now

call convert_num

jmp print_num





convert_num:

isf #initialize a new stackframe

movq $10, %rcx #when dividing the num by 10, num%10 is stored in rdx

loop2:

subq %rdx, %rdx #clear rdx

divq %rcx #the quotient is stored in %rax, the remainder is stored in %rdx

addq $0x30, %rdx #add 30hex to the value, so if it is 2 then it becomes 32hex because 32hex is ascii value for '2'

push %rdx

cmp $0, %rax

jne loop2 #continue the loop till all digits have been converted to chars

jmp *8(%rbp) #jump to the address saved by call



print_num:

#syscall(1, 1, %rsp, 1) ---> 1:write, 1:stdout, %rsp, 1: 1 byte

movq $1, %rax #sys_write

movq $1, %rdi #to stdout

movq $1, %rdx #1 byte

loop3:

movq %rsp, %rsi #print the value on top of the stack

addq $8, %rsp #move the stack pointer to the next value

syscall

cmp %rsp, %rbp

jne loop3 #if rsp and rbp are not equal continue printing

csf #clear stack frame

popq %rax



addq $1, %r10 #move to next char

jmp start
