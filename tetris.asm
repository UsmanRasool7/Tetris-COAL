org 0x0100

jmp start

top: dw 3
left: dw 2
bottom: dw 22
right: dw 30
top2: dw 1
left2: dw 0
bottom2: dw 23
right2: dw 60
highscore: db 'SCORE:'
Upcoming: db 'UPCOMING SHAPE'
Time: db 'Time: '
Gameover: db 'GAME OVER!!!!'
GameScore: dw 0
tickcount: dw 0
tickcmp: dw 0
sec: dw -1
msg: db 'End',0
oldtimerisr: dd 0
downflag: dw 0
rightflag: dw 0
leftflag: dw 0
RowCheckFlag: dw 0
currentx: dw 0
currenty: dw 0
shapenumber: dw 5
upcomingshape: dw 1
upcomingcheck: dw 0
topcheck: dw 0
oldkbisr: dd 0
starting: db 'Press any key to play the game!!!!!'

CLR:
	 push es
	 push ax
	 push cx
	 push di
	 mov ax, 0xb800
	 mov es, ax ; point es to video base
	 xor di, di ; point di to top left column
	 mov ax, 0x4720 ; space char in normal attribute
	 mov cx, 2000 ; number of screen locations
	 cld ; auto increment mode
	 rep stosw ; clear the whole screen
	
	 pop di 
	 pop cx
	 pop ax
	 pop es
	 ret

PrintNumber:
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di


mov ax,0xb800
mov es,ax
mov ax,[bp+4]
mov bx,10
mov cx,0

numDigits:
mov dx,0
div bx
add dl,0x30
push dx
inc cx
cmp ax,0
jnz numDigits

mov ax,0
mov al, 80
mul byte [bp+6] 
add ax, [bp+8] 
shl ax, 1
mov di,ax

next:
pop dx
mov dh,[bp+10]
mov [es:di],dx
add di,2
loop next


pop di
pop si
pop cx
pop bx
pop ax
pop bp

ret 8


clearscreen:
	push bp
	mov bp,sp
	push es
	push ax
	push di

	mov ax, 0xb800
	mov es, ax					
	mov di, 0					
	mov ax,[bp+4]
nextloc:
	mov word [es:di],ax
	add di, 2					
	cmp di, 4000				
	jne nextloc					

	pop di
	pop ax
	pop es
	pop bp
	ret 2
	
	
delay:   
			push cx
			mov cx, 0xFFFF
loop1:		loop loop1
			mov cx, 0xFFFF
loop2:		loop loop2
			mov cx,0xffff
loop3:		loop loop3

			pop cx
			ret

EndScreen:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push si
push di

mov ax, 0x7720	
push ax
call clearscreen

mov ax,0x19
push ax
mov ax,221
push ax
mov ax,1
push ax
mov ax,0
push ax
mov ax,23
push ax
mov ax,78
push ax
call OuterBorder
mov ax,0x29
push ax
mov ax,223
push ax
mov ax,4
push ax
mov ax,3
push ax
mov ax,19
push ax
mov ax,72
push ax
call OuterBorder
mov ax,0x34
push ax
mov ax,222
push ax
mov ax,8
push ax
mov ax,7
push ax
mov ax,15
push ax
mov ax,68
push ax
call OuterBorder

mov ax,0xFC
push ax
mov ax,Gameover
push ax
mov ax,13
push ax
mov ax,32
push ax
mov ax,10
push ax
call writetext


mov ax,0x7C
push ax
mov ax,highscore
push ax
mov ax,6
push ax
mov ax,32
push ax
mov ax,12
push ax
call writetext

mov ax,0x7C
push ax
mov ax,38
push ax
mov ax,12
push ax
mov ax,[GameScore]
push ax
call PrintNumber



pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret


minibackground:
	push es
	push ax
	push di

	mov ax, 0xb800
	mov es, ax					
	mov di, 160					
	mov si,440
	mov al,219
	mov ah,0x06
	mov cx,0
	mov dx,320
outerloop:
	mov di,dx
	
l2:
	mov word [es:di], ax
	add di, 2					
	cmp di, si		
	jne l2
	
	add si,160
	add dx,160
	add cx,1
	cmp cx,22
	jne outerloop

	pop di
	pop ax
	pop es
	ret


OuterBorder:
	push bp
	mov bp,sp
	push es
	push di
	push si
	push cx
	push ax
	
	mov ax, 0xb800
	mov es, ax 
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+8] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+4] 
	shl ax, 1
	mov si,ax
	
	
	mov al,[bp+12]
	mov ah,[bp+14]
	
topline2:
	mov [es:di],ax
	add di,2
	cmp di,si
	jnz topline2
	mov [es:di],ax
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+8] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+6] 
	add ax, [bp+8] 
	shl ax, 1
	mov si,ax
	
	
	mov al,[bp+12]
	mov ah,[bp+14]
	mov [es:di],ax
	add di,160
	mov ah,[bp+14]
