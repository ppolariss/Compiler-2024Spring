declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define void @move( i32 %r100, i32 %r102 ) {
move:
  %r101 = alloca i32
  store i32 %r100, i32* %r101
  %r103 = alloca i32
  store i32 %r102, i32* %r103
  %r104 = load i32, i32* %r101
  call void @putint(i32 %r104)
  call void @putch(i32 32)
  %r105 = load i32, i32* %r103
  call void @putint(i32 %r105)
  call void @putch(i32 44)
  call void @putch(i32 32)
  ret void
}

define void @hanoi( i32 %r106, i32 %r108, i32 %r110, i32 %r112 ) {
hanoi:
  %r107 = alloca i32
  store i32 %r106, i32* %r107
  %r109 = alloca i32
  store i32 %r108, i32* %r109
  %r111 = alloca i32
  store i32 %r110, i32* %r111
  %r113 = alloca i32
  store i32 %r112, i32* %r113
  %r115 = load i32, i32* %r107
  %r114 = icmp eq i32 %r115, 1
  br i1 %r114, label %bb1, label %bb2

bb1:
  %r116 = load i32, i32* %r109
  %r117 = load i32, i32* %r113
  call void @move(i32 %r116, i32 %r117)
  br label %bb3

bb2:
  %r119 = load i32, i32* %r107
  %r118 = sub i32 %r119, 1
  %r120 = load i32, i32* %r109
  %r121 = load i32, i32* %r113
  %r122 = load i32, i32* %r111
  call void @hanoi(i32 %r118, i32 %r120, i32 %r121, i32 %r122)
  %r123 = load i32, i32* %r109
  %r124 = load i32, i32* %r113
  call void @move(i32 %r123, i32 %r124)
  %r126 = load i32, i32* %r107
  %r125 = sub i32 %r126, 1
  %r127 = load i32, i32* %r111
  %r128 = load i32, i32* %r109
  %r129 = load i32, i32* %r113
  call void @hanoi(i32 %r125, i32 %r127, i32 %r128, i32 %r129)
  br label %bb3

bb3:
  ret void
}

define i32 @main( ) {
main:
  %r130 = call i32 @getint()
  %r131 = alloca i32
  store i32 %r130, i32* %r131
  br label %bb4

bb4:
  %r133 = load i32, i32* %r131
  %r132 = icmp sgt i32 %r133, 0
  br i1 %r132, label %bb5, label %bb6

bb5:
  %r134 = call i32 @getint()
  call void @hanoi(i32 %r134, i32 1, i32 2, i32 3)
  call void @putch(i32 10)
  %r136 = load i32, i32* %r131
  %r135 = sub i32 %r136, 1
  store i32 %r135, i32* %r131
  br label %bb4

bb6:
  ret i32 0
  ret i32 0
}

