declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@a = global [ 10 x i32 ] zeroinitializer
@b = global i32 27
@c = global i32 1
define i32 @main( ) {
main:
  call void @_sysy_starttime(i32 4)
  %r100 = alloca i32
  store i32 0, i32* %r100
  %r101 = alloca i32
  store i32 0, i32* %r101
  br label %bb1

bb1:
  %r103 = load i32, i32* %r100
  %r102 = icmp slt i32 %r103, 10
  br i1 %r102, label %bb2, label %bb3

bb2:
  %r105 = load i32, i32* %r100
  %r104 = getelementptr [10 x i32 ], [10 x i32 ]* @a, i32 0, i32 %r105
  %r106 = load i32, i32* %r100
  store i32 %r106, i32* %r104
  %r108 = load i32, i32* %r100
  %r107 = add i32 %r108, 1
  store i32 %r107, i32* %r100
  br label %bb1

bb3:
  store i32 0, i32* %r100
  br label %bb4

bb4:
  %r110 = load i32, i32* %r100
  %r109 = icmp slt i32 %r110, 10
  br i1 %r109, label %bb5, label %bb6

bb5:
  %r112 = load i32, i32* %r100
  %r111 = getelementptr [10 x i32 ], [10 x i32 ]* @a, i32 0, i32 %r112
  %r114 = load i32, i32* %r101
  %r115 = load i32, i32* %r111
  %r113 = add i32 %r114, %r115
  store i32 %r113, i32* %r101
  %r117 = load i32, i32* %r100
  %r116 = add i32 %r117, 1
  store i32 %r116, i32* %r100
  br label %bb4

bb6:
  %r118 = load i32, i32* @b
  call void @putint(i32 %r118)
  %r119 = load i32, i32* @c
  call void @putint(i32 %r119)
  %r120 = load i32, i32* %r101
  call void @putint(i32 %r120)
  call void @_sysy_stoptime(i32 19)
  ret i32 0
  ret i32 0
}

