declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@n = global i32 0
define i32 @swap( i32* %r100, i32 %r101, i32 %r103 ) {
swap:
  %r102 = alloca i32
  store i32 %r101, i32* %r102
  %r104 = alloca i32
  store i32 %r103, i32* %r104
  %r105 = alloca i32
  %r107 = load i32, i32* %r102
  %r106 = getelementptr i32, i32* %r100, i32 %r107
  %r108 = load i32, i32* %r106
  store i32 %r108, i32* %r105
  %r110 = load i32, i32* %r102
  %r109 = getelementptr i32, i32* %r100, i32 %r110
  %r112 = load i32, i32* %r104
  %r111 = getelementptr i32, i32* %r100, i32 %r112
  %r113 = load i32, i32* %r111
  store i32 %r113, i32* %r109
  %r115 = load i32, i32* %r104
  %r114 = getelementptr i32, i32* %r100, i32 %r115
  %r116 = load i32, i32* %r105
  store i32 %r116, i32* %r114
  ret i32 0
  ret i32 0
}

define i32 @heap_ajust( i32* %r117, i32 %r118, i32 %r120 ) {
heap_ajust:
  %r141 = alloca i32
  %r135 = alloca i32
  %r134 = alloca i32
  %r119 = alloca i32
  store i32 %r118, i32* %r119
  %r121 = alloca i32
  store i32 %r120, i32* %r121
  %r122 = alloca i32
  %r123 = load i32, i32* %r119
  store i32 %r123, i32* %r122
  %r124 = alloca i32
  %r126 = load i32, i32* %r122
  %r125 = mul i32 %r126, 2
  %r127 = add i32 %r125, 1
  store i32 %r127, i32* %r124
  br label %bb1

bb1:
  %r129 = load i32, i32* %r124
  %r131 = load i32, i32* %r121
  %r130 = add i32 %r131, 1
  %r128 = icmp slt i32 %r129, %r130
  br i1 %r128, label %bb2, label %bb3

bb2:
  %r133 = load i32, i32* %r124
  %r132 = add i32 %r133, 1
  store i32 %r132, i32* %r134
  %r137 = load i32, i32* %r124
  %r138 = load i32, i32* %r121
  %r136 = icmp slt i32 %r137, %r138
  br i1 %r136, label %bb7, label %bb8

bb7:
  store i32 1, i32* %r135
  br label %bb9

bb8:
  store i32 0, i32* %r135
  br label %bb9

bb9:
  %r139 = load i32, i32* %r135
  %r140 = icmp ne i32 %r139, 0
  br i1 %r140, label %bb10, label %bb5

bb10:
  %r144 = load i32, i32* %r124
  %r143 = getelementptr i32, i32* %r117, i32 %r144
  %r145 = load i32, i32* %r143
  %r147 = load i32, i32* %r134
  %r146 = getelementptr i32, i32* %r117, i32 %r147
  %r148 = load i32, i32* %r146
  %r142 = icmp slt i32 %r145, %r148
  br i1 %r142, label %bb11, label %bb12

bb11:
  store i32 1, i32* %r141
  br label %bb13

bb12:
  store i32 0, i32* %r141
  br label %bb13

bb13:
  %r149 = load i32, i32* %r141
  %r150 = icmp ne i32 %r149, 0
  br i1 %r150, label %bb4, label %bb5

bb4:
  %r152 = load i32, i32* %r124
  %r151 = add i32 %r152, 1
  store i32 %r151, i32* %r124
  br label %bb6

bb5:
  br label %bb6

bb6:
  %r155 = load i32, i32* %r122
  %r154 = getelementptr i32, i32* %r117, i32 %r155
  %r156 = load i32, i32* %r154
  %r158 = load i32, i32* %r124
  %r157 = getelementptr i32, i32* %r117, i32 %r158
  %r159 = load i32, i32* %r157
  %r153 = icmp sgt i32 %r156, %r159
  br i1 %r153, label %bb14, label %bb15

bb14:
  ret i32 0
  br label %bb16

bb15:
  %r161 = getelementptr i32, i32* %r117, i32 0
  %r162 = load i32, i32* %r122
  %r163 = load i32, i32* %r124
  %r160 = call i32 @swap(i32* %r161, i32 %r162, i32 %r163)
  store i32 %r160, i32* %r122
  %r164 = load i32, i32* %r124
  store i32 %r164, i32* %r122
  %r166 = load i32, i32* %r122
  %r165 = mul i32 %r166, 2
  %r167 = add i32 %r165, 1
  store i32 %r167, i32* %r124
  br label %bb16

bb16:
  br label %bb1

bb3:
  ret i32 0
  ret i32 0
}

