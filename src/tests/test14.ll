declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@a = global [ 10 x i32 ] zeroinitializer
%b = type { [10 x i32 ] }
define i32 @main( ) {
main:
  %r100 = getelementptr [10 x i32 ], [10 x i32 ]* @a, i32 0, i32 0
  store i32 5, i32* %r100
  %r101 = alloca %b
  %r102 = getelementptr %b, %b* %r101, i32 0, i32 0
  %r103 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 0
  store i32 5, i32* %r103
  %r104 = alloca i32
  %r106 = getelementptr [10 x i32 ], [10 x i32 ]* @a, i32 0, i32 0
  %r107 = load i32, i32* %r106
  %r108 = getelementptr %b, %b* %r101, i32 0, i32 0
  %r109 = getelementptr [10 x i32 ], [10 x i32 ]* %r108, i32 0, i32 0
  %r110 = load i32, i32* %r109
  %r105 = icmp eq i32 %r107, %r110
  br i1 %r105, label %bb1, label %bb2

bb1:
  store i32 1, i32* %r104
  br label %bb3

bb2:
  store i32 0, i32* %r104
  br label %bb3

bb3:
  %r111 = load i32, i32* %r104
  ret i32 %r111
  ret i32 0
}

