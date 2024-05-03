declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
@a = global i32 5
define i32 @main( ) {
main:
  %r104 = alloca i32
  %r100 = alloca i32
  %r102 = load i32, i32* @a
  %r101 = icmp sgt i32 %r102, 1
  br i1 %r101, label %bb1, label %bb2

bb1:
  store i32 1, i32* %r100
  br label %bb3

bb2:
  store i32 0, i32* %r100
  br label %bb3

bb3:
  %r103 = load i32, i32* %r100
  store i32 %r103, i32* %r104
  %r106 = load i32, i32* %r104
  %r105 = mul i32 %r106, 10
  ret i32 %r105
  ret i32 0
}

