//
//  Shader.vsh
//  OpenGLDemo
//
//  Created by wepie on 2021/3/15.
//

attribute vec4 position;
attribute vec2 textCoordinate;
uniform mat4 rotateMatrix;

varying vec2 varyTextCoord;

void main() {
    varyTextCoord = textCoordinate;
    vec4 vPos = position;
    vPos = vPos * rotateMatrix;
    gl_Position = vPos;
}
