// RUN: %clang_cc1 -triple dxil-pc-shadermodel6.3-library -x hlsl -o - %s -verify

// expected-no-diagnostics

[RootSignature("CBV(b0), CBV(b1)")]
void valid_root_signature_0() {}

[RootSignature("CBV(b0, visibility = SHADER_VISIBILITY_DOMAIN), CBV(b0, visibility = SHADER_VISIBILITY_PIXEL)")]
void valid_root_signature_1() {}

[RootSignature("CBV(b0, space = 1), CBV(b0, space = 2)")]
void valid_root_signature_2() {}

[RootSignature("CBV(b0), SRV(t0)")]
void valid_root_signature_3() {}
