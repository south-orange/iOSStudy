





attribute vec2 a_position;
attribute vec4 a_color;

uniform highp mat4 u_mvpMatrix;

varying lowp vec4 v_color;

void main() {
    gl_Position = u_mvpMatrix * vec4(a_position, 0.0, 1.0);
    v_color = a_color;
}
