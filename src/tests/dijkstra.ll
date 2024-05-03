declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@INF = global i32 65535
%array2D = type { [16 x i32 ] }
@e = global [ 16 x %array2D ] zeroinitializer
@book = global [ 16 x i32 ] zeroinitializer
@dis = global [ 16 x i32 ] zeroinitializer
@n = global i32 0
@m = global i32 0
@v1 = global i32 0
@v2 = global i32 0
@w = global i32 0
define void @Dijkstra( ) {
Dijkstra:
  %r150 = alloca i32
  %r135 = alloca i32
  %r127 = alloca i32
  %r123 = alloca i32
  %r122 = alloca i32
  %r121 = alloca i32
  %r100 = alloca i32
  store i32 1, i32* %r100
  br label %bb1

bb1:
  %r102 = load i32, i32* %r100
  %r103 = load i32, i32* @n
  %r101 = icmp sle i32 %r102, %r103
  br i1 %r101, label %bb2, label %bb3

bb2:
  %r105 = load i32, i32* %r100
  %r104 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r105
  %r106 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 1
  %r107 = getelementptr %array2D, %array2D* %r106, i32 0, i32 0
  %r109 = load i32, i32* %r100
  %r108 = getelementptr [16 x i32 ], [16 x i32 ]* %r107, i32 0, i32 %r109
  %r110 = load i32, i32* %r108
  store i32 %r110, i32* %r104
  %r112 = load i32, i32* %r100
  %r111 = getelementptr [16 x i32 ], [16 x i32 ]* @book, i32 0, i32 %r112
  store i32 0, i32* %r111
  %r114 = load i32, i32* %r100
  %r113 = add i32 %r114, 1
  store i32 %r113, i32* %r100
  br label %bb1

bb3:
  %r115 = getelementptr [16 x i32 ], [16 x i32 ]* @book, i32 0, i32 1
  store i32 1, i32* %r115
  store i32 1, i32* %r100
  br label %bb4

bb4:
  %r117 = load i32, i32* %r100
  %r119 = load i32, i32* @n
  %r118 = sub i32 %r119, 1
  %r116 = icmp sle i32 %r117, %r118
  br i1 %r116, label %bb5, label %bb6

bb5:
  %r120 = load i32, i32* @INF
  store i32 %r120, i32* %r121
  store i32 0, i32* %r122
  store i32 1, i32* %r123
  br label %bb7

bb7:
  %r125 = load i32, i32* %r123
  %r126 = load i32, i32* @n
  %r124 = icmp sle i32 %r125, %r126
  br i1 %r124, label %bb8, label %bb9

bb8:
  %r129 = load i32, i32* %r121
  %r131 = load i32, i32* %r123
  %r130 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r131
  %r132 = load i32, i32* %r130
  %r128 = icmp sgt i32 %r129, %r132
  br i1 %r128, label %bb13, label %bb14

bb13:
  store i32 1, i32* %r127
  br label %bb15

bb14:
  store i32 0, i32* %r127
  br label %bb15

bb15:
  %r133 = load i32, i32* %r127
  %r134 = icmp ne i32 %r133, 0
  br i1 %r134, label %bb16, label %bb11

bb16:
  %r138 = load i32, i32* %r123
  %r137 = getelementptr [16 x i32 ], [16 x i32 ]* @book, i32 0, i32 %r138
  %r139 = load i32, i32* %r137
  %r136 = icmp eq i32 %r139, 0
  br i1 %r136, label %bb17, label %bb18

bb17:
  store i32 1, i32* %r135
  br label %bb19

bb18:
  store i32 0, i32* %r135
  br label %bb19

bb19:
  %r140 = load i32, i32* %r135
  %r141 = icmp ne i32 %r140, 0
  br i1 %r141, label %bb10, label %bb11

bb10:
  %r143 = load i32, i32* %r123
  %r142 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r143
  %r144 = load i32, i32* %r142
  store i32 %r144, i32* %r121
  %r145 = load i32, i32* %r123
  store i32 %r145, i32* %r122
  br label %bb12

bb11:
  br label %bb12

bb12:
  %r147 = load i32, i32* %r123
  %r146 = add i32 %r147, 1
  store i32 %r146, i32* %r123
  br label %bb7

bb9:
  %r149 = load i32, i32* %r122
  %r148 = getelementptr [16 x i32 ], [16 x i32 ]* @book, i32 0, i32 %r149
  store i32 1, i32* %r148
  store i32 1, i32* %r150
  br label %bb20

bb20:
  %r152 = load i32, i32* %r150
  %r153 = load i32, i32* @n
  %r151 = icmp sle i32 %r152, %r153
  br i1 %r151, label %bb21, label %bb22

bb21:
  %r156 = load i32, i32* %r122
  %r155 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 %r156
  %r157 = getelementptr %array2D, %array2D* %r155, i32 0, i32 0
  %r159 = load i32, i32* %r150
  %r158 = getelementptr [16 x i32 ], [16 x i32 ]* %r157, i32 0, i32 %r159
  %r160 = load i32, i32* %r158
  %r161 = load i32, i32* @INF
  %r154 = icmp slt i32 %r160, %r161
  br i1 %r154, label %bb23, label %bb24

bb23:
  %r164 = load i32, i32* %r150
  %r163 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r164
  %r165 = load i32, i32* %r163
  %r167 = load i32, i32* %r122
  %r166 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r167
  %r169 = load i32, i32* %r122
  %r168 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 %r169
  %r170 = getelementptr %array2D, %array2D* %r168, i32 0, i32 0
  %r172 = load i32, i32* %r150
  %r171 = getelementptr [16 x i32 ], [16 x i32 ]* %r170, i32 0, i32 %r172
  %r174 = load i32, i32* %r166
  %r175 = load i32, i32* %r171
  %r173 = add i32 %r174, %r175
  %r162 = icmp sgt i32 %r165, %r173
  br i1 %r162, label %bb26, label %bb27

bb26:
  %r177 = load i32, i32* %r150
  %r176 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r177
  %r179 = load i32, i32* %r122
  %r178 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r179
  %r181 = load i32, i32* %r122
  %r180 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 %r181
  %r182 = getelementptr %array2D, %array2D* %r180, i32 0, i32 0
  %r184 = load i32, i32* %r150
  %r183 = getelementptr [16 x i32 ], [16 x i32 ]* %r182, i32 0, i32 %r184
  %r186 = load i32, i32* %r178
  %r187 = load i32, i32* %r183
  %r185 = add i32 %r186, %r187
  store i32 %r185, i32* %r176
  br label %bb28

bb27:
  br label %bb28

bb28:
  br label %bb25

bb24:
  br label %bb25

bb25:
  %r189 = load i32, i32* %r150
  %r188 = add i32 %r189, 1
  store i32 %r188, i32* %r150
  br label %bb20

bb22:
  %r191 = load i32, i32* %r100
  %r190 = add i32 %r191, 1
  store i32 %r190, i32* %r100
  br label %bb4

bb6:
  ret void
}

