IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
	;messages
	gameov db 'game over!$'
	score db 'score: $'
	
	;graphics VARIABLES
	;mole and hole printing
	x dw 59
	y dw 177
	color db 40
	moleColor db 6
	background db 0
	
	;variables to determine if mole is up
	hole1 db 0 
	hole2 db 0 
	hole3 db 0
	hole4 db 0
	hole5 db 0
	points dw 0000
	didwhackmole db 0
	
	;time variables
	seconds db 1 ;שניות
	cseconds db 10 ;עשיריות שנייה
	time db 20
	moletime db 40 ;how quick moles spawns
	moletimer db 30
	;spawns db 6 DUP(10) sigma 
	spawn db 10 ;time that takes for mole to disappear
	spawn1 db 10
	spawn2 db 10
	spawn3 db 10
	spawn4 db 10
	spawn5 db 10
	;secondmole db 10
	

CODESEG
proc IntToString 
	mov cx,4
	convert:
		xor ax,ax
		mov bl,10
		
		mov ax,[points]
		div bl
		
		mov dl, ah
		mov ah,0
		mov [points],ax
		add dl,'0'
		push dx
        ;mov ah, 2
		;int 21h
		loop convert
	mov cx,4
	printfromstack:
		pop dx
		mov ah, 2
		int 21h	
		loop printfromstack
    ret
	endp IntToString

proc makezero
	push 15
	push 21
	push 15
	call DrawMalben
	push [y]
	add [x], 3
	sub [y], 3
	push 9
	push 15
	push 0
	call DrawMalben
	mov cx,3
	sub [y],3
	loopzero:
		push cx
		push 3
		push 3
		push 15
		call DrawMalben
		sub [y],3
		add [x],3
		pop cx
		loop loopzero
	
	pop [y]
	ret
	endp makezero

proc makeone
	add [x],8
	push 3;widf
	push 21;leng
	push 15
	call DrawMalben
	
	ret 
	endp makeone

proc maketwo
	push 14
	push 21
	push 15
	call DrawMalben
	push [y]
	sub [y],12
	mov cx,2
	gyat1:
		push cx
		push 11
		push 6
		push 0
		call DrawMalben
		add [x],3
		add [y],9
		pop cx
		loop gyat1
	pop [y]
	ret
	endp maketwo
	
proc makethree
	push 14
	push 21
	push 15
	call DrawMalben
	push [y]
	sub [y],12
	mov cx,2
	gyat:
		push cx
		push 11
		push 6
		push 0
		call DrawMalben
		add [y],9
		pop cx
		loop gyat
	pop [y]
	ret
	endp makethree

proc makefour
	push 14
	push 21
	push 15
	call DrawMalben
	
	push 11
	push 9
	push 0
	call DrawMalben
	
	add [x],3
	sub [y],12
	
	push 8
	push 9
	push 0
	call DrawMalben
	
	add [y], 12
	ret
	endp makefour

proc makefive
	push 14
	push 21
	push 15
	call DrawMalben
	push [y]
	add [x],3
	sub [y],12
	mov cx,2
	gyat2:
		push cx
		push 11
		push 6
		push 0
		call DrawMalben
		sub [x],3
		add [y],9
		pop cx
		loop gyat2
	pop [y]
	ret
	endp makefive
proc makesix
	push 14
	push 21
	push 15
	call DrawMalben
	add [x],3
	push [y]
	sub [y],3
	
	push 8
	push 6
	push 0
	call DrawMalben
	
	sub [y],9
	push 11
	push 6
	push 0
	call DrawMalben
	pop [y]
	ret
	endp makesix
	
proc makeseven
	push 12
	push 21
	push 15
	call DrawMalben

	push 9
	push 18
	push 0
	call DrawMalben

	ret 
	endp makeseven

proc eight
	push 14
	push 21
	push 15
	call DrawMalben
	add [x],3
	sub [y],3
	
	push 8
	push 6
	push 0
	call DrawMalben

	sub [y],9

	push 8
	push 6
	push 0
	call DrawMalben
	
	add [y],12
	ret
	endp eight
	
