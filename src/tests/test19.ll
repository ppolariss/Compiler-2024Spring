declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @main( ) {
main:
  %r100 = alloca [ 10 x i32 ]
  %r101 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 0
  store i32 1, i32* %r101
  %r102 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 1
  store i32 2, i32* %r102
  %r103 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 2
  store i32 3, i32* %r103
  %r104 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 3
  store i32 4, i32* %r104
  %r105 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 4
  store i32 0, i32* %r105
  %r106 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 5
  store i32 0, i32* %r106
  %r107 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 6
  store i32 0, i32* %r107
  %r108 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 7
  store i32 0, i32* %r108
  %r109 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 8
  store i32 0, i32* %r109
  %r110 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 9
  store i32 0, i32* %r110
  %r111 = getelementptr [10 x i32 ], [10 x i32 ]* %r100, i32 0, i32 9
  %r112 = load i32, i32* %r111
  ret i32 %r112
  ret i32 0
}