leftline2:
	mov [es:di],ax
	add di,160
	cmp di,si
	jnz leftline2
	
	
	
	mov al, 80 ;calculating address from cordinates
	mul byte [bp+6] 
	add ax, [bp+8] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+6] 
	add ax, [bp+4] 
	shl ax, 1
	mov si,ax
	
	mov al,[bp+12]
	mov ah,[bp+14]
	mov [es:di],ax
	add di,2
	mov al,[bp+12]
	mov ah,[bp+14]
bottomline2:
	mov [es:di],ax
	add di,2
	cmp di,si
	jnz bottomline2
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+4] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+6] 
	add ax, [bp+4] 
	shl ax, 1
	mov si,ax
	
	mov al,[bp+12]
	mov ah,[bp+14]
	mov [es:di],ax
	add di,160
	mov al,[bp+12]
	mov ah,[bp+14]
rightline2:
	mov [es:di],ax
	add di,160
	cmp di,si
	jne rightline2
	mov al,[bp+12]
	mov [es:di],ax

	
	pop ax
	pop cx
	pop si
	pop di
	pop es
	pop bp
	ret 12


Border:
	push bp
	mov bp,sp
	push es
	push di
	push si
	push cx
	push ax
	
	mov ax, 0xb800
	mov es, ax 
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+8] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+4] 
	shl ax, 1
	mov si,ax
	
	
	mov al,205
	mov ah,0x60
	
topline:
	mov [es:di],ax
	add di,2
	cmp di,si
	jnz topline
	mov al,187
	mov [es:di],ax
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+8] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+6] 
	add ax, [bp+8] 
	shl ax, 1
	mov si,ax
	
	
	mov al,201
	mov ah,0x64
	mov [es:di],ax
	add di,160
	mov al,186
	mov ah,0x64
leftline:
	mov [es:di],ax
	add di,160
	cmp di,si
	jnz leftline
	
	
	
	mov al, 80 ;calculating address from cordinates
	mul byte [bp+6] 
	add ax, [bp+8] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+6] 
	add ax, [bp+4] 
	shl ax, 1
	mov si,ax
	
	mov al,200
	mov ah,0x64
	mov [es:di],ax
	add di,2
	mov al,205
	mov ah,0x60
bottomline:
	mov [es:di],ax
	add di,2
	cmp di,si
	jnz bottomline
	
	mov al, 80 
	mul byte [bp+10] 
	add ax, [bp+4] 
	shl ax, 1
	mov di,ax
	
	mov al, 80 
	mul byte [bp+6] 
	add ax, [bp+4] 
	shl ax, 1
	mov si,ax
	
	mov al,187
	mov ah,0x64
	mov [es:di],ax
	add di,160
	mov al,186
	mov ah,0x64
rightline:
	mov [es:di],ax
	add di,160
	cmp di,si
	jne rightline
	mov al,188
	mov [es:di],ax

	
	pop ax
	pop cx
	pop si
	pop di
	pop es
	pop bp
	ret 8



writetext:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov al, 80 
	mul byte [bp+4] 
	add ax, [bp+6] 
	shl ax, 1
	mov di,ax
	mov si,[bp+10]
	mov cx,[bp+8]
	mov ah,[bp+12]
lop1:
	mov al,[si]
	mov [es:di],ax
	add si,1
	add di,2
	dec cx
	jnz lop1
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 10


Block:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov ax,0
	mov al, 80
	mul byte [bp+4] 
	add ax, [bp+6] 
	shl ax, 1
	mov di,ax
	mov ah,0x38
	mov al,176
	
	mov [es:di],ax
	
	
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4


HBlock:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov ax,0
	mov al, 80
	mul byte [bp+4] 
	add ax, [bp+6] 
	shl ax, 1
	mov di,ax
	mov ah,[bp+8]
	mov al,[bp+10]
	
	mov [es:di],ax
	add di,2
	mov al,[bp+10]
	mov [es:di],ax
	
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8

LShape:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov cx,3
	mov ax,3
	mov bx,21
	
	mov dx,0x40
lp1:
	push dx
	push ax
	push bx
	call HBlock
	sub bx,1
	dec cx
	jnz lp1
	
	push dx
	mov bx,21
	mov ax,4
	push ax
	push bx
	call HBlock
	mov bx,21
	mov ax,5
	push dx
	push ax
	push bx
	call HBlock
	
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret


SShape:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	cmp word [upcomingcheck],1
	je startsshape
	
	mov ax,[bp+6]
	cmp ax,3
	ja check2
	mov word [bp+6],3
	jmp startsshape
	
check2:	mov ax,[bp+6]
	cmp ax,22
	jb startsshape
	mov word [bp+6],22
	jmp startsshape
	
startsshape:
	mov word [upcomingcheck],0
	mov ax,[bp+6]
	mov [bp+12],ax
	mov si,[bp+10]
	push si
	mov dx,[bp+8]
	push dx
	mov bx, [bp+4] 
	mov ax, [bp+6] 
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	sub bx,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add bx,1
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock

	
	
