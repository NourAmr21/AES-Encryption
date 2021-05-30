Macro mixColumns ; mult2, mult3 and place (helpers)  
;push dx
;push ax
;push bx
;push cx 
;push si
;push di
    
local l1
local l2
local l3
local one
local two
local three
local end3
local endd   

mov si,0 
mov dl,0  
mov di,0 
mov cx,0 
mov bx,0  
mov col,si 
  ; 3 nested loops, we fix the first column and loop over all rows, when we are done with the first row we calculate the index where
  ; the xored result will be saved and inserted. then we loop over the rest of the rows with the same logic.
  ; when the counter "di" reaches 16 this means that we finished everything related to column 1>>>>> di now is 0 and col = 1 and we start
  ; again to change all the values

l1:         ;loops on columns
     
cmp si,19
jz endd
mov di,0  
mov si,col
mov dl,data1[si] 
jmp l2 
end2:
mov bl,0 
call place ;;  
mov cx,si  
sub cx,4
mov si,ax  
mov bh,xored
mov data[si],bh 
mov si,col 
inc row 
jmp l2
;mov si,col

l2:
mov xored,0       ;loops on rows  
cmp si,19
jz endd 
cmp di,16 
jz check
mov cl,mix[di]   
mov bl,0
;mov ch,bl 
l3:     ; element by element
cmp si,19
jz endd
mov dl,data1[si]           
mov cl,mix[di]
cmp cl,1
jz one
cmp cl,2
jz two
cmp cl,3
jz three
one:  
 xor xored,dl
jmp end3
two:
call mult2 
 xor xored,dl 
 jmp end3
three:
call mult3  
xor xored,dl                   
jmp end3
end3:
add si,4 ;to move one element downwards
inc di
inc bl
;inc ch 
;inc bh
cmp bl,4 
jz end2
jmp l3 
check:      ; checks that we finished the column 

inc col
jmp l1  
endd:
;pop di
;pop si
;pop cx
;pop bx
;pop ax
;pop dx
endm 
Macro addRoundKey         ; each element in our data is "xored" with each corresponding element in the key
     
    
    Local l
   ; push ax
;    push bx
;    push cx
;    push dx
;    push si
;    push di
    mov si,0 
    mov cx,16
 l: 
    mov bl,data[si]
    mov al,key[si]
    xor bl,al
    mov data[si],bl
    inc si 
    cmp cx,si
    jnz l
   ; pop di
;    pop si
;    pop dx
;    pop cx
;    pop bx
;    pop ax
  
 endm    

Macro shiftRows     ; we shift the rows according to the logic explained in the lecture. each row is subjected to different shift
                    ; using registers as temps to not lose a value
    ; push ax
;    push bx
;    push cx
;    push dx
;    push si
;    push di
mov cx,0 
;row 0 no change 
;row1 shift
mov cl,data[7]
mov bl,data[4]
mov data[7],bl
mov ch, data[6]
mov data[6],cl
mov cl,data[5]
mov data[5],ch
mov data[4],cl
;row 2 shift
mov cl,data[8] 
mov bl,data[10]
mov data[8],bl
mov data[10],cl
mov cl,data[9] 
mov bl,data[11]
mov data[9],bl
mov data[11],cl 
;row 3 shift
mov cl,data[12]
mov ch,data[15]
mov data[12],ch
mov bl,data[14]
mov data[15],bl
mov ch,data[13]
mov data[13],cl 
mov data[14],ch  
  ;  pop di
;    pop si
;    pop dx
;    pop cx
;    pop bx
;    pop ax
endm  
   
Macro subBytes   ; each value in our data is substituted with the corresponding element in the s_box "data[i]=s_box index" 
                 ; example>>>>  data[0]= 19 >>>>>> we will change it with the value in index 19 of the s_box>>> s_box[19]
 Local L1
 Local end    
   ; push ax
;    push bx
;    push cx
;    push dx
;    push si
;    push di
 mov ax,0
 mov cx,16
 mov si,0
 L1:mov al,data[si]
    mov di,ax
    mov bl,s_box[di]
    mov data[si],bl
    inc si
    cmp si,cx
    jnz L1
    jz end
 end: 
 ; pop di
;    pop si
;    pop dx
;    pop cx
;    pop bx
;    pop ax
endm     
   org 100h 
   INCLUDE 'EMU8086.INC' 
