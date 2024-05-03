declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%AStruct = type { i32 }
%MyStruct = type { i32, [3 x i32 ], %AStruct, [3 x %AStruct ] }
@a = global i32 0
@a1 = global i32 1
@b = global [ 3 x i32 ] zeroinitializer
@b2 = global [ 3 x i32 ] [ i32 1, i32 2, i32 -3 ]
@c = global %MyStruct zeroinitializer
@d = global [ 3 x %MyStruct ] zeroinitializer
define void @foo( ) {
foo:
  ret void
}

define i32 @main( ) {
main:
  store i32 1, i32* @a
  %r100 = getelementptr [3 x i32 ], [3 x i32 ]* @b, i32 0, i32 1
  store i32 2, i32* %r100
  %r101 = getelementptr %MyStruct, %MyStruct* @c, i32 0, i32 0
  %r102 = add i32 1, 2
  store i32 %r102, i32* %r101
  %r103 = getelementptr %MyStruct, %MyStruct* @c, i32 0, i32 1
  %r104 = getelementptr [3 x i32 ], [3 x i32 ]* %r103, i32 0, i32 1
  %r105 = add i32 2, 2
  %r106 = add i32 %r105, 2
  %r107 = sub i32 %r106, 2
  store i32 %r107, i32* %r104
  %r108 = getelementptr [3 x %MyStruct ], [3 x %MyStruct ]* @d, i32 0, i32 1
  %r109 = getelementptr %MyStruct, %MyStruct* %r108, i32 0, i32 2
  %r110 = getelementptr %AStruct, %AStruct* %r109, i32 0, i32 0
  store i32 5, i32* %r110
  %r111 = getelementptr [3 x %MyStruct ], [3 x %MyStruct ]* @d, i32 0, i32 1
  %r112 = getelementptr %MyStruct, %MyStruct* %r111, i32 0, i32 3
  %r113 = getelementptr [3 x %AStruct ], [3 x %AStruct ]* %r112, i32 0, i32 1
  %r114 = getelementptr %AStruct, %AStruct* %r113, i32 0, i32 0
  store i32 6, i32* %r114
  %r115 = alloca i32
  store i32 1, i32* %r115
  %r117 = load i32, i32* %r115
  %r116 = add i32 %r117, 1
  %r118 = alloca i32
  store i32 %r116, i32* %r118
  %r119 = alloca [ 3 x i32 ]
  %r120 = getelementptr [3 x i32 ], [3 x i32 ]* %r119, i32 0, i32 0
  store i32 1, i32* %r120
  %r121 = getelementptr [3 x i32 ], [3 x i32 ]* %r119, i32 0, i32 1
  store i32 2, i32* %r121
  %r122 = getelementptr [3 x i32 ], [3 x i32 ]* %r119, i32 0, i32 2
  store i32 3, i32* %r122
  %r123 = alloca %MyStruct
  %r124 = alloca [ 3 x %MyStruct ]
  call void @foo()
  %r125 = load i32, i32* %r118
  %r126 = getelementptr [3 x i32 ], [3 x i32 ]* %r119, i32 0, i32 0
  %r127 = getelementptr [3 x %MyStruct ], [3 x %MyStruct ]* %r124, i32 0, i32 0
  call void @bar(i32 %r125, i32* %r126, %MyStruct* %r123, %MyStruct* %r127)
  %r128 = getelementptr %MyStruct, %MyStruct* %r123, i32 0, i32 0
  %r129 = load i32, i32* %r128
  call void @putint(i32 %r129)
  ret i32 0
}

