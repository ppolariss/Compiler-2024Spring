declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@ascii_0 = global i32 48
define i32 @my_getint( ) {
my_getint:
  %r126 = alloca i32
  %r121 = alloca i32
  %r111 = alloca i32
  %r106 = alloca i32
  %r100 = alloca i32
  store i32 0, i32* %r100
  %r101 = alloca i32
  br label %bb1

bb1:
  %r102 = icmp sgt i32 1, 0
  br i1 %r102, label %bb2, label %bb3

bb2:
  %r103 = call i32 @getch()
  %r105 = load i32, i32* @ascii_0
  %r104 = sub i32 %r103, %r105
  store i32 %r104, i32* %r101
  %r108 = load i32, i32* %r101
  %r107 = icmp slt i32 %r108, 0
  br i1 %r107, label %bb7, label %bb8

bb7:
  store i32 1, i32* %r106
  br label %bb9

bb8:
  store i32 0, i32* %r106
  br label %bb9

bb9:
  %r109 = load i32, i32* %r106
  %r110 = icmp ne i32 %r109, 0
  br i1 %r110, label %bb4, label %bb10

bb10:
  %r113 = load i32, i32* %r101
  %r112 = icmp sgt i32 %r113, 9
  br i1 %r112, label %bb11, label %bb12

bb11:
  store i32 1, i32* %r111
  br label %bb13

bb12:
  store i32 0, i32* %r111
  br label %bb13

bb13:
  %r114 = load i32, i32* %r111
  %r115 = icmp ne i32 %r114, 0
  br i1 %r115, label %bb4, label %bb5

bb4:
  br label %bb1

  br label %bb6

bb5:
  br label %bb3

  br label %bb6

bb6:
  br label %bb1

bb3:
  %r116 = load i32, i32* %r101
  store i32 %r116, i32* %r100
  br label %bb14

bb14:
  %r117 = icmp sgt i32 1, 0
  br i1 %r117, label %bb15, label %bb16

bb15:
  %r118 = call i32 @getch()
  %r120 = load i32, i32* @ascii_0
  %r119 = sub i32 %r118, %r120
  store i32 %r119, i32* %r101
  %r123 = load i32, i32* %r101
  %r122 = icmp sge i32 %r123, 0
  br i1 %r122, label %bb20, label %bb21

bb20:
  store i32 1, i32* %r121
  br label %bb22

bb21:
  store i32 0, i32* %r121
  br label %bb22

bb22:
  %r124 = load i32, i32* %r121
  %r125 = icmp ne i32 %r124, 0
  br i1 %r125, label %bb23, label %bb18

bb23:
  %r128 = load i32, i32* %r101
  %r127 = icmp sle i32 %r128, 9
  br i1 %r127, label %bb24, label %bb25

bb24:
  store i32 1, i32* %r126
  br label %bb26

bb25:
  store i32 0, i32* %r126
  br label %bb26

bb26:
  %r129 = load i32, i32* %r126
  %r130 = icmp ne i32 %r129, 0
  br i1 %r130, label %bb17, label %bb18

bb17:
  %r132 = load i32, i32* %r100
  %r131 = mul i32 %r132, 10
  %r134 = load i32, i32* %r101
  %r133 = add i32 %r131, %r134
  store i32 %r133, i32* %r100
  br label %bb19

bb18:
  br label %bb16

  br label %bb19

bb19:
  br label %bb14

bb16:
  %r135 = load i32, i32* %r100
  ret i32 %r135
  ret i32 0
}

define i32 @mod( i32 %r136, i32 %r138 ) {
mod:
  %r137 = alloca i32
  store i32 %r136, i32* %r137
  %r139 = alloca i32
  store i32 %r138, i32* %r139
  %r141 = load i32, i32* %r137
  %r142 = load i32, i32* %r139
  %r140 = sdiv i32 %r141, %r142
  %r144 = load i32, i32* %r139
  %r143 = mul i32 %r140, %r144
  %r146 = load i32, i32* %r137
  %r145 = sub i32 %r146, %r143
  ret i32 %r145
  ret i32 0
}

define void @my_putint( i32 %r147 ) {
my_putint:
  %r148 = alloca i32
  store i32 %r147, i32* %r148
  %r149 = alloca [ 16 x i32 ]
  %r150 = alloca i32
  store i32 0, i32* %r150
  br label %bb27

bb27:
  %r152 = load i32, i32* %r148
  %r151 = icmp sgt i32 %r152, 0
  br i1 %r151, label %bb28, label %bb29

bb28:
  %r154 = load i32, i32* %r150
  %r153 = getelementptr [16 x i32 ], [16 x i32 ]* %r149, i32 0, i32 %r154
  %r156 = load i32, i32* %r148
  %r155 = call i32 @mod(i32 %r156, i32 10)
  %r158 = load i32, i32* @ascii_0
  %r157 = add i32 %r155, %r158
  store i32 %r157, i32* %r153
  %r160 = load i32, i32* %r148
  %r159 = sdiv i32 %r160, 10
  store i32 %r159, i32* %r148
  %r162 = load i32, i32* %r150
  %r161 = add i32 %r162, 1
  store i32 %r161, i32* %r150
  br label %bb27

bb29:
  br label %bb30

bb30:
  %r164 = load i32, i32* %r150
  %r163 = icmp sgt i32 %r164, 0
  br i1 %r163, label %bb31, label %bb32

bb31:
  %r166 = load i32, i32* %r150
  %r165 = sub i32 %r166, 1
  store i32 %r165, i32* %r150
  %r168 = load i32, i32* %r150
  %r167 = getelementptr [16 x i32 ], [16 x i32 ]* %r149, i32 0, i32 %r168
  %r169 = load i32, i32* %r167
  call void @putch(i32 %r169)
  br label %bb30

bb32:
  ret void
}

define i32 @main( ) {
main:
  %r175 = alloca i32
  %r170 = call i32 @my_getint()
  %r171 = alloca i32
  store i32 %r170, i32* %r171
  br label %bb33

bb33:
  %r173 = load i32, i32* %r171
  %r172 = icmp sgt i32 %r173, 0
  br i1 %r172, label %bb34, label %bb35

bb34:
  %r174 = call i32 @my_getint()
  store i32 %r174, i32* %r175
  %r176 = load i32, i32* %r175
  call void @my_putint(i32 %r176)
  call void @putch(i32 10)
  %r178 = load i32, i32* %r171
  %r177 = sub i32 %r178, 1
  store i32 %r177, i32* %r171
  br label %bb33

bb35:
  ret i32 0
  ret i32 0
}