endsshape:	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8



OppLShape:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	
	cmp word [upcomingcheck],1
	je startoppLshape
	
	mov ax,[bp+6]
	cmp ax,3
	ja check222
	mov word [bp+6],3
	jmp startoppLshape
	
check222:	
	mov ax,[bp+6]
	cmp ax,25
	jb startoppLshape
	mov word [bp+6],25
	jmp startoppLshape
	
	
startoppLshape:
	mov word [upcomingcheck],0
	mov ax,[bp+6]
	mov [bp+12],ax
	mov dx,[bp+8]
	mov si,[bp+10]
	push si
	push dx
	mov bx, [bp+4] 
	mov ax, [bp+6] 
	
	push ax
	push bx
	call HBlock
	push si
	push dx
	sub bx,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	sub bx,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock

	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8



Horizontal:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	
	cmp word [upcomingcheck],1
	je starthorizontal

leftborderhorizontalcheck:
	mov ax,[bp+6]    ;Checking left border limit
	cmp ax,3
	ja check22
	mov word [bp+6],3
	jmp starthorizontal
	
check22:	
	mov ax,[bp+6]			;Checking right border limit
	cmp ax,25
	jb starthorizontal
	mov word [bp+6],25
	jmp starthorizontal
	
	mov ax,[bp+6]
	mov [bp+12],ax
starthorizontal:	
	mov word [upcomingcheck],0
	mov ax,[bp+6]
	mov [bp+12],ax
	mov si,[bp+10]
	mov dx,[bp+8]
	push si
	push dx
	mov bx, [bp+4] 
	mov ax, [bp+6] 
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock

	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8


LeftFaceL:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	cmp word [upcomingcheck],1
	je startleftfaceL
	
	mov ax,[bp+6]    ;Checking left border limit
	cmp ax,6
	ja check33
	mov word [bp+6],6
	jmp startleftfaceL
	
check33:	
	mov ax,[bp+6]			;Checking right border limit
	cmp ax,28
	jb startleftfaceL
	mov word [bp+6],28
	jmp startleftfaceL
	
	
startleftfaceL:
	mov word [upcomingcheck],0
	mov ax,[bp+6]
	mov [bp+12],ax
	mov si,[bp+10]
	mov dx,[bp+8]
	push si
	push dx
	mov bx, [bp+4] 
	mov ax, [bp+6] 
	
	push ax
	push bx
	call HBlock
	push si
	push dx
	dec bx
	push ax
	push bx
	call HBlock
	push si
	push dx
	dec bx
	push ax
	push bx
	call HBlock
	push si
	push dx
	dec ax
	push ax
	push bx
	call HBlock
	push si
	push dx
	dec ax
	push ax
	push bx
	call HBlock
	push si
	push dx
	dec ax
	push ax
	push bx
	call HBlock
	; push si
	; push dx
	; dec ax
	; push ax
	; push bx
	; call HBlock
		
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
	
	
Vertical:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	cmp word [upcomingcheck],1
	je startvertical
	
	mov ax,[bp+6]    ;Checking left border limit
	cmp ax,6
	ja check333
	mov word [bp+6],6
	jmp startvertical
	
check333:	
	mov ax,[bp+6]			;Checking right border limit
	cmp ax,25
	jb startvertical
	mov word [bp+6],25
	jmp startvertical
	
	
startvertical:
	mov word [upcomingcheck],0
	mov ax,[bp+6]
	mov [bp+12],ax
	mov si,[bp+10]
	mov dx,[bp+8]
	push si
	push dx
	mov bx, [bp+4] 
	mov ax, [bp+6] 
	
	push ax
	push bx
	call HBlock
	push si
	push dx
	dec bx
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	add ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	sub ax,4
	push ax
	push bx
	call HBlock
	push si
	push dx
	sub ax,1
	push ax
	push bx
	call HBlock
	push si
	push dx
	sub ax,1
	push ax
	push bx
	call HBlock


		
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8



Render:
pusha
mov ax, 0x0820	
push ax
call clearscreen
call minibackground
mov ax,[top]
push ax
mov ax,[left]
push ax
mov ax,[bottom]
push ax
mov ax,[right]
push ax
call Border

mov ax,0x04
push ax
mov ax,221
push ax
mov ax,[top2]
push ax
mov ax,[left2]
push ax
mov ax,[bottom2]
push ax
mov ax,[right2]
push ax
call OuterBorder

mov ax,0x60
push ax
mov ax,highscore
push ax
mov ax,6 ;length
push ax
mov ax,35
push ax
mov ax,5
push ax
call writetext

mov ax,0x60
push ax
mov ax,42
push ax
mov ax,5
push ax
mov ax,[GameScore]
push ax
call PrintNumber

mov ax,0x60
push ax
mov ax,Upcoming
push ax
mov ax,14
push ax
mov ax,35
push ax
mov ax,10
push ax
call writetext