define void @bar( i32 %r130, i32* %r132, %MyStruct* %r133, %MyStruct* %r134 ) {
bar:
  %r161 = alloca i32
  %r153 = alloca i32
  %r148 = alloca i32
  %r147 = alloca i32
  %r141 = alloca i32
  %r131 = alloca i32
  store i32 %r130, i32* %r131
  %r135 = load i32, i32* %r131
  call void @putint(i32 %r135)
  %r136 = getelementptr i32, i32* %r132, i32 1
  store i32 4, i32* %r136
  %r137 = alloca i32
  %r138 = icmp sgt i32 1, 2
  br i1 %r138, label %bb4, label %bb5

bb4:
  store i32 1, i32* %r137
  br label %bb6

bb5:
  store i32 0, i32* %r137
  br label %bb6

bb6:
  %r139 = load i32, i32* %r137
  %r140 = icmp ne i32 %r139, 0
  br i1 %r140, label %bb7, label %bb2

bb7:
  %r143 = call i32 @no_run()
  %r144 = sub i32 0, 1
  %r142 = icmp sgt i32 %r143, %r144
  br i1 %r142, label %bb8, label %bb9

bb8:
  store i32 1, i32* %r141
  br label %bb10

bb9:
  store i32 0, i32* %r141
  br label %bb10

bb10:
  %r145 = load i32, i32* %r141
  %r146 = icmp ne i32 %r145, 0
  br i1 %r146, label %bb1, label %bb2

bb1:
  ret void
  br label %bb3

bb2:
  br label %bb3

bb3:
  store i32 0, i32* %r147
  br label %bb11

bb11:
  %r150 = load i32, i32* %r147
  %r149 = icmp slt i32 %r150, 6
  br i1 %r149, label %bb14, label %bb15

bb14:
  store i32 1, i32* %r148
  br label %bb16

bb15:
  store i32 0, i32* %r148
  br label %bb16

bb16:
  %r151 = load i32, i32* %r148
  %r152 = icmp ne i32 %r151, 0
  br i1 %r152, label %bb17, label %bb13

bb17:
  %r155 = getelementptr i32, i32* %r132, i32 1
  %r156 = load i32, i32* %r155
  %r154 = icmp sgt i32 %r156, 1
  br i1 %r154, label %bb18, label %bb19

bb18:
  store i32 1, i32* %r153
  br label %bb20

bb19:
  store i32 0, i32* %r153
  br label %bb20

bb20:
  %r157 = load i32, i32* %r153
  %r158 = icmp ne i32 %r157, 0
  br i1 %r158, label %bb12, label %bb13

bb12:
  %r160 = load i32, i32* %r147
  %r159 = add i32 %r160, 1
  store i32 %r159, i32* %r161
  %r163 = load i32, i32* %r147
  %r162 = getelementptr %MyStruct, %MyStruct* %r134, i32 %r163
  %r164 = getelementptr %MyStruct, %MyStruct* %r162, i32 0, i32 1
  %r166 = load i32, i32* %r161
  %r165 = getelementptr [3 x i32 ], [3 x i32 ]* %r164, i32 0, i32 %r166
  %r168 = load i32, i32* %r161
  %r167 = mul i32 %r168, 1
  %r170 = load i32, i32* %r147
  %r169 = add i32 %r170, %r167
  store i32 %r169, i32* %r165
  %r172 = load i32, i32* %r147
  %r171 = icmp eq i32 %r172, 1
  br i1 %r171, label %bb21, label %bb22

bb21:
  br label %bb13

  br label %bb23

bb22:
  %r174 = load i32, i32* %r147
  %r173 = add i32 %r174, 1
  store i32 %r173, i32* %r147
  br label %bb11

  br label %bb23

bb23:
  %r176 = load i32, i32* %r147
  %r175 = getelementptr %MyStruct, %MyStruct* %r134, i32 %r176
  %r177 = getelementptr %MyStruct, %MyStruct* %r175, i32 0, i32 1
  %r179 = load i32, i32* %r161
  %r178 = getelementptr [3 x i32 ], [3 x i32 ]* %r177, i32 0, i32 %r179
  %r180 = sub i32 0, 1
  store i32 %r180, i32* %r178
  br label %bb11

bb13:
  %r181 = getelementptr %MyStruct, %MyStruct* %r133, i32 0, i32 0
  %r182 = getelementptr %MyStruct, %MyStruct* %r134, i32 0
  %r183 = getelementptr %MyStruct, %MyStruct* %r182, i32 0, i32 1
  %r184 = getelementptr [3 x i32 ], [3 x i32 ]* %r183, i32 0, i32 1
  %r185 = getelementptr %MyStruct, %MyStruct* %r134, i32 1
  %r186 = getelementptr %MyStruct, %MyStruct* %r185, i32 0, i32 1
  %r187 = getelementptr [3 x i32 ], [3 x i32 ]* %r186, i32 0, i32 2
  %r189 = load i32, i32* %r184
  %r190 = load i32, i32* %r187
  %r188 = add i32 %r189, %r190
  store i32 %r188, i32* %r181
  ret void
}

define i32 @no_run( ) {
no_run:
  call void @putint(i32 10)
  ret i32 0
  ret i32 0
}

