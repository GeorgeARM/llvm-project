; Test floating-point strict conversion to/from 128-bit integers.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z13 | FileCheck %s

declare fp128 @llvm.experimental.constrained.sitofp.f128.i128(i128, metadata, metadata)
declare double @llvm.experimental.constrained.sitofp.f64.i128(i128, metadata, metadata)
declare float @llvm.experimental.constrained.sitofp.f32.i128(i128, metadata, metadata)
declare half @llvm.experimental.constrained.sitofp.f16.i128(i128, metadata, metadata)

declare fp128 @llvm.experimental.constrained.uitofp.f128.i128(i128, metadata, metadata)
declare double @llvm.experimental.constrained.uitofp.f64.i128(i128, metadata, metadata)
declare float @llvm.experimental.constrained.uitofp.f32.i128(i128, metadata, metadata)
declare half @llvm.experimental.constrained.uitofp.f16.i128(i128, metadata, metadata)

declare i128 @llvm.experimental.constrained.fptosi.i128.f128(fp128, metadata)
declare i128 @llvm.experimental.constrained.fptosi.i128.f64(double, metadata)
declare i128 @llvm.experimental.constrained.fptosi.i128.f32(float, metadata)
declare i128 @llvm.experimental.constrained.fptosi.i128.f16(half, metadata)

declare i128 @llvm.experimental.constrained.fptoui.i128.f128(fp128, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.f64(double, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.f32(float, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.f16(half, metadata)

; Test signed i128->f128.
define fp128 @f1(i128 %i) #0 {
; CHECK-LABEL: f1:
; CHECK: brasl %r14, __floattitf@PLT
; CHECK: br %r14
  %conv = call fp128 @llvm.experimental.constrained.sitofp.f128.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

; Test signed i128->f64.
define double @f2(i128 %i) #0 {
; CHECK-LABEL: f2:
; CHECK: brasl %r14, __floattidf@PLT
; CHECK: br %r14
  %conv = call double @llvm.experimental.constrained.sitofp.f64.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %conv
}

; Test signed i128->f32.
define float @f3(i128 %i) #0 {
; CHECK-LABEL: f3:
; CHECK: brasl %r14, __floattisf@PLT
; CHECK: br %r14
  %conv = call float @llvm.experimental.constrained.sitofp.f32.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret float %conv
}

; Test signed i128->f16.
define half @f4(i128 %i) #0 {
; CHECK-LABEL: f4:
; CHECK: %r14, __floattisf@PLT
; CHECK: %r14, __truncsfhf2@PLT
; CHECK: br %r14
  %conv = call half @llvm.experimental.constrained.sitofp.f16.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret half %conv
}

; Test unsigned i128->f128.
define fp128 @f5(i128 %i) #0 {
; CHECK-LABEL: f5:
; CHECK: brasl %r14, __floatuntitf@PLT
; CHECK: br %r14
  %conv = call fp128 @llvm.experimental.constrained.uitofp.f128.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

; Test unsigned i128->f64.
define double @f6(i128 %i) #0 {
; CHECK-LABEL: f6:
; CHECK: brasl %r14, __floatuntidf@PLT
; CHECK: br %r14
  %conv = call double @llvm.experimental.constrained.uitofp.f64.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %conv
}

; Test unsigned i128->f32.
define float @f7(i128 %i) #0 {
; CHECK-LABEL: f7:
; CHECK: brasl %r14, __floatuntisf@PLT
; CHECK: br %r14
  %conv = call float @llvm.experimental.constrained.uitofp.f32.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret float %conv
}

; Test unsigned i128->f16.
define half @f8(i128 %i) #0 {
; CHECK-LABEL: f8:
; CHECK: brasl %r14, __floatuntisf@PLT
; CHECK: brasl %r14, __truncsfhf2@PLT
; CHECK: br %r14
  %conv = call half @llvm.experimental.constrained.uitofp.f16.i128(i128 %i,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret half %conv
}

; Test signed f128->i128.
define i128 @f9(fp128 %f) #0 {
; CHECK-LABEL: f9:
; CHECK: brasl %r14, __fixtfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptosi.i128.f128(fp128 %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test signed f64->i128.
define i128 @f10(double %f) #0 {
; CHECK-LABEL: f10:
; CHECK: brasl %r14, __fixdfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptosi.i128.f64(double %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test signed f32->i128.
define i128 @f11(float %f) #0 {
; CHECK-LABEL: f11:
; CHECK: brasl %r14, __fixsfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptosi.i128.f32(float %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test signed f16->i128.
define i128 @f12(half %f) #0 {
; CHECK-LABEL: f12:
; CHECK: brasl %r14, __extendhfsf2@PLT
; CHECK: brasl %r14, __fixsfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptosi.i128.f16(half %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test unsigned f128->i128.
define i128 @f13(fp128 %f) #0 {
; CHECK-LABEL: f13:
; CHECK: brasl %r14, __fixunstfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptoui.i128.f128(fp128 %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test unsigned f64->i128.
define i128 @f14(double %f) #0 {
; CHECK-LABEL: f14:
; CHECK: brasl %r14, __fixunsdfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptoui.i128.f64(double %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test unsigned f32->i128.
define i128 @f15(float %f) #0 {
; CHECK-LABEL: f15:
; CHECK: brasl %r14, __fixunssfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptoui.i128.f32(float %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

; Test unsigned f16->i128.
define i128 @f16(half %f) #0 {
; CHECK-LABEL: f16:
; CHECK: brasl %r14, __extendhfsf2@PLT
; CHECK: brasl %r14, __fixunssfti@PLT
; CHECK: br %r14
  %conv = call i128 @llvm.experimental.constrained.fptoui.i128.f16(half %f,
                                               metadata !"fpexcept.strict") #0
  ret i128 %conv
}

attributes #0 = { strictfp }