mov ax,0x60
push ax
mov ax,Time
push ax
mov ax,5
push ax
mov ax,35
push ax
mov ax,17
push ax
call writetext

; mov ax,0x60
; push ax
; mov ax,42
; push ax
; mov ax,17
; push ax
; mov ax,58
; push ax
; call PrintNumber

popa
ret

printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di


mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [cs:sec] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 2804 ; point di to 70th column
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack

end:
pop di
pop dx
pop cx
pop bx
pop ax 
pop es
pop bp
ret 2

;------------------------------------------------------
; timer interrupt service routine
;------------------------------------------------------
timer:		push ax
			
			inc word [cs:tickcount]  
			
			cmp word [cs:tickcount],10
			jb skip
			mov word[cs:tickcount],0
			inc word [cs:sec]
			
			
			mov ax,0x60
			push ax
			mov ax,42
			push ax
			mov ax,17
			push ax
			mov ax,[cs:sec]
			push ax
			call PrintNumber

skip:			mov al, 0x20
			out 0x20, al ; end of interrupt
			
		
			pop ax
			cmp word [cs:sec],20



skipt:		iret ; return from interrupt



;---------------------------------------------------------Downward Checks----------------------------------------------------------
checkdownflag:
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di
push es


mov al,80
mul byte[bp+4]
add ax,[bp+6]
shl ax,1
mov di,ax
add di,160

mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown2
mov word [downflag],1
jmp endcheckdown

checkdown2:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown3
mov word [downflag],1
jmp endcheckdown

checkdown3:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown390
mov word [downflag],1
jmp endcheckdown

checkdown390:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown391
mov word [downflag],1
jmp endcheckdown

checkdown391:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown392
mov word [downflag],1
jmp endcheckdown

checkdown392:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown393
mov word [downflag],1
jmp endcheckdown

checkdown393:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdown394
mov word [downflag],1
jmp endcheckdown

checkdown394:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne endcheckdown
mov word [downflag],1



endcheckdown:
pop es
pop di
pop si
pop cx
pop bx
pop ax
pop bp
ret 4


checkdownflag2: ;for horizontal SHAPE
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di
push es


mov al,80
mul byte[bp+4]
add ax,[bp+6]
shl ax,1
mov di,ax
add di,160

mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownhorizontal2
mov word [downflag],1
jmp endcheckdown2


checkdownhorizontal2:
add di,4
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownhorizontal39
mov word [downflag],1
jmp endcheckdown2

checkdownhorizontal39:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownhorizontal399
mov word [downflag],1
jmp endcheckdown2

checkdownhorizontal399:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne endcheckdown2
mov word [downflag],1
jmp endcheckdown2

endcheckdown2:
pop es
pop di
pop si
pop cx
pop bx
pop ax
pop bp
ret 4


checkdownflag3: ;for OppL SHAPE
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di
push es


mov al,80
mul byte[bp+4]
add ax,[bp+6]
shl ax,1
mov di,ax
add di,160

mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownhorizontal3
mov word [downflag],1
jmp endcheckdown3


checkdownhorizontal3:
add di,2
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownhorizontal444
mov word [downflag],1
jmp endcheckdown3



checkdownhorizontal444:
add di,6
sub di,160
sub di,160
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne endcheckdown3
mov word [downflag],1
jmp endcheckdown3



endcheckdown3:
pop es
pop di
pop si
pop cx
pop bx
pop ax
pop bp
ret 4


checkdownflag4: ;for Left face L SHAPE
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di
push es


mov al,80
mul byte[bp+4]
add ax,[bp+6]
shl ax,1
mov di,ax
add di,160

mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownh2
mov word [downflag],1
jmp endcheckdown4

checkdownh2:
add di,2
cmp byte [es:di],0xB0
jne checkdownhorizontal4
mov word [downflag],1
jmp endcheckdown4

checkdownhorizontal4:
sub di,8
sub di,160
sub di,160
mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownhorizontal49
mov word [downflag],1
jmp endcheckdown4

checkdownhorizontal49:
; add di,160
; add di,2
; mov ax,0xb800
; mov es,ax
; cmp byte [es:di],0xB0
; jne checkdownhorizontal49
; mov word [downflag],1
jmp endcheckdown4


endcheckdown4:
pop es
pop di
pop si
pop cx
pop bx
pop ax
pop bp
ret 4


checkdownflag5: ;for Vertical
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di
push es


mov al,80
mul byte[bp+4]
add ax,[bp+6]
shl ax,1
mov di,ax
add di,160

mov ax,0xb800
mov es,ax
cmp byte [es:di],0xB0
jne checkdownV2
mov word [downflag],1
jmp endcheckdownV4

checkdownV2:
add di,2
cmp byte [es:di],0xB0
jne checkdownV3
mov word [downflag],1
jmp endcheckdownV4

