.model small
.stack 100h

.data
menu_msg db '1. Admin', 13, 10, 
        db '2. Student', 13, 10,'$'
welcome_Admin_msg db 'Welcome Admin', 13, 10, '$'
admin_menu_msg db '1. Add Student', 13, 10,
        db '2. Add Book', 13, 10,
        db '3. Delete Student', 13, 10,
        db '4. Delete Book', 13, 10,
        db '5. Display all books', 13, 10, '$'
welcome_Student_msg db 'Welcome Student', 13, 10, '$'
Student_menu_msg db '1. Read Book', 13, 10,
        db '2. Borrow Book', 13, 10,
        db '3. Return Book', 13, 10,
        db '4. Display all Books', 13, 10, '$'
get_choice_msg db 'Select option: $' 
get_ID_msg db 'User_ID: $'
get_BID_msg db 'Book_ID: $'
get_username_msg db 'Username: $'
get_bookName_msg db 'Book Name: $'
get_password_msg db 'Password: $'
get_book_file_path_msg db 'File Path (fileName + ".txt"): $'
id_name_author_msg db '===== BID|Book Name| =====', 13, 10 ,'$'

cant_do_this_msg db 'You Cant Do This (invalid data)', 13, 10 ,'$'
invalid_data_msg db 'Wrong ID OR Username OR Password', 13, 10, '$'
Error_already_exist db 'The Record Is Already Exist',  13, 10, '$'
Error_it_not_exist db 'The Record Is Not Exist',  13, 10, '$'

done_msg db 'done', 13, 10 ,'$'
crlf db 13,10,'$'

Standard_input_msg dw get_ID_msg, get_username_msg, get_password_msg, 0
Books_input_msg dw get_BID_msg, get_bookName_msg, 0
Read_TXT_input_msg dw get_book_file_path_msg, 0
BR_Books_input_msg dw get_ID_msg, get_BID_msg, 0

admins_file db 'admins.txt',0
students_file db 'students.txt',0
books_file db 'books.txt',0
transactions_file db 'transactions.txt',0
handle   dw ? 

Record_buffer db 60 dup(?)
Record_length   dw ?
one_char db ?
line_buffer db 60 dup(?)
line_length dw ?
CX_start_of_line_in_file dw ?
DX_start_of_line_in_file dw ? 
dummy_buffer db 60 dup(?)
dummy_length dw ?

