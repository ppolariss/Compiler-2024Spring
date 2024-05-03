declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @main( ) {
main:
  %r127 = alloca i32
  %r125 = alloca i32
  %r123 = alloca i32
  %r121 = alloca i32
  %r119 = alloca i32
  %r115 = alloca i32
  %r112 = alloca i32
  %r106 = alloca i32
  call void @_sysy_starttime(i32 2)
  %r100 = alloca i32
  store i32 0, i32* %r100
  %r101 = alloca i32
  %r102 = alloca i32
  %r103 = icmp slt i32 1, 9
  br i1 %r103, label %bb4, label %bb5

bb4:
  store i32 1, i32* %r102
  br label %bb6

bb5:
  store i32 0, i32* %r102
  br label %bb6

bb6:
  %r104 = load i32, i32* %r102
  %r105 = icmp ne i32 %r104, 0
  br i1 %r105, label %bb7, label %bb2

bb7:
  %r108 = load i32, i32* %r100
  %r107 = icmp sgt i32 %r108, 0
  br i1 %r107, label %bb8, label %bb9

bb8:
  store i32 1, i32* %r106
  br label %bb10

bb9:
  store i32 0, i32* %r106
  br label %bb10

bb10:
  %r109 = load i32, i32* %r106
  %r110 = icmp ne i32 %r109, 0
  br i1 %r110, label %bb1, label %bb2

bb1:
  store i32 1, i32* %r101
  br label %bb3

bb2:
  store i32 0, i32* %r101
  br label %bb3

bb3:
  %r111 = load i32, i32* %r101
  store i32 %r111, i32* %r112
  br label %bb11

bb11:
  %r114 = load i32, i32* %r100
  %r113 = icmp slt i32 %r114, 1000000
  br i1 %r113, label %bb12, label %bb13

bb12:
  store i32 0, i32* %r115
  %r117 = load i32, i32* %r100
  %r116 = add i32 %r117, 1
  store i32 %r116, i32* %r100
  br label %bb11

bb13:
  %r118 = load i32, i32* %r112
  call void @putint(i32 %r118)
  call void @_sysy_stoptime(i32 10)
  ret i32 0
  store i32 1, i32* %r119
  %r120 = load i32, i32* %r119
  ret i32 %r120
  store i32 2, i32* %r121
  %r122 = load i32, i32* %r121
  ret i32 %r122
  store i32 3, i32* %r123
  %r124 = load i32, i32* %r123
  ret i32 %r124
  store i32 4, i32* %r125
  %r126 = load i32, i32* %r125
  ret i32 %r126
  store i32 5, i32* %r127
  ret i32 0
}

