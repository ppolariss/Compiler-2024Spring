.section .data
.section .text
.global getch
.global getint
.global putch
.global putint
.global putarray
.global _sysy_starttime
.global _sysy_stoptime
.global add
.global main
add:

        sub     sp, sp, #0
        //102:x29,#-16

        mov     x8, #16
        sub     sp, sp, x8
        //bb1:

bb1:

        //  %r102 = alloca %arrary

        mov     x10, x0
        mov     x11, x1
        //  %r103 = getelementptr %arrary, %arrary* %r102, i32 0, i32 0

        mov     x8, #-16
        add     x9, x29, x8
        mov     x8, #0
        add     x8, x9, x8
        //  %r104 = getelementptr %arrary, %arrary* %r100, i32 0, i32 0

        mov     x9, x10
        mov     x10, #0
        add     x10, x9, x10
        //  %r105 = getelementptr %arrary, %arrary* %r101, i32 0, i32 0

        mov     x9, x11
        mov     x11, #0
        add     x11, x9, x11
        //  %r117 = load i32, i32* %r104

        ldr     x10, [x10]
        //  %r118 = load i32, i32* %r105

        ldr     x9, [x11]
        //  %r119 = add i32 %r117, %r118

        add     x9, x10, x9
        //  store i32 %r119, i32* %r103

        str     x9, [x8]
        //  %r109 = getelementptr %arrary, %arrary* %r102, i32 0, i32 0

        mov     x8, #-16
        add     x8, x29, x8
        mov     x9, #0
        add     x9, x8, x9
        //  %r120 = load i32, i32* %r109

        ldr     x9, [x9]
        //  %r121 = add i32 %r120, 1

        mov     x8, #1
        add     x8, x9, x8
        //  ret i32 %r121

        mov     x0, x8
        ret
main:

        sub     sp, sp, #0
        //113:x29,#-32

        //112:x29,#-16

        mov     x8, #32
        sub     sp, sp, x8
        //bb2:

bb2:

        //  %r112 = alloca %arrary

        //  %r113 = alloca %arrary

        //  %r114 = getelementptr %arrary, %arrary* %r112, i32 0, i32 0

        mov     x8, #-16
        add     x8, x29, x8
        mov     x9, #0
        add     x9, x8, x9
        //  store i32 1, i32* %r114

        mov     x8, #1
        str     x8, [x9]
        //  %r115 = getelementptr %arrary, %arrary* %r113, i32 0, i32 0

        mov     x8, #-32
        add     x8, x29, x8
        mov     x9, #0
        add     x9, x8, x9
        //  store i32 2, i32* %r115

        mov     x8, #2
        str     x8, [x9]
        //  %r122 = call i32 @add(%arrary* %r112, %arrary* %r113)

        add     x8, x29, #-16
        mov     x0, x8
        add     x8, x29, #-32
        mov     x1, x8
        stp     x8, x9, [sp, #-16]!
        stp     x10, x11, [sp, #-16]!
        stp     x12, x13, [sp, #-16]!
        stp     x14, x15, [sp, #-16]!
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        bl     add
        mov     sp, x29
        ldp     x29, x30, [sp], #16
        ldp     x14, x15, [sp], #16
        ldp     x12, x13, [sp], #16
        ldp     x10, x11, [sp], #16
        ldp     x8, x9, [sp], #16
        mov     x8, x0
        //  ret i32 %r122

        mov     x0, x8
        ret
