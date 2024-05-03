declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @main( ) {
main:
  %r130 = alloca i32
  %r125 = alloca i32
  %r124 = alloca i32
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
  store i32 0, i32* %r123
  store i32 0, i32* %r100
  store i32 0, i32* %r124
  br label %bb4

bb4:
  %r127 = load i32, i32* %r100
  %r126 = icmp slt i32 %r127, 10
  br i1 %r126, label %bb7, label %bb8

bb7:
  store i32 1, i32* %r125
  br label %bb9

bb8:
  store i32 0, i32* %r125
  br label %bb9

bb9:
  %r128 = load i32, i32* %r125
  %r129 = icmp ne i32 %r128, 0
  br i1 %r129, label %bb10, label %bb6

bb10:
  %r132 = load i32, i32* %r123
  %r131 = icmp eq i32 %r132, 0
  br i1 %r131, label %bb11, label %bb12

bb11:
  store i32 1, i32* %r130
  br label %bb13

bb12:
  store i32 0, i32* %r130
  br label %bb13

bb13:
  %r133 = load i32, i32* %r130
  %r134 = icmp ne i32 %r133, 0
  br i1 %r134, label %bb5, label %bb6

bb5:
  %r137 = load i32, i32* %r100
  %r136 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 %r137
  %r138 = load i32, i32* %r136
  %r139 = load i32, i32* %r111
  %r135 = icmp eq i32 %r138, %r139
  br i1 %r135, label %bb14, label %bb15

bb14:
  store i32 1, i32* %r123
  %r140 = load i32, i32* %r100
  store i32 %r140, i32* %r124
  br label %bb16

bb15:
  br label %bb16

bb16:
  %r142 = load i32, i32* %r100
  %r141 = add i32 %r142, 1
  store i32 %r141, i32* %r100
  br label %bb4

bb6:
  %r144 = load i32, i32* %r123
  %r143 = icmp eq i32 %r144, 1
  br i1 %r143, label %bb17, label %bb18

bb17:
  %r145 = load i32, i32* %r124
  call void @putint(i32 %r145)
  br label %bb19

bb18:
  store i32 0, i32* %r111
  %r146 = load i32, i32* %r111
  call void @putint(i32 %r146)
  br label %bb19

bb19:
  store i32 10, i32* %r111
  %r147 = load i32, i32* %r111
  call void @putch(i32 %r147)
  ret i32 0
  ret i32 0
}

