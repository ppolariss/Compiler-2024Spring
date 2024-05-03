; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.timeval = type { i64, i64 }
%array2D = type { [5 x i32] }

@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @before_main, i8* null }]
@llvm.global_dtors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @after_main, i8* null }]
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%d:\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c" %d\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@_sysy_us = dso_local global [1024 x i32] zeroinitializer, align 16
@_sysy_s = dso_local global [1024 x i32] zeroinitializer, align 16
@_sysy_m = dso_local global [1024 x i32] zeroinitializer, align 16
@_sysy_h = dso_local global [1024 x i32] zeroinitializer, align 16
@_sysy_idx = dso_local global i32 0, align 4
@stderr = external global %struct._IO_FILE*, align 8
@.str.5 = private unnamed_addr constant [35 x i8] c"Timer@%04d-%04d: %dH-%dM-%dS-%dus\0A\00", align 1
@_sysy_l1 = dso_local global [1024 x i32] zeroinitializer, align 16
@_sysy_l2 = dso_local global [1024 x i32] zeroinitializer, align 16
@.str.6 = private unnamed_addr constant [25 x i8] c"TOTAL: %dH-%dM-%dS-%dus\0A\00", align 1
@_sysy_start = dso_local global %struct.timeval zeroinitializer, align 8
@_sysy_end = dso_local global %struct.timeval zeroinitializer, align 8

define i32 @relu_reg(i32 %r100) {
relu_reg:
  %r101 = alloca i32, align 4
  store i32 %r100, i32* %r101, align 4
  %r103 = load i32, i32* %r101, align 4
  %r102 = icmp sgt i32 %r103, 127
  br i1 %r102, label %bb1, label %bb2

bb1:                                              ; preds = %relu_reg
  ret i32 127

0:                                                ; No predecessors!
  br label %bb3

bb2:                                              ; preds = %relu_reg
  br label %bb3

bb3:                                              ; preds = %bb2, %0
  %r105 = load i32, i32* %r101, align 4
  %r104 = icmp slt i32 %r105, 0
  br i1 %r104, label %bb4, label %bb5

bb4:                                              ; preds = %bb3
  ret i32 0

1:                                                ; No predecessors!
  br label %bb6

bb5:                                              ; preds = %bb3
  br label %bb6

bb6:                                              ; preds = %bb5, %1
  %r106 = load i32, i32* %r101, align 4
  ret i32 %r106

2:                                                ; No predecessors!
  ret i32 0
}

