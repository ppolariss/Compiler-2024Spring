declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%A = type { i32 }
@a = global %A zeroinitializer
define i32 @main( ) {
main:
  %r100 = getelementptr %A, %A* @a, i32 0, i32 0
  store i32 1, i32* %r100
  %r101 = getelementptr %A, %A* @a, i32 0, i32 0
  %r102 = load i32, i32* %r101
  ret i32 %r102
  ret i32 0
}

