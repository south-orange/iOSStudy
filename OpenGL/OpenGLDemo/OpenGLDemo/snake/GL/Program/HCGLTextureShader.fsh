





#define MAX_TEXTURES 8


uniform highp mat4 u_mvpMatrix;
uniform lowp sampler2D u_textureSamplers[MAX_TEXTURES];

varying mediump vec4 v_textureAndAlpha;

void main() {
    int textureIndex = int(v_textureAndAlpha.z + 0.1);
    gl_FragColor = texture2D(u_textureSamplers[textureIndex], v_textureAndAlpha.xy) * v_textureAndAlpha.w;
}