define i32 @model(%array2D* %r107) {
model:
  %r110 = getelementptr %array2D, %array2D* %r107, i32 0
  %r111 = getelementptr %array2D, %array2D* %r110, i32 0, i32 0
  %r112 = getelementptr [5 x i32], [5 x i32]* %r111, i32 0, i32 0
  %r114 = load i32, i32* %r112, align 4
  %r113 = mul i32 %r114, 85
  %r115 = getelementptr %array2D, %array2D* %r107, i32 0
  %r116 = getelementptr %array2D, %array2D* %r115, i32 0, i32 0
  %r117 = getelementptr [5 x i32], [5 x i32]* %r116, i32 0, i32 1
  %r119 = load i32, i32* %r117, align 4
  %r118 = mul i32 %r119, 23
  %r120 = add i32 %r113, %r118
  %r121 = getelementptr %array2D, %array2D* %r107, i32 0
  %r122 = getelementptr %array2D, %array2D* %r121, i32 0, i32 0
  %r123 = getelementptr [5 x i32], [5 x i32]* %r122, i32 0, i32 2
  %r124 = sub i32 0, 82
  %r126 = load i32, i32* %r123, align 4
  %r125 = mul i32 %r126, %r124
  %r127 = add i32 %r120, %r125
  %r128 = getelementptr %array2D, %array2D* %r107, i32 0
  %r129 = getelementptr %array2D, %array2D* %r128, i32 0, i32 0
  %r130 = getelementptr [5 x i32], [5 x i32]* %r129, i32 0, i32 3
  %r131 = sub i32 0, 103
  %r133 = load i32, i32* %r130, align 4
  %r132 = mul i32 %r133, %r131
  %r134 = add i32 %r127, %r132
  %r135 = getelementptr %array2D, %array2D* %r107, i32 0
  %r136 = getelementptr %array2D, %array2D* %r135, i32 0, i32 0
  %r137 = getelementptr [5 x i32], [5 x i32]* %r136, i32 0, i32 4
  %r138 = sub i32 0, 123
  %r140 = load i32, i32* %r137, align 4
  %r139 = mul i32 %r140, %r138
  %r141 = add i32 %r134, %r139
  %r142 = getelementptr %array2D, %array2D* %r107, i32 1
  %r143 = getelementptr %array2D, %array2D* %r142, i32 0, i32 0
  %r144 = getelementptr [5 x i32], [5 x i32]* %r143, i32 0, i32 0
  %r146 = load i32, i32* %r144, align 4
  %r145 = mul i32 %r146, 64
  %r147 = add i32 %r141, %r145
  %r148 = getelementptr %array2D, %array2D* %r107, i32 1
  %r149 = getelementptr %array2D, %array2D* %r148, i32 0, i32 0
  %r150 = getelementptr [5 x i32], [5 x i32]* %r149, i32 0, i32 1
  %r151 = sub i32 0, 120
  %r153 = load i32, i32* %r150, align 4
  %r152 = mul i32 %r153, %r151
  %r154 = add i32 %r147, %r152
  %r155 = getelementptr %array2D, %array2D* %r107, i32 1
  %r156 = getelementptr %array2D, %array2D* %r155, i32 0, i32 0
  %r157 = getelementptr [5 x i32], [5 x i32]* %r156, i32 0, i32 2
  %r159 = load i32, i32* %r157, align 4
  %r158 = mul i32 %r159, 50
  %r160 = add i32 %r154, %r158
  %r161 = getelementptr %array2D, %array2D* %r107, i32 1
  %r162 = getelementptr %array2D, %array2D* %r161, i32 0, i32 0
  %r163 = getelementptr [5 x i32], [5 x i32]* %r162, i32 0, i32 3
  %r164 = sub i32 0, 59
  %r166 = load i32, i32* %r163, align 4
  %r165 = mul i32 %r166, %r164
  %r167 = add i32 %r160, %r165
  %r168 = getelementptr %array2D, %array2D* %r107, i32 1
  %r169 = getelementptr %array2D, %array2D* %r168, i32 0, i32 0
  %r170 = getelementptr [5 x i32], [5 x i32]* %r169, i32 0, i32 4
  %r172 = load i32, i32* %r170, align 4
  %r171 = mul i32 %r172, 47
  %r173 = add i32 %r167, %r171
  %r174 = getelementptr %array2D, %array2D* %r107, i32 2
  %r175 = getelementptr %array2D, %array2D* %r174, i32 0, i32 0
  %r176 = getelementptr [5 x i32], [5 x i32]* %r175, i32 0, i32 0
  %r177 = sub i32 0, 111
  %r179 = load i32, i32* %r176, align 4
  %r178 = mul i32 %r179, %r177
  %r180 = add i32 %r173, %r178
  %r181 = getelementptr %array2D, %array2D* %r107, i32 2
  %r182 = getelementptr %array2D, %array2D* %r181, i32 0, i32 0
  %r183 = getelementptr [5 x i32], [5 x i32]* %r182, i32 0, i32 1
  %r184 = sub i32 0, 67
  %r186 = load i32, i32* %r183, align 4
  %r185 = mul i32 %r186, %r184
  %r187 = add i32 %r180, %r185
  %r188 = getelementptr %array2D, %array2D* %r107, i32 2
  %r189 = getelementptr %array2D, %array2D* %r188, i32 0, i32 0
  %r190 = getelementptr [5 x i32], [5 x i32]* %r189, i32 0, i32 2
  %r191 = sub i32 0, 106
  %r193 = load i32, i32* %r190, align 4
  %r192 = mul i32 %r193, %r191
  %r194 = add i32 %r187, %r192
  %r195 = getelementptr %array2D, %array2D* %r107, i32 2
  %r196 = getelementptr %array2D, %array2D* %r195, i32 0, i32 0
  %r197 = getelementptr [5 x i32], [5 x i32]* %r196, i32 0, i32 3
  %r198 = sub i32 0, 75
  %r200 = load i32, i32* %r197, align 4
  %r199 = mul i32 %r200, %r198
  %r201 = add i32 %r194, %r199
  %r202 = getelementptr %array2D, %array2D* %r107, i32 2
  %r203 = getelementptr %array2D, %array2D* %r202, i32 0, i32 0
  %r204 = getelementptr [5 x i32], [5 x i32]* %r203, i32 0, i32 4
  %r205 = sub i32 0, 102
  %r207 = load i32, i32* %r204, align 4
  %r206 = mul i32 %r207, %r205
  %r208 = add i32 %r201, %r206
  %r209 = getelementptr %array2D, %array2D* %r107, i32 3
  %r210 = getelementptr %array2D, %array2D* %r209, i32 0, i32 0
  %r211 = getelementptr [5 x i32], [5 x i32]* %r210, i32 0, i32 0
  %r213 = load i32, i32* %r211, align 4
  %r212 = mul i32 %r213, 34
  %r214 = add i32 %r208, %r212
  %r215 = getelementptr %array2D, %array2D* %r107, i32 3
  %r216 = getelementptr %array2D, %array2D* %r215, i32 0, i32 0
  %r217 = getelementptr [5 x i32], [5 x i32]* %r216, i32 0, i32 1
  %r218 = sub i32 0, 39
  %r220 = load i32, i32* %r217, align 4
  %r219 = mul i32 %r220, %r218
  %r221 = add i32 %r214, %r219
  %r222 = getelementptr %array2D, %array2D* %r107, i32 3
  %r223 = getelementptr %array2D, %array2D* %r222, i32 0, i32 0
  %r224 = getelementptr [5 x i32], [5 x i32]* %r223, i32 0, i32 2
  %r226 = load i32, i32* %r224, align 4
  %r225 = mul i32 %r226, 65
  %r227 = add i32 %r221, %r225
  %r228 = getelementptr %array2D, %array2D* %r107, i32 3
  %r229 = getelementptr %array2D, %array2D* %r228, i32 0, i32 0
  %r230 = getelementptr [5 x i32], [5 x i32]* %r229, i32 0, i32 3
  %r232 = load i32, i32* %r230, align 4
  %r231 = mul i32 %r232, 47
  %r233 = add i32 %r227, %r231
  %r234 = getelementptr %array2D, %array2D* %r107, i32 3
  %r235 = getelementptr %array2D, %array2D* %r234, i32 0, i32 0
  %r236 = getelementptr [5 x i32], [5 x i32]* %r235, i32 0, i32 4
  %r238 = load i32, i32* %r236, align 4
  %r237 = mul i32 %r238, 113
  %r239 = add i32 %r233, %r237
  %r240 = getelementptr %array2D, %array2D* %r107, i32 4
  %r241 = getelementptr %array2D, %array2D* %r240, i32 0, i32 0
  %r242 = getelementptr [5 x i32], [5 x i32]* %r241, i32 0, i32 0
  %r244 = load i32, i32* %r242, align 4
  %r243 = mul i32 %r244, 110
  %r245 = add i32 %r239, %r243
  %r246 = getelementptr %array2D, %array2D* %r107, i32 4
  %r247 = getelementptr %array2D, %array2D* %r246, i32 0, i32 0
  %r248 = getelementptr [5 x i32], [5 x i32]* %r247, i32 0, i32 1
  %r250 = load i32, i32* %r248, align 4
  %r249 = mul i32 %r250, 47
  %r251 = add i32 %r245, %r249
  %r252 = getelementptr %array2D, %array2D* %r107, i32 4
  %r253 = getelementptr %array2D, %array2D* %r252, i32 0, i32 0
  %r254 = getelementptr [5 x i32], [5 x i32]* %r253, i32 0, i32 2
  %r255 = sub i32 0, 4
  %r257 = load i32, i32* %r254, align 4
  %r256 = mul i32 %r257, %r255
  %r258 = add i32 %r251, %r256
  %r259 = getelementptr %array2D, %array2D* %r107, i32 4
  %r260 = getelementptr %array2D, %array2D* %r259, i32 0, i32 0
  %r261 = getelementptr [5 x i32], [5 x i32]* %r260, i32 0, i32 3
  %r263 = load i32, i32* %r261, align 4
  %r262 = mul i32 %r263, 80
  %r264 = add i32 %r258, %r262
  %r265 = getelementptr %array2D, %array2D* %r107, i32 4
  %r266 = getelementptr %array2D, %array2D* %r265, i32 0, i32 0
  %r267 = getelementptr [5 x i32], [5 x i32]* %r266, i32 0, i32 4
  %r269 = load i32, i32* %r267, align 4
  %r268 = mul i32 %r269, 46
  %r270 = add i32 %r264, %r268
  %r109 = call i32 @relu_reg(i32 %r270)
  %r271 = mul i32 %r109, 39
  %r273 = getelementptr %array2D, %array2D* %r107, i32 0
  %r274 = getelementptr %array2D, %array2D* %r273, i32 0, i32 0
  %r275 = getelementptr [5 x i32], [5 x i32]* %r274, i32 0, i32 0
  %r276 = sub i32 0, 106
  %r278 = load i32, i32* %r275, align 4
  %r277 = mul i32 %r278, %r276
  %r279 = getelementptr %array2D, %array2D* %r107, i32 0
  %r280 = getelementptr %array2D, %array2D* %r279, i32 0, i32 0
  %r281 = getelementptr [5 x i32], [5 x i32]* %r280, i32 0, i32 1
  %r283 = load i32, i32* %r281, align 4
  %r282 = mul i32 %r283, 126
  %r284 = add i32 %r277, %r282
  %r285 = getelementptr %array2D, %array2D* %r107, i32 0
  %r286 = getelementptr %array2D, %array2D* %r285, i32 0, i32 0
  %r287 = getelementptr [5 x i32], [5 x i32]* %r286, i32 0, i32 2
  %r288 = sub i32 0, 18
  %r290 = load i32, i32* %r287, align 4
  %r289 = mul i32 %r290, %r288
  %r291 = add i32 %r284, %r289
  %r292 = getelementptr %array2D, %array2D* %r107, i32 0
  %r293 = getelementptr %array2D, %array2D* %r292, i32 0, i32 0
  %r294 = getelementptr [5 x i32], [5 x i32]* %r293, i32 0, i32 3
  %r295 = sub i32 0, 31
  %r297 = load i32, i32* %r294, align 4
  %r296 = mul i32 %r297, %r295
  %r298 = add i32 %r291, %r296
  %r299 = getelementptr %array2D, %array2D* %r107, i32 0
  %r300 = getelementptr %array2D, %array2D* %r299, i32 0, i32 0
  %r301 = getelementptr [5 x i32], [5 x i32]* %r300, i32 0, i32 4
  %r302 = sub i32 0, 8
  %r304 = load i32, i32* %r301, align 4
  %r303 = mul i32 %r304, %r302
  %r305 = add i32 %r298, %r303
  %r306 = getelementptr %array2D, %array2D* %r107, i32 1
  %r307 = getelementptr %array2D, %array2D* %r306, i32 0, i32 0
  %r308 = getelementptr [5 x i32], [5 x i32]* %r307, i32 0, i32 0
  %r310 = load i32, i32* %r308, align 4
  %r309 = mul i32 %r310, 47
  %r311 = add i32 %r305, %r309
  %r312 = getelementptr %array2D, %array2D* %r107, i32 1
  %r313 = getelementptr %array2D, %array2D* %r312, i32 0, i32 0
  %r314 = getelementptr [5 x i32], [5 x i32]* %r313, i32 0, i32 1
  %r315 = sub i32 0, 4
  %r317 = load i32, i32* %r314, align 4
  %r316 = mul i32 %r317, %r315
  %r318 = add i32 %r311, %r316
  %r319 = getelementptr %array2D, %array2D* %r107, i32 1
  %r320 = getelementptr %array2D, %array2D* %r319, i32 0, i32 0
  %r321 = getelementptr [5 x i32], [5 x i32]* %r320, i32 0, i32 2
  %r323 = load i32, i32* %r321, align 4
  %r322 = mul i32 %r323, 67
  %r324 = add i32 %r318, %r322
  %r325 = getelementptr %array2D, %array2D* %r107, i32 1
  %r326 = getelementptr %array2D, %array2D* %r325, i32 0, i32 0
  %r327 = getelementptr [5 x i32], [5 x i32]* %r326, i32 0, i32 3
  %r328 = sub i32 0, 94
  %r330 = load i32, i32* %r327, align 4
  %r329 = mul i32 %r330, %r328
  %r331 = add i32 %r324, %r329
  %r332 = getelementptr %array2D, %array2D* %r107, i32 1
  %r333 = getelementptr %array2D, %array2D* %r332, i32 0, i32 0
  %r334 = getelementptr [5 x i32], [5 x i32]* %r333, i32 0, i32 4
  %r335 = sub i32 0, 121
  %r337 = load i32, i32* %r334, align 4
  %r336 = mul i32 %r337, %r335
  %r338 = add i32 %r331, %r336
  %r339 = getelementptr %array2D, %array2D* %r107, i32 2
  %r340 = getelementptr %array2D, %array2D* %r339, i32 0, i32 0
  %r341 = getelementptr [5 x i32], [5 x i32]* %r340, i32 0, i32 0
  %r343 = load i32, i32* %r341, align 4
  %r342 = mul i32 %r343, 7
  %r344 = add i32 %r338, %r342
  %r345 = getelementptr %array2D, %array2D* %r107, i32 2
  %r346 = getelementptr %array2D, %array2D* %r345, i32 0, i32 0
  %r347 = getelementptr [5 x i32], [5 x i32]* %r346, i32 0, i32 1
  %r348 = sub i32 0, 21
  %r350 = load i32, i32* %r347, align 4
  %r349 = mul i32 %r350, %r348
  %r351 = add i32 %r344, %r349
  %r352 = getelementptr %array2D, %array2D* %r107, i32 2
  %r353 = getelementptr %array2D, %array2D* %r352, i32 0, i32 0
  %r354 = getelementptr [5 x i32], [5 x i32]* %r353, i32 0, i32 2
  %r355 = sub i32 0, 60
  %r357 = load i32, i32* %r354, align 4
  %r356 = mul i32 %r357, %r355
  %r358 = add i32 %r351, %r356
  %r359 = getelementptr %array2D, %array2D* %r107, i32 2
  %r360 = getelementptr %array2D, %array2D* %r359, i32 0, i32 0
  %r361 = getelementptr [5 x i32], [5 x i32]* %r360, i32 0, i32 3
  %r362 = sub i32 0, 43
  %r364 = load i32, i32* %r361, align 4
  %r363 = mul i32 %r364, %r362
  %r365 = add i32 %r358, %r363
  %r366 = getelementptr %array2D, %array2D* %r107, i32 2
  %r367 = getelementptr %array2D, %array2D* %r366, i32 0, i32 0
  %r368 = getelementptr [5 x i32], [5 x i32]* %r367, i32 0, i32 4
  %r370 = load i32, i32* %r368, align 4
  %r369 = mul i32 %r370, 105
  %r371 = add i32 %r365, %r369
  %r372 = getelementptr %array2D, %array2D* %r107, i32 3
  %r373 = getelementptr %array2D, %array2D* %r372, i32 0, i32 0
  %r374 = getelementptr [5 x i32], [5 x i32]* %r373, i32 0, i32 0
  %r375 = sub i32 0, 42
  %r377 = load i32, i32* %r374, align 4
  %r376 = mul i32 %r377, %r375
  %r378 = add i32 %r371, %r376
  %r379 = getelementptr %array2D, %array2D* %r107, i32 3
  %r380 = getelementptr %array2D, %array2D* %r379, i32 0, i32 0
  %r381 = getelementptr [5 x i32], [5 x i32]* %r380, i32 0, i32 1
  %r383 = load i32, i32* %r381, align 4
  %r382 = mul i32 %r383, 87
  %r384 = add i32 %r378, %r382
  %r385 = getelementptr %array2D, %array2D* %r107, i32 3
  %r386 = getelementptr %array2D, %array2D* %r385, i32 0, i32 0
  %r387 = getelementptr [5 x i32], [5 x i32]* %r386, i32 0, i32 2
  %r389 = load i32, i32* %r387, align 4
  %r388 = mul i32 %r389, 29
  %r390 = add i32 %r384, %r388
  %r391 = getelementptr %array2D, %array2D* %r107, i32 3
  %r392 = getelementptr %array2D, %array2D* %r391, i32 0, i32 0
  %r393 = getelementptr [5 x i32], [5 x i32]* %r392, i32 0, i32 3
  %r394 = sub i32 0, 106
  %r396 = load i32, i32* %r393, align 4
  %r395 = mul i32 %r396, %r394
  %r397 = add i32 %r390, %r395
  %r398 = getelementptr %array2D, %array2D* %r107, i32 3
  %r399 = getelementptr %array2D, %array2D* %r398, i32 0, i32 0
  %r400 = getelementptr [5 x i32], [5 x i32]* %r399, i32 0, i32 4
  %r401 = sub i32 0, 31
  %r403 = load i32, i32* %r400, align 4
  %r402 = mul i32 %r403, %r401
  %r404 = add i32 %r397, %r402
  %r405 = getelementptr %array2D, %array2D* %r107, i32 4
  %r406 = getelementptr %array2D, %array2D* %r405, i32 0, i32 0
  %r407 = getelementptr [5 x i32], [5 x i32]* %r406, i32 0, i32 0
  %r408 = sub i32 0, 110
  %r410 = load i32, i32* %r407, align 4
  %r409 = mul i32 %r410, %r408
  %r411 = add i32 %r404, %r409
  %r412 = getelementptr %array2D, %array2D* %r107, i32 4
  %r413 = getelementptr %array2D, %array2D* %r412, i32 0, i32 0
  %r414 = getelementptr [5 x i32], [5 x i32]* %r413, i32 0, i32 1
  %r415 = sub i32 0, 100
  %r417 = load i32, i32* %r414, align 4
  %r416 = mul i32 %r417, %r415
  %r418 = add i32 %r411, %r416
  %r419 = getelementptr %array2D, %array2D* %r107, i32 4
  %r420 = getelementptr %array2D, %array2D* %r419, i32 0, i32 0
  %r421 = getelementptr [5 x i32], [5 x i32]* %r420, i32 0, i32 2
  %r422 = sub i32 0, 22
  %r424 = load i32, i32* %r421, align 4
  %r423 = mul i32 %r424, %r422
  %r425 = add i32 %r418, %r423
  %r426 = getelementptr %array2D, %array2D* %r107, i32 4
  %r427 = getelementptr %array2D, %array2D* %r426, i32 0, i32 0
  %r428 = getelementptr [5 x i32], [5 x i32]* %r427, i32 0, i32 3
  %r429 = sub i32 0, 75
  %r431 = load i32, i32* %r428, align 4
  %r430 = mul i32 %r431, %r429
  %r432 = add i32 %r425, %r430
  %r433 = getelementptr %array2D, %array2D* %r107, i32 4
  %r434 = getelementptr %array2D, %array2D* %r433, i32 0, i32 0
  %r435 = getelementptr [5 x i32], [5 x i32]* %r434, i32 0, i32 4
  %r436 = sub i32 0, 125
  %r438 = load i32, i32* %r435, align 4
  %r437 = mul i32 %r438, %r436
  %r439 = add i32 %r432, %r437
  %r272 = call i32 @relu_reg(i32 %r439)
  %r440 = mul i32 %r272, 77
  %r441 = add i32 %r271, %r440
  %r443 = getelementptr %array2D, %array2D* %r107, i32 0
  %r444 = getelementptr %array2D, %array2D* %r443, i32 0, i32 0
  %r445 = getelementptr [5 x i32], [5 x i32]* %r444, i32 0, i32 0
  %r447 = load i32, i32* %r445, align 4
  %r446 = mul i32 %r447, 26
  %r448 = getelementptr %array2D, %array2D* %r107, i32 0
  %r449 = getelementptr %array2D, %array2D* %r448, i32 0, i32 0
  %r450 = getelementptr [5 x i32], [5 x i32]* %r449, i32 0, i32 1
  %r452 = load i32, i32* %r450, align 4
  %r451 = mul i32 %r452, 76
  %r453 = add i32 %r446, %r451
  %r454 = getelementptr %array2D, %array2D* %r107, i32 0
  %r455 = getelementptr %array2D, %array2D* %r454, i32 0, i32 0
  %r456 = getelementptr [5 x i32], [5 x i32]* %r455, i32 0, i32 2
  %r457 = sub i32 0, 70
  %r459 = load i32, i32* %r456, align 4
  %r458 = mul i32 %r459, %r457
  %r460 = add i32 %r453, %r458
  %r461 = getelementptr %array2D, %array2D* %r107, i32 0
  %r462 = getelementptr %array2D, %array2D* %r461, i32 0, i32 0
  %r463 = getelementptr [5 x i32], [5 x i32]* %r462, i32 0, i32 3
  %r465 = load i32, i32* %r463, align 4
  %r464 = mul i32 %r465, 29
  %r466 = add i32 %r460, %r464
  %r467 = getelementptr %array2D, %array2D* %r107, i32 0
  %r468 = getelementptr %array2D, %array2D* %r467, i32 0, i32 0
  %r469 = getelementptr [5 x i32], [5 x i32]* %r468, i32 0, i32 4
  %r470 = sub i32 0, 95
  %r472 = load i32, i32* %r469, align 4
  %r471 = mul i32 %r472, %r470
  %r473 = add i32 %r466, %r471
  %r474 = getelementptr %array2D, %array2D* %r107, i32 1
  %r475 = getelementptr %array2D, %array2D* %r474, i32 0, i32 0
  %r476 = getelementptr [5 x i32], [5 x i32]* %r475, i32 0, i32 0
  %r478 = load i32, i32* %r476, align 4
  %r477 = mul i32 %r478, 96
  %r479 = add i32 %r473, %r477
  %r480 = getelementptr %array2D, %array2D* %r107, i32 1
  %r481 = getelementptr %array2D, %array2D* %r480, i32 0, i32 0
  %r482 = getelementptr [5 x i32], [5 x i32]* %r481, i32 0, i32 1
  %r484 = load i32, i32* %r482, align 4
  %r483 = mul i32 %r484, 52
  %r485 = add i32 %r479, %r483
  %r486 = getelementptr %array2D, %array2D* %r107, i32 1
  %r487 = getelementptr %array2D, %array2D* %r486, i32 0, i32 0
  %r488 = getelementptr [5 x i32], [5 x i32]* %r487, i32 0, i32 2
  %r489 = sub i32 0, 68
  %r491 = load i32, i32* %r488, align 4
  %r490 = mul i32 %r491, %r489
  %r492 = add i32 %r485, %r490
  %r493 = getelementptr %array2D, %array2D* %r107, i32 1
  %r494 = getelementptr %array2D, %array2D* %r493, i32 0, i32 0
  %r495 = getelementptr [5 x i32], [5 x i32]* %r494, i32 0, i32 3
  %r496 = sub i32 0, 5
  %r498 = load i32, i32* %r495, align 4
  %r497 = mul i32 %r498, %r496
  %r499 = add i32 %r492, %r497
  %r500 = getelementptr %array2D, %array2D* %r107, i32 1
  %r501 = getelementptr %array2D, %array2D* %r500, i32 0, i32 0
  %r502 = getelementptr [5 x i32], [5 x i32]* %r501, i32 0, i32 4
  %r504 = load i32, i32* %r502, align 4
  %r503 = mul i32 %r504, 34
  %r505 = add i32 %r499, %r503
  %r506 = getelementptr %array2D, %array2D* %r107, i32 2
  %r507 = getelementptr %array2D, %array2D* %r506, i32 0, i32 0
  %r508 = getelementptr [5 x i32], [5 x i32]* %r507, i32 0, i32 0
  %r509 = sub i32 0, 34
  %r511 = load i32, i32* %r508, align 4
  %r510 = mul i32 %r511, %r509
  %r512 = add i32 %r505, %r510
  %r513 = getelementptr %array2D, %array2D* %r107, i32 2
  %r514 = getelementptr %array2D, %array2D* %r513, i32 0, i32 0
  %r515 = getelementptr [5 x i32], [5 x i32]* %r514, i32 0, i32 1
  %r517 = load i32, i32* %r515, align 4
  %r516 = mul i32 %r517, 102
  %r518 = add i32 %r512, %r516
  %r519 = getelementptr %array2D, %array2D* %r107, i32 2
  %r520 = getelementptr %array2D, %array2D* %r519, i32 0, i32 0
  %r521 = getelementptr [5 x i32], [5 x i32]* %r520, i32 0, i32 2
  %r523 = load i32, i32* %r521, align 4
  %r522 = mul i32 %r523, 6
  %r524 = add i32 %r518, %r522
  %r525 = getelementptr %array2D, %array2D* %r107, i32 2
  %r526 = getelementptr %array2D, %array2D* %r525, i32 0, i32 0
  %r527 = getelementptr [5 x i32], [5 x i32]* %r526, i32 0, i32 3
  %r528 = sub i32 0, 38
  %r530 = load i32, i32* %r527, align 4
  %r529 = mul i32 %r530, %r528
  %r531 = add i32 %r524, %r529
  %r532 = getelementptr %array2D, %array2D* %r107, i32 2
  %r533 = getelementptr %array2D, %array2D* %r532, i32 0, i32 0
  %r534 = getelementptr [5 x i32], [5 x i32]* %r533, i32 0, i32 4
  %r536 = load i32, i32* %r534, align 4
  %r535 = mul i32 %r536, 27
  %r537 = add i32 %r531, %r535
  %r538 = getelementptr %array2D, %array2D* %r107, i32 3
  %r539 = getelementptr %array2D, %array2D* %r538, i32 0, i32 0
  %r540 = getelementptr [5 x i32], [5 x i32]* %r539, i32 0, i32 0
  %r542 = load i32, i32* %r540, align 4
  %r541 = mul i32 %r542, 110
  %r543 = add i32 %r537, %r541
  %r544 = getelementptr %array2D, %array2D* %r107, i32 3
  %r545 = getelementptr %array2D, %array2D* %r544, i32 0, i32 0
  %r546 = getelementptr [5 x i32], [5 x i32]* %r545, i32 0, i32 1
  %r548 = load i32, i32* %r546, align 4
  %r547 = mul i32 %r548, 116
  %r549 = add i32 %r543, %r547
  %r550 = getelementptr %array2D, %array2D* %r107, i32 3
  %r551 = getelementptr %array2D, %array2D* %r550, i32 0, i32 0
  %r552 = getelementptr [5 x i32], [5 x i32]* %r551, i32 0, i32 2
  %r554 = load i32, i32* %r552, align 4
  %r553 = mul i32 %r554, 39
  %r555 = add i32 %r549, %r553
  %r556 = getelementptr %array2D, %array2D* %r107, i32 3
  %r557 = getelementptr %array2D, %array2D* %r556, i32 0, i32 0
  %r558 = getelementptr [5 x i32], [5 x i32]* %r557, i32 0, i32 3
  %r559 = sub i32 0, 63
  %r561 = load i32, i32* %r558, align 4
  %r560 = mul i32 %r561, %r559
  %r562 = add i32 %r555, %r560
  %r563 = getelementptr %array2D, %array2D* %r107, i32 3
  %r564 = getelementptr %array2D, %array2D* %r563, i32 0, i32 0
  %r565 = getelementptr [5 x i32], [5 x i32]* %r564, i32 0, i32 4
  %r566 = sub i32 0, 99
  %r568 = load i32, i32* %r565, align 4
  %r567 = mul i32 %r568, %r566
  %r569 = add i32 %r562, %r567
  %r570 = getelementptr %array2D, %array2D* %r107, i32 4
  %r571 = getelementptr %array2D, %array2D* %r570, i32 0, i32 0
  %r572 = getelementptr [5 x i32], [5 x i32]* %r571, i32 0, i32 0
  %r574 = load i32, i32* %r572, align 4
  %r573 = mul i32 %r574, 65
  %r575 = add i32 %r569, %r573
  %r576 = getelementptr %array2D, %array2D* %r107, i32 4
  %r577 = getelementptr %array2D, %array2D* %r576, i32 0, i32 0
  %r578 = getelementptr [5 x i32], [5 x i32]* %r577, i32 0, i32 1
  %r580 = load i32, i32* %r578, align 4
  %r579 = mul i32 %r580, 120
  %r581 = add i32 %r575, %r579
  %r582 = getelementptr %array2D, %array2D* %r107, i32 4
  %r583 = getelementptr %array2D, %array2D* %r582, i32 0, i32 0
  %r584 = getelementptr [5 x i32], [5 x i32]* %r583, i32 0, i32 2
  %r585 = sub i32 0, 39
  %r587 = load i32, i32* %r584, align 4
  %r586 = mul i32 %r587, %r585
  %r588 = add i32 %r581, %r586
  %r589 = getelementptr %array2D, %array2D* %r107, i32 4
  %r590 = getelementptr %array2D, %array2D* %r589, i32 0, i32 0
  %r591 = getelementptr [5 x i32], [5 x i32]* %r590, i32 0, i32 3
  %r592 = sub i32 0, 6
  %r594 = load i32, i32* %r591, align 4
  %r593 = mul i32 %r594, %r592
  %r595 = add i32 %r588, %r593
  %r596 = getelementptr %array2D, %array2D* %r107, i32 4
  %r597 = getelementptr %array2D, %array2D* %r596, i32 0, i32 0
  %r598 = getelementptr [5 x i32], [5 x i32]* %r597, i32 0, i32 4
  %r600 = load i32, i32* %r598, align 4
  %r599 = mul i32 %r600, 94
  %r601 = add i32 %r595, %r599
  %r442 = call i32 @relu_reg(i32 %r601)
  %r602 = mul i32 %r442, 127
  %r603 = add i32 %r441, %r602
  %r605 = getelementptr %array2D, %array2D* %r107, i32 0
  %r606 = getelementptr %array2D, %array2D* %r605, i32 0, i32 0
  %r607 = getelementptr [5 x i32], [5 x i32]* %r606, i32 0, i32 0
  %r608 = sub i32 0, 23
  %r610 = load i32, i32* %r607, align 4
  %r609 = mul i32 %r610, %r608
  %r611 = getelementptr %array2D, %array2D* %r107, i32 0
  %r612 = getelementptr %array2D, %array2D* %r611, i32 0, i32 0
  %r613 = getelementptr [5 x i32], [5 x i32]* %r612, i32 0, i32 1
  %r614 = sub i32 0, 63
  %r616 = load i32, i32* %r613, align 4
  %r615 = mul i32 %r616, %r614
  %r617 = add i32 %r609, %r615
  %r618 = getelementptr %array2D, %array2D* %r107, i32 0
  %r619 = getelementptr %array2D, %array2D* %r618, i32 0, i32 0
  %r620 = getelementptr [5 x i32], [5 x i32]* %r619, i32 0, i32 2
  %r622 = load i32, i32* %r620, align 4
  %r621 = mul i32 %r622, 49
  %r623 = add i32 %r617, %r621
  %r624 = getelementptr %array2D, %array2D* %r107, i32 0
  %r625 = getelementptr %array2D, %array2D* %r624, i32 0, i32 0
  %r626 = getelementptr [5 x i32], [5 x i32]* %r625, i32 0, i32 3
  %r628 = load i32, i32* %r626, align 4
  %r627 = mul i32 %r628, 50
  %r629 = add i32 %r623, %r627
  %r630 = getelementptr %array2D, %array2D* %r107, i32 0
  %r631 = getelementptr %array2D, %array2D* %r630, i32 0, i32 0
  %r632 = getelementptr [5 x i32], [5 x i32]* %r631, i32 0, i32 4
  %r634 = load i32, i32* %r632, align 4
  %r633 = mul i32 %r634, 72
  %r635 = add i32 %r629, %r633
  %r636 = getelementptr %array2D, %array2D* %r107, i32 1
  %r637 = getelementptr %array2D, %array2D* %r636, i32 0, i32 0
  %r638 = getelementptr [5 x i32], [5 x i32]* %r637, i32 0, i32 0
  %r640 = load i32, i32* %r638, align 4
  %r639 = mul i32 %r640, 85
  %r641 = add i32 %r635, %r639
  %r642 = getelementptr %array2D, %array2D* %r107, i32 1
  %r643 = getelementptr %array2D, %array2D* %r642, i32 0, i32 0
  %r644 = getelementptr [5 x i32], [5 x i32]* %r643, i32 0, i32 1
  %r645 = sub i32 0, 30
  %r647 = load i32, i32* %r644, align 4
  %r646 = mul i32 %r647, %r645
  %r648 = add i32 %r641, %r646
  %r649 = getelementptr %array2D, %array2D* %r107, i32 1
  %r650 = getelementptr %array2D, %array2D* %r649, i32 0, i32 0
  %r651 = getelementptr [5 x i32], [5 x i32]* %r650, i32 0, i32 2
  %r653 = load i32, i32* %r651, align 4
  %r652 = mul i32 %r653, 12
  %r654 = add i32 %r648, %r652
  %r655 = getelementptr %array2D, %array2D* %r107, i32 1
  %r656 = getelementptr %array2D, %array2D* %r655, i32 0, i32 0
  %r657 = getelementptr [5 x i32], [5 x i32]* %r656, i32 0, i32 3
  %r659 = load i32, i32* %r657, align 4
  %r658 = mul i32 %r659, 125
  %r660 = add i32 %r654, %r658
  %r661 = getelementptr %array2D, %array2D* %r107, i32 1
  %r662 = getelementptr %array2D, %array2D* %r661, i32 0, i32 0
  %r663 = getelementptr [5 x i32], [5 x i32]* %r662, i32 0, i32 4
  %r664 = sub i32 0, 117
  %r666 = load i32, i32* %r663, align 4
  %r665 = mul i32 %r666, %r664
  %r667 = add i32 %r660, %r665
  %r668 = getelementptr %array2D, %array2D* %r107, i32 2
  %r669 = getelementptr %array2D, %array2D* %r668, i32 0, i32 0
  %r670 = getelementptr [5 x i32], [5 x i32]* %r669, i32 0, i32 0
  %r671 = sub i32 0, 65
  %r673 = load i32, i32* %r670, align 4
  %r672 = mul i32 %r673, %r671
  %r674 = add i32 %r667, %r672
  %r675 = getelementptr %array2D, %array2D* %r107, i32 2
  %r676 = getelementptr %array2D, %array2D* %r675, i32 0, i32 0
  %r677 = getelementptr [5 x i32], [5 x i32]* %r676, i32 0, i32 1
  %r678 = sub i32 0, 67
  %r680 = load i32, i32* %r677, align 4
  %r679 = mul i32 %r680, %r678
  %r681 = add i32 %r674, %r679
  %r682 = getelementptr %array2D, %array2D* %r107, i32 2
  %r683 = getelementptr %array2D, %array2D* %r682, i32 0, i32 0
  %r684 = getelementptr [5 x i32], [5 x i32]* %r683, i32 0, i32 2
  %r686 = load i32, i32* %r684, align 4
  %r685 = mul i32 %r686, 125
  %r687 = add i32 %r681, %r685
  %r688 = getelementptr %array2D, %array2D* %r107, i32 2
  %r689 = getelementptr %array2D, %array2D* %r688, i32 0, i32 0
  %r690 = getelementptr [5 x i32], [5 x i32]* %r689, i32 0, i32 3
  %r692 = load i32, i32* %r690, align 4
  %r691 = mul i32 %r692, 110
  %r693 = add i32 %r687, %r691
  %r694 = getelementptr %array2D, %array2D* %r107, i32 2
  %r695 = getelementptr %array2D, %array2D* %r694, i32 0, i32 0
  %r696 = getelementptr [5 x i32], [5 x i32]* %r695, i32 0, i32 4
  %r697 = sub i32 0, 31
  %r699 = load i32, i32* %r696, align 4
  %r698 = mul i32 %r699, %r697
  %r700 = add i32 %r693, %r698
  %r701 = getelementptr %array2D, %array2D* %r107, i32 3
  %r702 = getelementptr %array2D, %array2D* %r701, i32 0, i32 0
  %r703 = getelementptr [5 x i32], [5 x i32]* %r702, i32 0, i32 0
  %r704 = sub i32 0, 123
  %r706 = load i32, i32* %r703, align 4
  %r705 = mul i32 %r706, %r704
  %r707 = add i32 %r700, %r705
  %r708 = getelementptr %array2D, %array2D* %r107, i32 3
  %r709 = getelementptr %array2D, %array2D* %r708, i32 0, i32 0
  %r710 = getelementptr [5 x i32], [5 x i32]* %r709, i32 0, i32 1
  %r712 = load i32, i32* %r710, align 4
  %r711 = mul i32 %r712, 83
  %r713 = add i32 %r707, %r711
  %r714 = getelementptr %array2D, %array2D* %r107, i32 3
  %r715 = getelementptr %array2D, %array2D* %r714, i32 0, i32 0
  %r716 = getelementptr [5 x i32], [5 x i32]* %r715, i32 0, i32 2
  %r718 = load i32, i32* %r716, align 4
  %r717 = mul i32 %r718, 122
  %r719 = add i32 %r713, %r717
  %r720 = getelementptr %array2D, %array2D* %r107, i32 3
  %r721 = getelementptr %array2D, %array2D* %r720, i32 0, i32 0
  %r722 = getelementptr [5 x i32], [5 x i32]* %r721, i32 0, i32 3
  %r724 = load i32, i32* %r722, align 4
  %r723 = mul i32 %r724, 11
  %r725 = add i32 %r719, %r723
  %r726 = getelementptr %array2D, %array2D* %r107, i32 3
  %r727 = getelementptr %array2D, %array2D* %r726, i32 0, i32 0
  %r728 = getelementptr [5 x i32], [5 x i32]* %r727, i32 0, i32 4
  %r729 = sub i32 0, 23
  %r731 = load i32, i32* %r728, align 4
  %r730 = mul i32 %r731, %r729
  %r732 = add i32 %r725, %r730
  %r733 = getelementptr %array2D, %array2D* %r107, i32 4
  %r734 = getelementptr %array2D, %array2D* %r733, i32 0, i32 0
  %r735 = getelementptr [5 x i32], [5 x i32]* %r734, i32 0, i32 0
  %r736 = sub i32 0, 47
  %r738 = load i32, i32* %r735, align 4
  %r737 = mul i32 %r738, %r736
  %r739 = add i32 %r732, %r737
  %r740 = getelementptr %array2D, %array2D* %r107, i32 4
  %r741 = getelementptr %array2D, %array2D* %r740, i32 0, i32 0
  %r742 = getelementptr [5 x i32], [5 x i32]* %r741, i32 0, i32 1
  %r743 = sub i32 0, 32
  %r745 = load i32, i32* %r742, align 4
  %r744 = mul i32 %r745, %r743
  %r746 = add i32 %r739, %r744
  %r747 = getelementptr %array2D, %array2D* %r107, i32 4
  %r748 = getelementptr %array2D, %array2D* %r747, i32 0, i32 0
  %r749 = getelementptr [5 x i32], [5 x i32]* %r748, i32 0, i32 2
  %r750 = sub i32 0, 117
  %r752 = load i32, i32* %r749, align 4
  %r751 = mul i32 %r752, %r750
  %r753 = add i32 %r746, %r751
  %r754 = getelementptr %array2D, %array2D* %r107, i32 4
  %r755 = getelementptr %array2D, %array2D* %r754, i32 0, i32 0
  %r756 = getelementptr [5 x i32], [5 x i32]* %r755, i32 0, i32 3
  %r758 = load i32, i32* %r756, align 4
  %r757 = mul i32 %r758, 95
  %r759 = add i32 %r753, %r757
  %r760 = getelementptr %array2D, %array2D* %r107, i32 4
  %r761 = getelementptr %array2D, %array2D* %r760, i32 0, i32 0
  %r762 = getelementptr [5 x i32], [5 x i32]* %r761, i32 0, i32 4
  %r764 = load i32, i32* %r762, align 4
  %r763 = mul i32 %r764, 118
  %r765 = add i32 %r759, %r763
  %r604 = call i32 @relu_reg(i32 %r765)
  %r766 = sub i32 0, 106
  %r767 = mul i32 %r604, %r766
  %r768 = add i32 %r603, %r767
  %r770 = getelementptr %array2D, %array2D* %r107, i32 0
  %r771 = getelementptr %array2D, %array2D* %r770, i32 0, i32 0
  %r772 = getelementptr [5 x i32], [5 x i32]* %r771, i32 0, i32 0
  %r774 = load i32, i32* %r772, align 4
  %r773 = mul i32 %r774, 8
  %r775 = getelementptr %array2D, %array2D* %r107, i32 0
  %r776 = getelementptr %array2D, %array2D* %r775, i32 0, i32 0
  %r777 = getelementptr [5 x i32], [5 x i32]* %r776, i32 0, i32 1
  %r779 = load i32, i32* %r777, align 4
  %r778 = mul i32 %r779, 82
  %r780 = add i32 %r773, %r778
  %r781 = getelementptr %array2D, %array2D* %r107, i32 0
  %r782 = getelementptr %array2D, %array2D* %r781, i32 0, i32 0
  %r783 = getelementptr [5 x i32], [5 x i32]* %r782, i32 0, i32 2
  %r784 = sub i32 0, 104
  %r786 = load i32, i32* %r783, align 4
  %r785 = mul i32 %r786, %r784
  %r787 = add i32 %r780, %r785
  %r788 = getelementptr %array2D, %array2D* %r107, i32 0
  %r789 = getelementptr %array2D, %array2D* %r788, i32 0, i32 0
  %r790 = getelementptr [5 x i32], [5 x i32]* %r789, i32 0, i32 3
  %r792 = load i32, i32* %r790, align 4
  %r791 = mul i32 %r792, 101
  %r793 = add i32 %r787, %r791
  %r794 = getelementptr %array2D, %array2D* %r107, i32 0
  %r795 = getelementptr %array2D, %array2D* %r794, i32 0, i32 0
  %r796 = getelementptr [5 x i32], [5 x i32]* %r795, i32 0, i32 4
  %r797 = sub i32 0, 116
  %r799 = load i32, i32* %r796, align 4
  %r798 = mul i32 %r799, %r797
  %r800 = add i32 %r793, %r798
  %r801 = getelementptr %array2D, %array2D* %r107, i32 1
  %r802 = getelementptr %array2D, %array2D* %r801, i32 0, i32 0
  %r803 = getelementptr [5 x i32], [5 x i32]* %r802, i32 0, i32 0
  %r804 = sub i32 0, 63
  %r806 = load i32, i32* %r803, align 4
  %r805 = mul i32 %r806, %r804
  %r807 = add i32 %r800, %r805
  %r808 = getelementptr %array2D, %array2D* %r107, i32 1
  %r809 = getelementptr %array2D, %array2D* %r808, i32 0, i32 0
  %r810 = getelementptr [5 x i32], [5 x i32]* %r809, i32 0, i32 1
  %r811 = sub i32 0, 16
  %r813 = load i32, i32* %r810, align 4
  %r812 = mul i32 %r813, %r811
  %r814 = add i32 %r807, %r812
  %r815 = getelementptr %array2D, %array2D* %r107, i32 1
  %r816 = getelementptr %array2D, %array2D* %r815, i32 0, i32 0
  %r817 = getelementptr [5 x i32], [5 x i32]* %r816, i32 0, i32 2
  %r818 = sub i32 0, 70
  %r820 = load i32, i32* %r817, align 4
  %r819 = mul i32 %r820, %r818
  %r821 = add i32 %r814, %r819
  %r822 = getelementptr %array2D, %array2D* %r107, i32 1
  %r823 = getelementptr %array2D, %array2D* %r822, i32 0, i32 0
  %r824 = getelementptr [5 x i32], [5 x i32]* %r823, i32 0, i32 3
  %r826 = load i32, i32* %r824, align 4
  %r825 = mul i32 %r826, 125
  %r827 = add i32 %r821, %r825
  %r828 = getelementptr %array2D, %array2D* %r107, i32 1
  %r829 = getelementptr %array2D, %array2D* %r828, i32 0, i32 0
  %r830 = getelementptr [5 x i32], [5 x i32]* %r829, i32 0, i32 4
  %r832 = load i32, i32* %r830, align 4
  %r831 = mul i32 %r832, 75
  %r833 = add i32 %r827, %r831
  %r834 = getelementptr %array2D, %array2D* %r107, i32 2
  %r835 = getelementptr %array2D, %array2D* %r834, i32 0, i32 0
  %r836 = getelementptr [5 x i32], [5 x i32]* %r835, i32 0, i32 0
  %r838 = load i32, i32* %r836, align 4
  %r837 = mul i32 %r838, 66
  %r839 = add i32 %r833, %r837
  %r840 = getelementptr %array2D, %array2D* %r107, i32 2
  %r841 = getelementptr %array2D, %array2D* %r840, i32 0, i32 0
  %r842 = getelementptr [5 x i32], [5 x i32]* %r841, i32 0, i32 1
  %r843 = sub i32 0, 96
  %r845 = load i32, i32* %r842, align 4
  %r844 = mul i32 %r845, %r843
  %r846 = add i32 %r839, %r844
  %r847 = getelementptr %array2D, %array2D* %r107, i32 2
  %r848 = getelementptr %array2D, %array2D* %r847, i32 0, i32 0
  %r849 = getelementptr [5 x i32], [5 x i32]* %r848, i32 0, i32 2
  %r850 = sub i32 0, 101
  %r852 = load i32, i32* %r849, align 4
  %r851 = mul i32 %r852, %r850
  %r853 = add i32 %r846, %r851
  %r854 = getelementptr %array2D, %array2D* %r107, i32 2
  %r855 = getelementptr %array2D, %array2D* %r854, i32 0, i32 0
  %r856 = getelementptr [5 x i32], [5 x i32]* %r855, i32 0, i32 3
  %r857 = sub i32 0, 114
  %r859 = load i32, i32* %r856, align 4
  %r858 = mul i32 %r859, %r857
  %r860 = add i32 %r853, %r858
  %r861 = getelementptr %array2D, %array2D* %r107, i32 2
  %r862 = getelementptr %array2D, %array2D* %r861, i32 0, i32 0
  %r863 = getelementptr [5 x i32], [5 x i32]* %r862, i32 0, i32 4
  %r865 = load i32, i32* %r863, align 4
  %r864 = mul i32 %r865, 59
  %r866 = add i32 %r860, %r864
  %r867 = getelementptr %array2D, %array2D* %r107, i32 3
  %r868 = getelementptr %array2D, %array2D* %r867, i32 0, i32 0
  %r869 = getelementptr [5 x i32], [5 x i32]* %r868, i32 0, i32 0
  %r871 = load i32, i32* %r869, align 4
  %r870 = mul i32 %r871, 12
  %r872 = add i32 %r866, %r870
  %r873 = getelementptr %array2D, %array2D* %r107, i32 3
  %r874 = getelementptr %array2D, %array2D* %r873, i32 0, i32 0
  %r875 = getelementptr [5 x i32], [5 x i32]* %r874, i32 0, i32 1
  %r877 = load i32, i32* %r875, align 4
  %r876 = mul i32 %r877, 5
  %r878 = add i32 %r872, %r876
  %r879 = getelementptr %array2D, %array2D* %r107, i32 3
  %r880 = getelementptr %array2D, %array2D* %r879, i32 0, i32 0
  %r881 = getelementptr [5 x i32], [5 x i32]* %r880, i32 0, i32 2
  %r882 = sub i32 0, 95
  %r884 = load i32, i32* %r881, align 4
  %r883 = mul i32 %r884, %r882
  %r885 = add i32 %r878, %r883
  %r886 = getelementptr %array2D, %array2D* %r107, i32 3
  %r887 = getelementptr %array2D, %array2D* %r886, i32 0, i32 0
  %r888 = getelementptr [5 x i32], [5 x i32]* %r887, i32 0, i32 3
  %r890 = load i32, i32* %r888, align 4
  %r889 = mul i32 %r890, 116
  %r891 = add i32 %r885, %r889
  %r892 = getelementptr %array2D, %array2D* %r107, i32 3
  %r893 = getelementptr %array2D, %array2D* %r892, i32 0, i32 0
  %r894 = getelementptr [5 x i32], [5 x i32]* %r893, i32 0, i32 4
  %r895 = sub i32 0, 93
  %r897 = load i32, i32* %r894, align 4
  %r896 = mul i32 %r897, %r895
  %r898 = add i32 %r891, %r896
  %r899 = getelementptr %array2D, %array2D* %r107, i32 4
  %r900 = getelementptr %array2D, %array2D* %r899, i32 0, i32 0
  %r901 = getelementptr [5 x i32], [5 x i32]* %r900, i32 0, i32 0
  %r903 = load i32, i32* %r901, align 4
  %r902 = mul i32 %r903, 15
  %r904 = add i32 %r898, %r902
  %r905 = getelementptr %array2D, %array2D* %r107, i32 4
  %r906 = getelementptr %array2D, %array2D* %r905, i32 0, i32 0
  %r907 = getelementptr [5 x i32], [5 x i32]* %r906, i32 0, i32 1
  %r909 = load i32, i32* %r907, align 4
  %r908 = mul i32 %r909, 79
  %r910 = add i32 %r904, %r908
  %r911 = getelementptr %array2D, %array2D* %r107, i32 4
  %r912 = getelementptr %array2D, %array2D* %r911, i32 0, i32 0
  %r913 = getelementptr [5 x i32], [5 x i32]* %r912, i32 0, i32 2
  %r915 = load i32, i32* %r913, align 4
  %r914 = mul i32 %r915, 3
  %r916 = add i32 %r910, %r914
  %r917 = getelementptr %array2D, %array2D* %r107, i32 4
  %r918 = getelementptr %array2D, %array2D* %r917, i32 0, i32 0
  %r919 = getelementptr [5 x i32], [5 x i32]* %r918, i32 0, i32 3
  %r921 = load i32, i32* %r919, align 4
  %r920 = mul i32 %r921, 49
  %r922 = add i32 %r916, %r920
  %r923 = getelementptr %array2D, %array2D* %r107, i32 4
  %r924 = getelementptr %array2D, %array2D* %r923, i32 0, i32 0
  %r925 = getelementptr [5 x i32], [5 x i32]* %r924, i32 0, i32 4
  %r926 = sub i32 0, 124
  %r928 = load i32, i32* %r925, align 4
  %r927 = mul i32 %r928, %r926
  %r929 = add i32 %r922, %r927
  %r769 = call i32 @relu_reg(i32 %r929)
  %r930 = sub i32 0, 3
  %r931 = mul i32 %r769, %r930
  %r932 = add i32 %r768, %r931
  %r934 = getelementptr %array2D, %array2D* %r107, i32 0
  %r935 = getelementptr %array2D, %array2D* %r934, i32 0, i32 0
  %r936 = getelementptr [5 x i32], [5 x i32]* %r935, i32 0, i32 0
  %r938 = load i32, i32* %r936, align 4
  %r937 = mul i32 %r938, 81
  %r939 = getelementptr %array2D, %array2D* %r107, i32 0
  %r940 = getelementptr %array2D, %array2D* %r939, i32 0, i32 0
  %r941 = getelementptr [5 x i32], [5 x i32]* %r940, i32 0, i32 1
  %r943 = load i32, i32* %r941, align 4
  %r942 = mul i32 %r943, 68
  %r944 = add i32 %r937, %r942
  %r945 = getelementptr %array2D, %array2D* %r107, i32 0
  %r946 = getelementptr %array2D, %array2D* %r945, i32 0, i32 0
  %r947 = getelementptr [5 x i32], [5 x i32]* %r946, i32 0, i32 2
  %r948 = sub i32 0, 102
  %r950 = load i32, i32* %r947, align 4
  %r949 = mul i32 %r950, %r948
  %r951 = add i32 %r944, %r949
  %r952 = getelementptr %array2D, %array2D* %r107, i32 0
  %r953 = getelementptr %array2D, %array2D* %r952, i32 0, i32 0
  %r954 = getelementptr [5 x i32], [5 x i32]* %r953, i32 0, i32 3
  %r955 = sub i32 0, 74
  %r957 = load i32, i32* %r954, align 4
  %r956 = mul i32 %r957, %r955
  %r958 = add i32 %r951, %r956
  %r959 = getelementptr %array2D, %array2D* %r107, i32 0
  %r960 = getelementptr %array2D, %array2D* %r959, i32 0, i32 0
  %r961 = getelementptr [5 x i32], [5 x i32]* %r960, i32 0, i32 4
  %r963 = load i32, i32* %r961, align 4
  %r962 = mul i32 %r963, 121
  %r964 = add i32 %r958, %r962
  %r965 = getelementptr %array2D, %array2D* %r107, i32 1
  %r966 = getelementptr %array2D, %array2D* %r965, i32 0, i32 0
  %r967 = getelementptr [5 x i32], [5 x i32]* %r966, i32 0, i32 0
  %r968 = sub i32 0, 15
  %r970 = load i32, i32* %r967, align 4
  %r969 = mul i32 %r970, %r968
  %r971 = add i32 %r964, %r969
  %r972 = getelementptr %array2D, %array2D* %r107, i32 1
  %r973 = getelementptr %array2D, %array2D* %r972, i32 0, i32 0
  %r974 = getelementptr [5 x i32], [5 x i32]* %r973, i32 0, i32 1
  %r976 = load i32, i32* %r974, align 4
  %r975 = mul i32 %r976, 55
  %r977 = add i32 %r971, %r975
  %r978 = getelementptr %array2D, %array2D* %r107, i32 1
  %r979 = getelementptr %array2D, %array2D* %r978, i32 0, i32 0
  %r980 = getelementptr [5 x i32], [5 x i32]* %r979, i32 0, i32 2
  %r982 = load i32, i32* %r980, align 4
  %r981 = mul i32 %r982, 101
  %r983 = add i32 %r977, %r981
  %r984 = getelementptr %array2D, %array2D* %r107, i32 1
  %r985 = getelementptr %array2D, %array2D* %r984, i32 0, i32 0
  %r986 = getelementptr [5 x i32], [5 x i32]* %r985, i32 0, i32 3
  %r987 = sub i32 0, 13
  %r989 = load i32, i32* %r986, align 4
  %r988 = mul i32 %r989, %r987
  %r990 = add i32 %r983, %r988
  %r991 = getelementptr %array2D, %array2D* %r107, i32 1
  %r992 = getelementptr %array2D, %array2D* %r991, i32 0, i32 0
  %r993 = getelementptr [5 x i32], [5 x i32]* %r992, i32 0, i32 4
  %r994 = sub i32 0, 62
  %r996 = load i32, i32* %r993, align 4
  %r995 = mul i32 %r996, %r994
  %r997 = add i32 %r990, %r995
  %r998 = getelementptr %array2D, %array2D* %r107, i32 2
  %r999 = getelementptr %array2D, %array2D* %r998, i32 0, i32 0
  %r1000 = getelementptr [5 x i32], [5 x i32]* %r999, i32 0, i32 0
  %r1002 = load i32, i32* %r1000, align 4
  %r1001 = mul i32 %r1002, 64
  %r1003 = add i32 %r997, %r1001
  %r1004 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1005 = getelementptr %array2D, %array2D* %r1004, i32 0, i32 0
  %r1006 = getelementptr [5 x i32], [5 x i32]* %r1005, i32 0, i32 1
  %r1008 = load i32, i32* %r1006, align 4
  %r1007 = mul i32 %r1008, 114
  %r1009 = add i32 %r1003, %r1007
  %r1010 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1011 = getelementptr %array2D, %array2D* %r1010, i32 0, i32 0
  %r1012 = getelementptr [5 x i32], [5 x i32]* %r1011, i32 0, i32 2
  %r1014 = load i32, i32* %r1012, align 4
  %r1013 = mul i32 %r1014, 38
  %r1015 = add i32 %r1009, %r1013
  %r1016 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1017 = getelementptr %array2D, %array2D* %r1016, i32 0, i32 0
  %r1018 = getelementptr [5 x i32], [5 x i32]* %r1017, i32 0, i32 3
  %r1019 = sub i32 0, 21
  %r1021 = load i32, i32* %r1018, align 4
  %r1020 = mul i32 %r1021, %r1019
  %r1022 = add i32 %r1015, %r1020
  %r1023 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1024 = getelementptr %array2D, %array2D* %r1023, i32 0, i32 0
  %r1025 = getelementptr [5 x i32], [5 x i32]* %r1024, i32 0, i32 4
  %r1027 = load i32, i32* %r1025, align 4
  %r1026 = mul i32 %r1027, 112
  %r1028 = add i32 %r1022, %r1026
  %r1029 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1030 = getelementptr %array2D, %array2D* %r1029, i32 0, i32 0
  %r1031 = getelementptr [5 x i32], [5 x i32]* %r1030, i32 0, i32 0
  %r1033 = load i32, i32* %r1031, align 4
  %r1032 = mul i32 %r1033, 114
  %r1034 = add i32 %r1028, %r1032
  %r1035 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1036 = getelementptr %array2D, %array2D* %r1035, i32 0, i32 0
  %r1037 = getelementptr [5 x i32], [5 x i32]* %r1036, i32 0, i32 1
  %r1039 = load i32, i32* %r1037, align 4
  %r1038 = mul i32 %r1039, 112
  %r1040 = add i32 %r1034, %r1038
  %r1041 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1042 = getelementptr %array2D, %array2D* %r1041, i32 0, i32 0
  %r1043 = getelementptr [5 x i32], [5 x i32]* %r1042, i32 0, i32 2
  %r1044 = sub i32 0, 10
  %r1046 = load i32, i32* %r1043, align 4
  %r1045 = mul i32 %r1046, %r1044
  %r1047 = add i32 %r1040, %r1045
  %r1048 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1049 = getelementptr %array2D, %array2D* %r1048, i32 0, i32 0
  %r1050 = getelementptr [5 x i32], [5 x i32]* %r1049, i32 0, i32 3
  %r1051 = sub i32 0, 16
  %r1053 = load i32, i32* %r1050, align 4
  %r1052 = mul i32 %r1053, %r1051
  %r1054 = add i32 %r1047, %r1052
  %r1055 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1056 = getelementptr %array2D, %array2D* %r1055, i32 0, i32 0
  %r1057 = getelementptr [5 x i32], [5 x i32]* %r1056, i32 0, i32 4
  %r1058 = sub i32 0, 50
  %r1060 = load i32, i32* %r1057, align 4
  %r1059 = mul i32 %r1060, %r1058
  %r1061 = add i32 %r1054, %r1059
  %r1062 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1063 = getelementptr %array2D, %array2D* %r1062, i32 0, i32 0
  %r1064 = getelementptr [5 x i32], [5 x i32]* %r1063, i32 0, i32 0
  %r1065 = sub i32 0, 112
  %r1067 = load i32, i32* %r1064, align 4
  %r1066 = mul i32 %r1067, %r1065
  %r1068 = add i32 %r1061, %r1066
  %r1069 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1070 = getelementptr %array2D, %array2D* %r1069, i32 0, i32 0
  %r1071 = getelementptr [5 x i32], [5 x i32]* %r1070, i32 0, i32 1
  %r1072 = sub i32 0, 116
  %r1074 = load i32, i32* %r1071, align 4
  %r1073 = mul i32 %r1074, %r1072
  %r1075 = add i32 %r1068, %r1073
  %r1076 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1077 = getelementptr %array2D, %array2D* %r1076, i32 0, i32 0
  %r1078 = getelementptr [5 x i32], [5 x i32]* %r1077, i32 0, i32 2
  %r1079 = sub i32 0, 54
  %r1081 = load i32, i32* %r1078, align 4
  %r1080 = mul i32 %r1081, %r1079
  %r1082 = add i32 %r1075, %r1080
  %r1083 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1084 = getelementptr %array2D, %array2D* %r1083, i32 0, i32 0
  %r1085 = getelementptr [5 x i32], [5 x i32]* %r1084, i32 0, i32 3
  %r1087 = load i32, i32* %r1085, align 4
  %r1086 = mul i32 %r1087, 82
  %r1088 = add i32 %r1082, %r1086
  %r1089 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1090 = getelementptr %array2D, %array2D* %r1089, i32 0, i32 0
  %r1091 = getelementptr [5 x i32], [5 x i32]* %r1090, i32 0, i32 4
  %r1092 = sub i32 0, 72
  %r1094 = load i32, i32* %r1091, align 4
  %r1093 = mul i32 %r1094, %r1092
  %r1095 = add i32 %r1088, %r1093
  %r933 = call i32 @relu_reg(i32 %r1095)
  %r1096 = mul i32 %r933, 32
  %r1097 = add i32 %r932, %r1096
  %r1099 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1100 = getelementptr %array2D, %array2D* %r1099, i32 0, i32 0
  %r1101 = getelementptr [5 x i32], [5 x i32]* %r1100, i32 0, i32 0
  %r1103 = load i32, i32* %r1101, align 4
  %r1102 = mul i32 %r1103, 15
  %r1104 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1105 = getelementptr %array2D, %array2D* %r1104, i32 0, i32 0
  %r1106 = getelementptr [5 x i32], [5 x i32]* %r1105, i32 0, i32 1
  %r1107 = sub i32 0, 77
  %r1109 = load i32, i32* %r1106, align 4
  %r1108 = mul i32 %r1109, %r1107
  %r1110 = add i32 %r1102, %r1108
  %r1111 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1112 = getelementptr %array2D, %array2D* %r1111, i32 0, i32 0
  %r1113 = getelementptr [5 x i32], [5 x i32]* %r1112, i32 0, i32 2
  %r1115 = load i32, i32* %r1113, align 4
  %r1114 = mul i32 %r1115, 66
  %r1116 = add i32 %r1110, %r1114
  %r1117 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1118 = getelementptr %array2D, %array2D* %r1117, i32 0, i32 0
  %r1119 = getelementptr [5 x i32], [5 x i32]* %r1118, i32 0, i32 3
  %r1120 = sub i32 0, 90
  %r1122 = load i32, i32* %r1119, align 4
  %r1121 = mul i32 %r1122, %r1120
  %r1123 = add i32 %r1116, %r1121
  %r1124 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1125 = getelementptr %array2D, %array2D* %r1124, i32 0, i32 0
  %r1126 = getelementptr [5 x i32], [5 x i32]* %r1125, i32 0, i32 4
  %r1127 = sub i32 0, 6
  %r1129 = load i32, i32* %r1126, align 4
  %r1128 = mul i32 %r1129, %r1127
  %r1130 = add i32 %r1123, %r1128
  %r1131 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1132 = getelementptr %array2D, %array2D* %r1131, i32 0, i32 0
  %r1133 = getelementptr [5 x i32], [5 x i32]* %r1132, i32 0, i32 0
  %r1134 = sub i32 0, 30
  %r1136 = load i32, i32* %r1133, align 4
  %r1135 = mul i32 %r1136, %r1134
  %r1137 = add i32 %r1130, %r1135
  %r1138 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1139 = getelementptr %array2D, %array2D* %r1138, i32 0, i32 0
  %r1140 = getelementptr [5 x i32], [5 x i32]* %r1139, i32 0, i32 1
  %r1141 = sub i32 0, 8
  %r1143 = load i32, i32* %r1140, align 4
  %r1142 = mul i32 %r1143, %r1141
  %r1144 = add i32 %r1137, %r1142
  %r1145 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1146 = getelementptr %array2D, %array2D* %r1145, i32 0, i32 0
  %r1147 = getelementptr [5 x i32], [5 x i32]* %r1146, i32 0, i32 2
  %r1149 = load i32, i32* %r1147, align 4
  %r1148 = mul i32 %r1149, 81
  %r1150 = add i32 %r1144, %r1148
  %r1151 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1152 = getelementptr %array2D, %array2D* %r1151, i32 0, i32 0
  %r1153 = getelementptr [5 x i32], [5 x i32]* %r1152, i32 0, i32 3
  %r1155 = load i32, i32* %r1153, align 4
  %r1154 = mul i32 %r1155, 2
  %r1156 = add i32 %r1150, %r1154
  %r1157 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1158 = getelementptr %array2D, %array2D* %r1157, i32 0, i32 0
  %r1159 = getelementptr [5 x i32], [5 x i32]* %r1158, i32 0, i32 4
  %r1160 = sub i32 0, 110
  %r1162 = load i32, i32* %r1159, align 4
  %r1161 = mul i32 %r1162, %r1160
  %r1163 = add i32 %r1156, %r1161
  %r1164 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1165 = getelementptr %array2D, %array2D* %r1164, i32 0, i32 0
  %r1166 = getelementptr [5 x i32], [5 x i32]* %r1165, i32 0, i32 0
  %r1167 = sub i32 0, 95
  %r1169 = load i32, i32* %r1166, align 4
  %r1168 = mul i32 %r1169, %r1167
  %r1170 = add i32 %r1163, %r1168
  %r1171 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1172 = getelementptr %array2D, %array2D* %r1171, i32 0, i32 0
  %r1173 = getelementptr [5 x i32], [5 x i32]* %r1172, i32 0, i32 1
  %r1175 = load i32, i32* %r1173, align 4
  %r1174 = mul i32 %r1175, 59
  %r1176 = add i32 %r1170, %r1174
  %r1177 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1178 = getelementptr %array2D, %array2D* %r1177, i32 0, i32 0
  %r1179 = getelementptr [5 x i32], [5 x i32]* %r1178, i32 0, i32 2
  %r1181 = load i32, i32* %r1179, align 4
  %r1180 = mul i32 %r1181, 52
  %r1182 = add i32 %r1176, %r1180
  %r1183 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1184 = getelementptr %array2D, %array2D* %r1183, i32 0, i32 0
  %r1185 = getelementptr [5 x i32], [5 x i32]* %r1184, i32 0, i32 3
  %r1187 = load i32, i32* %r1185, align 4
  %r1186 = mul i32 %r1187, 15
  %r1188 = add i32 %r1182, %r1186
  %r1189 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1190 = getelementptr %array2D, %array2D* %r1189, i32 0, i32 0
  %r1191 = getelementptr [5 x i32], [5 x i32]* %r1190, i32 0, i32 4
  %r1193 = load i32, i32* %r1191, align 4
  %r1192 = mul i32 %r1193, 55
  %r1194 = add i32 %r1188, %r1192
  %r1195 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1196 = getelementptr %array2D, %array2D* %r1195, i32 0, i32 0
  %r1197 = getelementptr [5 x i32], [5 x i32]* %r1196, i32 0, i32 0
  %r1198 = sub i32 0, 33
  %r1200 = load i32, i32* %r1197, align 4
  %r1199 = mul i32 %r1200, %r1198
  %r1201 = add i32 %r1194, %r1199
  %r1202 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1203 = getelementptr %array2D, %array2D* %r1202, i32 0, i32 0
  %r1204 = getelementptr [5 x i32], [5 x i32]* %r1203, i32 0, i32 1
  %r1206 = load i32, i32* %r1204, align 4
  %r1205 = mul i32 %r1206, 14
  %r1207 = add i32 %r1201, %r1205
  %r1208 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1209 = getelementptr %array2D, %array2D* %r1208, i32 0, i32 0
  %r1210 = getelementptr [5 x i32], [5 x i32]* %r1209, i32 0, i32 2
  %r1212 = load i32, i32* %r1210, align 4
  %r1211 = mul i32 %r1212, 58
  %r1213 = add i32 %r1207, %r1211
  %r1214 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1215 = getelementptr %array2D, %array2D* %r1214, i32 0, i32 0
  %r1216 = getelementptr [5 x i32], [5 x i32]* %r1215, i32 0, i32 3
  %r1218 = load i32, i32* %r1216, align 4
  %r1217 = mul i32 %r1218, 67
  %r1219 = add i32 %r1213, %r1217
  %r1220 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1221 = getelementptr %array2D, %array2D* %r1220, i32 0, i32 0
  %r1222 = getelementptr [5 x i32], [5 x i32]* %r1221, i32 0, i32 4
  %r1224 = load i32, i32* %r1222, align 4
  %r1223 = mul i32 %r1224, 86
  %r1225 = add i32 %r1219, %r1223
  %r1226 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1227 = getelementptr %array2D, %array2D* %r1226, i32 0, i32 0
  %r1228 = getelementptr [5 x i32], [5 x i32]* %r1227, i32 0, i32 0
  %r1229 = sub i32 0, 79
  %r1231 = load i32, i32* %r1228, align 4
  %r1230 = mul i32 %r1231, %r1229
  %r1232 = add i32 %r1225, %r1230
  %r1233 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1234 = getelementptr %array2D, %array2D* %r1233, i32 0, i32 0
  %r1235 = getelementptr [5 x i32], [5 x i32]* %r1234, i32 0, i32 1
  %r1237 = load i32, i32* %r1235, align 4
  %r1236 = mul i32 %r1237, 48
  %r1238 = add i32 %r1232, %r1236
  %r1239 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1240 = getelementptr %array2D, %array2D* %r1239, i32 0, i32 0
  %r1241 = getelementptr [5 x i32], [5 x i32]* %r1240, i32 0, i32 2
  %r1242 = sub i32 0, 13
  %r1244 = load i32, i32* %r1241, align 4
  %r1243 = mul i32 %r1244, %r1242
  %r1245 = add i32 %r1238, %r1243
  %r1246 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1247 = getelementptr %array2D, %array2D* %r1246, i32 0, i32 0
  %r1248 = getelementptr [5 x i32], [5 x i32]* %r1247, i32 0, i32 3
  %r1249 = sub i32 0, 15
  %r1251 = load i32, i32* %r1248, align 4
  %r1250 = mul i32 %r1251, %r1249
  %r1252 = add i32 %r1245, %r1250
  %r1253 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1254 = getelementptr %array2D, %array2D* %r1253, i32 0, i32 0
  %r1255 = getelementptr [5 x i32], [5 x i32]* %r1254, i32 0, i32 4
  %r1257 = load i32, i32* %r1255, align 4
  %r1256 = mul i32 %r1257, 66
  %r1258 = add i32 %r1252, %r1256
  %r1098 = call i32 @relu_reg(i32 %r1258)
  %r1259 = sub i32 0, 95
  %r1260 = mul i32 %r1098, %r1259
  %r1261 = add i32 %r1097, %r1260
  %r1263 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1264 = getelementptr %array2D, %array2D* %r1263, i32 0, i32 0
  %r1265 = getelementptr [5 x i32], [5 x i32]* %r1264, i32 0, i32 0
  %r1267 = load i32, i32* %r1265, align 4
  %r1266 = mul i32 %r1267, 33
  %r1268 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1269 = getelementptr %array2D, %array2D* %r1268, i32 0, i32 0
  %r1270 = getelementptr [5 x i32], [5 x i32]* %r1269, i32 0, i32 1
  %r1272 = load i32, i32* %r1270, align 4
  %r1271 = mul i32 %r1272, 82
  %r1273 = add i32 %r1266, %r1271
  %r1274 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1275 = getelementptr %array2D, %array2D* %r1274, i32 0, i32 0
  %r1276 = getelementptr [5 x i32], [5 x i32]* %r1275, i32 0, i32 2
  %r1278 = load i32, i32* %r1276, align 4
  %r1277 = mul i32 %r1278, 67
  %r1279 = add i32 %r1273, %r1277
  %r1280 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1281 = getelementptr %array2D, %array2D* %r1280, i32 0, i32 0
  %r1282 = getelementptr [5 x i32], [5 x i32]* %r1281, i32 0, i32 3
  %r1284 = load i32, i32* %r1282, align 4
  %r1283 = mul i32 %r1284, 30
  %r1285 = add i32 %r1279, %r1283
  %r1286 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1287 = getelementptr %array2D, %array2D* %r1286, i32 0, i32 0
  %r1288 = getelementptr [5 x i32], [5 x i32]* %r1287, i32 0, i32 4
  %r1289 = sub i32 0, 2
  %r1291 = load i32, i32* %r1288, align 4
  %r1290 = mul i32 %r1291, %r1289
  %r1292 = add i32 %r1285, %r1290
  %r1293 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1294 = getelementptr %array2D, %array2D* %r1293, i32 0, i32 0
  %r1295 = getelementptr [5 x i32], [5 x i32]* %r1294, i32 0, i32 0
  %r1297 = load i32, i32* %r1295, align 4
  %r1296 = mul i32 %r1297, 65
  %r1298 = add i32 %r1292, %r1296
  %r1299 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1300 = getelementptr %array2D, %array2D* %r1299, i32 0, i32 0
  %r1301 = getelementptr [5 x i32], [5 x i32]* %r1300, i32 0, i32 1
  %r1303 = load i32, i32* %r1301, align 4
  %r1302 = mul i32 %r1303, 120
  %r1304 = add i32 %r1298, %r1302
  %r1305 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1306 = getelementptr %array2D, %array2D* %r1305, i32 0, i32 0
  %r1307 = getelementptr [5 x i32], [5 x i32]* %r1306, i32 0, i32 2
  %r1308 = sub i32 0, 13
  %r1310 = load i32, i32* %r1307, align 4
  %r1309 = mul i32 %r1310, %r1308
  %r1311 = add i32 %r1304, %r1309
  %r1312 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1313 = getelementptr %array2D, %array2D* %r1312, i32 0, i32 0
  %r1314 = getelementptr [5 x i32], [5 x i32]* %r1313, i32 0, i32 3
  %r1316 = load i32, i32* %r1314, align 4
  %r1315 = mul i32 %r1316, 18
  %r1317 = add i32 %r1311, %r1315
  %r1318 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1319 = getelementptr %array2D, %array2D* %r1318, i32 0, i32 0
  %r1320 = getelementptr [5 x i32], [5 x i32]* %r1319, i32 0, i32 4
  %r1322 = load i32, i32* %r1320, align 4
  %r1321 = mul i32 %r1322, 5
  %r1323 = add i32 %r1317, %r1321
  %r1324 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1325 = getelementptr %array2D, %array2D* %r1324, i32 0, i32 0
  %r1326 = getelementptr [5 x i32], [5 x i32]* %r1325, i32 0, i32 0
  %r1328 = load i32, i32* %r1326, align 4
  %r1327 = mul i32 %r1328, 104
  %r1329 = add i32 %r1323, %r1327
  %r1330 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1331 = getelementptr %array2D, %array2D* %r1330, i32 0, i32 0
  %r1332 = getelementptr [5 x i32], [5 x i32]* %r1331, i32 0, i32 1
  %r1333 = sub i32 0, 119
  %r1335 = load i32, i32* %r1332, align 4
  %r1334 = mul i32 %r1335, %r1333
  %r1336 = add i32 %r1329, %r1334
  %r1337 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1338 = getelementptr %array2D, %array2D* %r1337, i32 0, i32 0
  %r1339 = getelementptr [5 x i32], [5 x i32]* %r1338, i32 0, i32 2
  %r1340 = sub i32 0, 7
  %r1342 = load i32, i32* %r1339, align 4
  %r1341 = mul i32 %r1342, %r1340
  %r1343 = add i32 %r1336, %r1341
  %r1344 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1345 = getelementptr %array2D, %array2D* %r1344, i32 0, i32 0
  %r1346 = getelementptr [5 x i32], [5 x i32]* %r1345, i32 0, i32 3
  %r1348 = load i32, i32* %r1346, align 4
  %r1347 = mul i32 %r1348, 71
  %r1349 = add i32 %r1343, %r1347
  %r1350 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1351 = getelementptr %array2D, %array2D* %r1350, i32 0, i32 0
  %r1352 = getelementptr [5 x i32], [5 x i32]* %r1351, i32 0, i32 4
  %r1354 = load i32, i32* %r1352, align 4
  %r1353 = mul i32 %r1354, 107
  %r1355 = add i32 %r1349, %r1353
  %r1356 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1357 = getelementptr %array2D, %array2D* %r1356, i32 0, i32 0
  %r1358 = getelementptr [5 x i32], [5 x i32]* %r1357, i32 0, i32 0
  %r1360 = load i32, i32* %r1358, align 4
  %r1359 = mul i32 %r1360, 24
  %r1361 = add i32 %r1355, %r1359
  %r1362 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1363 = getelementptr %array2D, %array2D* %r1362, i32 0, i32 0
  %r1364 = getelementptr [5 x i32], [5 x i32]* %r1363, i32 0, i32 1
  %r1366 = load i32, i32* %r1364, align 4
  %r1365 = mul i32 %r1366, 82
  %r1367 = add i32 %r1361, %r1365
  %r1368 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1369 = getelementptr %array2D, %array2D* %r1368, i32 0, i32 0
  %r1370 = getelementptr [5 x i32], [5 x i32]* %r1369, i32 0, i32 2
  %r1371 = sub i32 0, 96
  %r1373 = load i32, i32* %r1370, align 4
  %r1372 = mul i32 %r1373, %r1371
  %r1374 = add i32 %r1367, %r1372
  %r1375 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1376 = getelementptr %array2D, %array2D* %r1375, i32 0, i32 0
  %r1377 = getelementptr [5 x i32], [5 x i32]* %r1376, i32 0, i32 3
  %r1378 = sub i32 0, 104
  %r1380 = load i32, i32* %r1377, align 4
  %r1379 = mul i32 %r1380, %r1378
  %r1381 = add i32 %r1374, %r1379
  %r1382 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1383 = getelementptr %array2D, %array2D* %r1382, i32 0, i32 0
  %r1384 = getelementptr [5 x i32], [5 x i32]* %r1383, i32 0, i32 4
  %r1385 = sub i32 0, 121
  %r1387 = load i32, i32* %r1384, align 4
  %r1386 = mul i32 %r1387, %r1385
  %r1388 = add i32 %r1381, %r1386
  %r1389 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1390 = getelementptr %array2D, %array2D* %r1389, i32 0, i32 0
  %r1391 = getelementptr [5 x i32], [5 x i32]* %r1390, i32 0, i32 0
  %r1393 = load i32, i32* %r1391, align 4
  %r1392 = mul i32 %r1393, 65
  %r1394 = add i32 %r1388, %r1392
  %r1395 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1396 = getelementptr %array2D, %array2D* %r1395, i32 0, i32 0
  %r1397 = getelementptr [5 x i32], [5 x i32]* %r1396, i32 0, i32 1
  %r1399 = load i32, i32* %r1397, align 4
  %r1398 = mul i32 %r1399, 97
  %r1400 = add i32 %r1394, %r1398
  %r1401 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1402 = getelementptr %array2D, %array2D* %r1401, i32 0, i32 0
  %r1403 = getelementptr [5 x i32], [5 x i32]* %r1402, i32 0, i32 2
  %r1405 = load i32, i32* %r1403, align 4
  %r1404 = mul i32 %r1405, 83
  %r1406 = add i32 %r1400, %r1404
  %r1407 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1408 = getelementptr %array2D, %array2D* %r1407, i32 0, i32 0
  %r1409 = getelementptr [5 x i32], [5 x i32]* %r1408, i32 0, i32 3
  %r1411 = load i32, i32* %r1409, align 4
  %r1410 = mul i32 %r1411, 46
  %r1412 = add i32 %r1406, %r1410
  %r1413 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1414 = getelementptr %array2D, %array2D* %r1413, i32 0, i32 0
  %r1415 = getelementptr [5 x i32], [5 x i32]* %r1414, i32 0, i32 4
  %r1416 = sub i32 0, 84
  %r1418 = load i32, i32* %r1415, align 4
  %r1417 = mul i32 %r1418, %r1416
  %r1419 = add i32 %r1412, %r1417
  %r1262 = call i32 @relu_reg(i32 %r1419)
  %r1420 = sub i32 0, 50
  %r1421 = mul i32 %r1262, %r1420
  %r1422 = add i32 %r1261, %r1421
  %r1424 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1425 = getelementptr %array2D, %array2D* %r1424, i32 0, i32 0
  %r1426 = getelementptr [5 x i32], [5 x i32]* %r1425, i32 0, i32 0
  %r1427 = sub i32 0, 29
  %r1429 = load i32, i32* %r1426, align 4
  %r1428 = mul i32 %r1429, %r1427
  %r1430 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1431 = getelementptr %array2D, %array2D* %r1430, i32 0, i32 0
  %r1432 = getelementptr [5 x i32], [5 x i32]* %r1431, i32 0, i32 1
  %r1434 = load i32, i32* %r1432, align 4
  %r1433 = mul i32 %r1434, 7
  %r1435 = add i32 %r1428, %r1433
  %r1436 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1437 = getelementptr %array2D, %array2D* %r1436, i32 0, i32 0
  %r1438 = getelementptr [5 x i32], [5 x i32]* %r1437, i32 0, i32 2
  %r1439 = sub i32 0, 70
  %r1441 = load i32, i32* %r1438, align 4
  %r1440 = mul i32 %r1441, %r1439
  %r1442 = add i32 %r1435, %r1440
  %r1443 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1444 = getelementptr %array2D, %array2D* %r1443, i32 0, i32 0
  %r1445 = getelementptr [5 x i32], [5 x i32]* %r1444, i32 0, i32 3
  %r1447 = load i32, i32* %r1445, align 4
  %r1446 = mul i32 %r1447, 38
  %r1448 = add i32 %r1442, %r1446
  %r1449 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1450 = getelementptr %array2D, %array2D* %r1449, i32 0, i32 0
  %r1451 = getelementptr [5 x i32], [5 x i32]* %r1450, i32 0, i32 4
  %r1452 = sub i32 0, 90
  %r1454 = load i32, i32* %r1451, align 4
  %r1453 = mul i32 %r1454, %r1452
  %r1455 = add i32 %r1448, %r1453
  %r1456 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1457 = getelementptr %array2D, %array2D* %r1456, i32 0, i32 0
  %r1458 = getelementptr [5 x i32], [5 x i32]* %r1457, i32 0, i32 0
  %r1459 = sub i32 0, 15
  %r1461 = load i32, i32* %r1458, align 4
  %r1460 = mul i32 %r1461, %r1459
  %r1462 = add i32 %r1455, %r1460
  %r1463 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1464 = getelementptr %array2D, %array2D* %r1463, i32 0, i32 0
  %r1465 = getelementptr [5 x i32], [5 x i32]* %r1464, i32 0, i32 1
  %r1466 = sub i32 0, 32
  %r1468 = load i32, i32* %r1465, align 4
  %r1467 = mul i32 %r1468, %r1466
  %r1469 = add i32 %r1462, %r1467
  %r1470 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1471 = getelementptr %array2D, %array2D* %r1470, i32 0, i32 0
  %r1472 = getelementptr [5 x i32], [5 x i32]* %r1471, i32 0, i32 2
  %r1474 = load i32, i32* %r1472, align 4
  %r1473 = mul i32 %r1474, 37
  %r1475 = add i32 %r1469, %r1473
  %r1476 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1477 = getelementptr %array2D, %array2D* %r1476, i32 0, i32 0
  %r1478 = getelementptr [5 x i32], [5 x i32]* %r1477, i32 0, i32 3
  %r1480 = load i32, i32* %r1478, align 4
  %r1479 = mul i32 %r1480, 36
  %r1481 = add i32 %r1475, %r1479
  %r1482 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1483 = getelementptr %array2D, %array2D* %r1482, i32 0, i32 0
  %r1484 = getelementptr [5 x i32], [5 x i32]* %r1483, i32 0, i32 4
  %r1485 = sub i32 0, 62
  %r1487 = load i32, i32* %r1484, align 4
  %r1486 = mul i32 %r1487, %r1485
  %r1488 = add i32 %r1481, %r1486
  %r1489 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1490 = getelementptr %array2D, %array2D* %r1489, i32 0, i32 0
  %r1491 = getelementptr [5 x i32], [5 x i32]* %r1490, i32 0, i32 0
  %r1492 = sub i32 0, 125
  %r1494 = load i32, i32* %r1491, align 4
  %r1493 = mul i32 %r1494, %r1492
  %r1495 = add i32 %r1488, %r1493
  %r1496 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1497 = getelementptr %array2D, %array2D* %r1496, i32 0, i32 0
  %r1498 = getelementptr [5 x i32], [5 x i32]* %r1497, i32 0, i32 1
  %r1499 = sub i32 0, 46
  %r1501 = load i32, i32* %r1498, align 4
  %r1500 = mul i32 %r1501, %r1499
  %r1502 = add i32 %r1495, %r1500
  %r1503 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1504 = getelementptr %array2D, %array2D* %r1503, i32 0, i32 0
  %r1505 = getelementptr [5 x i32], [5 x i32]* %r1504, i32 0, i32 2
  %r1506 = sub i32 0, 70
  %r1508 = load i32, i32* %r1505, align 4
  %r1507 = mul i32 %r1508, %r1506
  %r1509 = add i32 %r1502, %r1507
  %r1510 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1511 = getelementptr %array2D, %array2D* %r1510, i32 0, i32 0
  %r1512 = getelementptr [5 x i32], [5 x i32]* %r1511, i32 0, i32 3
  %r1514 = load i32, i32* %r1512, align 4
  %r1513 = mul i32 %r1514, 37
  %r1515 = add i32 %r1509, %r1513
  %r1516 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1517 = getelementptr %array2D, %array2D* %r1516, i32 0, i32 0
  %r1518 = getelementptr [5 x i32], [5 x i32]* %r1517, i32 0, i32 4
  %r1519 = sub i32 0, 73
  %r1521 = load i32, i32* %r1518, align 4
  %r1520 = mul i32 %r1521, %r1519
  %r1522 = add i32 %r1515, %r1520
  %r1523 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1524 = getelementptr %array2D, %array2D* %r1523, i32 0, i32 0
  %r1525 = getelementptr [5 x i32], [5 x i32]* %r1524, i32 0, i32 0
  %r1526 = sub i32 0, 34
  %r1528 = load i32, i32* %r1525, align 4
  %r1527 = mul i32 %r1528, %r1526
  %r1529 = add i32 %r1522, %r1527
  %r1530 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1531 = getelementptr %array2D, %array2D* %r1530, i32 0, i32 0
  %r1532 = getelementptr [5 x i32], [5 x i32]* %r1531, i32 0, i32 1
  %r1533 = sub i32 0, 87
  %r1535 = load i32, i32* %r1532, align 4
  %r1534 = mul i32 %r1535, %r1533
  %r1536 = add i32 %r1529, %r1534
  %r1537 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1538 = getelementptr %array2D, %array2D* %r1537, i32 0, i32 0
  %r1539 = getelementptr [5 x i32], [5 x i32]* %r1538, i32 0, i32 2
  %r1540 = sub i32 0, 75
  %r1542 = load i32, i32* %r1539, align 4
  %r1541 = mul i32 %r1542, %r1540
  %r1543 = add i32 %r1536, %r1541
  %r1544 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1545 = getelementptr %array2D, %array2D* %r1544, i32 0, i32 0
  %r1546 = getelementptr [5 x i32], [5 x i32]* %r1545, i32 0, i32 3
  %r1548 = load i32, i32* %r1546, align 4
  %r1547 = mul i32 %r1548, 71
  %r1549 = add i32 %r1543, %r1547
  %r1550 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1551 = getelementptr %array2D, %array2D* %r1550, i32 0, i32 0
  %r1552 = getelementptr [5 x i32], [5 x i32]* %r1551, i32 0, i32 4
  %r1553 = sub i32 0, 77
  %r1555 = load i32, i32* %r1552, align 4
  %r1554 = mul i32 %r1555, %r1553
  %r1556 = add i32 %r1549, %r1554
  %r1557 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1558 = getelementptr %array2D, %array2D* %r1557, i32 0, i32 0
  %r1559 = getelementptr [5 x i32], [5 x i32]* %r1558, i32 0, i32 0
  %r1561 = load i32, i32* %r1559, align 4
  %r1560 = mul i32 %r1561, 53
  %r1562 = add i32 %r1556, %r1560
  %r1563 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1564 = getelementptr %array2D, %array2D* %r1563, i32 0, i32 0
  %r1565 = getelementptr [5 x i32], [5 x i32]* %r1564, i32 0, i32 1
  %r1567 = load i32, i32* %r1565, align 4
  %r1566 = mul i32 %r1567, 37
  %r1568 = add i32 %r1562, %r1566
  %r1569 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1570 = getelementptr %array2D, %array2D* %r1569, i32 0, i32 0
  %r1571 = getelementptr [5 x i32], [5 x i32]* %r1570, i32 0, i32 2
  %r1572 = sub i32 0, 103
  %r1574 = load i32, i32* %r1571, align 4
  %r1573 = mul i32 %r1574, %r1572
  %r1575 = add i32 %r1568, %r1573
  %r1576 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1577 = getelementptr %array2D, %array2D* %r1576, i32 0, i32 0
  %r1578 = getelementptr [5 x i32], [5 x i32]* %r1577, i32 0, i32 3
  %r1579 = sub i32 0, 13
  %r1581 = load i32, i32* %r1578, align 4
  %r1580 = mul i32 %r1581, %r1579
  %r1582 = add i32 %r1575, %r1580
  %r1583 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1584 = getelementptr %array2D, %array2D* %r1583, i32 0, i32 0
  %r1585 = getelementptr [5 x i32], [5 x i32]* %r1584, i32 0, i32 4
  %r1586 = sub i32 0, 114
  %r1588 = load i32, i32* %r1585, align 4
  %r1587 = mul i32 %r1588, %r1586
  %r1589 = add i32 %r1582, %r1587
  %r1423 = call i32 @relu_reg(i32 %r1589)
  %r1590 = sub i32 0, 23
  %r1591 = mul i32 %r1423, %r1590
  %r1592 = add i32 %r1422, %r1591
  %r1594 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1595 = getelementptr %array2D, %array2D* %r1594, i32 0, i32 0
  %r1596 = getelementptr [5 x i32], [5 x i32]* %r1595, i32 0, i32 0
  %r1598 = load i32, i32* %r1596, align 4
  %r1597 = mul i32 %r1598, 67
  %r1599 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1600 = getelementptr %array2D, %array2D* %r1599, i32 0, i32 0
  %r1601 = getelementptr [5 x i32], [5 x i32]* %r1600, i32 0, i32 1
  %r1603 = load i32, i32* %r1601, align 4
  %r1602 = mul i32 %r1603, 42
  %r1604 = add i32 %r1597, %r1602
  %r1605 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1606 = getelementptr %array2D, %array2D* %r1605, i32 0, i32 0
  %r1607 = getelementptr [5 x i32], [5 x i32]* %r1606, i32 0, i32 2
  %r1609 = load i32, i32* %r1607, align 4
  %r1608 = mul i32 %r1609, 41
  %r1610 = add i32 %r1604, %r1608
  %r1611 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1612 = getelementptr %array2D, %array2D* %r1611, i32 0, i32 0
  %r1613 = getelementptr [5 x i32], [5 x i32]* %r1612, i32 0, i32 3
  %r1614 = sub i32 0, 123
  %r1616 = load i32, i32* %r1613, align 4
  %r1615 = mul i32 %r1616, %r1614
  %r1617 = add i32 %r1610, %r1615
  %r1618 = getelementptr %array2D, %array2D* %r107, i32 0
  %r1619 = getelementptr %array2D, %array2D* %r1618, i32 0, i32 0
  %r1620 = getelementptr [5 x i32], [5 x i32]* %r1619, i32 0, i32 4
  %r1621 = sub i32 0, 92
  %r1623 = load i32, i32* %r1620, align 4
  %r1622 = mul i32 %r1623, %r1621
  %r1624 = add i32 %r1617, %r1622
  %r1625 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1626 = getelementptr %array2D, %array2D* %r1625, i32 0, i32 0
  %r1627 = getelementptr [5 x i32], [5 x i32]* %r1626, i32 0, i32 0
  %r1629 = load i32, i32* %r1627, align 4
  %r1628 = mul i32 %r1629, 10
  %r1630 = add i32 %r1624, %r1628
  %r1631 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1632 = getelementptr %array2D, %array2D* %r1631, i32 0, i32 0
  %r1633 = getelementptr [5 x i32], [5 x i32]* %r1632, i32 0, i32 1
  %r1634 = sub i32 0, 77
  %r1636 = load i32, i32* %r1633, align 4
  %r1635 = mul i32 %r1636, %r1634
  %r1637 = add i32 %r1630, %r1635
  %r1638 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1639 = getelementptr %array2D, %array2D* %r1638, i32 0, i32 0
  %r1640 = getelementptr [5 x i32], [5 x i32]* %r1639, i32 0, i32 2
  %r1642 = load i32, i32* %r1640, align 4
  %r1641 = mul i32 %r1642, 75
  %r1643 = add i32 %r1637, %r1641
  %r1644 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1645 = getelementptr %array2D, %array2D* %r1644, i32 0, i32 0
  %r1646 = getelementptr [5 x i32], [5 x i32]* %r1645, i32 0, i32 3
  %r1648 = load i32, i32* %r1646, align 4
  %r1647 = mul i32 %r1648, 96
  %r1649 = add i32 %r1643, %r1647
  %r1650 = getelementptr %array2D, %array2D* %r107, i32 1
  %r1651 = getelementptr %array2D, %array2D* %r1650, i32 0, i32 0
  %r1652 = getelementptr [5 x i32], [5 x i32]* %r1651, i32 0, i32 4
  %r1653 = sub i32 0, 51
  %r1655 = load i32, i32* %r1652, align 4
  %r1654 = mul i32 %r1655, %r1653
  %r1656 = add i32 %r1649, %r1654
  %r1657 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1658 = getelementptr %array2D, %array2D* %r1657, i32 0, i32 0
  %r1659 = getelementptr [5 x i32], [5 x i32]* %r1658, i32 0, i32 0
  %r1661 = load i32, i32* %r1659, align 4
  %r1660 = mul i32 %r1661, 109
  %r1662 = add i32 %r1656, %r1660
  %r1663 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1664 = getelementptr %array2D, %array2D* %r1663, i32 0, i32 0
  %r1665 = getelementptr [5 x i32], [5 x i32]* %r1664, i32 0, i32 1
  %r1666 = sub i32 0, 74
  %r1668 = load i32, i32* %r1665, align 4
  %r1667 = mul i32 %r1668, %r1666
  %r1669 = add i32 %r1662, %r1667
  %r1670 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1671 = getelementptr %array2D, %array2D* %r1670, i32 0, i32 0
  %r1672 = getelementptr [5 x i32], [5 x i32]* %r1671, i32 0, i32 2
  %r1673 = sub i32 0, 7
  %r1675 = load i32, i32* %r1672, align 4
  %r1674 = mul i32 %r1675, %r1673
  %r1676 = add i32 %r1669, %r1674
  %r1677 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1678 = getelementptr %array2D, %array2D* %r1677, i32 0, i32 0
  %r1679 = getelementptr [5 x i32], [5 x i32]* %r1678, i32 0, i32 3
  %r1680 = sub i32 0, 122
  %r1682 = load i32, i32* %r1679, align 4
  %r1681 = mul i32 %r1682, %r1680
  %r1683 = add i32 %r1676, %r1681
  %r1684 = getelementptr %array2D, %array2D* %r107, i32 2
  %r1685 = getelementptr %array2D, %array2D* %r1684, i32 0, i32 0
  %r1686 = getelementptr [5 x i32], [5 x i32]* %r1685, i32 0, i32 4
  %r1688 = load i32, i32* %r1686, align 4
  %r1687 = mul i32 %r1688, 67
  %r1689 = add i32 %r1683, %r1687
  %r1690 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1691 = getelementptr %array2D, %array2D* %r1690, i32 0, i32 0
  %r1692 = getelementptr [5 x i32], [5 x i32]* %r1691, i32 0, i32 0
  %r1694 = load i32, i32* %r1692, align 4
  %r1693 = mul i32 %r1694, 47
  %r1695 = add i32 %r1689, %r1693
  %r1696 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1697 = getelementptr %array2D, %array2D* %r1696, i32 0, i32 0
  %r1698 = getelementptr [5 x i32], [5 x i32]* %r1697, i32 0, i32 1
  %r1700 = load i32, i32* %r1698, align 4
  %r1699 = mul i32 %r1700, 22
  %r1701 = add i32 %r1695, %r1699
  %r1702 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1703 = getelementptr %array2D, %array2D* %r1702, i32 0, i32 0
  %r1704 = getelementptr [5 x i32], [5 x i32]* %r1703, i32 0, i32 2
  %r1705 = sub i32 0, 68
  %r1707 = load i32, i32* %r1704, align 4
  %r1706 = mul i32 %r1707, %r1705
  %r1708 = add i32 %r1701, %r1706
  %r1709 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1710 = getelementptr %array2D, %array2D* %r1709, i32 0, i32 0
  %r1711 = getelementptr [5 x i32], [5 x i32]* %r1710, i32 0, i32 3
  %r1713 = load i32, i32* %r1711, align 4
  %r1712 = mul i32 %r1713, 38
  %r1714 = add i32 %r1708, %r1712
  %r1715 = getelementptr %array2D, %array2D* %r107, i32 3
  %r1716 = getelementptr %array2D, %array2D* %r1715, i32 0, i32 0
  %r1717 = getelementptr [5 x i32], [5 x i32]* %r1716, i32 0, i32 4
  %r1719 = load i32, i32* %r1717, align 4
  %r1718 = mul i32 %r1719, 29
  %r1720 = add i32 %r1714, %r1718
  %r1721 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1722 = getelementptr %array2D, %array2D* %r1721, i32 0, i32 0
  %r1723 = getelementptr [5 x i32], [5 x i32]* %r1722, i32 0, i32 0
  %r1725 = load i32, i32* %r1723, align 4
  %r1724 = mul i32 %r1725, 115
  %r1726 = add i32 %r1720, %r1724
  %r1727 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1728 = getelementptr %array2D, %array2D* %r1727, i32 0, i32 0
  %r1729 = getelementptr [5 x i32], [5 x i32]* %r1728, i32 0, i32 1
  %r1730 = sub i32 0, 121
  %r1732 = load i32, i32* %r1729, align 4
  %r1731 = mul i32 %r1732, %r1730
  %r1733 = add i32 %r1726, %r1731
  %r1734 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1735 = getelementptr %array2D, %array2D* %r1734, i32 0, i32 0
  %r1736 = getelementptr [5 x i32], [5 x i32]* %r1735, i32 0, i32 2
  %r1738 = load i32, i32* %r1736, align 4
  %r1737 = mul i32 %r1738, 36
  %r1739 = add i32 %r1733, %r1737
  %r1740 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1741 = getelementptr %array2D, %array2D* %r1740, i32 0, i32 0
  %r1742 = getelementptr [5 x i32], [5 x i32]* %r1741, i32 0, i32 3
  %r1743 = sub i32 0, 49
  %r1745 = load i32, i32* %r1742, align 4
  %r1744 = mul i32 %r1745, %r1743
  %r1746 = add i32 %r1739, %r1744
  %r1747 = getelementptr %array2D, %array2D* %r107, i32 4
  %r1748 = getelementptr %array2D, %array2D* %r1747, i32 0, i32 0
  %r1749 = getelementptr [5 x i32], [5 x i32]* %r1748, i32 0, i32 4
  %r1751 = load i32, i32* %r1749, align 4
  %r1750 = mul i32 %r1751, 85
  %r1752 = add i32 %r1746, %r1750
  %r1593 = call i32 @relu_reg(i32 %r1752)
  %r1753 = mul i32 %r1593, 46
  %r1754 = add i32 %r1592, %r1753
  %r108 = icmp sgt i32 %r1754, 0
  br i1 %r108, label %bb7, label %bb8

bb7:                                              ; preds = %model
  ret i32 1

0:                                                ; No predecessors!
  br label %bb9

bb8:                                              ; preds = %model
  br label %bb9

bb9:                                              ; preds = %bb8, %0
  ret i32 0

1:                                                ; No predecessors!
  ret i32 0
}