.code 
main proc
  mov ax, @data
  mov ds, ax
  main_menu:; menu admin or student 
    call nl
    lea dx, menu_msg
    call print_string
    lea dx, get_choice_msg
    call print_string      
    call cin
    cmp al, '1'
      je admin
    cmp al, '2'
      je student
    jmp exit_program
    admin:
      ;=========================== verify admin ==============================
      ;open admins file
      call nl
      lea dx, admins_file 
      mov si, offset Standard_input_msg
      call verify; al == 1 if found al == 0 if not 
      cmp al, 0 
        je sus_user
      call kill_file   
      welcome_Admin:
        ;========================= Admin Welcome menu ===================================
        lea dx, welcome_Admin_msg
        call print_string 
        lea dx, admin_menu_msg
        call print_string
        lea dx, get_choice_msg
        call print_string
        call cin
        cmp al, '1'
          je add_student
        cmp al, '2'
          je add_book
        cmp al, '3'
          je delete_student
        cmp al, '4'
          je delete_book
        cmp al, '5'
          je display_all_books
      jmp exit_program
      add_student: ;add student
        call nl
        ;================================ add student =================================
        ;get the new record data 
        lea dx, students_file
        mov si, offset Standard_input_msg
        call verify; al == 1 if found al == 0 if not 
        cmp al, 1
          je invalid_it_exist
        call nl
        lea dx, students_file
        call append_record_to_file
      jmp welcome_Admin
      add_book: ;add book
        call nl
        ;================================= add book =================================== 
        ;get the new record data 
        lea dx, books_file
        mov si, offset Books_input_msg
        call verify; al == 1 if found al == 0 if not 
        cmp al, 1
          je invalid_it_exist
        call nl
        lea dx, books_file
        call append_record_to_file
      jmp welcome_Admin
      delete_student: ;delete student
        call nl
        ;================================= delete student =================================== 
        lea dx, students_file
        mov si, offset Standard_input_msg 
        call verify ; al == 1 if found al == 0 if not 
        cmp al, 0 
          je invalid_it_not_exist
        call dummy_builder  
        lea dx, students_file
        call replace_record_in_file 
      jmp welcome_Admin
      ;delete book
      delete_book: ;delete book
        call nl
        ;================================= delete book =================================== 
        lea dx, books_file 
        mov si, offset Books_input_msg
        call verify ; al == 1 if found al == 0 if not 
        cmp al, 0 
          je invalid_it_not_exist
        call dummy_builder  
        lea dx, books_file
        call replace_record_in_file 
      jmp welcome_Admin
      ;display all books
      display_all_books:
        call nl
        ;================================= display books =================================== 
        lea dx, id_name_author_msg
        call print_string
        lea dx, books_file ;prepare the file to scan
        call print_exist_records
      jmp welcome_Admin
      ;view logs(all actions)
    student:
      call nl
      ;============================== verify student ================================
      ;open students file
      lea dx, students_file 
      mov si, offset Standard_input_msg
      call verify ; al == 1 if found al == 0 if not 
      cmp al, 0 
        je sus_user
      call kill_file   
      welcome_Student:;view welcome message
      call nl
      ;========================= Admin Welcome menu =================================
      lea dx, welcome_Student_msg
      call print_string 
      lea dx, Student_menu_msg
      call print_string
      lea dx, get_choice_msg
      call print_string
      call cin
      cmp al, '1'
        je read_book
      cmp al, '2'
        je borrow_book
      cmp al, '3'
        je return_book
      cmp al, '4'
        je S_display_all_books
      jmp exit_program
      read_book:
        call nl
        ;================ read book (get the name and show him the file) ==============
        lea dx, get_book_file_path_msg
        call print_string
        
        call rest_record_input
        lea di, Record_buffer
        call read_file_name
        call nl

        ; mov ah, 3Dh       
        ; mov al, 2         
        ; int 21h 
        ;   jc did_it_before

        lea dx, Record_buffer;prepare the file to scan
        call print_exist_records
      
      borrow_book:;borrow book 
        call nl
        ;===================== borrow book (add to transaction) =================
        lea dx, transactions_file
        mov si, offset BR_Books_input_msg
        call verify
        mov cx, -1
        cmp al, 1
          je invalid_it_exist
        lea dx, transactions_file
        call append_record_to_file
      jmp welcome_Student
      
      return_book:;return book
        call nl
        ;===================== return book (add to transaction) =================
        lea dx, transactions_file
        mov si, offset BR_Books_input_msg
        call verify
        mov cx, -1
        cmp al, 0
          je invalid_it_not_exist
        call dummy_builder  
        lea dx, transactions_file
        call replace_record_in_file 
      jmp welcome_Student
      S_display_all_books:;display all books
        call nl
        ;================================= display books =================================== 
        lea dx, id_name_author_msg
        call print_string
        lea dx, books_file ;prepare the file to scan
        call print_exist_records
      jmp welcome_Student

  invalid_it_exist: 
    lea dx, Error_already_exist
    call print_string
    call kill_file
    cmp cx, -1
      je welcome_Student
  jmp welcome_Admin
  invalid_it_not_exist: 
    lea dx, Error_it_not_exist
    call print_string
    call kill_file
    cmp cx, -1
      je welcome_Student
  jmp welcome_Admin
  did_it_before:
    lea dx, cant_do_this_msg
    call print_string
  jmp welcome_Student
  sus_user:
    lea dx, invalid_data_msg
    call print_string
    jmp main_menu
  exit_program :
    mov ah, 4Ch       ; terminate program
    int 21h  

main endp
;=========================================================================
;=========================== verify user ==============================
; make sure to move the file name to dx before calling "verify"
; make sure to move the wanted input_msg to si
; the input will be saved in Record_buffer
; the output in AL 1 for verified 0 for not verified
verify proc
  call open_file
  mov handle, ax 
  call read_multiple_input  
  ;search for the same record
  call search_file_for_record
  ; al == 1 if found al == 0 if not 
  ret
verify endp

;==================== open the file (file name in DX) even if not created =====================;
; how to use open_file 
; load the file name to dx
; AX will be storing the file_handle when you create it so move the AX to the handle 
open_file proc      
  mov ah, 3Dh       ; open file
  mov al, 2         ; read/write
  int 21h 
    jc just_create_it ; the carry flag will trigger if you can't open it
  ret    
  just_create_it:
    mov ah, 3Ch     ; create file
    mov cx, 0       ; normal file (not readonly or hidden)
    int 21h
    ret
