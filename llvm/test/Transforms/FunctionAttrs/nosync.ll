; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes
; RUN: opt < %s -function-attrs -S | FileCheck %s
; RUN: opt < %s -passes=function-attrs -S | FileCheck %s

; Base case, empty function
define void @test1() {
; CHECK: Function Attrs: norecurse nounwind readnone willreturn
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret void
;
  ret void
}

; Show the bottom up walk
define void @test2() {
; CHECK: Function Attrs: norecurse nounwind readnone willreturn
; CHECK-LABEL: @test2(
; CHECK-NEXT:    call void @test1()
; CHECK-NEXT:    ret void
;
  call void @test1()
  ret void
}

declare void @unknown() convergent

; Negative case with convergent function
define void @test3() convergent {
; CHECK: Function Attrs: convergent
; CHECK-LABEL: @test3(
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    ret void
;
  call void @unknown()
  ret void
}

define i32 @test4(i32 %a, i32 %b) {
; CHECK: Function Attrs: norecurse nounwind readnone willreturn
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %add = add i32 %a, %b
  ret i32 %a
}

; negative case - explicit sync
define void @test5(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn
; CHECK-LABEL: @test5(
; CHECK-NEXT:    store atomic i8 0, i8* [[P:%.*]] seq_cst, align 1
; CHECK-NEXT:    ret void
;
  store atomic i8 0, i8* %p seq_cst, align 1
  ret void
}

; negative case - explicit sync
define i8 @test6(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[V:%.*]] = load atomic i8, i8* [[P:%.*]] seq_cst, align 1
; CHECK-NEXT:    ret i8 [[V]]
;
  %v = load atomic i8, i8* %p seq_cst, align 1
  ret i8 %v
}

; negative case - explicit sync
define void @test7(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = atomicrmw add i8* [[P:%.*]], i8 0 seq_cst, align 1
; CHECK-NEXT:    ret void
;
  atomicrmw add i8* %p, i8 0 seq_cst, align 1
  ret void
}

; negative case - explicit sync
define void @test8(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn
; CHECK-LABEL: @test8(
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret void
;
  fence seq_cst
  ret void
}
