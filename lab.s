bits	64
section .data
str:
	times 1024	db	0
newstr:
	times 1024	db	0
file:
	times 1024	db	0
vowels:
	db	"a", "e", "i", "u", "y", "o", "A", "E", "I", "U", "Y", "O"
size:
	db	12
section .text
global  _start
_start:
	pop 	rsi
	pop	rsi
	pop	rsi
stack:
	pop	rsi
	cmp	rsi, 0
	je	end
	mov	rdx, 0
	mov	rax, 0
symbol:
	cmp	byte[rsi+rdx], 70
	jne	stack
	inc	rdx
	cmp	byte[rsi+rdx], 73
	jne	stack
	inc	rdx
	cmp	byte[rsi+rdx], 76
	jne	stack
	inc	rdx
	cmp	byte[rsi+rdx], 69
	jne	stack
	inc	rdx
	cmp	byte[rsi+rdx], 61
	jne	stack
	inc	rdx
name:
	cmp	byte[rsi+rdx], 0
	je	restart
	mov	cl, byte[rsi+rdx]
	mov	byte[file+rax], cl
	inc	rdx
	inc	rax
	jmp	name
restart:
	mov	byte[file+rax], 0
	mov	rax, 2
	mov	rsi, 2
	mov	rdi, file
	syscall
	mov	rdi, rax
	mov	rdx, 1024
	mov	rax, 0
	mov	rsi, str
	syscall
	mov	r9, rax
	mov	r11, -1
	mov	rsi, 0
preloop:
	inc	r11
	cmp	r11, r9
	jge	print
	mov	r10b, byte[str+r11]
	mov	rcx, 0
	cmp	r10b, 32
	je	space
	cmp	r10b, 9
	je	space
	mov	rsi, 0
	jmp	copy
space:
	cmp	rsi, 1
	je	preloop
	mov	rsi, 1
	cmp	r10b, 10
	je	space
copy:
	mov	byte[newstr+rbx], r10b
	inc	rbx
loop:
	cmp	cl, [size]
	jge	preloop
	cmp	r10b, byte[vowels+rcx]
	je	plus
	inc	rcx
	cmp	r10b, 10
	je	space
	jmp	loop
plus:
	mov	byte[newstr+rbx], r10b
	inc	rbx
	jmp	preloop
print:
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, newstr
	mov	rdx, rbx
	syscall
end:
	mov	rax, 60
	mov	rdi, 0
	syscall