.data segment
    data DB 16,?,16 DUP (0h)   
    s_box db 63h,7ch,77h,7bh,0f2h,6bh,6fh,0c5h,30h,01h,67h,2bh,0feh,0d7h,0abh,76h
         db 0cah,82h,0c9h,7dh,0fah,59h,47h,0f0h,0adh,0d4h,0a2h,0afh,9ch,0a4h,72h,0c0h
         db 0b7h,0fdh,93h,26h,36h,3fh,0f7h,0cch,34h,0a5h,0e5h,0f1h,71h,0d8h,31h,15h
         db 04h,0c7h,23h,0c3h,18h,96h,05h,9ah,07h,12h,80h,0e2h,0ebh,27h,0b2h,75h
         db 09h,83h,2ch,1ah,1bh,6eh,5ah,0a0h,52h,3bh,0d6h,0b3h,29h,0e3h,2fh,84h
         db 53h,0d1h,00h,0edh,20h,0fch,0b1h,5bh,6ah,0cbh,0beh,39h,4ah,4ch,58h,0cfh
         db 0d0h,0efh,0aah,0fbh,43h,4dh,33h,85h,45h,0f9h,02h,7fh,50h,3ch,9fh,0a8h
         db 51h,0a3h,40h,8fh,92h,9dh,38h,0f5h,0bch,0b6h,0dah,21h,10h,0ffh,0f3h,0d2h
         db 0cdh,0ch,13h,0ech,5fh,97h,44h,17h,0c4h,0a7h,7eh,3dh,64h,5dh,19h,73h
         db 60h,81h,4fh,0dch,22h,2ah,90h,88h,46h,0eeh,0b8h,14h,0deh,5eh,0bh,0dbh
         db 0e0h,32h,3ah,0ah,49h,06h,24h,5ch,0c2h,0d3h,0ach,62h,91h,95h,0e4h,79h
         db 0e7h,0c8h,37h,6dh,8dh,0d5h,4eh,0a9h,6ch,56h,0f4h,0eah,65h,7ah,0aeh,08h
         db 0bah,78h,25h,2eh,1ch,0a6h,0b4h,0c6h,0e8h,0ddh,74h,1fh,4bh,0bdh,8bh,8ah
         db 70h,3eh,0b5h,66h,48h,03h,0f6h,0eh,61h,35h,57h,0b9h,86h,0c1h,1dh,9eh
         db 0e1h,0f8h,98h,11h,69h,0d9h,8eh,94h,9bh,1eh,87h,0e9h,0ceh,55h,28h,0dfh
         db 8ch,0a1h,89h,0dh,0bfh,0e6h,42h,68h,41h,99h,2dh,0fh,0b0h,54h,0bbh,16h 
    ctr db 0  
    key db 0ffh,0ffh,0ffh,0ffh
        db 0ffh,0ffh,0ffh,0ffh
        db 0ffh,0ffh,0ffh,0ffh
        db 0ffh,0ffh,0ffh,0ffh   
    ;data db 19h,0a0h,9ah,0e9h
;         db 3dh,0f4h,0c6h,0f8h
;         db 0e3h,0e2h,8dh,48h
;         db 0beh,2bh,2ah,08h 
          data1 db 19h,0a0h,9ah,0e9h
         db 3dh,0f4h,0c6h,0f8h
         db 0e3h,0e2h,8dh,48h
         db 0beh,2bh,2ah,08h    
    mix db 02h,03h,01h,01h
        db 01h,02h,03h,01h
        db 01h,01h,02h,03h
        db 03h,01h,01h,02h 
   ; index dw 00h
    col dw 0000h 
        row dw 00h 
    xored db 00h
        xctr db 00h 
        tmp dw 0
.code segment 
    ;mov bh,0  
    
  CALL Input
;  addRoundKey 
;l1:
;  subbytes
;  shiftrows
  mixcolumns 

;  addroundkey 
;  inc ctr
;  cmp ctr,9
;  jnz l1
;  subbytes
;  shiftrows
;  addroundkey
  CALL Output
 
    ret
Input PROC 
     MOV AH,1
        MOV SI,0 
  l: INT 21H
           MOV data[SI],AL 
           mov data1[si],al
           INC SI
           cmp si,16
          jnz l
    ret
ENDP
Output PROC
;    ; push ax
;;    push bx
;;    push cx
;;    push dx
;;    push si
;;    push di  
;    printn
;        
  printn
  mov cx,bx
  mov si,0
  mov ah,2
  x:
  mov dl,data[si]
  int 21h 
  inc si
  cmp si,16
  jnz x
;  ; pop di
;;    pop si
;;    pop dx
;;    pop cx
;;    pop bx
;;    pop ax 
   ret
ENDP 
 mult2  proc    ; responsible of multiplication by  2 

   ;  push ax
;    push bx
;    push cx
;    push dx
;    push si
;    push di 
  
 sal dl,1       ; shifting 1 element to the left>>>>  which means adding a zero in binary>>>>> x2
 jns no1
 xor dl,1bh     ; when the sign flag is 1 >>>>> we xor with 1bh
 jmp exit
 no1:
 jmp exit
 exit:
 ; pop di
;    pop si
;    pop dx
;    pop cx
;    pop bx
;    pop ax   
 ret
 endp 
 mult3   proc         ; it is the same as multiplication by 2 and then xor with the value itself  "value before multiplication by 2"
    mov dh,dl
   ; mov bl,cl
    call mult2 
    xor dl,dh
 
  ;  pop di
   ; pop si
;    pop dx
;    pop cx
;    pop bx
;    pop ax  
    ret
 endp   
place  proc          ; calculating the value where we are supposed to save the xored new value "after mixColumns" 
     
    mov ax,row  
    sal ax,2         ; multiplication by 4 
    add ax ,col 
    ret
  endp