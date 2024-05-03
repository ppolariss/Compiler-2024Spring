declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%A = type { i32 }
%B = type { %A }
define i32 @f( %B* %r100 ) {
f:
  %r101 = getelementptr %B, %B* %r100, i32 0, i32 0
  %r102 = getelementptr %A, %A* %r101, i32 0, i32 0
  %r103 = load i32, i32* %r102
  ret i32 %r103
  ret i32 0
}

define i32 @main( ) {
main:
  %r104 = alloca %B
  %r105 = getelementptr %B, %B* %r104, i32 0, i32 0
  %r106 = getelementptr %A, %A* %r105, i32 0, i32 0
  store i32 1, i32* %r106
  %r107 = call i32 @f(%B* %r104)
  ret i32 %r107
  ret i32 0
}