open_file endp
;==================== close the file (file handle in handle)  =====================;
; how to use close_file 
; AX will be storing the file_handle when you create it so move the AX to the handle 
kill_file proc
  mov ah, 3Eh      ; close file
  mov bx, handle
  int 21h
  ret
kill_file endp
;=======================================================================
;====================== print exist record in file =====================
; load you file name in dx
print_exist_records proc
  call open_file
  mov handle, ax
  scan_lines_loop:
    call read_line_in_file
    mov al, [line_buffer]
    cmp line_length, 0 ; reach the EOF
      je do_me
    cmp al, '-'        ; deleted record
      je scan_lines_loop
    lea si, line_buffer; print the line
    mov cx, line_length
    call print_record
    call nl
  jmp scan_lines_loop
  do_me:
    call kill_file
print_exist_records endp
;================================================================================================;
;============================= Compare String ===================================================;
; how to use compare_lines; compare 2 strings si , di
; set di and si on your strings you want to compare
; the result will be in AL 1 if both are same or 0 if both are diff 
compare_lines proc 
  while_switch_loop:
    mov al, [si]     ; 2 pointers compare 
    mov bl, [di]
    inc si
    inc di
    cmp al, bl
      jne case2
    cmp al, bl
      je case1
    case1: 
      cmp al, 10
        jne while_switch_loop  
      mov al, 1 
      ret
    case2: 
      mov al, 0
      ret
compare_lines endp
;=======================================================================
;============================ Search file ==============================
; how to use search_file_for_record (compare line in file with your target)
; you need to set record buffer&length (wanted target) a
; open your file and save your handle of your file in "handle"
; the output will be found in AL as 1 to found 0 to not found
search_file_for_record proc
  read_lines_loop:
    ; save file pointer position (start of this line)
    mov ah, 42h        ; Function 42h  (move file pointer)
    mov al, 1          ; use the current cursor position
    xor cx, cx
    xor dx, dx
    mov bx, handle
    int 21h
    ; save the file offset for later
    mov CX_start_of_line_in_file, dx 
    mov DX_start_of_line_in_file, ax

    call read_line_in_file
    cmp line_length, 0
      je return
    mov ax, line_length
    cmp ax, Record_length
      jne read_lines_loop

    lea si, Record_buffer
    lea di, line_buffer 
    call compare_lines 

    cmp al, 0
      je read_lines_loop
    return:

      ret
search_file_for_record endp
;===========================================================================
;======================= read line file ====================================
; how to use 
; make sure you did "open_file" and saved the file handle to your handle buffer  
read_line_in_file proc
  lea di, line_buffer
  mov line_length, 0
  read_char:
    mov ah, 3Fh     ; Read from file
    mov bx, handle  
    mov cx, 1       ; number of of byte you will read form the file
    lea dx, one_char; place holder
    int 21h

    cmp ax, 0
      je eof      

    mov al, one_char 
    mov [di], al 
    
    inc di
    inc line_length
    cmp al, 10          
      je line_done
    jmp read_char
    line_done:
      ret
    eof: ; end of the file no more lines
      mov line_length, 0    
      ret
read_line_in_file endp
;===========================================================================
;======================= rest record input =================================
; *************** important before getting any new record ***************** 
rest_record_input proc
  xor  cx, cx
  lea di, Record_buffer
  mov Record_length, 0
  ret
rest_record_input endp
;===========================================================================
;======================= read record input =================================
; make sure to use "rest_record" before use it for every record
; it will divide every record cell using "|" 
; make sure to use "close_record" after finish so you can save it in file safely
read_input_record proc
  xor cx, cx
  call read_string
  mov [di], '|'
  inc di
  inc cx
  add Record_length, cx
  ret
read_input_record endp
;===========================================================================
;======================= input file name =================================
; make sure to use "rest_record" before use it for every record
read_file_name proc
  xor cx, cx
  call read_string
  mov [di], 0
  inc di
  inc cx
  add Record_length, cx
  ret
read_file_name endp
;===========================================================================
;============================ read X string  =================================
; make user to mov the wanted input_msg to si
; the input will be saved in Record_buffer
read_multiple_input proc
  call rest_record_input
  print_array:
    mov bx, [si]
    cmp bx, 0
      je .done
    mov dx, bx
    call print_string
    call read_input_record
    call nl
    inc si
    inc si
  jmp print_array
  .done:
    call close_record_line
    call nl
  ret
