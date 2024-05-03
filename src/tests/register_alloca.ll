declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
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
define i32 @func( i32 %r100, i32 %r102 ) {
func:
  %r101 = alloca i32
  store i32 %r100, i32* %r101
  %r103 = alloca i32
  store i32 %r102, i32* %r103
  %r104 = alloca i32
  %r106 = load i32, i32* %r101
  %r107 = load i32, i32* %r103
  %r105 = add i32 %r106, %r107
  store i32 %r105, i32* %r104
  %r108 = alloca i32
  %r109 = alloca i32
  %r110 = alloca i32
  %r111 = alloca i32
  %r112 = alloca i32
  %r113 = alloca i32
  %r114 = alloca i32
  %r115 = alloca i32
  %r116 = alloca i32
  %r117 = alloca i32
  %r118 = alloca i32
  %r119 = alloca i32
  %r120 = alloca i32
  %r121 = alloca i32
  %r122 = alloca i32
  %r123 = alloca i32
  %r124 = alloca i32
  %r125 = alloca i32
  %r126 = alloca i32
  %r127 = alloca i32
  %r128 = alloca i32
  %r129 = alloca i32
  %r130 = alloca i32
  %r131 = alloca i32
  %r132 = alloca i32
  %r133 = alloca i32
  %r134 = alloca i32
  %r135 = alloca i32
  %r136 = alloca i32
  %r137 = alloca i32
  %r138 = alloca i32
  %r139 = alloca i32
  %r140 = alloca i32
  %r141 = alloca i32
  %r142 = alloca i32
  %r143 = alloca i32
  %r144 = call i32 @getint()
  store i32 %r144, i32* %r108
  %r145 = call i32 @getint()
  store i32 %r145, i32* %r109
  %r146 = call i32 @getint()
  store i32 %r146, i32* %r110
  %r147 = call i32 @getint()
  store i32 %r147, i32* %r111
  %r149 = load i32, i32* %r108
  %r148 = add i32 1, %r149
  %r151 = load i32, i32* @a1
  %r150 = add i32 %r148, %r151
  store i32 %r150, i32* %r112
  %r153 = load i32, i32* %r109
  %r152 = add i32 2, %r153
  %r155 = load i32, i32* @a2
  %r154 = add i32 %r152, %r155
  store i32 %r154, i32* %r113
  %r157 = load i32, i32* %r110
  %r156 = add i32 3, %r157
  %r159 = load i32, i32* @a3
  %r158 = add i32 %r156, %r159
  store i32 %r158, i32* %r114
  %r161 = load i32, i32* %r111
  %r160 = add i32 4, %r161
  %r163 = load i32, i32* @a4
  %r162 = add i32 %r160, %r163
  store i32 %r162, i32* %r115
  %r165 = load i32, i32* %r112
  %r164 = add i32 1, %r165
  %r167 = load i32, i32* @a5
  %r166 = add i32 %r164, %r167
  store i32 %r166, i32* %r116
  %r169 = load i32, i32* %r113
  %r168 = add i32 2, %r169
  %r171 = load i32, i32* @a6
  %r170 = add i32 %r168, %r171
  store i32 %r170, i32* %r117
  %r173 = load i32, i32* %r114
  %r172 = add i32 3, %r173
  %r175 = load i32, i32* @a7
  %r174 = add i32 %r172, %r175
  store i32 %r174, i32* %r118
  %r177 = load i32, i32* %r115
  %r176 = add i32 4, %r177
  %r179 = load i32, i32* @a8
  %r178 = add i32 %r176, %r179
  store i32 %r178, i32* %r119
  %r181 = load i32, i32* %r116
  %r180 = add i32 1, %r181
  %r183 = load i32, i32* @a9
  %r182 = add i32 %r180, %r183
  store i32 %r182, i32* %r120
  %r185 = load i32, i32* %r117
  %r184 = add i32 2, %r185
  %r187 = load i32, i32* @a10
  %r186 = add i32 %r184, %r187
  store i32 %r186, i32* %r121
  %r189 = load i32, i32* %r118
  %r188 = add i32 3, %r189
  %r191 = load i32, i32* @a11
  %r190 = add i32 %r188, %r191
  store i32 %r190, i32* %r122
  %r193 = load i32, i32* %r119
  %r192 = add i32 4, %r193
  %r195 = load i32, i32* @a12
  %r194 = add i32 %r192, %r195
  store i32 %r194, i32* %r123
  %r197 = load i32, i32* %r120
  %r196 = add i32 1, %r197
  %r199 = load i32, i32* @a13
  %r198 = add i32 %r196, %r199
  store i32 %r198, i32* %r124
  %r201 = load i32, i32* %r121
  %r200 = add i32 2, %r201
  %r203 = load i32, i32* @a14
  %r202 = add i32 %r200, %r203
  store i32 %r202, i32* %r125
  %r205 = load i32, i32* %r122
  %r204 = add i32 3, %r205
  %r207 = load i32, i32* @a15
  %r206 = add i32 %r204, %r207
  store i32 %r206, i32* %r126
  %r209 = load i32, i32* %r123
  %r208 = add i32 4, %r209
  %r211 = load i32, i32* @a16
  %r210 = add i32 %r208, %r211
  store i32 %r210, i32* %r127
  %r213 = load i32, i32* %r124
  %r212 = add i32 1, %r213
  %r215 = load i32, i32* @a17
  %r214 = add i32 %r212, %r215
  store i32 %r214, i32* %r128
  %r217 = load i32, i32* %r125
  %r216 = add i32 2, %r217
  %r219 = load i32, i32* @a18
  %r218 = add i32 %r216, %r219
  store i32 %r218, i32* %r129
  %r221 = load i32, i32* %r126
  %r220 = add i32 3, %r221
  %r223 = load i32, i32* @a19
  %r222 = add i32 %r220, %r223
  store i32 %r222, i32* %r130
  %r225 = load i32, i32* %r127
  %r224 = add i32 4, %r225
  %r227 = load i32, i32* @a20
  %r226 = add i32 %r224, %r227
  store i32 %r226, i32* %r131
  %r229 = load i32, i32* %r128
  %r228 = add i32 1, %r229
  %r231 = load i32, i32* @a21
  %r230 = add i32 %r228, %r231
  store i32 %r230, i32* %r132
  %r233 = load i32, i32* %r129
  %r232 = add i32 2, %r233
  %r235 = load i32, i32* @a22
  %r234 = add i32 %r232, %r235
  store i32 %r234, i32* %r133
  %r237 = load i32, i32* %r130
  %r236 = add i32 3, %r237
  %r239 = load i32, i32* @a23
  %r238 = add i32 %r236, %r239
  store i32 %r238, i32* %r134
  %r241 = load i32, i32* %r131
  %r240 = add i32 4, %r241
  %r243 = load i32, i32* @a24
  %r242 = add i32 %r240, %r243
  store i32 %r242, i32* %r135
  %r245 = load i32, i32* %r132
  %r244 = add i32 1, %r245
  %r247 = load i32, i32* @a25
  %r246 = add i32 %r244, %r247
  store i32 %r246, i32* %r136
  %r249 = load i32, i32* %r133
  %r248 = add i32 2, %r249
  %r251 = load i32, i32* @a26
  %r250 = add i32 %r248, %r251
  store i32 %r250, i32* %r137
  %r253 = load i32, i32* %r134
  %r252 = add i32 3, %r253
  %r255 = load i32, i32* @a27
  %r254 = add i32 %r252, %r255
  store i32 %r254, i32* %r138
  %r257 = load i32, i32* %r135
  %r256 = add i32 4, %r257
  %r259 = load i32, i32* @a28
  %r258 = add i32 %r256, %r259
  store i32 %r258, i32* %r139
  %r261 = load i32, i32* %r136
  %r260 = add i32 1, %r261
  %r263 = load i32, i32* @a29
  %r262 = add i32 %r260, %r263
  store i32 %r262, i32* %r140
  %r265 = load i32, i32* %r137
  %r264 = add i32 2, %r265
  %r267 = load i32, i32* @a30
  %r266 = add i32 %r264, %r267
  store i32 %r266, i32* %r141
  %r269 = load i32, i32* %r138
  %r268 = add i32 3, %r269
  %r271 = load i32, i32* @a31
  %r270 = add i32 %r268, %r271
  store i32 %r270, i32* %r142
  %r273 = load i32, i32* %r139
  %r272 = add i32 4, %r273
  %r275 = load i32, i32* @a32
  %r274 = add i32 %r272, %r275
  store i32 %r274, i32* %r143
  %r277 = load i32, i32* %r101
  %r278 = load i32, i32* %r103
  %r276 = sub i32 %r277, %r278
  %r279 = add i32 %r276, 10
  store i32 %r279, i32* %r104
  %r281 = load i32, i32* %r136
  %r280 = add i32 1, %r281
  %r283 = load i32, i32* @a29
  %r282 = add i32 %r280, %r283
  store i32 %r282, i32* %r140
  %r285 = load i32, i32* %r137
  %r284 = add i32 2, %r285
  %r287 = load i32, i32* @a30
  %r286 = add i32 %r284, %r287
  store i32 %r286, i32* %r141
  %r289 = load i32, i32* %r138
  %r288 = add i32 3, %r289
  %r291 = load i32, i32* @a31
  %r290 = add i32 %r288, %r291
  store i32 %r290, i32* %r142
  %r293 = load i32, i32* %r139
  %r292 = add i32 4, %r293
  %r295 = load i32, i32* @a32
  %r294 = add i32 %r292, %r295
  store i32 %r294, i32* %r143
  %r297 = load i32, i32* %r132
  %r296 = add i32 1, %r297
  %r299 = load i32, i32* @a25
  %r298 = add i32 %r296, %r299
  store i32 %r298, i32* %r136
  %r301 = load i32, i32* %r133
  %r300 = add i32 2, %r301
  %r303 = load i32, i32* @a26
  %r302 = add i32 %r300, %r303
  store i32 %r302, i32* %r137
  %r305 = load i32, i32* %r134
  %r304 = add i32 3, %r305
  %r307 = load i32, i32* @a27
  %r306 = add i32 %r304, %r307
  store i32 %r306, i32* %r138
  %r309 = load i32, i32* %r135
  %r308 = add i32 4, %r309
  %r311 = load i32, i32* @a28
  %r310 = add i32 %r308, %r311
  store i32 %r310, i32* %r139
  %r313 = load i32, i32* %r128
  %r312 = add i32 1, %r313
  %r315 = load i32, i32* @a21
  %r314 = add i32 %r312, %r315
  store i32 %r314, i32* %r132
  %r317 = load i32, i32* %r129
  %r316 = add i32 2, %r317
  %r319 = load i32, i32* @a22
  %r318 = add i32 %r316, %r319
  store i32 %r318, i32* %r133
  %r321 = load i32, i32* %r130
  %r320 = add i32 3, %r321
  %r323 = load i32, i32* @a23
  %r322 = add i32 %r320, %r323
  store i32 %r322, i32* %r134
  %r325 = load i32, i32* %r131
  %r324 = add i32 4, %r325
  %r327 = load i32, i32* @a24
  %r326 = add i32 %r324, %r327
  store i32 %r326, i32* %r135
  %r329 = load i32, i32* %r124
  %r328 = add i32 1, %r329
  %r331 = load i32, i32* @a17
  %r330 = add i32 %r328, %r331
  store i32 %r330, i32* %r128
  %r333 = load i32, i32* %r125
  %r332 = add i32 2, %r333
  %r335 = load i32, i32* @a18
  %r334 = add i32 %r332, %r335
  store i32 %r334, i32* %r129
  %r337 = load i32, i32* %r126
  %r336 = add i32 3, %r337
  %r339 = load i32, i32* @a19
  %r338 = add i32 %r336, %r339
  store i32 %r338, i32* %r130
  %r341 = load i32, i32* %r127
  %r340 = add i32 4, %r341
  %r343 = load i32, i32* @a20
  %r342 = add i32 %r340, %r343
  store i32 %r342, i32* %r131
  %r345 = load i32, i32* %r120
  %r344 = add i32 1, %r345
  %r347 = load i32, i32* @a13
  %r346 = add i32 %r344, %r347
  store i32 %r346, i32* %r124
  %r349 = load i32, i32* %r121
  %r348 = add i32 2, %r349
  %r351 = load i32, i32* @a14
  %r350 = add i32 %r348, %r351
  store i32 %r350, i32* %r125
  %r353 = load i32, i32* %r122
  %r352 = add i32 3, %r353
  %r355 = load i32, i32* @a15
  %r354 = add i32 %r352, %r355
  store i32 %r354, i32* %r126
  %r357 = load i32, i32* %r123
  %r356 = add i32 4, %r357
  %r359 = load i32, i32* @a16
  %r358 = add i32 %r356, %r359
  store i32 %r358, i32* %r127
  %r361 = load i32, i32* %r116
  %r360 = add i32 1, %r361
  %r363 = load i32, i32* @a9
  %r362 = add i32 %r360, %r363
  store i32 %r362, i32* %r120
  %r365 = load i32, i32* %r117
  %r364 = add i32 2, %r365
  %r367 = load i32, i32* @a10
  %r366 = add i32 %r364, %r367
  store i32 %r366, i32* %r121
  %r369 = load i32, i32* %r118
  %r368 = add i32 3, %r369
  %r371 = load i32, i32* @a11
  %r370 = add i32 %r368, %r371
  store i32 %r370, i32* %r122
  %r373 = load i32, i32* %r119
  %r372 = add i32 4, %r373
  %r375 = load i32, i32* @a12
  %r374 = add i32 %r372, %r375
  store i32 %r374, i32* %r123
  %r377 = load i32, i32* %r112
  %r376 = add i32 1, %r377
  %r379 = load i32, i32* @a5
  %r378 = add i32 %r376, %r379
  store i32 %r378, i32* %r116
  %r381 = load i32, i32* %r113
  %r380 = add i32 2, %r381
  %r383 = load i32, i32* @a6
  %r382 = add i32 %r380, %r383
  store i32 %r382, i32* %r117
  %r385 = load i32, i32* %r114
  %r384 = add i32 3, %r385
  %r387 = load i32, i32* @a7
  %r386 = add i32 %r384, %r387
  store i32 %r386, i32* %r118
  %r389 = load i32, i32* %r115
  %r388 = add i32 4, %r389
  %r391 = load i32, i32* @a8
  %r390 = add i32 %r388, %r391
  store i32 %r390, i32* %r119
  %r393 = load i32, i32* %r108
  %r392 = add i32 1, %r393
  %r395 = load i32, i32* @a1
  %r394 = add i32 %r392, %r395
  store i32 %r394, i32* %r112
  %r397 = load i32, i32* %r109
  %r396 = add i32 2, %r397
  %r399 = load i32, i32* @a2
  %r398 = add i32 %r396, %r399
  store i32 %r398, i32* %r113
  %r401 = load i32, i32* %r110
  %r400 = add i32 3, %r401
  %r403 = load i32, i32* @a3
  %r402 = add i32 %r400, %r403
  store i32 %r402, i32* %r114
  %r405 = load i32, i32* %r111
  %r404 = add i32 4, %r405
  %r407 = load i32, i32* @a4
  %r406 = add i32 %r404, %r407
  store i32 %r406, i32* %r115
  %r409 = load i32, i32* %r108
  %r408 = add i32 1, %r409
  %r411 = load i32, i32* @a1
  %r410 = add i32 %r408, %r411
  store i32 %r410, i32* %r112
  %r413 = load i32, i32* %r109
  %r412 = add i32 2, %r413
  %r415 = load i32, i32* @a2
  %r414 = add i32 %r412, %r415
  store i32 %r414, i32* %r113
  %r417 = load i32, i32* %r110
  %r416 = add i32 3, %r417
  %r419 = load i32, i32* @a3
  %r418 = add i32 %r416, %r419
  store i32 %r418, i32* %r114
  %r421 = load i32, i32* %r111
  %r420 = add i32 4, %r421
  %r423 = load i32, i32* @a4
  %r422 = add i32 %r420, %r423
  store i32 %r422, i32* %r115
  %r425 = load i32, i32* %r104
  %r426 = load i32, i32* %r108
  %r424 = add i32 %r425, %r426
  %r428 = load i32, i32* %r109
  %r427 = add i32 %r424, %r428
  %r430 = load i32, i32* %r110
  %r429 = add i32 %r427, %r430
  %r432 = load i32, i32* %r111
  %r431 = add i32 %r429, %r432
  %r434 = load i32, i32* %r112
  %r433 = sub i32 %r431, %r434
  %r436 = load i32, i32* %r113
  %r435 = sub i32 %r433, %r436
  %r438 = load i32, i32* %r114
  %r437 = sub i32 %r435, %r438
  %r440 = load i32, i32* %r115
  %r439 = sub i32 %r437, %r440
  %r442 = load i32, i32* %r116
  %r441 = add i32 %r439, %r442
  %r444 = load i32, i32* %r117
  %r443 = add i32 %r441, %r444
  %r446 = load i32, i32* %r118
  %r445 = add i32 %r443, %r446
  %r448 = load i32, i32* %r119
  %r447 = add i32 %r445, %r448
  %r450 = load i32, i32* %r120
  %r449 = sub i32 %r447, %r450
  %r452 = load i32, i32* %r121
  %r451 = sub i32 %r449, %r452
  %r454 = load i32, i32* %r122
  %r453 = sub i32 %r451, %r454
  %r456 = load i32, i32* %r123
  %r455 = sub i32 %r453, %r456
  %r458 = load i32, i32* %r124
  %r457 = add i32 %r455, %r458
  %r460 = load i32, i32* %r125
  %r459 = add i32 %r457, %r460
  %r462 = load i32, i32* %r126
  %r461 = add i32 %r459, %r462
  %r464 = load i32, i32* %r127
  %r463 = add i32 %r461, %r464
  %r466 = load i32, i32* %r128
  %r465 = sub i32 %r463, %r466
  %r468 = load i32, i32* %r129
  %r467 = sub i32 %r465, %r468
  %r470 = load i32, i32* %r130
  %r469 = sub i32 %r467, %r470
  %r472 = load i32, i32* %r131
  %r471 = sub i32 %r469, %r472
  %r474 = load i32, i32* %r132
  %r473 = add i32 %r471, %r474
  %r476 = load i32, i32* %r133
  %r475 = add i32 %r473, %r476
  %r478 = load i32, i32* %r134
  %r477 = add i32 %r475, %r478
  %r480 = load i32, i32* %r135
  %r479 = add i32 %r477, %r480
  %r482 = load i32, i32* %r136
  %r481 = sub i32 %r479, %r482
  %r484 = load i32, i32* %r137
  %r483 = sub i32 %r481, %r484
  %r486 = load i32, i32* %r138
  %r485 = sub i32 %r483, %r486
  %r488 = load i32, i32* %r139
  %r487 = sub i32 %r485, %r488
  %r490 = load i32, i32* %r140
  %r489 = add i32 %r487, %r490
  %r492 = load i32, i32* %r141
  %r491 = add i32 %r489, %r492
  %r494 = load i32, i32* %r142
  %r493 = add i32 %r491, %r494
  %r496 = load i32, i32* %r143
  %r495 = add i32 %r493, %r496
  %r498 = load i32, i32* @a1
  %r497 = add i32 %r495, %r498
  %r500 = load i32, i32* @a2
  %r499 = sub i32 %r497, %r500
  %r502 = load i32, i32* @a3
  %r501 = add i32 %r499, %r502
  %r504 = load i32, i32* @a4
  %r503 = sub i32 %r501, %r504
  %r506 = load i32, i32* @a5
  %r505 = add i32 %r503, %r506
  %r508 = load i32, i32* @a6
  %r507 = sub i32 %r505, %r508
  %r510 = load i32, i32* @a7
  %r509 = add i32 %r507, %r510
  %r512 = load i32, i32* @a8
  %r511 = sub i32 %r509, %r512
  %r514 = load i32, i32* @a9
  %r513 = add i32 %r511, %r514
  %r516 = load i32, i32* @a10
  %r515 = sub i32 %r513, %r516
  %r518 = load i32, i32* @a11
  %r517 = add i32 %r515, %r518
  %r520 = load i32, i32* @a12
  %r519 = sub i32 %r517, %r520
  %r522 = load i32, i32* @a13
  %r521 = add i32 %r519, %r522
  %r524 = load i32, i32* @a14
  %r523 = sub i32 %r521, %r524
  %r526 = load i32, i32* @a15
  %r525 = add i32 %r523, %r526
  %r528 = load i32, i32* @a16
  %r527 = sub i32 %r525, %r528
  %r530 = load i32, i32* @a17
  %r529 = add i32 %r527, %r530
  %r532 = load i32, i32* @a18
  %r531 = sub i32 %r529, %r532
  %r534 = load i32, i32* @a19
  %r533 = add i32 %r531, %r534
  %r536 = load i32, i32* @a20
  %r535 = sub i32 %r533, %r536
  %r538 = load i32, i32* @a21
  %r537 = add i32 %r535, %r538
  %r540 = load i32, i32* @a22
  %r539 = sub i32 %r537, %r540
  %r542 = load i32, i32* @a23
  %r541 = add i32 %r539, %r542
  %r544 = load i32, i32* @a24
  %r543 = sub i32 %r541, %r544
  %r546 = load i32, i32* @a25
  %r545 = add i32 %r543, %r546
  %r548 = load i32, i32* @a26
  %r547 = sub i32 %r545, %r548
  %r550 = load i32, i32* @a27
  %r549 = add i32 %r547, %r550
  %r552 = load i32, i32* @a28
  %r551 = sub i32 %r549, %r552
  %r554 = load i32, i32* @a29
  %r553 = add i32 %r551, %r554
  %r556 = load i32, i32* @a30
  %r555 = sub i32 %r553, %r556
  %r558 = load i32, i32* @a31
  %r557 = add i32 %r555, %r558
  %r560 = load i32, i32* @a32
  %r559 = sub i32 %r557, %r560
  ret i32 %r559
  ret i32 0
}

define i32 @main( ) {
main:
  %r561 = alloca i32
  %r562 = alloca i32
  %r563 = call i32 @getint()
  store i32 %r563, i32* %r561
  %r564 = mul i32 2, 9
  %r566 = load i32, i32* %r561
  %r565 = add i32 %r566, %r564
  store i32 %r565, i32* %r562
  %r568 = load i32, i32* %r561
  %r569 = load i32, i32* %r562
  %r567 = call i32 @func(i32 %r568, i32 %r569)
  store i32 %r567, i32* %r561
  %r570 = load i32, i32* %r561
  call void @putint(i32 %r570)
  %r571 = load i32, i32* %r561
  ret i32 %r571
  ret i32 0
}

