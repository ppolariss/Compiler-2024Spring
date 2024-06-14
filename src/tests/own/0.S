.section .data
.global    a0
.global    a1
.global    a2
.global    a3
.global    a4
.global    a5
.global    a6
.global    a7
.global    a8
a0:
        .quad   0
a1:
        .quad   0
a2:
        .quad   0
a3:
        .quad   0
a4:
        .quad   0
a5:
        .quad   0
a6:
        .quad   0
a7:
        .quad   0
a8:
        .quad   0
.section .text
.global getch
.global getint
.global putch
.global putint
.global putarray
.global _sysy_starttime
.global _sysy_stoptime
.global testParam8
.global main
testParam8:

        sub     sp, sp, #8
        mov     x8, #0
        sub     sp, sp, x8
        //bb1:

bb1:

        //  %r150 = add i32 0, 0

        mov     x15, x0
        mov     x14, x1
        mov     x13, x2
        mov     x12, x3
        mov     x11, x4
        mov     x10, x5
        mov     x9, x6
        mov     x16, x7
        str     x16, [sp]
        add     sp, sp, #0
        mov     x8, #0
        //  %r151 = add i32 %r100, 0

        mov     x15, x15
        //  %r152 = add i32 0, 0

        mov     x8, #0
        //  %r153 = add i32 %r102, 0

        mov     x14, x14
        //  %r154 = add i32 0, 0

        mov     x8, #0
        //  %r155 = add i32 %r104, 0

        mov     x13, x13
        //  %r156 = add i32 0, 0

        mov     x8, #0
        //  %r157 = add i32 %r106, 0

        mov     x12, x12
        //  %r158 = add i32 0, 0

        mov     x8, #0
        //  %r159 = add i32 %r108, 0

        mov     x11, x11
        //  %r160 = add i32 0, 0

        mov     x8, #0
        //  %r161 = add i32 %r110, 0

        mov     x10, x10
        //  %r162 = add i32 0, 0

        mov     x8, #0
        //  %r163 = add i32 %r112, 0

        mov     x9, x9
        //  %r164 = add i32 0, 0

        mov     x8, #0
        //  %r165 = add i32 %r114, 0

        ldr     x17, [sp]
        mov     x8, x17
        //  %r166 = add i32 %r151, %r153

        add     x14, x15, x14
        //  %r167 = add i32 %r166, %r155

        add     x13, x14, x13
        //  %r168 = add i32 %r167, %r157

        add     x12, x13, x12
        //  %r169 = add i32 %r168, %r159

        add     x11, x12, x11
        //  %r170 = add i32 %r169, %r161

        add     x10, x11, x10
        //  %r171 = add i32 %r170, %r163

        add     x9, x10, x9
        //  %r172 = add i32 %r171, %r165

        add     x9, x9, x8
        //  %r173 = add i32 %r172, 0

        mov     x8, #0
        add     x8, x9, x8
        //  ret i32 %r173

        mov     x0, x8
        ret
main:

        mov     x8, #0
        sub     sp, sp, x8
        //bb2:

