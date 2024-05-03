declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @canJump( i32* %r100, i32 %r101 ) {
canJump:
  %r130 = alloca i32
  %r122 = alloca i32
  %r111 = alloca i32
  %r110 = alloca [ 10 x i32 ]
  %r102 = alloca i32
  store i32 %r101, i32* %r102
  %r104 = load i32, i32* %r102
  %r103 = icmp eq i32 %r104, 1
  br i1 %r103, label %bb1, label %bb2

bb1:
  ret i32 1
  br label %bb3

bb2:
  br label %bb3

bb3:
  %r106 = getelementptr i32, i32* %r100, i32 0
  %r107 = load i32, i32* %r106
  %r109 = load i32, i32* %r102
  %r108 = sub i32 %r109, 2
  %r105 = icmp sgt i32 %r107, %r108
  br i1 %r105, label %bb4, label %bb5

bb4:
  ret i32 1
  br label %bb6

bb5:
  br label %bb6

bb6:
  store i32 0, i32* %r111
  br label %bb7

bb7:
  %r113 = load i32, i32* %r111
  %r115 = load i32, i32* %r102
  %r114 = sub i32 %r115, 1
  %r112 = icmp slt i32 %r113, %r114
  br i1 %r112, label %bb8, label %bb9

bb8:
  %r117 = load i32, i32* %r111
  %r116 = getelementptr [10 x i32 ], [10 x i32 ]* %r110, i32 0, i32 %r117
  store i32 0, i32* %r116
  %r119 = load i32, i32* %r111
  %r118 = add i32 %r119, 1
  store i32 %r118, i32* %r111
  br label %bb7

bb9:
  %r121 = load i32, i32* %r102
  %r120 = sub i32 %r121, 1
  store i32 %r120, i32* %r122
  %r124 = load i32, i32* %r122
  %r123 = getelementptr [10 x i32 ], [10 x i32 ]* %r110, i32 0, i32 %r124
  store i32 1, i32* %r123
  %r126 = load i32, i32* %r102
  %r125 = sub i32 %r126, 2
  store i32 %r125, i32* %r111
  br label %bb10

bb10:
  %r128 = load i32, i32* %r111
  %r129 = sub i32 0, 1
  %r127 = icmp sgt i32 %r128, %r129
  br i1 %r127, label %bb11, label %bb12

bb11:
  %r133 = load i32, i32* %r111
  %r132 = getelementptr i32, i32* %r100, i32 %r133
  %r134 = load i32, i32* %r132
  %r136 = load i32, i32* %r102
  %r135 = sub i32 %r136, 1
  %r138 = load i32, i32* %r111
  %r137 = sub i32 %r135, %r138
  %r131 = icmp slt i32 %r134, %r137
  br i1 %r131, label %bb13, label %bb14

bb13:
  %r140 = load i32, i32* %r111
  %r139 = getelementptr i32, i32* %r100, i32 %r140
  %r141 = load i32, i32* %r139
  store i32 %r141, i32* %r130
  br label %bb15

bb14:
  %r143 = load i32, i32* %r102
  %r142 = sub i32 %r143, 1
  %r145 = load i32, i32* %r111
  %r144 = sub i32 %r142, %r145
  store i32 %r144, i32* %r130
  br label %bb15

bb15:
  br label %bb16

bb16:
  %r147 = load i32, i32* %r130
  %r148 = sub i32 0, 1
  %r146 = icmp sgt i32 %r147, %r148
  br i1 %r146, label %bb17, label %bb18

bb17:
  %r150 = load i32, i32* %r111
  %r151 = load i32, i32* %r130
  %r149 = add i32 %r150, %r151
  store i32 %r149, i32* %r122
  %r154 = load i32, i32* %r122
  %r153 = getelementptr [10 x i32 ], [10 x i32 ]* %r110, i32 0, i32 %r154
  %r155 = load i32, i32* %r153
  %r152 = icmp ne i32 %r155, 0
  br i1 %r152, label %bb19, label %bb20

bb19:
  %r157 = load i32, i32* %r111
  %r156 = getelementptr [10 x i32 ], [10 x i32 ]* %r110, i32 0, i32 %r157
  store i32 1, i32* %r156
  br label %bb21

bb20:
  br label %bb21

bb21:
  %r159 = load i32, i32* %r130
  %r158 = sub i32 %r159, 1
  store i32 %r158, i32* %r130
  br label %bb16

bb18:
  %r161 = load i32, i32* %r111
  %r160 = sub i32 %r161, 1
  store i32 %r160, i32* %r111
  br label %bb10

bb12:
  %r162 = getelementptr [10 x i32 ], [10 x i32 ]* %r110, i32 0, i32 0
  %r163 = load i32, i32* %r162
  ret i32 %r163
  ret i32 0
}

define i32 @main( ) {
main:
  %r164 = alloca i32
  %r165 = alloca [ 10 x i32 ]
  %r166 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 0
  store i32 3, i32* %r166
  %r167 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 1
  store i32 3, i32* %r167
  %r168 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 2
  store i32 9, i32* %r168
  %r169 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 3
  store i32 0, i32* %r169
  %r170 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 4
  store i32 0, i32* %r170
  %r171 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 5
  store i32 1, i32* %r171
  %r172 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 6
  store i32 1, i32* %r172
  %r173 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 7
  store i32 5, i32* %r173
  %r174 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 8
  store i32 7, i32* %r174
  %r175 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 9
  store i32 8, i32* %r175
  store i32 10, i32* %r164
  %r177 = getelementptr [10 x i32 ], [10 x i32 ]* %r165, i32 0, i32 0
  %r178 = load i32, i32* %r164
  %r176 = call i32 @canJump(i32* %r177, i32 %r178)
  store i32 %r176, i32* %r164
  %r179 = load i32, i32* %r164
  ret i32 %r179
  ret i32 0
}

