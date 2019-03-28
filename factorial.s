.data
numformatout: .asciz "%ld\n"
numformatin: .asciz "%ld"
error_message: .asciz "Cannot calculate the factorial of a number equal to or less than 0! Program exiting\n"


.global main


main:
  movq  %rsp, %rbp          # initialize stack

  call  get_input           # Call the subroutine to scan user's input
  push  %rax                # return value is the scanned number to rax (parameter) 

  cmp   $0, %rax            # compare the given value to 0
  jle   end_with_error      # ump to subroutine if given number is 0 or less

  call  factorial           # Call factorial

  call  print_out           # Call the print function
  
  call  end_app             # terminate the program



end_with_error:

  movq  $0, %rax            # No victor args  
  movq  $error_message, %rdi# rmove addr of the error message t=int o rdi for printing
  call  printf              # call the printf function from c
  call  end_app             # end the app

print_out:
  push  %rbp
  movq  %rsp, %rbp 

  movq  %rax, %rsi          # rax is the return from the factorial
  movq  $0, %rax            # No victor args  
  movq  $numformatout, %rdi # The output fomrat
  call  printf              # call the printf function from c

  movq  %rbp, %rsp
  pop   %rbp 
  ret

get_input:
  push  %rbp
  movq  %rsp, %rbp 

  subq  $8, %rsp            # allocate space for the to be scanned number
  leaq  (%rsp), %rsi        # load the memory address onto the rsi to use it
  movq  $numformatin, %rdi  # use the fomratin
  movq  $0, %rax            # no victor args
  call  scanf               # call scanf from c
  pop   %rax

  movq  %rbp, %rsp
  pop   %rbp 
  ret


end_app:
  movq  $0, %rdi            # exit code 0
  call  exit                # call exit

factorial:
  
  # saving the stack state
  push  %rbp
  movq  %rsp, %rbp 
  movq  16(%rbp), %rbx

  # if equal to one => Base case == 1 

  cmp   $1, %rbx
  je    base_factorial

  # else recursive call it

  dec   %rbx
  push  %rbx        # for next call to factorial
  call  factorial

  # after it is done
  add   $8, %rsp 
  movq  16(%rbp), %rbx 
  imul  %rbx, %rax

  jmp   end_factorial


base_factorial:
  movq  $1, %rax

end_factorial:
  movq  %rbp, %rsp
  pop   %rbp 
  ret