define i32 @main() {
main:
  %r1763 = alloca i32, align 4
  %r1760 = alloca i32, align 4
  %r1755 = call i32 @getint()
  %r1756 = alloca i32, align 4
  store i32 %r1755, i32* %r1756, align 4
  %r1757 = alloca [5 x %array2D], align 8
  br label %bb10

bb10:                                             ; preds = %bb21, %main
  %r1759 = load i32, i32* %r1756, align 4
  %r1758 = icmp sgt i32 %r1759, 0
  br i1 %r1758, label %bb11, label %bb12

bb11:                                             ; preds = %bb10
  store i32 0, i32* %r1760, align 4
  br label %bb13

bb13:                                             ; preds = %bb18, %bb11
  %r1762 = load i32, i32* %r1760, align 4
  %r1761 = icmp slt i32 %r1762, 5
  br i1 %r1761, label %bb14, label %bb15

bb14:                                             ; preds = %bb13
  store i32 0, i32* %r1763, align 4
  br label %bb16

bb16:                                             ; preds = %bb17, %bb14
  %r1765 = load i32, i32* %r1763, align 4
  %r1764 = icmp slt i32 %r1765, 5
  br i1 %r1764, label %bb17, label %bb18

bb17:                                             ; preds = %bb16
  %r1767 = load i32, i32* %r1760, align 4
  %r1766 = getelementptr [5 x %array2D], [5 x %array2D]* %r1757, i32 0, i32 %r1767
  %r1768 = getelementptr %array2D, %array2D* %r1766, i32 0, i32 0
  %r1770 = load i32, i32* %r1763, align 4
  %r1769 = getelementptr [5 x i32], [5 x i32]* %r1768, i32 0, i32 %r1770
  %r1771 = call i32 @getint()
  store i32 %r1771, i32* %r1769, align 4
  %r1773 = load i32, i32* %r1763, align 4
  %r1772 = add i32 %r1773, 1
  store i32 %r1772, i32* %r1763, align 4
  br label %bb16

bb18:                                             ; preds = %bb16
  %r1775 = load i32, i32* %r1760, align 4
  %r1774 = add i32 %r1775, 1
  store i32 %r1774, i32* %r1760, align 4
  br label %bb13

bb15:                                             ; preds = %bb13
  %r1778 = getelementptr [5 x %array2D], [5 x %array2D]* %r1757, i32 0, i32 0
  %r1777 = call i32 @model(%array2D* %r1778)
  %r1776 = icmp ne i32 %r1777, 0
  br i1 %r1776, label %bb19, label %bb20

bb19:                                             ; preds = %bb15
  call void @putch(i32 99)
  call void @putch(i32 97)
  call void @putch(i32 116)
  call void @putch(i32 10)
  br label %bb21

bb20:                                             ; preds = %bb15
  call void @putch(i32 100)
  call void @putch(i32 111)
  call void @putch(i32 103)
  call void @putch(i32 10)
  br label %bb21

bb21:                                             ; preds = %bb20, %bb19
  %r1780 = load i32, i32* %r1756, align 4
  %r1779 = sub i32 %r1780, 1
  store i32 %r1779, i32* %r1756, align 4
  br label %bb10

bb12:                                             ; preds = %bb10
  ret i32 0

0:                                                ; No predecessors!
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @before_main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %2

2:                                                ; preds = %18, %0
  %3 = load i32, i32* %1, align 4
  %4 = icmp slt i32 %3, 1024
  br i1 %4, label %5, label %21

5:                                                ; preds = %2
  %6 = load i32, i32* %1, align 4
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 %7
  store i32 0, i32* %8, align 4
  %9 = load i32, i32* %1, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 %10
  store i32 0, i32* %11, align 4
  %12 = load i32, i32* %1, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 %13
  store i32 0, i32* %14, align 4
  %15 = load i32, i32* %1, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 %16
  store i32 0, i32* %17, align 4
  br label %18

18:                                               ; preds = %5
  %19 = load i32, i32* %1, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, i32* %1, align 4
  br label %2, !llvm.loop !6

21:                                               ; preds = %2
  store i32 1, i32* @_sysy_idx, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @after_main() #0 {
  %1 = alloca i32, align 4
  store i32 1, i32* %1, align 4
  br label %2

2:                                                ; preds = %63, %0
  %3 = load i32, i32* %1, align 4
  %4 = load i32, i32* @_sysy_idx, align 4
  %5 = icmp slt i32 %3, %4
  br i1 %5, label %6, label %66

6:                                                ; preds = %2
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %8 = load i32, i32* %1, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_l1, i64 0, i64 %9
  %11 = load i32, i32* %10, align 4
  %12 = load i32, i32* %1, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_l2, i64 0, i64 %13
  %15 = load i32, i32* %14, align 4
  %16 = load i32, i32* %1, align 4
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 %17
  %19 = load i32, i32* %18, align 4
  %20 = load i32, i32* %1, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 %21
  %23 = load i32, i32* %22, align 4
  %24 = load i32, i32* %1, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 %25
  %27 = load i32, i32* %26, align 4
  %28 = load i32, i32* %1, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 %29
  %31 = load i32, i32* %30, align 4
  %32 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* noundef %7, i8* noundef getelementptr inbounds ([35 x i8], [35 x i8]* @.str.5, i64 0, i64 0), i32 noundef %11, i32 noundef %15, i32 noundef %19, i32 noundef %23, i32 noundef %27, i32 noundef %31)
  %33 = load i32, i32* %1, align 4
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 %34
  %36 = load i32, i32* %35, align 4
  %37 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 0), align 16
  %38 = add nsw i32 %37, %36
  store i32 %38, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 0), align 16
  %39 = load i32, i32* %1, align 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 %40
  %42 = load i32, i32* %41, align 4
  %43 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 0), align 16
  %44 = add nsw i32 %43, %42
  store i32 %44, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 0), align 16
  %45 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 0), align 16
  %46 = srem i32 %45, 1000000
  store i32 %46, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 0), align 16
  %47 = load i32, i32* %1, align 4
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 %48
  %50 = load i32, i32* %49, align 4
  %51 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 0), align 16
  %52 = add nsw i32 %51, %50
  store i32 %52, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 0), align 16
  %53 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 0), align 16
  %54 = srem i32 %53, 60
  store i32 %54, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 0), align 16
  %55 = load i32, i32* %1, align 4
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 %56
  %58 = load i32, i32* %57, align 4
  %59 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 0), align 16
  %60 = add nsw i32 %59, %58
  store i32 %60, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 0), align 16
  %61 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 0), align 16
  %62 = srem i32 %61, 60
  store i32 %62, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 0), align 16
  br label %63

