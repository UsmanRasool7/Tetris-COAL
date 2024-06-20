printstr: 
	 push bp
	 mov bp, sp
	 push es
	 push ax
	 push cx
	 push si
	 push di

	 mov ax, 0xb800
	 mov es, ax ; point es to video base
	 mov al, 80 ; load al with columns per row
	 mul byte [bp+10] ; multiply with y position
	 add ax, [bp+12] ; add x position
	 shl ax, 1 ; turn into byte offset
	 mov di,ax ; point di to required location
	 mov si, [bp+6] ; point si to string
	 mov cx, [bp+4] ; load length of string in cx
	 mov ah, [bp+8] 

cld ; auto increment mode
nextchar: 
	mov al, 20h
	 stosw ; print char/attribute pair
	 loop nextchar ; repeat for the whole string

	 pop di
	 pop si
	 pop cx
	 pop ax
	 pop es
	 pop bp
	 ret 10 

;-----------------------------------------------------------START SCREEN-----------------------------------------

StartScreen:
pusha
call CLR ; call clrscr subroutine


mov cx , 5
mov bx , 5

MakeTLeft:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 1 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeTLeft

mov cx , 9
mov bx , 10
mov dx , 3

MakeTCenter:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeTCenter

mov cx , 5
mov bx , 13
mov dx, 5

MakeTRight:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, dx
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr 

	 add bx, 81
	 dec cx
	 call delay
	 call delay
	 jnz MakeTRight


mov cx , 9
mov bx , 19
mov dx , 3

MakeELeft:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeELeft


mov cx , 6
mov bx , 22

MakeETop:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr
	 add bx, 82
	 call delay
	 call delay
	 sub cx , 2
	 jnz MakeETop


mov cx , 3
mov bx , 22

 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 9
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr


mov cx , 6
mov bx , 22

MakeEBottom:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 13
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr
	 sub bx, 78
	 sub cx , 2
	 call delay
	 call delay
	 jnz MakeEBottom

mov cx , 5
mov bx , 29

MakeT2Left:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 1 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeT2Left

mov cx , 9
mov bx , 34
mov dx , 3

MakeT2Center:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeT2Center

mov cx , 5
mov bx , 37
mov dx, 5

MakeT2Right:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, dx
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push cx;
	 call printstr 

	 add bx, 81
	 dec cx
	 call delay
	 call delay
	 jnz MakeT2Right

mov cx , 9
mov bx , 43
mov dx , 3

MakeRLeft:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeRLeft

mov cx , 3
mov bx , 46
mov dx , 5

MakeRTop:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 add dx, 1
	 dec cx
	 call delay
	 call delay
	 jnz MakeRTop

mov cx , 3
mov bx , 46
mov dx , 7

MakeRTopn:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 7
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 sub dx, 1
	 dec cx
	 call delay
	 call delay
	 jnz MakeRTopn


mov cx , 4
mov bx , 46
mov dx , 2

MakeRBottom:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 10
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 add dx, 1
	 dec cx
	 call delay
	 call delay
	 jnz MakeRBottom


mov cx , 3
mov bx , 45
mov dx , 2

MakeRILeft:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 6
	 push ax ; push y position
	 mov ax, 47h ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x44
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeRILeft

mov cx , 2
mov bx , 46
mov dx , 3

MakeRITop:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 6
	 push ax ; push y position
	 mov ax, 47h ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x44
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 add dx, 1
	 dec cx
	 call delay
	 call delay
	 jnz MakeRITop

mov cx , 2
mov bx , 46
mov dx , 4

MakeRITopn:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 7
	 push ax ; push y position
	 mov ax, 47h ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x44
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 sub dx, 1
	 dec cx
	 call delay
	 call delay
	 jnz MakeRITopn

mov cx , 9
mov bx , 54
mov dx , 3

MakeILeft:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 dec cx
	 call delay
	 call delay
	 jnz MakeILeft

mov cx , 9
mov bx , 58
mov dx , 7

MakeS:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 81
	 dec cx
	 call delay
	 call delay
	 jnz MakeS


mov cx , 6
mov bx , 67
mov dx , 6

MakeSLeft:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 5
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 81
	 dec dx
	 dec cx
	 call delay
	 call delay
	 jnz MakeSLeft


mov cx , 6
mov bx , 58
mov dx , 1

MakeSRight:
 	 mov ax, bx
	 push ax ; push x position
	 mov ax, 8
	 push ax ; push y position
	 mov ax, 10 ; blue on black attribute
	 push ax ; push attribute
	 mov ax, 0x41
	 push ax ; push address of message
	 push dx;
	 call printstr 

	 add bx, 80
	 inc dx
	 dec cx
	 call delay
	 call delay
	 jnz MakeSRight
popa
ret


