declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@a = global i32 1
define i32 @foo( i32 %r100 ) {
foo:
  %r101 = alloca i32
  store i32 %r100, i32* %r101
  %r102 = load i32, i32* %r101
  store i32 %r102, i32* @a
  ret i32 1
  ret i32 0
}

define i32 @main( ) {
main:
  %r109 = alloca i32
  call void @_sysy_starttime(i32 9)
  %r103 = alloca i32
  store i32 1, i32* %r103
  %r104 = alloca i32
  %r106 = call i32 @foo(i32 2)
  %r105 = icmp sgt i32 %r106, 0
  br i1 %r105, label %bb4, label %bb5

bb4:
  store i32 1, i32* %r104
  br label %bb6

bb5:
  store i32 0, i32* %r104
  br label %bb6

bb6:
  %r107 = load i32, i32* %r104
  %r108 = icmp ne i32 %r107, 0
  br i1 %r108, label %bb1, label %bb7

bb7:
  %r111 = call i32 @foo(i32 3)
  %r110 = icmp sgt i32 %r111, 0
  br i1 %r110, label %bb8, label %bb9

bb8:
  store i32 1, i32* %r109
  br label %bb10

bb9:
  store i32 0, i32* %r109
  br label %bb10

bb10:
  %r112 = load i32, i32* %r109
  %r113 = icmp ne i32 %r112, 0
  br i1 %r113, label %bb1, label %bb2

bb1:
  store i32 2, i32* %r103
  br label %bb3

bb2:
  br label %bb3

bb3:
  %r114 = load i32, i32* @a
  call void @putint(i32 %r114)
  %r115 = load i32, i32* %r103
  call void @putint(i32 %r115)
  call void @_sysy_stoptime(i32 17)
  ret i32 0
  ret i32 0
}

