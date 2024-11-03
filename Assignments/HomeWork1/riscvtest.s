#       RISC-V Assembly         Description               Address   Machine Code
main:   addi x2, x0, 5          # x2 = 5                  0         00500113   
        addi x3, x0, 12         # x3 = 12                 4         00C00193
        addi x7, x3, -9         # x7 = (12 - 9) = 3       8         FF718393
        or   x4, x7, x2         # x4 = (3 OR 5) = 7       C         0023E233
        and  x5, x3, x4         # x5 = (12 AND 7) = 4     10        0041F2B3
        add  x5, x5, x4         # x5 = (4 + 7) = 11       14        004282B3

        auipc x6, 1             # x6 = PC + (1 << 12)     18        xxxx

        beq  x5, x7, end        # shouldn't be taken      1C        xxxx
        slt  x4, x3, x4         # x4 = (12 < 7) = 0       20        xxxx
        beq  x4, x0, around     # should be taken         24        xxxx
        addi x5, x0, 0          # shouldn't happen        28        xxxx

around: slt  x4, x7, x2         # x4 = (3 < 5) = 1        2C        xxxx
        add  x7, x4, x5         # x7 = (1 + 11) = 12      30        xxxx
        sub  x7, x7, x2         # x7 = (12 - 5) = 7       34        xxxx
        andi x10, x5, 0xF       # x10 = x5 AND 0xF        38        xxxx
        sw   x7, 84(x3)         # [96] = 7                3C        xxxx
        lw   x2, 96(x0)         # x2 = [96] = 7           40        xxxx
        add  x9, x2, x5         # x9 = (7 + 11) = 18      44        xxxx
        jal  x3, next           # jump to next, x3 = 0x44 48        xxxx
        addi x2, x0, 1          # shouldn't happen        4C        xxxx

next:   addi x7, x0, 0x400      # increment x7            50        xxxx
        addi x7, x7, 0x400      # increment x7            54        xxxx
        addi x7, x7, 0x400      # increment x7            58        xxxx
        addi x7, x7, 0x418      # adjust x7               5C        xxxx
        beq  x6, x7, good       # branch if equal         60        xxxx
        beq  x6, x0, done       # branch if zero          64        xxxx

good:   add  x2, x2, x9         # x2 = (7 + 18) = 25      68        xxxx
        sw   x2, 0x20(x3)       # mem[100] = 25           6C        xxxx

done:   beq  x2, x2, done       # infinite loop           70        xxxx
end:     
