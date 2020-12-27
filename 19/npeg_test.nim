import npeg

let inputpattern = peg("r0"):
  r0 <- r8 * r11  * !1

  r8 <- (r42 | r42 * r8) * &r11
  r11 <- r42 * r31 | r42 * r11 * r31
  #r8 <- r42
  #r11 <- r42 * r31

  r3 <- r7 * r45 | * r10 * r39
  r120 <- r109 * r45 | * r16 * r39
  r84 <- r96 * r39 | * r104 * r45
  r6 <- r120 * r39 | * r113 * r45
  r111 <- r45 * r93 | * r39 * r45
  r13 <- r17 * r45 | * r96 * r39
  r74 <- r122 * r45 | * r17 * r39
  r94 <- r66 * r45 | * r119 * r39
  r127 <- r39 * r84 | * r45 * r132
  r129 <- r45 * r128 | * r39 * r35
  r112 <- r39 * r35 | * r45 * r58
  r24 <- r45 * r76 | * r39 * r112
  r43 <- r39 * r17 | * r45 * r96
  r2 <- r45 * r5 | * r39 * r77
  r71 <- r100 * r45
  r51 <- r77 * r45
  r4 <- r124 * r39 | * r85 * r45
  r45 <- "a"
  r78 <- r111 * r39 | * r128 * r45
  r104 <- r45 * r39 | * r39 * r93
  r29 <- r122 * r39 | * r66 * r45
  r42 <- r63 * r45 | * r20 * r39
  r41 <- r73 * r45 | * r19 * r39
  r110 <- r39 * r98 | * r45 * r114
  r55 <- r45 * r104 | * r39 * r122
  r53 <- r39 * r34 | * r45 * r89
  r39 <- "b"
  r61 <- r77 * r45 | * r104 * r39
  r121 <- r45 * r65 | * r39 * r1
  r105 <- r45 * r44 | * r39 * r99
  r113 <- r9 * r39 | * r103 * r45
  r117 <- r96 * r93
  r125 <- r39 * r108 | * r45 * r43
  r69 <- r45 * r39
  r56 <- r50 * r45 | * r12 * r39
  r73 <- r39 * r35 | * r45 * r100
  r87 <- r39 * r100 | * r45 * r111
  r10 <- r45 * r13 | * r39 * r73
  r19 <- r39 * r69 | * r45 * r58
  r100 <- r39 * r45
  r66 <- r93 * r93
  r46 <- r45 * r82 | * r39 * r74
  r76 <- r66 * r45 | * r111 * r39
  r103 <- r45 * r52 | * r39 * r115
  r77 <- r45 * r39 | * r45 * r45
  r52 <- r82 * r39 | * r112 * r45
  r15 <- r45 * r47 | * r39 * r132
  r68 <- r39 * r77 | * r45 * r17
  r1 <- r45 * r47 | * r39 * r61
  r65 <- r37 * r45 | * r51 * r39
  r98 <- r45 * r2 | * r39 * r80
  r35 <- r39 * r45 | * r45 * r45
  r93 <- r39 | * r45
  r126 <- r111 * r39 | * r77 * r45
  r32 <- r45 * r36 | * r39 * r37
  r37 <- r45 * r69 | * r39 * r119
  r90 <- r39 * r17 | * r45 * r69
  r21 <- r39 * r66 | * r45 * r58
  r22 <- r39 * r56 | * r45 * r64
  r7 <- r123 * r39 | * r48 * r45
  r60 <- r45 * r102 | * r39 * r26
  r107 <- r45 * r29 | * r39 * r71
  r58 <- r39 * r45 | * r39 * r39
  r70 <- r128 * r39 | * r111 * r45
  r81 <- r27 * r45 | * r129 * r39
  r67 <- r5 * r39 | * r100 * r45
  r96 <- r45 * r45 | * r39 * r39
  r116 <- r39 * r87 | * r45 * r55
  r106 <- r39 * r51 | * r45 * r92
  r14 <- r45 * r128 | * r39 * r58
  r48 <- r39 * r104 | * r45 * r5
  r72 <- r45 * r35 | * r39 * r111
  r130 <- r118 * r45 | * r28 * r39
  r115 <- r45 * r91 | * r39 * r87
  r31 <- r39 * r6 | * r45 * r22
  r30 <- r79 * r45 | * r57 * r39
  r9 <- r125 * r39 | * r49 * r45
  r122 <- r39 * r39 | * r45 * r93
  r23 <- r101 * r45 | * r78 * r39
  r47 <- r39 * r100 | * r45 * r58
  r28 <- r45 * r111 | * r39 * r122
  r101 <- r45 * r77 | * r39 * r66
  r33 <- r39 * r5 | * r45 * r111
  r95 <- r39 * r5
  r27 <- r58 * r45 | * r17 * r39
  r16 <- r15 * r39 | * r116 * r45
  r80 <- r45 * r119 | * r39 * r66
  r92 <- r45 * r111 | * r39 * r58
  r57 <- r39 * r73 | * r45 * r86
  r123 <- r45 * r58 | * r39 * r77
  r5 <- r39 * r39
  r128 <- r45 * r45
  r124 <- r101 * r39 | * r126 * r45
  r108 <- r45 * r122 | * r39 * r119
  r119 <- r45 * r39 | * r39 * r39
  r50 <- r81 * r45 | * r106 * r39
  r99 <- r130 * r45 | * r46 * r39
  r132 <- r17 * r45 | * r119 * r39
  r49 <- r70 * r45 | * r117 * r39
  r63 <- r131 * r39 | * r83 * r45
  r85 <- r39 * r33 | * r45 * r97
  r18 <- r45 * r60 | * r39 * r25
  r83 <- r39 * r54 | * r45 * r4
  r38 <- r62 * r45 | * r21 * r39
  r64 <- r39 * r30 | * r45 * r121
  r118 <- r45 * r17
  r91 <- r39 * r17 | * r45 * r100
  r82 <- r39 * r100 | * r45 * r119
  r86 <- r119 * r39 | * r111 * r45
  r89 <- r39 * r119 | * r45 * r77
  r44 <- r39 * r127 | * r45 * r107
  r88 <- r45 * r95 | * r39 * r89
  r17 <- r39 * r45 | * r45 * r39
  r131 <- r39 * r3 | * r45 * r110
  r12 <- r39 * r24 | * r45 * r23
  r26 <- r39 * r108 | * r45 * r90
  r36 <- r58 * r45 | * r100 * r39
  r97 <- r45 * r111
  r25 <- r39 * r88 | * r45 * r32
  r62 <- r96 * r39 | * r111 * r45
  r59 <- r39 * r119 | * r45 * r96
  r34 <- r45 * r35 | * r39 * r100
  r79 <- r68 * r39 | * r94 * r45
  r40 <- r39 * r72 | * r45 * r14
  r20 <- r39 * r105 | * r45 * r18
  r75 <- r111 * r45 | * r69 * r39
  r114 <- r67 * r45 | * r59 * r39
  r54 <- r38 * r39 | * r53 * r45
  r102 <- r39 * r75 | * r45 * r80
  r109 <- r39 * r40 | * r45 * r41

