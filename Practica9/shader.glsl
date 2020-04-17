#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform int directionValue;
uniform int offset;
uniform float threshold;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {

  int direction = 0;

  vec4 col0 = textureOffset(texture, vertTexCoord.st, ivec2(-offset, -offset)); //Esquina superior izquierda
  vec4 col1 = textureOffset(texture, vertTexCoord.st, ivec2(      0, -offset)); //Centro superior
  vec4 col2 = textureOffset(texture, vertTexCoord.st, ivec2(+offset, -offset)); //Esquina superior derecha
  vec4 col3 = textureOffset(texture, vertTexCoord.st, ivec2(-offset,       0)); //Centro izquierda
  vec4 col4 = textureOffset(texture, vertTexCoord.st, ivec2(      0,       0)); //Centro
  vec4 col5 = textureOffset(texture, vertTexCoord.st, ivec2(+offset,       0)); //Centro derecha
  vec4 col6 = textureOffset(texture, vertTexCoord.st, ivec2(-offset, +offset)); //Esquina inferior izquierda
  vec4 col7 = textureOffset(texture, vertTexCoord.st, ivec2(      0, +offset)); //Centro inferior
  vec4 col8 = textureOffset(texture, vertTexCoord.st, ivec2(+offset, +offset)); //Esquina inferior derecha

  float brightness = (col4.r, col4.g, col4.b) / 3.0;

  if (threshold < brightness) direction = directionValue;

  vec4 sum;

  switch(direction){
    case 0:
      sum = col4;
      break;

    case 1:
      sum = (0.5 * col4 + 1.5 * col3 + 2.5 * col6 + 1.5 * col7) / 6.0 ;
      break;

    case 2:
      sum = (0.5 * col4 + 1.5 * col6 + 2.5 * col7 + 1.5 * col8) / 6.0 ;
      break;

    case 3:
      sum = (0.5 * col4 + 1.5 * col7 + 2.5 * col8 + 1.5 * col5) / 6.0 ;
      break;
      
    case 4:
      sum = (0.5 * col4 + 1.5 * col8 + 2.5 * col5 + 1.5 * col2) / 6.0;
      break;

    case 5:
      sum = (0.5 * col4 + 1.5 * col5 + 2.5 * col2 + 1.5 * col1) / 6.0 ;
      break;

    case 6:
      sum = (0.5 * col4 + 1.5 * col2 + 2.5 * col1 + 1.5 * col0) / 6.0 ;
      break;

    case 7:
      sum = (0.5 * col4 + 1.5 * col1 + 2.5 * col0 + 1.5 * col3) / 6.0 ;
      break;
      
    case 8:
      sum = (0.5 * col4 + 1.5 * col0 + 2.5 * col3 + 1.5 * col6) / 6.0;
      break;

    default:
      break;
  }
    
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;  
}
