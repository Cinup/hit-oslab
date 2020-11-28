.globl begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text
	
SETUPSEG = 0x07e0   ;setup.s地址	
INITSEG  = 0x0800   ;硬件参数存储地址
;程序入口
entry _start
_start:
    mov	ah,#0x03     ;ah=0x03
	xor	bh,bh        ;
	int	0x10         ;ah=0x03,获取光标的位置和形状
	mov	cx,#26
	mov	bx,#0x0007	
    mov ax,#SETUPSEG
    mov es,ax	     ;es=0x07e0
	mov	bp,#msg2     ;es:bp为字符串地址
	mov	ax,#0x1301      
	int	0x10         ;ah=0x13,在显示器上显示字符

    mov ax,cs        
    mov es,ax        ;ex=0x07e0
    mov ax,#INITSEG    
    mov ss,ax        ;ss=0x0800
    mov sp,#0xFF00   ;sp=0xFF00
    mov ax,#INITSEG  
    mov ds,ax        ;ds=0x0800
get_cursor:
    mov ah,#0x03     ;读取光标位置
    xor bh,bh
    int 0x10
    mov [0],dx       ;ds:[0]=dx
get_memory:
    mov ah,#0x88
    int 0x15
    mov [2],ax       ;ds:[2]=ax
;磁盘信息存在中断向量表中
get_disk:
    mov ax,#0x0000
    mov ds,ax        ;ds=0x0000
    lds si,[4*0x41]  ;si=4*0x41
    mov ax,#INITSEG  
    mov es,ax        ;es=0x0800
    mov di,#0x0004   ;di=0x0004
    mov cx,#0x10     ;cx=16
    rep
    movsb
print:
    mov ax,cs
    mov es,ax
    mov ax,#INITSEG
    mov ds,ax

    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#18
    mov bx,#0x0007
    mov bp,#msg_cursor
    mov ax,#0x1301
    int 0x10
    mov dx,[0]
    call    print_hex

    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#14
    mov bx,#0x0007
    mov bp,#msg_memory
    mov ax,#0x1301
    int 0x10
    mov dx,[2]
    call    print_hex

    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#2
    mov bx,#0x0007
    mov bp,#msg_kb
    mov ax,#0x1301
    int 0x10

    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#7
    mov bx,#0x0007
    mov bp,#msg_cyles
    mov ax,#0x1301
    int 0x10
    mov dx,[4]
    call    print_hex

    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#8
    mov bx,#0x0007
    mov bp,#msg_heads
    mov ax,#0x1301
    int 0x10
    mov dx,[6]
    call    print_hex

    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#10
    mov bx,#0x0007
    mov bp,#msg_sectors
    mov ax,#0x1301
    int 0x10
    mov dx,[12]
    call    print_hex
inf_loop:
    jmp inf_loop
print_hex:
    mov    cx,#4
print_digit:
    rol    dx,#4
    mov    ax,#0xe0f
    and    al,dl
    add    al,#0x30
    cmp    al,#0x3a
    jl     outp
    add    al,#0x07
outp:
    int    0x10
    loop   print_digit
    ret
print_nl:
    mov    ax,#0xe0d     
    int    0x10
    mov    al,#0xa     
    int    0x10
    ret    
msg2:
	.byte 13,10
	.ascii "Now we are in steup.s"
    .byte 13,10
msg_cursor:
    .byte 13,10
    .ascii "Cursor position:"
msg_memory:
    .byte 13,10
    .ascii "Memory Size:"
msg_cyles:
    .byte 13,10
    .ascii "Cyls:"
msg_heads:
    .byte 13,10
    .ascii "Heads:"
msg_sectors:
    .byte 13,10
    .ascii "Sectors:"
msg_kb:
    .ascii "KB"
	.byte 13,10,13,10
.org 512
.text
endtext:
.data
enddata:
.bss
endbss: