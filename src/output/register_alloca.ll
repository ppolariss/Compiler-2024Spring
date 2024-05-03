; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.timeval = type { i64, i64 }

@a1 = global i32 1
@a2 = global i32 2
@a3 = global i32 3
@a4 = global i32 4
@a5 = global i32 5
@a6 = global i32 6
@a7 = global i32 7
@a8 = global i32 8
@a9 = global i32 9
@a10 = global i32 10
@a11 = global i32 11
@a12 = global i32 12
@a13 = global i32 13
@a14 = global i32 14
@a15 = global i32 15
@a16 = global i32 16
@a17 = global i32 1
@a18 = global i32 2
@a19 = global i32 3
@a20 = global i32 4
@a21 = global i32 5
@a22 = global i32 6
@a23 = global i32 7
@a24 = global i32 8
@a25 = global i32 9
@a26 = global i32 10
@a27 = global i32 11
@a28 = global i32 12
@a29 = global i32 13
@a30 = global i32 14
@a31 = global i32 15
@a32 = global i32 16
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

define i32 @func(i32 %r100, i32 %r102) {
func:
  %r101 = alloca i32, align 4
  store i32 %r100, i32* %r101, align 4
  %r103 = alloca i32, align 4
  store i32 %r102, i32* %r103, align 4
  %r104 = alloca i32, align 4
  %r106 = load i32, i32* %r101, align 4
  %r107 = load i32, i32* %r103, align 4
  %r105 = add i32 %r106, %r107
  store i32 %r105, i32* %r104, align 4
  %r108 = alloca i32, align 4
  %r109 = alloca i32, align 4
  %r110 = alloca i32, align 4
  %r111 = alloca i32, align 4
  %r112 = alloca i32, align 4
  %r113 = alloca i32, align 4
  %r114 = alloca i32, align 4
  %r115 = alloca i32, align 4
  %r116 = alloca i32, align 4
  %r117 = alloca i32, align 4
  %r118 = alloca i32, align 4
  %r119 = alloca i32, align 4
  %r120 = alloca i32, align 4
  %r121 = alloca i32, align 4
  %r122 = alloca i32, align 4
  %r123 = alloca i32, align 4
  %r124 = alloca i32, align 4
  %r125 = alloca i32, align 4
  %r126 = alloca i32, align 4
  %r127 = alloca i32, align 4
  %r128 = alloca i32, align 4
  %r129 = alloca i32, align 4
  %r130 = alloca i32, align 4
  %r131 = alloca i32, align 4
  %r132 = alloca i32, align 4
  %r133 = alloca i32, align 4
  %r134 = alloca i32, align 4
  %r135 = alloca i32, align 4
  %r136 = alloca i32, align 4
  %r137 = alloca i32, align 4
  %r138 = alloca i32, align 4
  %r139 = alloca i32, align 4
  %r140 = alloca i32, align 4
  %r141 = alloca i32, align 4
  %r142 = alloca i32, align 4
  %r143 = alloca i32, align 4
  %r144 = call i32 @getint()
  store i32 %r144, i32* %r108, align 4
  %r145 = call i32 @getint()
  store i32 %r145, i32* %r109, align 4
  %r146 = call i32 @getint()
  store i32 %r146, i32* %r110, align 4
  %r147 = call i32 @getint()
  store i32 %r147, i32* %r111, align 4
  %r149 = load i32, i32* %r108, align 4
  %r148 = add i32 1, %r149
  %r151 = load i32, i32* @a1, align 4
  %r150 = add i32 %r148, %r151
  store i32 %r150, i32* %r112, align 4
  %r153 = load i32, i32* %r109, align 4
  %r152 = add i32 2, %r153
  %r155 = load i32, i32* @a2, align 4
  %r154 = add i32 %r152, %r155
  store i32 %r154, i32* %r113, align 4
  %r157 = load i32, i32* %r110, align 4
  %r156 = add i32 3, %r157
  %r159 = load i32, i32* @a3, align 4
  %r158 = add i32 %r156, %r159
  store i32 %r158, i32* %r114, align 4
  %r161 = load i32, i32* %r111, align 4
  %r160 = add i32 4, %r161
  %r163 = load i32, i32* @a4, align 4
  %r162 = add i32 %r160, %r163
  store i32 %r162, i32* %r115, align 4
  %r165 = load i32, i32* %r112, align 4
  %r164 = add i32 1, %r165
  %r167 = load i32, i32* @a5, align 4
  %r166 = add i32 %r164, %r167
  store i32 %r166, i32* %r116, align 4
  %r169 = load i32, i32* %r113, align 4
  %r168 = add i32 2, %r169
  %r171 = load i32, i32* @a6, align 4
  %r170 = add i32 %r168, %r171
  store i32 %r170, i32* %r117, align 4
  %r173 = load i32, i32* %r114, align 4
  %r172 = add i32 3, %r173
  %r175 = load i32, i32* @a7, align 4
  %r174 = add i32 %r172, %r175
  store i32 %r174, i32* %r118, align 4
  %r177 = load i32, i32* %r115, align 4
  %r176 = add i32 4, %r177
  %r179 = load i32, i32* @a8, align 4
  %r178 = add i32 %r176, %r179
  store i32 %r178, i32* %r119, align 4
  %r181 = load i32, i32* %r116, align 4
  %r180 = add i32 1, %r181
  %r183 = load i32, i32* @a9, align 4
  %r182 = add i32 %r180, %r183
  store i32 %r182, i32* %r120, align 4
  %r185 = load i32, i32* %r117, align 4
  %r184 = add i32 2, %r185
  %r187 = load i32, i32* @a10, align 4
  %r186 = add i32 %r184, %r187
  store i32 %r186, i32* %r121, align 4
  %r189 = load i32, i32* %r118, align 4
  %r188 = add i32 3, %r189
  %r191 = load i32, i32* @a11, align 4
  %r190 = add i32 %r188, %r191
  store i32 %r190, i32* %r122, align 4
  %r193 = load i32, i32* %r119, align 4
  %r192 = add i32 4, %r193
  %r195 = load i32, i32* @a12, align 4
  %r194 = add i32 %r192, %r195
  store i32 %r194, i32* %r123, align 4
  %r197 = load i32, i32* %r120, align 4
  %r196 = add i32 1, %r197
  %r199 = load i32, i32* @a13, align 4
  %r198 = add i32 %r196, %r199
  store i32 %r198, i32* %r124, align 4
  %r201 = load i32, i32* %r121, align 4
  %r200 = add i32 2, %r201
  %r203 = load i32, i32* @a14, align 4
  %r202 = add i32 %r200, %r203
  store i32 %r202, i32* %r125, align 4
  %r205 = load i32, i32* %r122, align 4
  %r204 = add i32 3, %r205
  %r207 = load i32, i32* @a15, align 4
  %r206 = add i32 %r204, %r207
  store i32 %r206, i32* %r126, align 4
  %r209 = load i32, i32* %r123, align 4
  %r208 = add i32 4, %r209
  %r211 = load i32, i32* @a16, align 4
  %r210 = add i32 %r208, %r211
  store i32 %r210, i32* %r127, align 4
  %r213 = load i32, i32* %r124, align 4
  %r212 = add i32 1, %r213
  %r215 = load i32, i32* @a17, align 4
  %r214 = add i32 %r212, %r215
  store i32 %r214, i32* %r128, align 4
  %r217 = load i32, i32* %r125, align 4
  %r216 = add i32 2, %r217
  %r219 = load i32, i32* @a18, align 4
  %r218 = add i32 %r216, %r219
  store i32 %r218, i32* %r129, align 4
  %r221 = load i32, i32* %r126, align 4
  %r220 = add i32 3, %r221
  %r223 = load i32, i32* @a19, align 4
  %r222 = add i32 %r220, %r223
  store i32 %r222, i32* %r130, align 4
  %r225 = load i32, i32* %r127, align 4
  %r224 = add i32 4, %r225
  %r227 = load i32, i32* @a20, align 4
  %r226 = add i32 %r224, %r227
  store i32 %r226, i32* %r131, align 4
  %r229 = load i32, i32* %r128, align 4
  %r228 = add i32 1, %r229
  %r231 = load i32, i32* @a21, align 4
  %r230 = add i32 %r228, %r231
  store i32 %r230, i32* %r132, align 4
  %r233 = load i32, i32* %r129, align 4
  %r232 = add i32 2, %r233
  %r235 = load i32, i32* @a22, align 4
  %r234 = add i32 %r232, %r235
  store i32 %r234, i32* %r133, align 4
  %r237 = load i32, i32* %r130, align 4
  %r236 = add i32 3, %r237
  %r239 = load i32, i32* @a23, align 4
  %r238 = add i32 %r236, %r239
  store i32 %r238, i32* %r134, align 4
  %r241 = load i32, i32* %r131, align 4
  %r240 = add i32 4, %r241
  %r243 = load i32, i32* @a24, align 4
  %r242 = add i32 %r240, %r243
  store i32 %r242, i32* %r135, align 4
  %r245 = load i32, i32* %r132, align 4
  %r244 = add i32 1, %r245
  %r247 = load i32, i32* @a25, align 4
  %r246 = add i32 %r244, %r247
  store i32 %r246, i32* %r136, align 4
  %r249 = load i32, i32* %r133, align 4
  %r248 = add i32 2, %r249
  %r251 = load i32, i32* @a26, align 4
  %r250 = add i32 %r248, %r251
  store i32 %r250, i32* %r137, align 4
  %r253 = load i32, i32* %r134, align 4
  %r252 = add i32 3, %r253
  %r255 = load i32, i32* @a27, align 4
  %r254 = add i32 %r252, %r255
  store i32 %r254, i32* %r138, align 4
  %r257 = load i32, i32* %r135, align 4
  %r256 = add i32 4, %r257
  %r259 = load i32, i32* @a28, align 4
  %r258 = add i32 %r256, %r259
  store i32 %r258, i32* %r139, align 4
  %r261 = load i32, i32* %r136, align 4
  %r260 = add i32 1, %r261
  %r263 = load i32, i32* @a29, align 4
  %r262 = add i32 %r260, %r263
  store i32 %r262, i32* %r140, align 4
  %r265 = load i32, i32* %r137, align 4
  %r264 = add i32 2, %r265
  %r267 = load i32, i32* @a30, align 4
  %r266 = add i32 %r264, %r267
  store i32 %r266, i32* %r141, align 4
  %r269 = load i32, i32* %r138, align 4
  %r268 = add i32 3, %r269
  %r271 = load i32, i32* @a31, align 4
  %r270 = add i32 %r268, %r271
  store i32 %r270, i32* %r142, align 4
  %r273 = load i32, i32* %r139, align 4
  %r272 = add i32 4, %r273
  %r275 = load i32, i32* @a32, align 4
  %r274 = add i32 %r272, %r275
  store i32 %r274, i32* %r143, align 4
  %r277 = load i32, i32* %r101, align 4
  %r278 = load i32, i32* %r103, align 4
  %r276 = sub i32 %r277, %r278
  %r279 = add i32 %r276, 10
  store i32 %r279, i32* %r104, align 4
  %r281 = load i32, i32* %r136, align 4
  %r280 = add i32 1, %r281
  %r283 = load i32, i32* @a29, align 4
  %r282 = add i32 %r280, %r283
  store i32 %r282, i32* %r140, align 4
  %r285 = load i32, i32* %r137, align 4
  %r284 = add i32 2, %r285
  %r287 = load i32, i32* @a30, align 4
  %r286 = add i32 %r284, %r287
  store i32 %r286, i32* %r141, align 4
  %r289 = load i32, i32* %r138, align 4
  %r288 = add i32 3, %r289
  %r291 = load i32, i32* @a31, align 4
  %r290 = add i32 %r288, %r291
  store i32 %r290, i32* %r142, align 4
  %r293 = load i32, i32* %r139, align 4
  %r292 = add i32 4, %r293
  %r295 = load i32, i32* @a32, align 4
  %r294 = add i32 %r292, %r295
  store i32 %r294, i32* %r143, align 4
  %r297 = load i32, i32* %r132, align 4
  %r296 = add i32 1, %r297
  %r299 = load i32, i32* @a25, align 4
  %r298 = add i32 %r296, %r299
  store i32 %r298, i32* %r136, align 4
  %r301 = load i32, i32* %r133, align 4
  %r300 = add i32 2, %r301
  %r303 = load i32, i32* @a26, align 4
  %r302 = add i32 %r300, %r303
  store i32 %r302, i32* %r137, align 4
  %r305 = load i32, i32* %r134, align 4
  %r304 = add i32 3, %r305
  %r307 = load i32, i32* @a27, align 4
  %r306 = add i32 %r304, %r307
  store i32 %r306, i32* %r138, align 4
  %r309 = load i32, i32* %r135, align 4
  %r308 = add i32 4, %r309
  %r311 = load i32, i32* @a28, align 4
  %r310 = add i32 %r308, %r311
  store i32 %r310, i32* %r139, align 4
  %r313 = load i32, i32* %r128, align 4
  %r312 = add i32 1, %r313
  %r315 = load i32, i32* @a21, align 4
  %r314 = add i32 %r312, %r315
  store i32 %r314, i32* %r132, align 4
  %r317 = load i32, i32* %r129, align 4
  %r316 = add i32 2, %r317
  %r319 = load i32, i32* @a22, align 4
  %r318 = add i32 %r316, %r319
  store i32 %r318, i32* %r133, align 4
  %r321 = load i32, i32* %r130, align 4
  %r320 = add i32 3, %r321
  %r323 = load i32, i32* @a23, align 4
  %r322 = add i32 %r320, %r323
  store i32 %r322, i32* %r134, align 4
  %r325 = load i32, i32* %r131, align 4
  %r324 = add i32 4, %r325
  %r327 = load i32, i32* @a24, align 4
  %r326 = add i32 %r324, %r327
  store i32 %r326, i32* %r135, align 4
  %r329 = load i32, i32* %r124, align 4
  %r328 = add i32 1, %r329
  %r331 = load i32, i32* @a17, align 4
  %r330 = add i32 %r328, %r331
  store i32 %r330, i32* %r128, align 4
  %r333 = load i32, i32* %r125, align 4
  %r332 = add i32 2, %r333
  %r335 = load i32, i32* @a18, align 4
  %r334 = add i32 %r332, %r335
  store i32 %r334, i32* %r129, align 4
  %r337 = load i32, i32* %r126, align 4
  %r336 = add i32 3, %r337
  %r339 = load i32, i32* @a19, align 4
  %r338 = add i32 %r336, %r339
  store i32 %r338, i32* %r130, align 4
  %r341 = load i32, i32* %r127, align 4
  %r340 = add i32 4, %r341
  %r343 = load i32, i32* @a20, align 4
  %r342 = add i32 %r340, %r343
  store i32 %r342, i32* %r131, align 4
  %r345 = load i32, i32* %r120, align 4
  %r344 = add i32 1, %r345
  %r347 = load i32, i32* @a13, align 4
  %r346 = add i32 %r344, %r347
  store i32 %r346, i32* %r124, align 4
  %r349 = load i32, i32* %r121, align 4
  %r348 = add i32 2, %r349
  %r351 = load i32, i32* @a14, align 4
  %r350 = add i32 %r348, %r351
  store i32 %r350, i32* %r125, align 4
  %r353 = load i32, i32* %r122, align 4
  %r352 = add i32 3, %r353
  %r355 = load i32, i32* @a15, align 4
  %r354 = add i32 %r352, %r355
  store i32 %r354, i32* %r126, align 4
  %r357 = load i32, i32* %r123, align 4
  %r356 = add i32 4, %r357
  %r359 = load i32, i32* @a16, align 4
  %r358 = add i32 %r356, %r359
  store i32 %r358, i32* %r127, align 4
  %r361 = load i32, i32* %r116, align 4
  %r360 = add i32 1, %r361
  %r363 = load i32, i32* @a9, align 4
  %r362 = add i32 %r360, %r363
  store i32 %r362, i32* %r120, align 4
  %r365 = load i32, i32* %r117, align 4
  %r364 = add i32 2, %r365
  %r367 = load i32, i32* @a10, align 4
  %r366 = add i32 %r364, %r367
  store i32 %r366, i32* %r121, align 4
  %r369 = load i32, i32* %r118, align 4
  %r368 = add i32 3, %r369
  %r371 = load i32, i32* @a11, align 4
  %r370 = add i32 %r368, %r371
  store i32 %r370, i32* %r122, align 4
  %r373 = load i32, i32* %r119, align 4
  %r372 = add i32 4, %r373
  %r375 = load i32, i32* @a12, align 4
  %r374 = add i32 %r372, %r375
  store i32 %r374, i32* %r123, align 4
  %r377 = load i32, i32* %r112, align 4
  %r376 = add i32 1, %r377
  %r379 = load i32, i32* @a5, align 4
  %r378 = add i32 %r376, %r379
  store i32 %r378, i32* %r116, align 4
  %r381 = load i32, i32* %r113, align 4
  %r380 = add i32 2, %r381
  %r383 = load i32, i32* @a6, align 4
  %r382 = add i32 %r380, %r383
  store i32 %r382, i32* %r117, align 4
  %r385 = load i32, i32* %r114, align 4
  %r384 = add i32 3, %r385
  %r387 = load i32, i32* @a7, align 4
  %r386 = add i32 %r384, %r387
  store i32 %r386, i32* %r118, align 4
  %r389 = load i32, i32* %r115, align 4
  %r388 = add i32 4, %r389
  %r391 = load i32, i32* @a8, align 4
  %r390 = add i32 %r388, %r391
  store i32 %r390, i32* %r119, align 4
  %r393 = load i32, i32* %r108, align 4
  %r392 = add i32 1, %r393
  %r395 = load i32, i32* @a1, align 4
  %r394 = add i32 %r392, %r395
  store i32 %r394, i32* %r112, align 4
  %r397 = load i32, i32* %r109, align 4
  %r396 = add i32 2, %r397
  %r399 = load i32, i32* @a2, align 4
  %r398 = add i32 %r396, %r399
  store i32 %r398, i32* %r113, align 4
  %r401 = load i32, i32* %r110, align 4
  %r400 = add i32 3, %r401
  %r403 = load i32, i32* @a3, align 4
  %r402 = add i32 %r400, %r403
  store i32 %r402, i32* %r114, align 4
  %r405 = load i32, i32* %r111, align 4
  %r404 = add i32 4, %r405
  %r407 = load i32, i32* @a4, align 4
  %r406 = add i32 %r404, %r407
  store i32 %r406, i32* %r115, align 4
  %r409 = load i32, i32* %r108, align 4
  %r408 = add i32 1, %r409
  %r411 = load i32, i32* @a1, align 4
  %r410 = add i32 %r408, %r411
  store i32 %r410, i32* %r112, align 4
  %r413 = load i32, i32* %r109, align 4
  %r412 = add i32 2, %r413
  %r415 = load i32, i32* @a2, align 4
  %r414 = add i32 %r412, %r415
  store i32 %r414, i32* %r113, align 4
  %r417 = load i32, i32* %r110, align 4
  %r416 = add i32 3, %r417
  %r419 = load i32, i32* @a3, align 4
  %r418 = add i32 %r416, %r419
  store i32 %r418, i32* %r114, align 4
  %r421 = load i32, i32* %r111, align 4
  %r420 = add i32 4, %r421
  %r423 = load i32, i32* @a4, align 4
  %r422 = add i32 %r420, %r423
  store i32 %r422, i32* %r115, align 4
  %r425 = load i32, i32* %r104, align 4
  %r426 = load i32, i32* %r108, align 4
  %r424 = add i32 %r425, %r426
  %r428 = load i32, i32* %r109, align 4
  %r427 = add i32 %r424, %r428
  %r430 = load i32, i32* %r110, align 4
  %r429 = add i32 %r427, %r430
  %r432 = load i32, i32* %r111, align 4
  %r431 = add i32 %r429, %r432
  %r434 = load i32, i32* %r112, align 4
  %r433 = sub i32 %r431, %r434
  %r436 = load i32, i32* %r113, align 4
  %r435 = sub i32 %r433, %r436
  %r438 = load i32, i32* %r114, align 4
  %r437 = sub i32 %r435, %r438
  %r440 = load i32, i32* %r115, align 4
  %r439 = sub i32 %r437, %r440
  %r442 = load i32, i32* %r116, align 4
  %r441 = add i32 %r439, %r442
  %r444 = load i32, i32* %r117, align 4
  %r443 = add i32 %r441, %r444
  %r446 = load i32, i32* %r118, align 4
  %r445 = add i32 %r443, %r446
  %r448 = load i32, i32* %r119, align 4
  %r447 = add i32 %r445, %r448
  %r450 = load i32, i32* %r120, align 4
  %r449 = sub i32 %r447, %r450
  %r452 = load i32, i32* %r121, align 4
  %r451 = sub i32 %r449, %r452
  %r454 = load i32, i32* %r122, align 4
  %r453 = sub i32 %r451, %r454
  %r456 = load i32, i32* %r123, align 4
  %r455 = sub i32 %r453, %r456
  %r458 = load i32, i32* %r124, align 4
  %r457 = add i32 %r455, %r458
  %r460 = load i32, i32* %r125, align 4
  %r459 = add i32 %r457, %r460
  %r462 = load i32, i32* %r126, align 4
  %r461 = add i32 %r459, %r462
  %r464 = load i32, i32* %r127, align 4
  %r463 = add i32 %r461, %r464
  %r466 = load i32, i32* %r128, align 4
  %r465 = sub i32 %r463, %r466
  %r468 = load i32, i32* %r129, align 4
  %r467 = sub i32 %r465, %r468
  %r470 = load i32, i32* %r130, align 4
  %r469 = sub i32 %r467, %r470
  %r472 = load i32, i32* %r131, align 4
  %r471 = sub i32 %r469, %r472
  %r474 = load i32, i32* %r132, align 4
  %r473 = add i32 %r471, %r474
  %r476 = load i32, i32* %r133, align 4
  %r475 = add i32 %r473, %r476
  %r478 = load i32, i32* %r134, align 4
  %r477 = add i32 %r475, %r478
  %r480 = load i32, i32* %r135, align 4
  %r479 = add i32 %r477, %r480
  %r482 = load i32, i32* %r136, align 4
  %r481 = sub i32 %r479, %r482
  %r484 = load i32, i32* %r137, align 4
  %r483 = sub i32 %r481, %r484
  %r486 = load i32, i32* %r138, align 4
  %r485 = sub i32 %r483, %r486
  %r488 = load i32, i32* %r139, align 4
  %r487 = sub i32 %r485, %r488
  %r490 = load i32, i32* %r140, align 4
  %r489 = add i32 %r487, %r490
  %r492 = load i32, i32* %r141, align 4
  %r491 = add i32 %r489, %r492
  %r494 = load i32, i32* %r142, align 4
  %r493 = add i32 %r491, %r494
  %r496 = load i32, i32* %r143, align 4
  %r495 = add i32 %r493, %r496
  %r498 = load i32, i32* @a1, align 4
  %r497 = add i32 %r495, %r498
  %r500 = load i32, i32* @a2, align 4
  %r499 = sub i32 %r497, %r500
  %r502 = load i32, i32* @a3, align 4
  %r501 = add i32 %r499, %r502
  %r504 = load i32, i32* @a4, align 4
  %r503 = sub i32 %r501, %r504
  %r506 = load i32, i32* @a5, align 4
  %r505 = add i32 %r503, %r506
  %r508 = load i32, i32* @a6, align 4
  %r507 = sub i32 %r505, %r508
  %r510 = load i32, i32* @a7, align 4
  %r509 = add i32 %r507, %r510
  %r512 = load i32, i32* @a8, align 4
  %r511 = sub i32 %r509, %r512
  %r514 = load i32, i32* @a9, align 4
  %r513 = add i32 %r511, %r514
  %r516 = load i32, i32* @a10, align 4
  %r515 = sub i32 %r513, %r516
  %r518 = load i32, i32* @a11, align 4
  %r517 = add i32 %r515, %r518
  %r520 = load i32, i32* @a12, align 4
  %r519 = sub i32 %r517, %r520
  %r522 = load i32, i32* @a13, align 4
  %r521 = add i32 %r519, %r522
  %r524 = load i32, i32* @a14, align 4
  %r523 = sub i32 %r521, %r524
  %r526 = load i32, i32* @a15, align 4
  %r525 = add i32 %r523, %r526
  %r528 = load i32, i32* @a16, align 4
  %r527 = sub i32 %r525, %r528
  %r530 = load i32, i32* @a17, align 4
  %r529 = add i32 %r527, %r530
  %r532 = load i32, i32* @a18, align 4
  %r531 = sub i32 %r529, %r532
  %r534 = load i32, i32* @a19, align 4
  %r533 = add i32 %r531, %r534
  %r536 = load i32, i32* @a20, align 4
  %r535 = sub i32 %r533, %r536
  %r538 = load i32, i32* @a21, align 4
  %r537 = add i32 %r535, %r538
  %r540 = load i32, i32* @a22, align 4
  %r539 = sub i32 %r537, %r540
  %r542 = load i32, i32* @a23, align 4
  %r541 = add i32 %r539, %r542
  %r544 = load i32, i32* @a24, align 4
  %r543 = sub i32 %r541, %r544
  %r546 = load i32, i32* @a25, align 4
  %r545 = add i32 %r543, %r546
  %r548 = load i32, i32* @a26, align 4
  %r547 = sub i32 %r545, %r548
  %r550 = load i32, i32* @a27, align 4
  %r549 = add i32 %r547, %r550
  %r552 = load i32, i32* @a28, align 4
  %r551 = sub i32 %r549, %r552
  %r554 = load i32, i32* @a29, align 4
  %r553 = add i32 %r551, %r554
  %r556 = load i32, i32* @a30, align 4
  %r555 = sub i32 %r553, %r556
  %r558 = load i32, i32* @a31, align 4
  %r557 = add i32 %r555, %r558
  %r560 = load i32, i32* @a32, align 4
  %r559 = sub i32 %r557, %r560
  ret i32 %r559

0:                                                ; No predecessors!
  ret i32 0
}

define i32 @main() {
main:
  %r561 = alloca i32, align 4
  %r562 = alloca i32, align 4
  %r563 = call i32 @getint()
  store i32 %r563, i32* %r561, align 4
  %r564 = mul i32 2, 9
  %r566 = load i32, i32* %r561, align 4
  %r565 = add i32 %r566, %r564
  store i32 %r565, i32* %r562, align 4
  %r568 = load i32, i32* %r561, align 4
  %r569 = load i32, i32* %r562, align 4
  %r567 = call i32 @func(i32 %r568, i32 %r569)
  store i32 %r567, i32* %r561, align 4
  %r570 = load i32, i32* %r561, align 4
  call void @putint(i32 %r570)
  %r571 = load i32, i32* %r561, align 4
  ret i32 %r571

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