bb2:

        //  store i32 0, i32* @a0

        mov     x9, #0
        adrp     x8, a0
        add     x8, x8, #:lo12:a0
        str     x9, [x8]
        //  store i32 1, i32* @a1

        mov     x9, #1
        adrp     x8, a1
        add     x8, x8, #:lo12:a1
        str     x9, [x8]
        //  store i32 2, i32* @a2

        mov     x9, #2
        adrp     x8, a2
        add     x8, x8, #:lo12:a2
        str     x9, [x8]
        //  store i32 3, i32* @a3

        mov     x9, #3
        adrp     x8, a3
        add     x8, x8, #:lo12:a3
        str     x9, [x8]
        //  store i32 4, i32* @a4

        mov     x9, #4
        adrp     x8, a4
        add     x8, x8, #:lo12:a4
        str     x9, [x8]
        //  store i32 5, i32* @a5

        mov     x9, #5
        adrp     x8, a5
        add     x8, x8, #:lo12:a5
        str     x9, [x8]
        //  store i32 6, i32* @a6

        mov     x9, #6
        adrp     x8, a6
        add     x8, x8, #:lo12:a6
        str     x9, [x8]
        //  store i32 7, i32* @a7

        mov     x9, #7
        adrp     x8, a7
        add     x8, x8, #:lo12:a7
        str     x9, [x8]
        //  store i32 8, i32* @a8

        mov     x9, #8
        adrp     x8, a8
        add     x8, x8, #:lo12:a8
        str     x9, [x8]
        //  %r174 = load i32, i32* @a0

        adrp     x8, a0
        add     x8, x8, #:lo12:a0
        ldr     x8, [x8]
        //  %r175 = load i32, i32* @a1

        adrp     x15, a1
        add     x15, x15, #:lo12:a1
        ldr     x15, [x15]
        //  %r176 = load i32, i32* @a2

        adrp     x14, a2
        add     x14, x14, #:lo12:a2
        ldr     x14, [x14]
        //  %r177 = load i32, i32* @a3

        adrp     x13, a3
        add     x13, x13, #:lo12:a3
        ldr     x13, [x13]
        //  %r178 = load i32, i32* @a4

        adrp     x12, a4
        add     x12, x12, #:lo12:a4
        ldr     x12, [x12]
        //  %r179 = load i32, i32* @a5

        adrp     x11, a5
        add     x11, x11, #:lo12:a5
        ldr     x11, [x11]
        //  %r180 = load i32, i32* @a6

        adrp     x10, a6
        add     x10, x10, #:lo12:a6
        ldr     x10, [x10]
        //  %r181 = load i32, i32* @a7

        adrp     x9, a7
        add     x9, x9, #:lo12:a7
        ldr     x9, [x9]
        //  %r182 = call i32 @testParam8(i32 %r174, i32 %r175, i32 %r176, i32 %r177, i32 %r178, i32 %r179, i32 %r180, i32 %r181)

        mov     x8, x8
        mov     x0, x8
        mov     x8, x15
        mov     x1, x8
        mov     x8, x14
        mov     x2, x8
        mov     x8, x13
        mov     x3, x8
        mov     x8, x12
        mov     x4, x8
        mov     x8, x11
        mov     x5, x8
        mov     x8, x10
        mov     x6, x8
        mov     x8, x9
        mov     x7, x8
        stp     x8, x9, [sp, #-16]!
        stp     x10, x11, [sp, #-16]!
        stp     x12, x13, [sp, #-16]!
        stp     x14, x15, [sp, #-16]!
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        bl     testParam8
        mov     sp, x29
        ldp     x29, x30, [sp], #16
        ldp     x14, x15, [sp], #16
        ldp     x12, x13, [sp], #16
        ldp     x10, x11, [sp], #16
        ldp     x8, x9, [sp], #16
        mov     x9, x0
        //  store i32 %r182, i32* @a0

        adrp     x8, a0
        add     x8, x8, #:lo12:a0
        str     x9, [x8]
        //  %r183 = load i32, i32* @a0

        adrp     x8, a0
        add     x8, x8, #:lo12:a0
        ldr     x8, [x8]
        //  call void @putint(i32 %r183)

        mov     x8, x8
        mov     x0, x8
        stp     x8, x9, [sp, #-16]!
        stp     x10, x11, [sp, #-16]!
        stp     x12, x13, [sp, #-16]!
        stp     x14, x15, [sp, #-16]!
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        bl     putint
        mov     sp, x29
        ldp     x29, x30, [sp], #16
        ldp     x14, x15, [sp], #16
        ldp     x12, x13, [sp], #16
        ldp     x10, x11, [sp], #16
        ldp     x8, x9, [sp], #16
        //  ret i32 0

        mov     x0, #0
        ret
