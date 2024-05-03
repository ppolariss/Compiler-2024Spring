declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@n = global i32 0
define i32 @Merge( i32* %r100, i32 %r101, i32 %r103, i32 %r105 ) {
Merge:
  %r156 = alloca i32
  %r150 = alloca i32
  %r148 = alloca i32
  %r102 = alloca i32
  store i32 %r101, i32* %r102
  %r104 = alloca i32
  store i32 %r103, i32* %r104
  %r106 = alloca i32
  store i32 %r105, i32* %r106
  %r107 = alloca i32
  %r109 = load i32, i32* %r104
  %r110 = load i32, i32* %r102
  %r108 = sub i32 %r109, %r110
  %r111 = add i32 %r108, 1
  store i32 %r111, i32* %r107
  %r112 = alloca i32
  %r114 = load i32, i32* %r106
  %r115 = load i32, i32* %r104
  %r113 = sub i32 %r114, %r115
  store i32 %r113, i32* %r112
  %r116 = alloca [ 10 x i32 ]
  %r117 = alloca [ 10 x i32 ]
  %r118 = alloca i32
  store i32 0, i32* %r118
  %r119 = alloca i32
  store i32 0, i32* %r119
  %r120 = alloca i32
  br label %bb1

bb1:
  %r122 = load i32, i32* %r118
  %r123 = load i32, i32* %r107
  %r121 = icmp slt i32 %r122, %r123
  br i1 %r121, label %bb2, label %bb3

bb2:
  %r125 = load i32, i32* %r118
  %r126 = load i32, i32* %r102
  %r124 = add i32 %r125, %r126
  store i32 %r124, i32* %r120
  %r128 = load i32, i32* %r118
  %r127 = getelementptr [10 x i32 ], [10 x i32 ]* %r116, i32 0, i32 %r128
  %r130 = load i32, i32* %r120
  %r129 = getelementptr i32, i32* %r100, i32 %r130
  %r131 = load i32, i32* %r129
  store i32 %r131, i32* %r127
  %r133 = load i32, i32* %r118
  %r132 = add i32 %r133, 1
  store i32 %r132, i32* %r118
  br label %bb1

bb3:
  br label %bb4

bb4:
  %r135 = load i32, i32* %r119
  %r136 = load i32, i32* %r112
  %r134 = icmp slt i32 %r135, %r136
  br i1 %r134, label %bb5, label %bb6

bb5:
  %r138 = load i32, i32* %r119
  %r139 = load i32, i32* %r104
  %r137 = add i32 %r138, %r139
  %r140 = add i32 %r137, 1
  store i32 %r140, i32* %r120
  %r142 = load i32, i32* %r119
  %r141 = getelementptr [10 x i32 ], [10 x i32 ]* %r117, i32 0, i32 %r142
  %r144 = load i32, i32* %r120
  %r143 = getelementptr i32, i32* %r100, i32 %r144
  %r145 = load i32, i32* %r143
  store i32 %r145, i32* %r141
  %r147 = load i32, i32* %r119
  %r146 = add i32 %r147, 1
  store i32 %r146, i32* %r119
  br label %bb4

bb6:
  store i32 0, i32* %r118
  store i32 0, i32* %r119
  %r149 = load i32, i32* %r102
  store i32 %r149, i32* %r148
  br label %bb7

bb7:
  %r152 = load i32, i32* %r118
  %r153 = load i32, i32* %r107
  %r151 = icmp ne i32 %r152, %r153
  br i1 %r151, label %bb10, label %bb11

bb10:
  store i32 1, i32* %r150
  br label %bb12

bb11:
  store i32 0, i32* %r150
  br label %bb12

bb12:
  %r154 = load i32, i32* %r150
  %r155 = icmp ne i32 %r154, 0
  br i1 %r155, label %bb13, label %bb9

bb13:
  %r158 = load i32, i32* %r119
  %r159 = load i32, i32* %r112
  %r157 = icmp ne i32 %r158, %r159
  br i1 %r157, label %bb14, label %bb15

bb14:
  store i32 1, i32* %r156
  br label %bb16

bb15:
  store i32 0, i32* %r156
  br label %bb16

bb16:
  %r160 = load i32, i32* %r156
  %r161 = icmp ne i32 %r160, 0
  br i1 %r161, label %bb8, label %bb9

bb8:
  %r164 = load i32, i32* %r118
  %r163 = getelementptr [10 x i32 ], [10 x i32 ]* %r116, i32 0, i32 %r164
  %r165 = load i32, i32* %r163
  %r167 = load i32, i32* %r119
  %r166 = getelementptr [10 x i32 ], [10 x i32 ]* %r117, i32 0, i32 %r167
  %r169 = load i32, i32* %r166
  %r168 = add i32 %r169, 1
  %r162 = icmp slt i32 %r165, %r168
  br i1 %r162, label %bb17, label %bb18

bb17:
  %r171 = load i32, i32* %r148
  %r170 = getelementptr i32, i32* %r100, i32 %r171
  %r173 = load i32, i32* %r118
  %r172 = getelementptr [10 x i32 ], [10 x i32 ]* %r116, i32 0, i32 %r173
  %r174 = load i32, i32* %r172
  store i32 %r174, i32* %r170
  %r176 = load i32, i32* %r148
  %r175 = add i32 %r176, 1
  store i32 %r175, i32* %r148
  %r178 = load i32, i32* %r118
  %r177 = add i32 %r178, 1
  store i32 %r177, i32* %r118
  br label %bb19

bb18:
  %r180 = load i32, i32* %r148
  %r179 = getelementptr i32, i32* %r100, i32 %r180
  %r182 = load i32, i32* %r119
  %r181 = getelementptr [10 x i32 ], [10 x i32 ]* %r117, i32 0, i32 %r182
  %r183 = load i32, i32* %r181
  store i32 %r183, i32* %r179
  %r185 = load i32, i32* %r148
  %r184 = add i32 %r185, 1
  store i32 %r184, i32* %r148
  %r187 = load i32, i32* %r119
  %r186 = add i32 %r187, 1
  store i32 %r186, i32* %r119
  br label %bb19

bb19:
  br label %bb7

bb9:
  br label %bb20

bb20:
  %r189 = load i32, i32* %r118
  %r190 = load i32, i32* %r107
  %r188 = icmp slt i32 %r189, %r190
  br i1 %r188, label %bb21, label %bb22

bb21:
  %r192 = load i32, i32* %r148
  %r191 = getelementptr i32, i32* %r100, i32 %r192
  %r194 = load i32, i32* %r118
  %r193 = getelementptr [10 x i32 ], [10 x i32 ]* %r116, i32 0, i32 %r194
  %r195 = load i32, i32* %r193
  store i32 %r195, i32* %r191
  %r197 = load i32, i32* %r148
  %r196 = add i32 %r197, 1
  store i32 %r196, i32* %r148
  %r199 = load i32, i32* %r118
  %r198 = add i32 %r199, 1
  store i32 %r198, i32* %r118
  br label %bb20

bb22:
  br label %bb23

bb23:
  %r201 = load i32, i32* %r119
  %r202 = load i32, i32* %r112
  %r200 = icmp slt i32 %r201, %r202
  br i1 %r200, label %bb24, label %bb25

bb24:
  %r204 = load i32, i32* %r148
  %r203 = getelementptr i32, i32* %r100, i32 %r204
  %r206 = load i32, i32* %r119
  %r205 = getelementptr [10 x i32 ], [10 x i32 ]* %r117, i32 0, i32 %r206
  %r207 = load i32, i32* %r205
  store i32 %r207, i32* %r203
  %r209 = load i32, i32* %r148
  %r208 = add i32 %r209, 1
  store i32 %r208, i32* %r148
  %r211 = load i32, i32* %r119
  %r210 = add i32 %r211, 1
  store i32 %r210, i32* %r119
  br label %bb23

bb25:
  ret i32 0
  ret i32 0
}

