.globl begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

BOOTSEG  = 0x07c0   ;bootsect.s地址		
SETUPSEG = 0x07e0   ;setup.s地址	
;程序入口
entry _start
;打印启动字符串
_start:
    mov	ah,#0x03     ;ah=0x03
    xor	bh,bh        ;bh=0
    int	0x10         ;ah=0x03,获取光标的位置和形状
    mov	cx,#23       ;cx指定字符串长度
    mov	bx,#0x0007	
    mov ax,#BOOTSEG
    mov es,ax	     ;es=0x07c0
    mov	bp,#msg1     ;es:bp为字符串地址
    mov	ax,#0x1301      
    int	0x10         ;ah=0x13,在显示器上显示字符
;从磁盘中读取setup.s
load_setup:
    mov ax,#BOOTSEG
    mov es,ax	     ;es=0x07c0
    mov	dx,#0x0000   ;dx=0x0000 
    mov	cx,#0x0002   ;cx=0x0002
    mov	bx,#0x0200   ;bx=0x0200
    mov	ax,#0x0201   ;ax=0x0204
    int	0x13	     ;读取磁盘中断,ah=0x02,al扇区数量,
                     ;ch柱面号,cl开始扇区,dh磁头号,dl驱动器号,es:bx内存地址
    jnc	ok_load_setup;读取成功,跳转到ok_load_setup
    mov	dx,#0x0000
    mov	ax,#0x0000
    int	0x13
    j	load_setup
ok_load_setup:
    jmpi  0,SETUPSEG ;跳转到0x07e00处,执行setup.s
msg1:
    .byte 13,10
    .ascii "Cinux is Loading..."
    .byte 13,10,
.org 510
;MBR魔法字符
boot_flag:
    .word 0xAA55
.text
endtext:
.data
enddata:
.bss
endbss: