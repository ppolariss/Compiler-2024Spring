declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%next = type { i32 }
%arrary = type { i32, %next }
define i32 @add( %arrary* %r100, %arrary* %r101 ) {
add:
  %r102 = alloca %arrary
  %r103 = getelementptr %arrary, %arrary* %r102, i32 0, i32 0
  %r104 = getelementptr %arrary, %arrary* %r100, i32 0, i32 0
  %r105 = getelementptr %arrary, %arrary* %r101, i32 0, i32 0
  %r107 = load i32, i32* %r104
  %r108 = load i32, i32* %r105
  %r106 = add i32 %r107, %r108
  store i32 %r106, i32* %r103
  %r109 = getelementptr %arrary, %arrary* %r102, i32 0, i32 0
  %r111 = load i32, i32* %r109
  %r110 = add i32 %r111, 1
  ret i32 %r110
  ret i32 0
}

define i32 @main( ) {
main:
  %r112 = alloca %arrary
  %r113 = alloca %arrary
  %r114 = getelementptr %arrary, %arrary* %r112, i32 0, i32 0
  store i32 1, i32* %r114
  %r115 = getelementptr %arrary, %arrary* %r113, i32 0, i32 0
  store i32 2, i32* %r115
  %r116 = call i32 @add(%arrary* %r112, %arrary* %r113)
  ret i32 %r116
  ret i32 0
}

