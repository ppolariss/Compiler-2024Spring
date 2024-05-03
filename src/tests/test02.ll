declare i32 @getch( )
declare i32 @getint( )
declare void @putch( i32 )
declare void @putint( i32 )
declare void @putarray( i32, i32* )
declare void @_sysy_starttime( i32 )
declare void @_sysy_stoptime( i32 )
%Node = type { i32, i32 }
@d = global %Node zeroinitializer
@e = global [ 10 x %Node ] zeroinitializer
define void @foo( %Node* %r100 ) {
foo:
  %r101 = getelementptr %Node, %Node* %r100, i32 0, i32 0
  %r102 = call i32 @getint()
  store i32 %r102, i32* %r101
  %r103 = getelementptr %Node, %Node* %r100, i32 0, i32 1
  %r104 = call i32 @getint()
  store i32 %r104, i32* %r103
  ret void
  ret void
}

define void @baz( %Node* %r105 ) {
baz:
  %r106 = getelementptr %Node, %Node* %r105, i32 2
  %r107 = getelementptr %Node, %Node* %r106, i32 0, i32 0
  %r108 = call i32 @getint()
  store i32 %r108, i32* %r107
  %r109 = getelementptr %Node, %Node* %r105, i32 2
  %r110 = getelementptr %Node, %Node* %r109, i32 0, i32 1
  %r111 = call i32 @getint()
  store i32 %r111, i32* %r110
  ret void
  ret void
}

define i32 @main( ) {
main:
  call void @_sysy_starttime(i32 13)
  %r112 = alloca %Node
  %r113 = getelementptr %Node, %Node* %r112, i32 0, i32 0
  store i32 1, i32* %r113
  %r114 = getelementptr %Node, %Node* %r112, i32 0, i32 1
  store i32 2, i32* %r114
  call void @foo(%Node* %r112)
  call void @foo(%Node* @d)
  %r115 = getelementptr [10 x %Node ], [10 x %Node ]* @e, i32 0, i32 0
  call void @baz(%Node* %r115)
  %r116 = getelementptr %Node, %Node* %r112, i32 0, i32 0
  %r117 = getelementptr %Node, %Node* %r112, i32 0, i32 1
  %r119 = load i32, i32* %r116
  %r120 = load i32, i32* %r117
  %r118 = add i32 %r119, %r120
  call void @putint(i32 %r118)
  %r121 = getelementptr %Node, %Node* @d, i32 0, i32 0
  %r122 = getelementptr %Node, %Node* @d, i32 0, i32 1
  %r124 = load i32, i32* %r121
  %r125 = load i32, i32* %r122
  %r123 = add i32 %r124, %r125
  call void @putint(i32 %r123)
  %r126 = getelementptr [10 x %Node ], [10 x %Node ]* @e, i32 0, i32 2
  %r127 = getelementptr %Node, %Node* %r126, i32 0, i32 0
  %r128 = getelementptr [10 x %Node ], [10 x %Node ]* @e, i32 0, i32 2
  %r129 = getelementptr %Node, %Node* %r128, i32 0, i32 1
  %r131 = load i32, i32* %r127
  %r132 = load i32, i32* %r129
  %r130 = add i32 %r131, %r132
  call void @putint(i32 %r130)
  call void @_sysy_stoptime(i32 19)
  ret i32 0
  ret i32 0
}