proc makenine 
	push 14
	push 21
	push 15
	call DrawMalben
	
	add [x],3
	push [y]
	sub [y],12

	push 8
	push 6
	push 0
	call DrawMalben

	sub [x],3
	add [y],9
	push 11
	push 6
	push 0
	call DrawMalben

	pop [y]
	ret
	endp makenine
	

;proc to draw holes
proc malben
	push [x]
	push [y]
	push 81
	push 26
	push 40
	call DrawMalben
	sub [y],2
	add [x],2
	push 77
	push 22
	push 0
	call DrawMalben
	pop [y]
	pop [x]
	ret
	endp malben
proc DrawMalben
	push bp
	mov bp,sp
	
	mov di, [y] 
	mov si,[x]
	colur equ [bp+4]
	len equ [bp+6] ;אורך מלבן
	wid equ [bp+8] ;רוחב מלבן
	
	mov cx, len
	MalbenLoop:
		push cx
		mov cx, wid 
		;print lines
		insideMalben:
			push cx
			;print pixel
			mov bh,0h
			mov cx,[x]
			mov dx,[y]
			mov al,colur
			mov ah,0ch
			int 10h  
			inc [x]
			pop cx
			loop insideMalben
		dec [y] ;mov up a line
		mov [x],si
		pop cx
		loop MalbenLoop
	mov [y],di
	pop bp
	ret 6
	endp DrawMalben


proc choosehole
	;add [x], 15 ????
	;push 50
	;call verline
	
	;choose hole randomly
	mov	ah, 2Ch
	int		21h
	
	test dl, 1  ; Perform bitwise AND operation
	jz below     ; Jump if result is zero (זוגי)
	
	;chose the top 3
	mov [y], 105
	cmp dl, 33
	JA ThreeOrTwo
	test [hole1],1
	jz drawone
	jmp dontdraw
	drawone:
	mov [x], 30
	mov [hole1],1  ;first hole is up
	jmp endchoose
	
	ThreeOrTwo:
	cmp dl, 66
	JA Three
	;second hole
	test [hole2],1
	jz drawtwo
	jmp dontdraw
	drawtwo:
	mov [x], 135
	mov [hole2],1
	jmp endchoose
	
	Three: ;third hole
		test [hole3],1
		jz drawthree
		jmp dontdraw
		drawthree:
		mov [x], 240
		mov [hole3],1
		jmp endchoose
	
	below: ;chose the bottom two
		mov [y], 175
		cmp dl,50
		JA rightHole
		test [hole4],1
		jz drawfour
		jmp dontdraw
		drawfour:
		mov [x],75       ;left hole
		mov [hole4],1
		jmp endchoose
		
		rightHole:
			test [hole5],1
			jz drawfive
			jmp dontdraw
			drawfive:
			mov [x], 195
			mov [hole5],1
	
	endchoose:
	call SummonMole

	ret
	endp choosehole

proc SummonMole
	mov ax, 2h ; hide mouse
    int 33h
	
	push [x]
	push [y]
	
	push 50
	push 60
	push 6
	call DrawMalben
	
	sub [y],40
	add [x],17
	mov cx,2
		
	eyes:
		push cx
		push 4
		push 10
		push 0
		call DrawMalben
		add [x],10
		pop cx
		loop eyes
	sub [x],10
	sub [y],6
	mov cx,2
	eyes2:
		push cx
		push 4
		push 4
		push 15
		call DrawMalben
		sub [x],10
		pop cx
		loop eyes2
	
	add [x],8
	add [y],15
	add [y],3
	push 18
	push 8
	push 64
	call DrawMalben
	
	sub [y],3
	inc [x]
	push 6
	push 4
	push 15
	call DrawMalben
		
	pop [y]
	pop [x]
	
    mov ax, 1h ; show mouse
    int 33h
	dontdraw:
	ret
	endp SummonMole

