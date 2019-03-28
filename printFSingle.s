.data
numformatout: .asciz "%d\n"
numformatin: .asciz "%d"


.global main

main:
    
    movq    %rsp, %rbp

    subq    $16, %rsp           # allocate space for the to be scanned numbers
    leaq    (%rsp), %rsi        # load the memory address onto the rsi to use it
    movq    $numformatin, %rdi  # use the 
    movq    $0, %rax            # no victor args
    call    scanf               # call scanf from c

    leaq    8(%rsp), %rsi      # load the memory address onto the rsi to use it
    movq    $numformatin, %rdi  # use the fomratin
    movq    $0, %rax            # no victor args
    call    scanf               # call scanf from c

    pop     %r8                 
    pop     %r9


    movq    %r8, %r10
    movq    $1, %r11

pow:
    inc     %r11
    imul    %r10, %r8           # r8 = r8 * r10
    cmp     %r11, %r9
    je      end
    jmp     pow

end:
    movq    $0, %rax        # No victor args
    movq    %r8, %rsi      # first arg
    movq    $numformatout, %rdi
    call    printf          # call the printf function from c
    movq    $0, %rdi         # exit code 0
    call    exit             # call exit