63:                                               ; preds = %6
  %64 = load i32, i32* %1, align 4
  %65 = add nsw i32 %64, 1
  store i32 %65, i32* %1, align 4
  br label %2, !llvm.loop !8

66:                                               ; preds = %2
  %67 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %68 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 0), align 16
  %69 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 0), align 16
  %70 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 0), align 16
  %71 = load i32, i32* getelementptr inbounds ([1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 0), align 16
  %72 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* noundef %67, i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.6, i64 0, i64 0), i32 noundef %68, i32 noundef %69, i32 noundef %70, i32 noundef %71)
  ret void
}

declare i32 @fprintf(%struct._IO_FILE* noundef, i8* noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @getint() #0 {
  %1 = alloca i32, align 4
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32* noundef %1)
  %3 = load i32, i32* %1, align 4
  ret i32 %3
}

declare i32 @__isoc99_scanf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @getch() #0 {
  %1 = alloca i8, align 1
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0), i8* noundef %1)
  %3 = load i8, i8* %1, align 1
  %4 = sext i8 %3 to i32
  ret i32 %4
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @getarray(i32* noundef %0) #0 {
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32* %0, i32** %2, align 8
  %5 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32* noundef %3)
  store i32 0, i32* %4, align 4
  br label %6

6:                                                ; preds = %16, %1
  %7 = load i32, i32* %4, align 4
  %8 = load i32, i32* %3, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %10, label %19