proc checkholeclicked
	cmp dx, 105 ;top or bottom
	ja bottomtwo
	cmp dx,45
	ja chole1
	jmp endcheck
	chole1:
	;start testing which hole
	test [hole1],1
	jz chole2
	cmp cx,30 
	jb chole2
	cmp cx,80
	ja chole2
	mov [hole1],2
	
	;check if x is in area of mole
	chole2:
	test [hole2],1
	jz chole3
	cmp cx,135
	jb chole3
	cmp cx, 185
	ja chole3
	mov [hole2],2
	
	chole3:
	test [hole3],1
	jz endcheck
	cmp cx,240
	jb endcheck
	cmp cx,290
	ja endcheck
	mov [hole3],2
	jmp endcheck
	
	bottomtwo:
	cmp dx,115
	jb endcheck
	cmp dx,175
	ja endcheck
	
	test [hole4],1
	jz chole5 
	cmp cx,75
	jb chole5
	cmp cx, 125
	ja chole5
	mov [hole4],2
	
	chole5:
	test [hole5],1
	jz endcheck
	cmp cx, 195
	jb endcheck
	cmp cx, 245
	ja endcheck
	mov [hole5],2
	endcheck:
	ret
	endp checkholeclicked
proc CheckClick	;check if mouse clicked mole
	;get mouse cordinates
	mov ax,3h
	int 33h
	
	;test if mouse left clicked
	test bx, 1h
	JNZ fanum
	jmp endclick
	fanum:
	
	;div x click by 2
	shr cx, 1         ;moves all digits to the right, basically cx/2
	
	call checkholeclicked
	
	mov [y],105
	
	cmp [hole1],2
	jne nexthole
	mov [didwhackmole],69
	mov [x],30
	call removeMole
	mov [hole1],0
	add [points],10
	call print_score
	
	nexthole:
	cmp [hole2],2
	JNE nexthole2
	mov [didwhackmole],69
	mov [x],135
	call removeMole
	mov [hole2],0
	add [points],10
	call print_score

	nexthole2:
	cmp [hole3],2
	JNE nexthole3
	mov [didwhackmole],69
	mov [x],240
	call removeMole
	mov [hole3],0
	add [points],10
	call print_score

	nexthole3:
	mov [y],175
	cmp [hole4],2
	JNE nexthole4
	mov [didwhackmole],69
	mov [x],75
	call removeMole
	mov [hole4],0
	add [points],10
	call print_score

	nexthole4:
	cmp [hole5],2
	JNE endclick
	mov [didwhackmole],69
	mov [x],195
	call removeMole
	mov [hole5],0
	add [points],10
	call print_score

	endclick:
	ret
	endp CheckClick
	
proc removeMole
	mov ax, 2h ; hide mouse
    int 33h

	push 50
	push 60
	push 0
	call DrawMalben
	
    sub [y],22
	push 50
	push 2
	push 40
	call DrawMalben
	
	mov ax, 1h ; show mouse
    int 33h
	
	ret
	endp removeMole

proc print_score
	mov [x],295
	mov [y],26
	mov ax, [points] 
	
	mov cx,4
	scoreloop:
		push cx
		mov bx, 10
		mov dx,0
		div bx
		
		push ax
		
		push [x]
		push dx
		call print_num
		
		
		pop [x]
		sub [x],19
		pop ax
		pop cx
		loop scoreloop
	
	
	ret
	endp print_score
	
proc print_num
	push bp
	push bx
	mov bp,sp
	
	push 17
	push 26
	push 0
	call DrawMalben
	
	num equ [bp+6]
	mov bl,num
	
	cmp bl,0 
	JNE drawon
	call makezero
	jmp exitto
	
	drawon:
	cmp bl,1
	JNE drawtwu
	call makeone
	jmp exitto
	
	drawtwu:
	cmp bl,2
	JNE drawthre
	call maketwo
	jmp exitto

	drawthre:
	cmp bl,3
	JNE drawfoor
	call makethree
	jmp exitto
	
	drawfoor:
	cmp bl,4
	JNE drawfave
	call makefour
	jmp exitto
	
	drawfave:
	cmp bl,5
	JNE drawsix
	call makefive
	jmp exitto
	
	drawsix:
	cmp bl,6
	JNE drawseven
	call makesix
	jmp exitto
	
	drawseven:
	cmp bl,7
	JNE draweight
	call makeseven
	jmp exitto
	
	draweight:
	cmp bl,8
	JNE drawnine
	call eight
	jmp exitto

	drawnine:
	cmp bl,9
	JNE exitto
	call makenine
	
	exitto:
	pop bx
	pop bp
	ret 2
	endp print_num
	
