declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@N = global i32 0
@newline = global i32 0
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

define i32 @split( i32 %r111, i32* %r113 ) {
split:
  %r112 = alloca i32
  store i32 %r111, i32* %r112
  %r114 = alloca i32
  %r116 = load i32, i32* @N
  %r115 = sub i32 %r116, 1
  store i32 %r115, i32* %r114
  br label %bb1

bb1:
  %r118 = load i32, i32* %r114
  %r119 = sub i32 0, 1
  %r117 = icmp ne i32 %r118, %r119
  br i1 %r117, label %bb2, label %bb3

bb2:
  %r121 = load i32, i32* %r114
  %r120 = getelementptr i32, i32* %r113, i32 %r121
  %r123 = load i32, i32* %r112
  %r122 = call i32 @mod(i32 %r123, i32 10)
  store i32 %r122, i32* %r120
  %r125 = load i32, i32* %r112
  %r124 = sdiv i32 %r125, 10
  store i32 %r124, i32* %r112
  %r127 = load i32, i32* %r114
  %r126 = sub i32 %r127, 1
  store i32 %r126, i32* %r114
  br label %bb1

bb3:
  ret i32 0
  ret i32 0
}

define i32 @main( ) {
main:
  store i32 4, i32* @N
  store i32 10, i32* @newline
  %r128 = alloca i32
  %r129 = alloca i32
  %r130 = alloca [ 4 x i32 ]
  store i32 1478, i32* %r129
  %r132 = load i32, i32* %r129
  %r133 = getelementptr [4 x i32 ], [4 x i32 ]* %r130, i32 0, i32 0
  %r131 = call i32 @split(i32 %r132, i32* %r133)
  store i32 %r131, i32* %r129
  %r134 = alloca i32
  store i32 0, i32* %r128
  br label %bb4

bb4:
  %r136 = load i32, i32* %r128
  %r135 = icmp slt i32 %r136, 4
  br i1 %r135, label %bb5, label %bb6

bb5:
  %r138 = load i32, i32* %r128
  %r137 = getelementptr [4 x i32 ], [4 x i32 ]* %r130, i32 0, i32 %r138
  %r139 = load i32, i32* %r137
  store i32 %r139, i32* %r134
  %r140 = load i32, i32* %r134
  call void @putint(i32 %r140)
  %r141 = load i32, i32* @newline
  call void @putch(i32 %r141)
  %r143 = load i32, i32* %r128
  %r142 = add i32 %r143, 1
  store i32 %r142, i32* %r128
  br label %bb4

bb6:
  ret i32 0
  ret i32 0
}