checkdownV3:
add di,6
sub di,160
cmp byte [es:di],0xB0
jne checkdownV4
mov word [downflag],1
jmp endcheckdownV4

checkdownV4:
sub di,14
cmp byte [es:di],0xB0
jne endcheckdownV4
mov word [downflag],1
jmp endcheckdownV4

endcheckdownV4:
pop es
pop di
pop si
pop cx
pop bx
pop ax
pop bp
ret 4

;-------------------------------------------------CLEAR AND SCROLL------------------------------------------------------

ClearAndScroll:
push bp
mov bp,sp
pusha
push es
push ds

mov ax,0xb800
mov es,ax
mov ds,ax
mov si,[bp+8];ending
mov di,[bp+6];starting
mov ax,0x6C20

scrollloop1:
mov [es:di],ax
add di,2
cmp di,si
jbe scrollloop1

mov dx , [bp + 4]

mov si,[bp+6];starting
sub si,160
mov di,[bp+6];ending



clearandscroll1:
mov si,[bp+6];starting
sub si,160
mov di,[bp+6];ending


clearloopinner:
movsw
cmp di,[bp+8]
jbe clearloopinner

sub word [bp+8],160
sub word [bp+6],160
dec dx
jnz clearandscroll1

pop ds
pop es
popa
pop bp
ret 6


CheckIfRowFill:
pusha
push es
mov dl,21

;end cordinate start
mov al,80
mul dl
add ax,3
shl ax,1
mov di,ax


mov al,80
mul dl
add ax,30
shl ax,1
mov si,ax

mov ax,0xb800
mov es,ax
mov cx,17

mov bx,si
mov dx,di

rowloop1:
mov si,bx
mov di,dx
mov word [RowCheckFlag],0

innerrowloop:
cmp byte [es:di],0xB0
jne endrowloop1
add di,2
cmp di,si
jb innerrowloop

cmp di,si
jae rowflag
jmp endrowloop1

rowflag:
mov word [RowCheckFlag],1
push bx
push dx
push cx
add word [GameScore],10 ;Update score of the game
mov ax,0x60
push ax
mov ax,42
push ax
mov ax,5
push ax
mov ax,[GameScore]
push ax
call PrintNumber
call ClearAndScroll


endrowloop1:


sub dx,160
sub bx,160
dec cx
jnz rowloop1


pop es
popa
ret
;-------------------------------------------------TOPMOST CHECK-------------------------------------------------------------------------

topmostcheck:
pusha
push es

mov ax,0xb800
mov es,ax

mov di,810
mov ax,840

topmostloop:
cmp byte [es:di],0xb0
je topchecktrue
add di,2
cmp  di,ax
jbe topmostloop

jmp endtopmost

topchecktrue:
mov word [topcheck],1

endtopmost:
pop es
popa
ret

;--------------------------------------------------GENERATE RANDOM NUMBER-------------------------------------------------------------

clearupcoming:
pusha
mov ax,0xb800
mov es,ax

mov di,1988
mov cx,15
mov ax,0x6C20
clearUloop1:
mov [es:di],ax
add di,2
loop clearUloop1
mov di,2148
mov cx,15
mov ax,0x6C20
clearUloop2:
mov [es:di],ax
add di,2
loop clearUloop2
mov di,2310
mov cx,15
mov ax,0x6C20
clearUloop3:
mov [es:di],ax
add di,2
loop clearUloop3


popa
ret



GenRand:
pusha

call clearupcoming
mov dx,0
mov word ax,[sec]
add ax,bx
mov bx,6
div bx
mov ax,[upcomingshape]
mov [shapenumber],ax
mov [upcomingshape],dx

cmp word [upcomingshape],1
je	shape11
cmp word [upcomingshape],2
je	shape22
cmp word [upcomingshape],3
je	shape33
cmp word [upcomingshape],4
je	shape44
cmp word [upcomingshape],5
jmp shape55


shape11:
mov word [upcomingcheck],1
sub sp,2
mov ax,176
push ax
mov ax,0x24
push ax
mov ax,37
push ax
mov ax,14
push ax
call Vertical
pop bx
jmp endgenrand

shape22:
mov word [upcomingcheck],1
sub sp,2
mov ax,176
push ax
mov ax,0x10
push ax
mov ax,37
push ax
mov ax,14
push ax
call Horizontal
pop bx
jmp endgenrand

shape33:
mov word [upcomingcheck],1
sub sp,2
mov ax,176
push ax
mov ax,0x70
push ax
mov ax,37
push ax
mov ax,14
push ax
call OppLShape
pop bx
jmp endgenrand

shape44:
mov word [upcomingcheck],1
sub sp,2
mov ax,176
push ax
mov ax,0x50
push ax
mov ax,37
push ax
mov ax,14
push ax
call LeftFaceL
pop bx
jmp endgenrand

shape55:
mov word [upcomingcheck],1
sub sp,2
mov ax,176
push ax
mov ax,0x40
push ax
mov ax,37
push ax
mov ax,14
push ax
call SShape
pop bx
jmp endgenrand

