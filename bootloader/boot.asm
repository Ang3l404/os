[org 0x7c00]
[bits 16]

stg2l equ 0x7c00

_main16:
  mov [diskB], dl

  cli
  mov ax, 0x00
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7C00
  sti

  mov ah, 0x00
  mov al, 0x03
  int 0x10

  xor bx, bx
  mov es, bx

  mov bx, stg2l
  mov al, 0x02
  mov ch, 0x00
  mov cl, 0x02
  mov dh, 0x00
  call diskR

  jmp stg2l

  jmp $

%include"printS.asm"
%include"printD.asm"
%include"disk.asm"

times 510-($-$$) db 0x00
dw 0xAA55