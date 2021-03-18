//
//  Shader.fsh
//  OpenGLDemo
//
//  Created by wepie on 2021/3/15.
//

precision mediump float;

uniform sampler2D colorMap;
varying vec2 varyTextCoord;

void main() {
    gl_FragColor = texture2D(colorMap, varyTextCoord);
}
