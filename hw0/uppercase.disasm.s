
uppercase.bin:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <_start>:
   10074:	ffff2517          	auipc	a0,0xffff2
   10078:	f8c50513          	addi	a0,a0,-116 # 2000 <__DATA_BEGIN__>
   1007c:	00000913          	li	s2,0
   10080:	06100a13          	li	s4,97
   10084:	07b00a93          	li	s5,123

00010088 <loop>:
   10088:	00050583          	lb	a1,0(a0)
   1008c:	0145c863          	blt	a1,s4,1009c <after>
   10090:	0155d663          	bge	a1,s5,1009c <after>
   10094:	fe058593          	addi	a1,a1,-32
   10098:	00b50023          	sb	a1,0(a0)

0001009c <after>:
   1009c:	00150513          	addi	a0,a0,1
   100a0:	ff2594e3          	bne	a1,s2,10088 <loop>
   100a4:	0040006f          	j	100a8 <end_program>

000100a8 <end_program>:
   100a8:	0000006f          	j	100a8 <end_program>
