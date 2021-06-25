




#define MAX_TEXTURES 8

attribute vec2 a_position;
attribute vec4 a_textureAndAlpha;

uniform highp mat4 u_mvpMatrix;
uniform lowp sampler2D  u_texSamplers[MAX_TEXTURES];

varying mediump vec4 v_textureAndAlpha;

void main() {
    gl_Position = u_mvpMatrix * vec4(a_position, 0.0, 1.0);
    v_textureAndAlpha = a_textureAndAlpha;
}
