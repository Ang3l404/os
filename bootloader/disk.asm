diskR:
  mov ah, 0x02
  mov dl, [diskB]
  int 0x13

  jc diskRERR

  cmp ah, 0x00
  jne diskRERR

  xor ah, ah
  mov bx, ax
  call printD

  mov bx, diskS
  call printS
  ret

drvPE equ 0x5200

driveP:
  mov dl, [diskB]
  mov ah, 0x08
  int 0x13
  jc diskPERR

  and cl, 0x3f

  mov []