declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @main( ) {
main:
  %r131 = alloca i32
  %r123 = alloca i32
  %r115 = alloca i32
  %r114 = alloca i32
  %r113 = alloca i32
  %r112 = alloca i32
  %r111 = alloca i32
  %r100 = alloca i32
  %r101 = alloca i32
  %r102 = alloca [ 10 x i32 ]
  store i32 0, i32* %r101
  store i32 0, i32* %r100
  br label %bb1

bb1:
  %r104 = load i32, i32* %r100
  %r103 = icmp slt i32 %r104, 10
  br i1 %r103, label %bb2, label %bb3

bb2:
  %r106 = load i32, i32* %r100
  %r105 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 %r106
  %r108 = load i32, i32* %r100
  %r107 = add i32 %r108, 1
  store i32 %r107, i32* %r105
  %r110 = load i32, i32* %r100
  %r109 = add i32 %r110, 1
  store i32 %r109, i32* %r100
  br label %bb1

bb3:
  store i32 10, i32* %r115
  %r116 = call i32 @getint()
  store i32 %r116, i32* %r111
  %r118 = load i32, i32* %r115
  %r117 = sub i32 %r118, 1
  store i32 %r117, i32* %r112
  store i32 0, i32* %r113
  %r120 = load i32, i32* %r112
  %r121 = load i32, i32* %r113
  %r119 = add i32 %r120, %r121
  %r122 = sdiv i32 %r119, 2
  store i32 %r122, i32* %r114
  br label %bb4

bb4:
  %r126 = load i32, i32* %r114
  %r125 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 %r126
  %r127 = load i32, i32* %r125
  %r128 = load i32, i32* %r111
  %r124 = icmp ne i32 %r127, %r128
  br i1 %r124, label %bb7, label %bb8

bb7:
  store i32 1, i32* %r123
  br label %bb9

bb8:
  store i32 0, i32* %r123
  br label %bb9

bb9:
  %r129 = load i32, i32* %r123
  %r130 = icmp ne i32 %r129, 0
  br i1 %r130, label %bb10, label %bb6

bb10:
  %r133 = load i32, i32* %r113
  %r134 = load i32, i32* %r112
  %r132 = icmp slt i32 %r133, %r134
  br i1 %r132, label %bb11, label %bb12

bb11:
  store i32 1, i32* %r131
  br label %bb13

bb12:
  store i32 0, i32* %r131
  br label %bb13

bb13:
  %r135 = load i32, i32* %r131
  %r136 = icmp ne i32 %r135, 0
  br i1 %r136, label %bb5, label %bb6

bb5:
  %r138 = load i32, i32* %r112
  %r139 = load i32, i32* %r113
  %r137 = add i32 %r138, %r139
  %r140 = sdiv i32 %r137, 2
  store i32 %r140, i32* %r114
  %r142 = load i32, i32* %r111
  %r144 = load i32, i32* %r114
  %r143 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 %r144
  %r145 = load i32, i32* %r143
  %r141 = icmp slt i32 %r142, %r145
  br i1 %r141, label %bb14, label %bb15

bb14:
  %r147 = load i32, i32* %r114
  %r146 = sub i32 %r147, 1
  store i32 %r146, i32* %r112
  br label %bb16

bb15:
  %r149 = load i32, i32* %r114
  %r148 = add i32 %r149, 1
  store i32 %r148, i32* %r113
  br label %bb16

bb16:
  br label %bb4

bb6:
  %r151 = load i32, i32* %r111
  %r153 = load i32, i32* %r114
  %r152 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 %r153
  %r154 = load i32, i32* %r152
  %r150 = icmp eq i32 %r151, %r154
  br i1 %r150, label %bb17, label %bb18

bb17:
  %r155 = load i32, i32* %r111
  call void @putint(i32 %r155)
  br label %bb19

bb18:
  store i32 0, i32* %r111
  %r156 = load i32, i32* %r111
  call void @putint(i32 %r156)
  br label %bb19

bb19:
  store i32 10, i32* %r111
  %r157 = load i32, i32* %r111
  call void @putch(i32 %r157)
  ret i32 0
  ret i32 0
}