read_multiple_input endp
;===========================================================================
;======================= close record input =================================
; *************** important after getting any new record ***************** 
close_record_line proc
  lea di, Record_buffer
  add di, Record_length
  mov [di], 13     ; cr
  inc di
  mov [di], 10     ; lf
  add Record_length, 2
  ret
close_record_line endp
;===========================================================================
;============================ read string  =================================
; how to use
; before you run make sure to initialize "lea di, your_container" 
; before you run make sure to rest CX "mov cx, 0" or "xor cx, cx (if you are crazy problem solver :! )" 
; input will stop with "ENTER" key
; after you run make sure to save the new length for that string form CX 
read_string proc ; read string until you press enter 
  rs:
    call cin
    cmp al, 0Dh
      je done
    cmp al, 08h        
      je handle_backspace
    mov [di], al
    inc di
    inc cx
    jmp rs
  handle_backspace:
    cmp cx, 0          ; if buffer is empty, ignore backspace
      je rs            
    mov dl, ' '        ; space to overwrite character
    call cout
    mov dl, 08h        
    call cout
    dec di
    dec cx
  jmp rs
  done:  
    ret
read_string endp
;===========================================================================
;======================= read character  ===================================
; how to use 
; just call it and the input will be saved in AL
cin proc ; read one character to the AL 
  mov ah, 01h
  int 21h
  ret
cin endp

;===============================================================================
;======================= write record to file  =================================
; make sure the you "lea dx, your_file" 
append_record_to_file proc
  call open_file
  mov handle, ax
  ; reset the file pointer to the end of the file
  mov ah, 42h    ; Function 42h  (move file pointer)
  mov al, 2      ; 2 = end of file
  xor cx, cx
  xor dx, dx   
  mov bx, handle  ; file handle
  int 21h         

  mov ah, 40h          ;write
  mov bx, handle        ;file
  lea dx, Record_buffer ;the new line
  mov cx, Record_length ;length of that line
  int 21h

  lea dx, done_msg
  call print_string
  call nl

  call kill_file
  ret
append_record_to_file endp
;===============================================================================
;======================= dummy_builder for record in file ======================
; before run make sure to save your record in "Record_buffer" to build the dummy from
; before run make sure to save your length in "Record_length" to build the dummy from
dummy_builder proc

  ; reset the dummy_buffer
  xor  cx, cx
  lea di, dummy_buffer
  mov dummy_length, 0

  ;fill the dummy buffer with the dummy value '-'
  lea di, dummy_buffer
  lea si, Record_buffer
  mov cx, Record_length
  mov dummy_length, cx 
  sub cx, 2           

  replace_loop:
    mov al, [si]
    cmp al, 13
      je dummy_close
    mov [di], '-'
    inc si
    inc di
  jmp replace_loop
  dummy_close:
    mov [di], 13
    inc di
    mov [di], 10
  ret
dummy_builder endp
;===============================================================================
;======================= Replace/Delete record to file =========================
; make sure the you "lea dx, your_file" before the run
; make sure to run "search_file_for_record" before the run
; construct the dummy replacement before the run
replace_record_in_file proc
  call open_file
  mov handle, ax
  ; reset the file pointer to the end of the file
  mov ah, 42h    ; Function 42h  (move file pointer)
  mov al, 0      ; 0 = start of the file 
  mov bx, handle  ; file handle
  mov cx, CX_start_of_line_in_file
  mov dx, DX_start_of_line_in_file   
  int 21h         

  mov ah, 40h          ;write
  mov bx, handle        ;file
  lea dx, dummy_buffer ;the new line
  mov cx, dummy_length ;length of that line
  int 21h

  lea dx, done_msg
  call print_string
  call nl

  call kill_file
  ret
replace_record_in_file endp

;==============================================================================
;============================== print string ==================================
;how to use 
; make sure to "lea dx, your_data"
print_string proc ; print a string from the DX
  mov ah, 09h
  int 21h
  ret
print_string endp

;==============================================================================
;=========================== print char =======================================
;how to use 
; make sure to "lea dx, your_data"
cout proc ; print one character from the DL
  mov ah, 02h
  int 21h
  ret
cout endp 
nl proc 
  ; print New line
  mov ah, 09h
  lea dx, crlf
  int 21h
  ret
nl endp   

;===============Debug functions==================;
;lea si, your_buffer
;mov cx, your_buffer_length
;call print_record
print_record proc
  print_loop:
    mov dl, [si]
    call cout
    inc si
  loop print_loop
  ret
print_record endp

end main