endgenrand:
popa
ret

;-------------------------------------------------------GAME LOOP------------------------------------------------------------------------
MoveDown:
push bp
mov bp,sp
pusha
push es

mov bx,13 ;X cordinate 
mov si,5;Y cordinate
mov cx,17
mov word [shapenumber],3
outerloopdown:

call CheckIfRowFill
call CheckIfRowFill
call CheckIfRowFill
mov bx,13
mov si,6
mov cx,16
mov dx,si
mov word [downflag],0
mov [currentx],bx 
mov [currenty],si

cmp word [sec],299
jge forceend

call GenRand     ;Generates random shape


call topmostcheck    ;checks if top filled 
cmp word [topcheck],1
je forceend

cmp word [shapenumber],2
jne loopdown
mov si,4
mov cx,18
jmp loopdown

forceend:    ;Ends Game
xor ax, ax	;Unhooking timer interrupt
mov es, ax 
mov ax,[oldtimerisr]
mov bx,[oldtimerisr+2]
cli
mov [es:8*4],ax
mov [es:8*4+2],bx
sti

xor ax, ax	;Unhooking keyboard interrupt
mov es, ax 
mov ax,[oldkbisr]
mov bx,[oldkbisr+2]
cli
mov [es:9*4],ax
mov [es:9*4+2],bx
sti


call EndScreen
mov ax, 0x4c00 ; terminate program
int 0x21

loopdown:
cmp word [shapenumber],1
je	shape1
cmp word [shapenumber],2
je	shape2
cmp word [shapenumber],3
je	farjmp3
cmp word [shapenumber],4
je	farjmp4
cmp word [shapenumber],5
jmp	shape5


farjmp3:
jmp shape3

farjmp4:
jmp shape4


shape1:  ;Vertical Shape
mov di,bx
 
sub sp,2
mov ax,176
push ax
mov ax,0x24
push ax
mov ax,bx
push ax
mov ax,si
push ax
call Vertical
pop bx

call delay
call delay
call delay
call delay

cmp cx,1
je outerloopdown 


;Vertical check
push bx
push si
call checkdownflag5 ;checking if shapes already down
cmp word[downflag],1
je outerloopdown


sub sp,2
mov ax,0x20
push ax
mov ax,0x6C
push ax
mov ax,di
push ax
mov ax,si
push ax
call Vertical
pop dx
jmp innerloopend


shape2: ;HORIZONTAL SHAPE
mov di,bx

sub sp,2
mov ax,176
push ax
mov ax,0x10
push ax
mov ax,bx
push ax
mov ax,si
push ax
call Horizontal
pop bx  ;value of bx remains unchanged if tried to go outside Border

call delay
call delay
call delay
call delay

cmp cx,1
je outerloopdown 

;horizontaldowncheck
push bx
push si
call checkdownflag2 ;checking if shapes already down
cmp word[downflag],1
je outerloopdown

sub sp,2
mov ax,0x20
push ax
mov ax,0x6C 
push ax
mov ax,di
push ax
mov ax,si
push ax
call Horizontal
pop dx
jmp innerloopend

shape3: ;OPP L SHAPE
mov di,bx

sub sp,2
mov ax,176
push ax
mov ax,0x70
push ax
mov ax,bx
push ax
mov ax,si
push ax
call OppLShape
pop bx

call delay
call delay
call delay
call delay

cmp cx,1
je outerloopdown 

;Opp L Shape check
push bx
push si
call checkdownflag3 ;checking if shapes already down
cmp word[downflag],1
je outerloopdown

sub sp,2
mov ax,0x20
push ax
mov ax,0x6C
push ax
mov ax,di
push ax
mov ax,si
push ax
call OppLShape
pop dx
jmp innerloopend


shape4: ;LEFT FACE L
mov di,bx

sub sp,2
mov ax,176
push ax
mov ax,0x50
push ax
mov ax,bx
push ax
mov ax,si
push ax
call LeftFaceL
pop bx

call delay
call delay
call delay
call delay


cmp cx,1
je outerloopdown 

;Left face L check
push bx
push si
call checkdownflag4 ;checking if shapes already down
cmp word[downflag],1
je outerloopdown


sub sp,2
mov ax,0x20
push ax
mov ax,0x6C
push ax
mov ax,di
push ax
mov ax,si
push ax
call LeftFaceL
pop dx
jmp innerloopend


shape5: ;OPP T Shape
mov di,bx

sub sp,2
mov ax,176
push ax
mov ax,0x40
push ax
mov ax,bx
push ax
mov ax,si
push ax
call SShape
pop bx

call delay
call delay
call delay
call delay

cmp cx,1
je outerloopdown 

push bx
push si
call checkdownflag ;checking if shapes already down
cmp word[downflag],1
je outerloopdown

