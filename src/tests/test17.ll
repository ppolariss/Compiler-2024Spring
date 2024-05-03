declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%MyStruct = type { i32, i32 }
@x = global [ 10 x %MyStruct ] zeroinitializer
@m = global i32 1
@n = global i32 2
define i32 @main( ) {
main:
  %r100 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 1
  %r101 = getelementptr %MyStruct, %MyStruct* %r100, i32 0, i32 0
  store i32 1, i32* %r101
  %r103 = load i32, i32* @n
  %r102 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 %r103
  %r104 = getelementptr %MyStruct, %MyStruct* %r102, i32 0, i32 1
  %r105 = load i32, i32* @m
  store i32 %r105, i32* %r104
  %r107 = load i32, i32* @m
  %r106 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 %r107
  %r108 = getelementptr %MyStruct, %MyStruct* %r106, i32 0, i32 1
  %r109 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 1
  %r110 = getelementptr %MyStruct, %MyStruct* %r109, i32 0, i32 0
  %r111 = load i32, i32* %r110
  store i32 %r111, i32* %r108
  %r113 = load i32, i32* @m
  %r112 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 %r113
  %r114 = getelementptr %MyStruct, %MyStruct* %r112, i32 0, i32 0
  %r116 = load i32, i32* @n
  %r115 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 %r116
  %r117 = getelementptr %MyStruct, %MyStruct* %r115, i32 0, i32 1
  %r118 = load i32, i32* %r117
  store i32 %r118, i32* %r114
  %r119 = alloca i32
  %r122 = load i32, i32* @n
  %r121 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 %r122
  %r123 = getelementptr %MyStruct, %MyStruct* %r121, i32 0, i32 1
  %r124 = load i32, i32* %r123
  %r126 = load i32, i32* @m
  %r125 = getelementptr [10 x %MyStruct ], [10 x %MyStruct ]* @x, i32 0, i32 %r126
  %r127 = getelementptr %MyStruct, %MyStruct* %r125, i32 0, i32 0
  %r128 = load i32, i32* %r127
  %r120 = icmp eq i32 %r124, %r128
  br i1 %r120, label %bb1, label %bb2

bb1:
  store i32 1, i32* %r119
  br label %bb3

bb2:
  store i32 0, i32* %r119
  br label %bb3

bb3:
  %r129 = load i32, i32* %r119
  ret i32 %r129
  ret i32 0
}