proc print_time	
	mov al, [time] 
	
	mov bl, 10
	mov ah, 0
	div bl
	
	mov bl,ah
	mov ah,0
	push [x]
	push ax
	call print_num
	
	pop [x]
	add [x],19
	mov al,bl
	push ax
	call print_num
	
	ret
	endp print_time

proc timer
	mov	ah, 2Ch
	int		21h
	
	cmp dh, [seconds]
	je checktime
	mov [seconds],dh
	dec [time]
	
	mov [y],26
	mov [x],5
	call print_time
	
	checktime:
	cmp [time],0
	jne endtime
	jmp game_over
	endtime:
	ret
	endp timer

proc despawnmole
	mov [y], 105
	cmp [spawn1],0
	jne subhole
	mov [x],30
	call removeMole
	mov bl, [spawn]
	mov [spawn1],bl
	mov [hole1],0
	
	subhole:
	cmp [hole1],1
	jne shole
	sub [spawn1],10
	
	shole:
	cmp [spawn2],0
	jne subhole2
	mov [x],135
	call removeMole
	mov bl, [spawn]
	mov [spawn2],bl
	mov [hole2],0
	
	subhole2:
	cmp [hole2],1
	jne thole
	sub [spawn2],10
	
	thole:
	cmp [spawn3],0
	jne subhole3
	mov [x],240
	call removeMole
	mov bl, [spawn]
	mov [spawn3],bl
	mov [hole3],0
	
	subhole3:
	cmp [hole3],1
	jne fhole
	sub [spawn3],10
	
	fhole:
	mov [y], 175
	cmp [spawn4],0
	jne subhole4
	mov [x],75
	call removeMole
	mov bl, [spawn]
	mov [spawn4],bl
	mov [hole4],0
	
	subhole4:
	cmp [hole4],1
	jne fihole
	sub [spawn4],10
	
	fihole:
	cmp [spawn5],0
	jne subhole5
	mov [x],195
	call removeMole
	mov bl, [spawn]
	mov [spawn5],bl
	mov [hole5],0
	
	subhole5:
	cmp [hole5],1
	jne endespawn
	sub [spawn5],10
	
	endespawn:
	ret
	endp despawnmole


	
proc dagame ;פרוצודה שאחראית לאלגוריתמים במשחק
	mov	ah, 2Ch
	int		21h
	
	;decreasing spawn time between moles until its 1 second
	cmp [moletime],5
	je summonmoles
	
	cmp [seconds], dh
	je summonmoles
	mov [seconds],dh
	sub [moletime],1
	call despawnmole
	
	cmp [didwhackmole],69
	JNE summonmoles
	call choosehole
	mov [didwhackmole],0
	
	;מוריד זמן עד שהחפרפרת תזדמן
	summonmoles:
	;div dl by 10 to get the עשיריות שנייה
	mov al, dl 
	
	mov bl, 10
	mov ah, 0
	div bl ;result at ax
	
	cmp al, [cseconds]
	JE skibidytoilet
	mov [cseconds],al
	dec [moletimer]
	
	checktimer:
	cmp [moletimer],0
	jne skibidytoilet
	call choosehole
	mov cl,[moletime]
	mov [moletimer],cl
	
	skibidytoilet:
	ret
	endp dagame


start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	
	;Graphic mode
	mov ax, 13h
	int 10h
	
	;print bottom two malbens
	call malben
	add [x],120
	call malben
	
	sub [y], 70
	mov [x], 14
	;top 3 malbenim
	mov cx,3
	lip:
		push cx
		call malben
		add [x], 105
		pop cx
		loop lip
	
	call choosehole
	
	call print_score
	
	mov ax, 0h
	int 33h
	
	mov ax, 1h
	int 33h
	
	game:
		call timer
		call dagame
		call CheckClick

		jmp game
	
	game_over: 
		;text mode
		mov ax, 3h       
		int 10h
		
		mov dx, offset gameov
		mov ah, 9
		int 21h
		
		mov dl, 13
		mov ah, 2
		int 21h
		mov dl, 10
		mov ah, 2
		int 21h
		
		mov dx, offset score
		mov ah, 9
		int 21h
		
		call IntToString
exit:
	mov ax, 4c00h
	int 21h
END start