10:                                               ; preds = %6
  %11 = load i32*, i32** %2, align 8
  %12 = load i32, i32* %4, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds i32, i32* %11, i64 %13
  %15 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32* noundef %14)
  br label %16

16:                                               ; preds = %10
  %17 = load i32, i32* %4, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* %4, align 4
  br label %6, !llvm.loop !9

19:                                               ; preds = %6
  %20 = load i32, i32* %3, align 4
  ret i32 %20
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @putint(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32 noundef %3)
  ret void
}

declare i32 @printf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @putch(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0), i32 noundef %3)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @putarray(i32 noundef %0, i32* noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32*, align 8
  %5 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32* %1, i32** %4, align 8
  %6 = load i32, i32* %3, align 4
  %7 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i32 noundef %6)
  store i32 0, i32* %5, align 4
  br label %8

8:                                                ; preds = %19, %2
  %9 = load i32, i32* %5, align 4
  %10 = load i32, i32* %3, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %12, label %22

12:                                               ; preds = %8
  %13 = load i32*, i32** %4, align 8
  %14 = load i32, i32* %5, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds i32, i32* %13, i64 %15
  %17 = load i32, i32* %16, align 4
  %18 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i32 noundef %17)
  br label %19

19:                                               ; preds = %12
  %20 = load i32, i32* %5, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, i32* %5, align 4
  br label %8, !llvm.loop !10

