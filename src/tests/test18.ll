declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
define i32 @main( ) {
main:
  br label %bb1

bb1:
  %r100 = icmp eq i32 1, 1
  br i1 %r100, label %bb2, label %bb3

bb2:
  %r101 = icmp eq i32 1, 1
  br i1 %r101, label %bb4, label %bb5

bb4:
  br label %bb3

  call void @putint(i32 1)
  br label %bb6

bb5:
  br label %bb6

bb6:
  br label %bb1

bb3:
  ret i32 1
  ret i32 0
}