define i32 @MergeSort( i32* %r212, i32 %r213, i32 %r215 ) {
MergeSort:
  %r225 = alloca i32
  %r220 = alloca i32
  %r214 = alloca i32
  store i32 %r213, i32* %r214
  %r216 = alloca i32
  store i32 %r215, i32* %r216
  %r218 = load i32, i32* %r214
  %r219 = load i32, i32* %r216
  %r217 = icmp slt i32 %r218, %r219
  br i1 %r217, label %bb26, label %bb27

bb26:
  %r222 = load i32, i32* %r214
  %r223 = load i32, i32* %r216
  %r221 = add i32 %r222, %r223
  %r224 = sdiv i32 %r221, 2
  store i32 %r224, i32* %r220
  %r227 = getelementptr i32, i32* %r212, i32 0
  %r228 = load i32, i32* %r214
  %r229 = load i32, i32* %r220
  %r226 = call i32 @MergeSort(i32* %r227, i32 %r228, i32 %r229)
  store i32 %r226, i32* %r225
  %r231 = load i32, i32* %r220
  %r230 = add i32 %r231, 1
  store i32 %r230, i32* %r225
  %r233 = getelementptr i32, i32* %r212, i32 0
  %r234 = load i32, i32* %r225
  %r235 = load i32, i32* %r216
  %r232 = call i32 @MergeSort(i32* %r233, i32 %r234, i32 %r235)
  store i32 %r232, i32* %r225
  %r237 = getelementptr i32, i32* %r212, i32 0
  %r238 = load i32, i32* %r214
  %r239 = load i32, i32* %r220
  %r240 = load i32, i32* %r216
  %r236 = call i32 @Merge(i32* %r237, i32 %r238, i32 %r239, i32 %r240)
  store i32 %r236, i32* %r225
  br label %bb28

bb27:
  br label %bb28

bb28:
  ret i32 0
  ret i32 0
}