22:                                               ; preds = %8
  %23 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0))
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_sysy_starttime(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = load i32, i32* @_sysy_idx, align 4
  %5 = sext i32 %4 to i64
  %6 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_l1, i64 0, i64 %5
  store i32 %3, i32* %6, align 4
  %7 = call i32 @gettimeofday(%struct.timeval* noundef @_sysy_start, i8* noundef null) #3
  ret void
}

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_sysy_stoptime(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = call i32 @gettimeofday(%struct.timeval* noundef @_sysy_end, i8* noundef null) #3
  %4 = load i32, i32* %2, align 4
  %5 = load i32, i32* @_sysy_idx, align 4
  %6 = sext i32 %5 to i64
  %7 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_l2, i64 0, i64 %6
  store i32 %4, i32* %7, align 4
  %8 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @_sysy_end, i32 0, i32 0), align 8
  %9 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @_sysy_start, i32 0, i32 0), align 8
  %10 = sub nsw i64 %8, %9
  %11 = mul nsw i64 1000000, %10
  %12 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @_sysy_end, i32 0, i32 1), align 8
  %13 = add nsw i64 %11, %12
  %14 = load i64, i64* getelementptr inbounds (%struct.timeval, %struct.timeval* @_sysy_start, i32 0, i32 1), align 8
  %15 = sub nsw i64 %13, %14
  %16 = load i32, i32* @_sysy_idx, align 4
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 %17
  %19 = load i32, i32* %18, align 4
  %20 = sext i32 %19 to i64
  %21 = add nsw i64 %20, %15
  %22 = trunc i64 %21 to i32
  store i32 %22, i32* %18, align 4
  %23 = load i32, i32* @_sysy_idx, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 %24
  %26 = load i32, i32* %25, align 4
  %27 = sdiv i32 %26, 1000000
  %28 = load i32, i32* @_sysy_idx, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 %29
  %31 = load i32, i32* %30, align 4
  %32 = add nsw i32 %31, %27
  store i32 %32, i32* %30, align 4
  %33 = load i32, i32* @_sysy_idx, align 4
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_us, i64 0, i64 %34
  %36 = load i32, i32* %35, align 4
  %37 = srem i32 %36, 1000000
  store i32 %37, i32* %35, align 4
  %38 = load i32, i32* @_sysy_idx, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 %39
  %41 = load i32, i32* %40, align 4
  %42 = sdiv i32 %41, 60
  %43 = load i32, i32* @_sysy_idx, align 4
  %44 = sext i32 %43 to i64
  %45 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 %44
  %46 = load i32, i32* %45, align 4
  %47 = add nsw i32 %46, %42
  store i32 %47, i32* %45, align 4
  %48 = load i32, i32* @_sysy_idx, align 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_s, i64 0, i64 %49
  %51 = load i32, i32* %50, align 4
  %52 = srem i32 %51, 60
  store i32 %52, i32* %50, align 4
  %53 = load i32, i32* @_sysy_idx, align 4
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 %54
  %56 = load i32, i32* %55, align 4
  %57 = sdiv i32 %56, 60
  %58 = load i32, i32* @_sysy_idx, align 4
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_h, i64 0, i64 %59
  %61 = load i32, i32* %60, align 4
  %62 = add nsw i32 %61, %57
  store i32 %62, i32* %60, align 4
  %63 = load i32, i32* @_sysy_idx, align 4
  %64 = sext i32 %63 to i64
  %65 = getelementptr inbounds [1024 x i32], [1024 x i32]* @_sysy_m, i64 0, i64 %64
  %66 = load i32, i32* %65, align 4
  %67 = srem i32 %66, 60
  store i32 %67, i32* %65, align 4
  %68 = load i32, i32* @_sysy_idx, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* @_sysy_idx, align 4
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