define i32 @main( ) {
main:
  %r226 = alloca i32
  %r224 = alloca i32
  %r198 = alloca i32
  %r192 = alloca i32
  %r193 = call i32 @getint()
  store i32 %r193, i32* @n
  %r194 = call i32 @getint()
  store i32 %r194, i32* @m
  store i32 1, i32* %r192
  br label %bb29

bb29:
  %r196 = load i32, i32* %r192
  %r197 = load i32, i32* @n
  %r195 = icmp sle i32 %r196, %r197
  br i1 %r195, label %bb30, label %bb31

bb30:
  store i32 1, i32* %r198
  br label %bb32

bb32:
  %r200 = load i32, i32* %r198
  %r201 = load i32, i32* @n
  %r199 = icmp sle i32 %r200, %r201
  br i1 %r199, label %bb33, label %bb34

bb33:
  %r203 = load i32, i32* %r192
  %r204 = load i32, i32* %r198
  %r202 = icmp eq i32 %r203, %r204
  br i1 %r202, label %bb35, label %bb36

bb35:
  %r206 = load i32, i32* %r192
  %r205 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 %r206
  %r207 = getelementptr %array2D, %array2D* %r205, i32 0, i32 0
  %r209 = load i32, i32* %r198
  %r208 = getelementptr [16 x i32 ], [16 x i32 ]* %r207, i32 0, i32 %r209
  store i32 0, i32* %r208
  br label %bb37

bb36:
  %r211 = load i32, i32* %r192
  %r210 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 %r211
  %r212 = getelementptr %array2D, %array2D* %r210, i32 0, i32 0
  %r214 = load i32, i32* %r198
  %r213 = getelementptr [16 x i32 ], [16 x i32 ]* %r212, i32 0, i32 %r214
  %r215 = load i32, i32* @INF
  store i32 %r215, i32* %r213
  br label %bb37

bb37:
  %r217 = load i32, i32* %r198
  %r216 = add i32 %r217, 1
  store i32 %r216, i32* %r198
  br label %bb32

bb34:
  %r219 = load i32, i32* %r192
  %r218 = add i32 %r219, 1
  store i32 %r218, i32* %r192
  br label %bb29

bb31:
  store i32 1, i32* %r192
  br label %bb38

bb38:
  %r221 = load i32, i32* %r192
  %r222 = load i32, i32* @m
  %r220 = icmp sle i32 %r221, %r222
  br i1 %r220, label %bb39, label %bb40

bb39:
  %r223 = call i32 @getint()
  store i32 %r223, i32* %r224
  %r225 = call i32 @getint()
  store i32 %r225, i32* %r226
  %r228 = load i32, i32* %r224
  %r227 = getelementptr [16 x %array2D ], [16 x %array2D ]* @e, i32 0, i32 %r228
  %r229 = getelementptr %array2D, %array2D* %r227, i32 0, i32 0
  %r231 = load i32, i32* %r226
  %r230 = getelementptr [16 x i32 ], [16 x i32 ]* %r229, i32 0, i32 %r231
  %r232 = call i32 @getint()
  store i32 %r232, i32* %r230
  %r234 = load i32, i32* %r192
  %r233 = add i32 %r234, 1
  store i32 %r233, i32* %r192
  br label %bb38

bb40:
  call void @Dijkstra()
  store i32 1, i32* %r192
  br label %bb41

bb41:
  %r236 = load i32, i32* %r192
  %r237 = load i32, i32* @n
  %r235 = icmp sle i32 %r236, %r237
  br i1 %r235, label %bb42, label %bb43

bb42:
  %r239 = load i32, i32* %r192
  %r238 = getelementptr [16 x i32 ], [16 x i32 ]* @dis, i32 0, i32 %r239
  %r240 = load i32, i32* %r238
  call void @putint(i32 %r240)
  call void @putch(i32 32)
  %r242 = load i32, i32* %r192
  %r241 = add i32 %r242, 1
  store i32 %r241, i32* %r192
  br label %bb41

bb43:
  call void @putch(i32 10)
  ret i32 0
  ret i32 0
}