define i32 @main( ) {
main:
  store i32 10, i32* @n
  %r241 = alloca [ 10 x i32 ]
  %r242 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 0
  store i32 4, i32* %r242
  %r243 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 1
  store i32 3, i32* %r243
  %r244 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 2
  store i32 9, i32* %r244
  %r245 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 3
  store i32 2, i32* %r245
  %r246 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 4
  store i32 0, i32* %r246
  %r247 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 5
  store i32 1, i32* %r247
  %r248 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 6
  store i32 6, i32* %r248
  %r249 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 7
  store i32 5, i32* %r249
  %r250 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 8
  store i32 7, i32* %r250
  %r251 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 9
  store i32 8, i32* %r251
  %r252 = alloca i32
  store i32 0, i32* %r252
  %r253 = alloca i32
  %r255 = load i32, i32* @n
  %r254 = sub i32 %r255, 1
  store i32 %r254, i32* %r253
  %r257 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 0
  %r258 = load i32, i32* %r252
  %r259 = load i32, i32* %r253
  %r256 = call i32 @MergeSort(i32* %r257, i32 %r258, i32 %r259)
  store i32 %r256, i32* %r252
  br label %bb29

bb29:
  %r261 = load i32, i32* %r252
  %r262 = load i32, i32* @n
  %r260 = icmp slt i32 %r261, %r262
  br i1 %r260, label %bb30, label %bb31

bb30:
  %r264 = load i32, i32* %r252
  %r263 = getelementptr [10 x i32 ], [10 x i32 ]* %r241, i32 0, i32 %r264
  %r265 = load i32, i32* %r263
  store i32 %r265, i32* %r253
  %r266 = load i32, i32* %r253
  call void @putint(i32 %r266)
  store i32 10, i32* %r253
  %r267 = load i32, i32* %r253
  call void @putch(i32 %r267)
  %r269 = load i32, i32* %r252
  %r268 = add i32 %r269, 1
  store i32 %r268, i32* %r252
  br label %bb29

bb31:
  ret i32 0
  ret i32 0
}

