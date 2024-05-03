declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @mod( i32 %r100, i32 %r102 ) {
mod:
  %r101 = alloca i32
  store i32 %r100, i32* %r101
  %r103 = alloca i32
  store i32 %r102, i32* %r103
  %r105 = load i32, i32* %r101
  %r106 = load i32, i32* %r103
  %r104 = sdiv i32 %r105, %r106
  %r108 = load i32, i32* %r103
  %r107 = mul i32 %r104, %r108
  %r110 = load i32, i32* %r101
  %r109 = sub i32 %r110, %r107
  ret i32 %r109
  ret i32 0
}

define i32 @palindrome( i32 %r111 ) {
palindrome:
  %r134 = alloca i32
  %r126 = alloca i32
  %r112 = alloca i32
  store i32 %r111, i32* %r112
  %r113 = alloca [ 4 x i32 ]
  %r114 = alloca i32
  %r115 = alloca i32
  store i32 0, i32* %r114
  br label %bb1

bb1:
  %r117 = load i32, i32* %r114
  %r116 = icmp slt i32 %r117, 4
  br i1 %r116, label %bb2, label %bb3

bb2:
  %r119 = load i32, i32* %r114
  %r118 = getelementptr [4 x i32 ], [4 x i32 ]* %r113, i32 0, i32 %r119
  %r121 = load i32, i32* %r112
  %r120 = call i32 @mod(i32 %r121, i32 10)
  store i32 %r120, i32* %r118
  %r123 = load i32, i32* %r112
  %r122 = sdiv i32 %r123, 10
  store i32 %r122, i32* %r112
  %r125 = load i32, i32* %r114
  %r124 = add i32 %r125, 1
  store i32 %r124, i32* %r114
  br label %bb1

bb3:
  %r128 = getelementptr [4 x i32 ], [4 x i32 ]* %r113, i32 0, i32 0
  %r129 = load i32, i32* %r128
  %r130 = getelementptr [4 x i32 ], [4 x i32 ]* %r113, i32 0, i32 3
  %r131 = load i32, i32* %r130
  %r127 = icmp eq i32 %r129, %r131
  br i1 %r127, label %bb7, label %bb8

bb7:
  store i32 1, i32* %r126
  br label %bb9

bb8:
  store i32 0, i32* %r126
  br label %bb9

bb9:
  %r132 = load i32, i32* %r126
  %r133 = icmp ne i32 %r132, 0
  br i1 %r133, label %bb10, label %bb5

bb10:
  %r136 = getelementptr [4 x i32 ], [4 x i32 ]* %r113, i32 0, i32 1
  %r137 = load i32, i32* %r136
  %r138 = getelementptr [4 x i32 ], [4 x i32 ]* %r113, i32 0, i32 2
  %r139 = load i32, i32* %r138
  %r135 = icmp eq i32 %r137, %r139
  br i1 %r135, label %bb11, label %bb12

bb11:
  store i32 1, i32* %r134
  br label %bb13

bb12:
  store i32 0, i32* %r134
  br label %bb13

bb13:
  %r140 = load i32, i32* %r134
  %r141 = icmp ne i32 %r140, 0
  br i1 %r141, label %bb4, label %bb5

bb4:
  store i32 1, i32* %r115
  br label %bb6

bb5:
  store i32 0, i32* %r115
  br label %bb6

bb6:
  %r142 = load i32, i32* %r115
  ret i32 %r142
  ret i32 0
}

define i32 @main( ) {
main:
  %r143 = alloca i32
  store i32 1221, i32* %r143
  %r144 = alloca i32
  %r146 = load i32, i32* %r143
  %r145 = call i32 @palindrome(i32 %r146)
  store i32 %r145, i32* %r144
  %r148 = load i32, i32* %r144
  %r147 = icmp eq i32 %r148, 1
  br i1 %r147, label %bb14, label %bb15

bb14:
  %r149 = load i32, i32* %r143
  call void @putint(i32 %r149)
  br label %bb16

bb15:
  store i32 0, i32* %r144
  %r150 = load i32, i32* %r144
  call void @putint(i32 %r150)
  br label %bb16

bb16:
  store i32 10, i32* %r144
  %r151 = load i32, i32* %r144
  call void @putch(i32 %r151)
  ret i32 0
  ret i32 0
}

