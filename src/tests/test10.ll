declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%man = type { i32, i32 }
%MyStruct = type { [10 x %man ], %man, [10 x i32 ], %man }
@f = global %MyStruct zeroinitializer
define i32 @main( ) {
main:
  %r100 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 0
  %r101 = getelementptr [10 x %man ], [10 x %man ]* %r100, i32 0, i32 0
  %r102 = getelementptr %man, %man* %r101, i32 0, i32 0
  store i32 1, i32* %r102
  %r103 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 0
  %r104 = getelementptr [10 x %man ], [10 x %man ]* %r103, i32 0, i32 0
  %r105 = getelementptr %man, %man* %r104, i32 0, i32 1
  store i32 2, i32* %r105
  %r106 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 1
  %r107 = getelementptr %man, %man* %r106, i32 0, i32 0
  store i32 3, i32* %r107
  %r108 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 1
  %r109 = getelementptr %man, %man* %r108, i32 0, i32 1
  store i32 4, i32* %r109
  %r110 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 2
  %r111 = getelementptr [10 x i32 ], [10 x i32 ]* %r110, i32 0, i32 0
  store i32 5, i32* %r111
  %r112 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 3
  %r113 = getelementptr %man, %man* %r112, i32 0, i32 0
  store i32 6, i32* %r113
  %r114 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 3
  %r115 = getelementptr %man, %man* %r114, i32 0, i32 1
  %r116 = sub i32 0, 11
  store i32 %r116, i32* %r115
  %r117 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 0
  %r118 = getelementptr [10 x %man ], [10 x %man ]* %r117, i32 0, i32 0
  %r119 = getelementptr %man, %man* %r118, i32 0, i32 0
  %r120 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 0
  %r121 = getelementptr [10 x %man ], [10 x %man ]* %r120, i32 0, i32 0
  %r122 = getelementptr %man, %man* %r121, i32 0, i32 1
  %r124 = load i32, i32* %r119
  %r125 = load i32, i32* %r122
  %r123 = add i32 %r124, %r125
  %r126 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 1
  %r127 = getelementptr %man, %man* %r126, i32 0, i32 0
  %r129 = load i32, i32* %r127
  %r128 = add i32 %r123, %r129
  %r130 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 1
  %r131 = getelementptr %man, %man* %r130, i32 0, i32 1
  %r133 = load i32, i32* %r131
  %r132 = add i32 %r128, %r133
  %r134 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 2
  %r135 = getelementptr [10 x i32 ], [10 x i32 ]* %r134, i32 0, i32 0
  %r137 = load i32, i32* %r135
  %r136 = add i32 %r132, %r137
  %r138 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 3
  %r139 = getelementptr %man, %man* %r138, i32 0, i32 0
  %r141 = load i32, i32* %r139
  %r140 = add i32 %r136, %r141
  %r142 = getelementptr %MyStruct, %MyStruct* @f, i32 0, i32 3
  %r143 = getelementptr %man, %man* %r142, i32 0, i32 1
  %r145 = load i32, i32* %r143
  %r144 = add i32 %r140, %r145
  ret i32 %r144
  ret i32 0
}

