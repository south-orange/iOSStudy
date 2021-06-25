



uniform highp mat4 u_projectionMatrix;
uniform highp mat4 u_fullViewMatrix;


varying lowp vec4 v_color;

void main() {
    gl_FragColor = v_color;
}