define i32 @heap_sort( i32* %r168, i32 %r169 ) {
heap_sort:
  %r191 = alloca i32
  %r170 = alloca i32
  store i32 %r169, i32* %r170
  %r171 = alloca i32
  %r172 = alloca i32
  %r174 = load i32, i32* %r170
  %r173 = sdiv i32 %r174, 2
  %r175 = sub i32 %r173, 1
  store i32 %r175, i32* %r171
  br label %bb17

bb17:
  %r177 = load i32, i32* %r171
  %r178 = sub i32 0, 1
  %r176 = icmp sgt i32 %r177, %r178
  br i1 %r176, label %bb18, label %bb19

bb18:
  %r180 = load i32, i32* %r170
  %r179 = sub i32 %r180, 1
  store i32 %r179, i32* %r172
  %r182 = getelementptr i32, i32* %r168, i32 0
  %r183 = load i32, i32* %r171
  %r184 = load i32, i32* %r172
  %r181 = call i32 @heap_ajust(i32* %r182, i32 %r183, i32 %r184)
  store i32 %r181, i32* %r172
  %r186 = load i32, i32* %r171
  %r185 = sub i32 %r186, 1
  store i32 %r185, i32* %r171
  br label %bb17

bb19:
  %r188 = load i32, i32* %r170
  %r187 = sub i32 %r188, 1
  store i32 %r187, i32* %r171
  br label %bb20

bb20:
  %r190 = load i32, i32* %r171
  %r189 = icmp sgt i32 %r190, 0
  br i1 %r189, label %bb21, label %bb22

bb21:
  store i32 0, i32* %r191
  %r193 = getelementptr i32, i32* %r168, i32 0
  %r194 = load i32, i32* %r191
  %r195 = load i32, i32* %r171
  %r192 = call i32 @swap(i32* %r193, i32 %r194, i32 %r195)
  store i32 %r192, i32* %r172
  %r197 = load i32, i32* %r171
  %r196 = sub i32 %r197, 1
  store i32 %r196, i32* %r172
  %r199 = getelementptr i32, i32* %r168, i32 0
  %r200 = load i32, i32* %r191
  %r201 = load i32, i32* %r172
  %r198 = call i32 @heap_ajust(i32* %r199, i32 %r200, i32 %r201)
  store i32 %r198, i32* %r172
  %r203 = load i32, i32* %r171
  %r202 = sub i32 %r203, 1
  store i32 %r202, i32* %r171
  br label %bb20

bb22:
  ret i32 0
  ret i32 0
}

define i32 @main( ) {
main:
  %r222 = alloca i32
  store i32 10, i32* @n
  %r204 = alloca [ 10 x i32 ]
  %r205 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 0
  store i32 4, i32* %r205
  %r206 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 1
  store i32 3, i32* %r206
  %r207 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 2
  store i32 9, i32* %r207
  %r208 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 3
  store i32 2, i32* %r208
  %r209 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 4
  store i32 0, i32* %r209
  %r210 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 5
  store i32 1, i32* %r210
  %r211 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 6
  store i32 6, i32* %r211
  %r212 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 7
  store i32 5, i32* %r212
  %r213 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 8
  store i32 7, i32* %r213
  %r214 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 9
  store i32 8, i32* %r214
  %r215 = alloca i32
  store i32 0, i32* %r215
  %r217 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 0
  %r218 = load i32, i32* @n
  %r216 = call i32 @heap_sort(i32* %r217, i32 %r218)
  store i32 %r216, i32* %r215
  br label %bb23

bb23:
  %r220 = load i32, i32* %r215
  %r221 = load i32, i32* @n
  %r219 = icmp slt i32 %r220, %r221
  br i1 %r219, label %bb24, label %bb25

bb24:
  %r224 = load i32, i32* %r215
  %r223 = getelementptr [10 x i32 ], [10 x i32 ]* %r204, i32 0, i32 %r224
  %r225 = load i32, i32* %r223
  store i32 %r225, i32* %r222
  %r226 = load i32, i32* %r222
  call void @putint(i32 %r226)
  store i32 10, i32* %r222
  %r227 = load i32, i32* %r222
  call void @putch(i32 %r227)
  %r229 = load i32, i32* %r215
  %r228 = add i32 %r229, 1
  store i32 %r228, i32* %r215
  br label %bb23

bb25:
  ret i32 0
  ret i32 0
}

