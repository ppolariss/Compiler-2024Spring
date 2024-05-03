declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @main( ) {
main:
  %r155 = alloca i32
  %r149 = alloca i32
  %r145 = alloca i32
  %r144 = alloca i32
  %r140 = alloca i32
  %r139 = alloca i32
  %r134 = alloca i32
  %r128 = alloca i32
  %r124 = alloca i32
  %r123 = alloca i32
  %r122 = alloca i32
  %r121 = alloca i32
  %r116 = alloca i32
  %r110 = alloca i32
  %r106 = alloca i32
  %r105 = alloca i32
  %r104 = alloca i32
  %r103 = alloca i32
  %r100 = alloca i32
  %r101 = icmp sgt i32 1, 0
  br i1 %r101, label %bb1, label %bb2

bb1:
  store i32 1, i32* %r100
  br label %bb3

bb2:
  store i32 0, i32* %r100
  br label %bb3

bb3:
  %r102 = load i32, i32* %r100
  store i32 %r102, i32* %r103
  %r107 = icmp sgt i32 1, 0
  br i1 %r107, label %bb10, label %bb11

bb10:
  store i32 1, i32* %r106
  br label %bb12

bb11:
  store i32 0, i32* %r106
  br label %bb12

bb12:
  %r108 = load i32, i32* %r106
  %r109 = icmp ne i32 %r108, 0
  br i1 %r109, label %bb13, label %bb8

bb13:
  %r111 = icmp sgt i32 2, 1
  br i1 %r111, label %bb14, label %bb15

bb14:
  store i32 1, i32* %r110
  br label %bb16

bb15:
  store i32 0, i32* %r110
  br label %bb16

bb16:
  %r112 = load i32, i32* %r110
  %r113 = icmp ne i32 %r112, 0
  br i1 %r113, label %bb7, label %bb8

bb7:
  store i32 1, i32* %r105
  br label %bb9

bb8:
  store i32 0, i32* %r105
  br label %bb9

bb9:
  %r114 = load i32, i32* %r105
  %r115 = icmp ne i32 %r114, 0
  br i1 %r115, label %bb17, label %bb5

bb17:
  %r117 = icmp slt i32 3, 0
  br i1 %r117, label %bb18, label %bb19

bb18:
  store i32 1, i32* %r116
  br label %bb20

bb19:
  store i32 0, i32* %r116
  br label %bb20

bb20:
  %r118 = load i32, i32* %r116
  %r119 = icmp ne i32 %r118, 0
  br i1 %r119, label %bb4, label %bb5

bb4:
  store i32 1, i32* %r104
  br label %bb6

bb5:
  store i32 0, i32* %r104
  br label %bb6

bb6:
  %r120 = load i32, i32* %r104
  store i32 %r120, i32* %r121
  %r125 = icmp slt i32 1, 0
  br i1 %r125, label %bb27, label %bb28

bb27:
  store i32 1, i32* %r124
  br label %bb29

bb28:
  store i32 0, i32* %r124
  br label %bb29

bb29:
  %r126 = load i32, i32* %r124
  %r127 = icmp ne i32 %r126, 0
  br i1 %r127, label %bb24, label %bb30

bb30:
  %r129 = icmp slt i32 2, 1
  br i1 %r129, label %bb31, label %bb32

bb31:
  store i32 1, i32* %r128
  br label %bb33

bb32:
  store i32 0, i32* %r128
  br label %bb33

bb33:
  %r130 = load i32, i32* %r128
  %r131 = icmp ne i32 %r130, 0
  br i1 %r131, label %bb24, label %bb25

bb24:
  store i32 1, i32* %r123
  br label %bb26

bb25:
  store i32 0, i32* %r123
  br label %bb26

bb26:
  %r132 = load i32, i32* %r123
  %r133 = icmp ne i32 %r132, 0
  br i1 %r133, label %bb21, label %bb34

bb34:
  %r135 = icmp sgt i32 5, 4
  br i1 %r135, label %bb35, label %bb36

bb35:
  store i32 1, i32* %r134
  br label %bb37

bb36:
  store i32 0, i32* %r134
  br label %bb37

bb37:
  %r136 = load i32, i32* %r134
  %r137 = icmp ne i32 %r136, 0
  br i1 %r137, label %bb21, label %bb22

bb21:
  store i32 1, i32* %r122
  br label %bb23

bb22:
  store i32 0, i32* %r122
  br label %bb23

bb23:
  %r138 = load i32, i32* %r122
  store i32 %r138, i32* %r139
  %r142 = load i32, i32* %r121
  %r141 = icmp sgt i32 %r142, 1
  br i1 %r141, label %bb38, label %bb39

bb38:
  store i32 1, i32* %r140
  br label %bb40

bb39:
  store i32 0, i32* %r140
  br label %bb40

bb40:
  %r143 = load i32, i32* %r140
  store i32 %r143, i32* %r121
  %r146 = icmp sgt i32 1, 0
  br i1 %r146, label %bb47, label %bb48

bb47:
  store i32 1, i32* %r145
  br label %bb49

bb48:
  store i32 0, i32* %r145
  br label %bb49

bb49:
  %r147 = load i32, i32* %r145
  %r148 = icmp ne i32 %r147, 0
  br i1 %r148, label %bb50, label %bb45

bb50:
  %r150 = icmp sgt i32 3, 2
  br i1 %r150, label %bb51, label %bb52

bb51:
  store i32 1, i32* %r149
  br label %bb53

bb52:
  store i32 0, i32* %r149
  br label %bb53

bb53:
  %r151 = load i32, i32* %r149
  %r152 = icmp ne i32 %r151, 0
  br i1 %r152, label %bb44, label %bb45

bb44:
  store i32 1, i32* %r144
  br label %bb46

bb45:
  store i32 0, i32* %r144
  br label %bb46

bb46:
  %r153 = load i32, i32* %r144
  %r154 = icmp ne i32 %r153, 0
  br i1 %r154, label %bb41, label %bb54

bb54:
  %r156 = icmp sgt i32 0, 6
  br i1 %r156, label %bb55, label %bb56

bb55:
  store i32 1, i32* %r155
  br label %bb57

bb56:
  store i32 0, i32* %r155
  br label %bb57

bb57:
  %r157 = load i32, i32* %r155
  %r158 = icmp ne i32 %r157, 0
  br i1 %r158, label %bb41, label %bb42

bb41:
  %r160 = load i32, i32* %r139
  %r159 = mul i32 %r160, 10
  %r162 = load i32, i32* %r121
  %r161 = add i32 %r159, %r162
  ret i32 %r161
  br label %bb43

bb42:
  br label %bb43

bb43:
  ret i32 1
  ret i32 0
}