sub sp,2
mov ax,0x20
push ax
mov ax,0x6c
push ax
mov ax,di
push ax
mov ax,si
push ax
call SShape
jmp innerloopend
pop dx

innerloopend:
add si,1
sub cx,1
jnz loopdown


EndGame:

pop es
popa
pop bp
ret


;---------------------------------------Timer ISRs----------------------------------------------------------------------
hookTimer:
pusha
push es


xor ax, ax
mov es, ax ; point es to IVT base
mov ax,[es:8*4]
mov [oldtimerisr],ax
mov ax,[es:8*4+2]
mov [oldtimerisr+2],ax



xor ax, ax
mov es, ax
cli ; disable interrupts
mov ax,cs
mov word [es:8*4], timer; store offset at n*4
mov [es:8*4+2], cs ; store segment at n*4+2
sti ; enable interrupts



pop es
popa
ret
;----------------------------------------------------------------------------------------------------------------------------


;------------------------------Right And Left key Checks for Horizontal Shape-----------------------------------------------;
LeftKeyCheckHorizontal:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
sub di,2
cmp byte [es:di],0xB0
jne lefthcheck2
mov word [leftflag],1

lefthcheck2:
add di,160
cmp byte [es:di],0xB0
jne endlefthcheck
mov word [leftflag],1


endlefthcheck:
popa
ret

RightKeyCheckHorizontal:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
add di,10
cmp byte [es:di],0xB0
jne righthcheck2
mov word [rightflag],1

righthcheck2:
add di,160
cmp byte [es:di],0xB0
jne endrighthcheck
mov word [rightflag],1


endrighthcheck:
popa
ret
;---------------------------OPPL Shape Checks------------------------------------------------;
RightKeyCheckOppLshape:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
add di,10
sub di,320
cmp byte [es:di],0xB0
jne righthcheck3
mov word [rightflag],1

righthcheck3:
add di,160
cmp byte [es:di],0xB0
jne rightOcheck
mov word [rightflag],1

rightOcheck:
sub di,6
add di,160
cmp byte [es:di],0xB0
jne endrighthcheck2
mov word [rightflag],1


endrighthcheck2:
popa
ret
;-------------------------------------Left Face L Checks----------------------------------------------------------

LeftKeyCheckLeftL:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
sub di,8
sub di,320
cmp byte [es:di],0xB0
jne leftcheck4
mov word [leftflag],1

leftcheck4:
add di,160
cmp byte [es:di],0xB0
jne endleftcheck
mov word [leftflag],1


endleftcheck:
popa
ret


RightKeyCheckLeftL:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
add di,4
cmp byte [es:di],0xB0
jne leftLcheck1
mov word [rightflag],1

leftLcheck1:
sub di,160
cmp byte [es:di],0xB0
jne leftLcheck2
mov word [rightflag],1


leftLcheck2:
add di,320
cmp byte [es:di],0xB0
jne endrightLcheck4
mov word [rightflag],1

endrightLcheck4:
popa
ret



;--------------------------------Checks for Vertical Shape and T shape---------------------------------------------------------------------
LeftKeyCheckVertical2:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
sub di,2
cmp byte [es:di],0xB0
jne leftcheckvertical
mov word [leftflag],1

leftcheckvertical:
sub di,160
cmp byte [es:di],0xB0
jne lefthcheckvertical2
mov word [leftflag],1


lefthcheckvertical2:
add di,320
cmp byte [es:di],0xB0
jne endlefthcheckvertical
mov word [leftflag],1


endlefthcheckvertical:
popa
ret

LeftKeyT:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
sub di,2
cmp byte [es:di],0xB0
jne lefthcheckt0
mov word [leftflag],1

lefthcheckt0:
add di,160
cmp byte [es:di],0xB0
jne leftcheckt
mov word [leftflag],1

leftcheckt:
sub di,320
sub di,6
cmp byte [es:di],0xB0
jne lefthcheckt2
mov word [leftflag],1


lefthcheckt2:
add di,160
cmp byte [es:di],0xB0
jne endlefthcheckt
mov word [leftflag],1


endlefthcheckt:
popa
ret

RightKeyVertical2:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
add di,4
cmp byte [es:di],0xB0
jne rightVertical
mov word [rightflag],1

rightVertical:
add di,160
cmp byte [es:di],0xB0
jne endrightvertical
mov word [rightflag],1


endrightvertical:
popa
ret

RightKeyT:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
add di,4
cmp byte [es:di],0xB0
jne rightcheckt0
mov word [rightflag],1

rightcheckt0:
add di,160
cmp byte [es:di],0xB0
jne rightcheckt
mov word [rightflag],1

rightcheckt:
sub di,320
add di,6
cmp byte [es:di],0xB0
jne rightcheckt2
mov word [rightflag],1


rightcheckt2:
add di,160
cmp byte [es:di],0xB0
jne endrightcheckt
mov word [rightflag],1


endrightcheckt:
popa
ret

;-------------------------------------------------Right Check for opp T shape------------------------------------------------

