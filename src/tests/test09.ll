declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%A = type { i32 }
define void @test( i32 %r100 ) {
test:
  %r101 = alloca i32
  store i32 %r100, i32* %r101
  %r102 = alloca %A
  %r103 = getelementptr %A, %A* %r102, i32 0, i32 0
  %r104 = load i32, i32* %r101
  store i32 %r104, i32* %r103
  ret void
}

define i32 @main( ) {
main:
  ret i32 1
  ret i32 0
}

