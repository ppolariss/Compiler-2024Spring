declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@N = global i32 0
@newline = global i32 0
define i32 @factor( i32 %r100 ) {
factor:
  %r101 = alloca i32
  store i32 %r100, i32* %r101
  %r102 = alloca i32
  %r103 = alloca i32
  store i32 0, i32* %r103
  store i32 1, i32* %r102
  br label %bb1

bb1:
  %r105 = load i32, i32* %r102
  %r107 = load i32, i32* %r101
  %r106 = add i32 %r107, 1
  %r104 = icmp slt i32 %r105, %r106
  br i1 %r104, label %bb2, label %bb3

bb2:
  %r110 = load i32, i32* %r101
  %r111 = load i32, i32* %r102
  %r109 = sdiv i32 %r110, %r111
  %r113 = load i32, i32* %r102
  %r112 = mul i32 %r109, %r113
  %r114 = load i32, i32* %r101
  %r108 = icmp eq i32 %r112, %r114
  br i1 %r108, label %bb4, label %bb5

bb4:
  %r116 = load i32, i32* %r103
  %r117 = load i32, i32* %r102
  %r115 = add i32 %r116, %r117
  store i32 %r115, i32* %r103
  br label %bb6

bb5:
  br label %bb6

bb6:
  %r119 = load i32, i32* %r102
  %r118 = add i32 %r119, 1
  store i32 %r118, i32* %r102
  br label %bb1

bb3:
  %r120 = load i32, i32* %r103
  ret i32 %r120
  ret i32 0
}

define i32 @main( ) {
main:
  call void @_sysy_starttime(i32 24)
  store i32 4, i32* @N
  store i32 10, i32* @newline
  %r121 = alloca i32
  %r122 = alloca i32
  store i32 1478, i32* %r122
  %r123 = alloca i32
  call void @_sysy_stoptime(i32 31)
  %r125 = load i32, i32* %r122
  %r124 = call i32 @factor(i32 %r125)
  ret i32 %r124
  ret i32 0
}

