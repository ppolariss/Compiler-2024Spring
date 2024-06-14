.section .data
.global    a
a:
        .zero   80
.section .text
.global getch
.global getint
.global putch
.global putint
.global putarray
.global _sysy_starttime
.global _sysy_stoptime
.global main
main:

        sub     sp, sp, #40
        //101:x29,#-80

        mov     x8, #80
        sub     sp, sp, x8
        //bb1:

bb1:

        //  %r100 = getelementptr [10 x i32 ], [10 x i32 ]* @a, i32 0, i32 0

        adrp     x16, a
        add     x16, x16, #:lo12:a
        str     x16, [sp,#24]
        mov     x9, #0
        mov     x8, #8
        mul     x8, x9, x8
        add     x8, x16, x8
        //  store i32 5, i32* %r100

        mov     x9, #5
        str     x9, [x8]
        //  %r101 = alloca %b

        //  %r102 = getelementptr %b, %b* %r101, i32 0, i32 0

        mov     x8, #-80
        add     x8, x29, x8
        mov     x9, #0
        add     x9, x8, x9
        //  %r103 = getelementptr [10 x i32 ], [10 x i32 ]* %r102, i32 0, i32 0

        mov     x17, x9
        str     x17, [sp,#16]
        mov     x9, #0
        mov     x8, #8
        mul     x8, x9, x8
        add     x8, x17, x8
        //  store i32 5, i32* %r103

        mov     x9, #5
        str     x9, [x8]
        //  %r113 = add i32 0, 0

        mov     x8, #0
        //  %r106 = getelementptr [10 x i32 ], [10 x i32 ]* @a, i32 0, i32 0

        adrp     x18, a
        add     x18, x18, #:lo12:a
        str     x18, [sp,#8]
        mov     x9, #0
        mov     x8, #8
        mul     x8, x9, x8
        add     x8, x18, x8
        //  %r114 = load i32, i32* %r106

        ldr     x19, [x8]
        str     x19, [sp,#32]
        //  %r108 = getelementptr %b, %b* %r101, i32 0, i32 0

        mov     x8, #-80
        add     x8, x29, x8
        mov     x9, #0
        add     x9, x8, x9
        //  %r109 = getelementptr [10 x i32 ], [10 x i32 ]* %r108, i32 0, i32 0

        mov     x16, x9
        str     x16, [sp]
        mov     x9, #0
        mov     x8, #8
        mul     x8, x9, x8
        add     x8, x16, x8
        //  %r115 = load i32, i32* %r109

        ldr     x8, [x8]
        //  %r116 = icmp eq i32 %r114, %r115

        ldr     x17, [sp,#32]
        cmp     x17, x8
        //  br i1 %r116, label %bb2, label %bb3


        b.eq     bb2
        b     bb3
        //bb2:

bb2:

        //  %r119 = add i32 1, 0

        mov     x8, #1
        mov     x8, x8
        mov     x8, x8
        //  br label %bb4


        b     bb4
        //bb3:

bb3:

        //  %r118 = add i32 0, 0

        mov     x8, #0
        mov     x8, x8
        mov     x8, x8
        //  br label %bb4


        b     bb4
        //bb4:

bb4:

        //  %r117 = phi i32 [ %r119, %bb2 ], [ %r118, %bb3 ]

        //  ret i32 %r117

        mov     x0, x8
        ret