RightKeyOppT:
pusha

mov ax,0xb800
mov es,ax
mov ax,0
mov al, 80
mul byte [currenty]
add ax, [currentx] 
shl ax, 1
mov di,ax
add di,16
cmp byte [es:di],0xB0
jne righthcheck2222
mov word [rightflag],1

righthcheck2222:
add di,160
cmp byte [es:di],0xB0
jne endrighthcheck990
mov word [rightflag],1


endrighthcheck990:
popa
ret


;--------------------------------------------------KEYBOARD ISR----------------------------------------------------------------------------

kbisr:
push ax
push es
push di
mov word [rightflag],0
mov word [leftflag],0
mov word [currentx],bx
mov word [currenty],si

; mov ax, 0xb800
; mov es, ax ; point es to video memory




in al, 0x60 ; read a char from keyboard port
cmp al, 75 ; is the key left shift
jne farjmpnextcmp ; no, try next comparison
jmp LeftChecks

farjmpnextcmp:
jmp nextcmp

LeftChecks:
mov word [rightflag],0
mov word [leftflag],0
cmp word [shapenumber],1
je left1shape
cmp word [shapenumber],2
je left2shape
cmp word [shapenumber],3
je left3shape
cmp word [shapenumber],4
je left4shape
cmp word [shapenumber],5
jmp left2shape


left1shape:
;left key check for T shape
call LeftKeyT
cmp word [leftflag],1
je farjmpnomatch
jmp endleftkeycheck

left2shape:
call LeftKeyCheckHorizontal
cmp word [leftflag],1
je farjmpnomatch
jmp endleftkeycheck

left3shape: ;left key check for OppLShape
call LeftKeyCheckVertical2
cmp word [leftflag],1
je farjmpnomatch
jmp endleftkeycheck

left4shape: ;Left Key Check for left face L also required leftkeycheck horizontal with it
call LeftKeyCheckHorizontal
cmp word [leftflag],1
je farjmpnomatch
jmp endleftkeycheck

call LeftKeyCheckLeftL
cmp word [leftflag],1
je farjmpnomatch
jmp endleftkeycheck


farjmpnomatch:
jmp nomatch

endleftkeycheck:
sub bx,1
mov word [rightflag],0
mov word [leftflag],0
jmp nomatch ; leave interrupt routine

nextcmp: cmp al, 77 ; is the key right shift
jne nomatchfarjmp2 ; no, leave interrupt routine

cmp word [shapenumber],1
je right1shape
cmp word [shapenumber],2
je right2shape
cmp word [shapenumber],3
je right3shape
cmp word [shapenumber],4
je right4shape
cmp word [shapenumber],5
jmp right5shape

nomatchfarjmp2:
jmp nomatch

right1shape:
;Right key check for T shape
call RightKeyT
cmp word [rightflag],1
je nomatch
jmp endrightkeycheck

right2shape:
;right key horizontal check
call RightKeyCheckHorizontal
cmp word [rightflag],1
je nomatch
jmp endrightkeycheck

right3shape:
;Right key check for oppL shape
call RightKeyCheckOppLshape
cmp word [rightflag],1
je nomatch
jmp endrightkeycheck
call RightKeyVertical2
cmp word [rightflag],1
je nomatch
jmp endrightkeycheck



right4shape:
; ;Right key check for Left face L shape
call RightKeyCheckLeftL
cmp word [rightflag],1
je nomatch
jmp endrightkeycheck

right5shape:
call RightKeyOppT
cmp word [rightflag],1
je nomatch
jmp endrightkeycheck

endrightkeycheck:
add bx,1


nomatch: mov al, 0x20
out 0x20, al ; send EOI to PIC

kbisrend:
pop di
pop es
pop ax
iret


HookKB:
pusha

xor ax, ax
mov es, ax ; point es to IVT base
mov ax,[es:9*4]
mov [oldkbisr],ax
mov ax,[es:9*4+2]
mov [oldkbisr+2],ax


xor ax, ax
mov es, ax ; point es to IVT base
cli ; disable interrupts
mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
sti ; enable interrupts
popa
ret


start:

call StartScreen
mov ax,0x60
push ax
mov ax,starting
push ax
mov ax,36
push ax
mov ax,1
push ax
mov ax,1
push ax
call writetext
mov ah,0
int 16h
call clearscreen
call Render
call hookTimer
call HookKB



gameloop:
call MoveDown


End99:
xor ax, ax	;Unhooking keyboard interrupt
mov es, ax 
mov ax,[oldkbisr]
mov bx,[oldkbisr+2]
cli
mov [es:9*4],ax
mov [es:9*4+2],bx
sti


xor ax, ax	;Unhooking timer interrupt
mov es, ax 
mov ax,[oldtimerisr]
mov bx,[oldtimerisr+2]
cli
mov [es:8*4],ax
mov [es:8*4+2],bx
sti

mov ax, 0x4c00 ; terminate program
int 0x21
%include 'start.asm'