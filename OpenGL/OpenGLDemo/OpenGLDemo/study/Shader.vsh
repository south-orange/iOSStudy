//
//  Shader.vsh
//  OpenGLDemo
//
//  Created by wepie on 2021/3/15.
//

attribute vec3 position;
attribute vec2 textCoordinate;

varying vec2 varyTextCoord;

void main() {
    varyTextCoord = textCoordinate;
    gl_Position = vec4(position, 1.0);
}
