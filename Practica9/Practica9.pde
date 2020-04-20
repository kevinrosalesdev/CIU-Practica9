//import gifAnimation.*;

//GifMaker ficherogif;
//int frameCounter;

PShader shader;
PImage[] images;
String[] paintingTitles;
int direction, offset, movement, imageIndex;
float threshold;
PFont font;
boolean showControlsMenu, showValuesPanel, isLeftArrowPressed, isUpArrowPressed, isDownArrowPressed, isRightArrowPressed;

void setup(){
  fullScreen(P3D);
  //size(1200, 750, P2D);
  //ficherogif = new GifMaker(this, "animation.gif");
  //ficherogif.setRepeat(0);
  //ficherogif.addFrame();
  //frameCounter = 0;
  
  direction = 1;
  offset = 1;
  movement = 0;
  imageIndex = 0;
  threshold = 0.1;
  showControlsMenu = true;
  showValuesPanel = true;
  images = new PImage[3];
  
  images[0] = loadImage("paintings/theStarryNight.png");
  images[1] = loadImage("paintings/theScream.png");
  images[2] = loadImage("paintings/wandererAboveTheSeaOfFog.jpg");
  paintingTitles = new String[]{"La Noche Estrellada - Vincent Van Gogh", "El Grito - Edvard Munch", "El Caminante sobre el Mar de Nubes - David Friedrich"};
  shader = loadShader("shader.glsl");
  font = loadFont("SegoeUI-Semibold-48.vlw");
  image(images[imageIndex], 0, 0, width, height);
  frameRate(10);
}

void draw(){
  //frameCounter++;
  //if(frameCounter == 10){
  //  ficherogif.addFrame();
  //  frameCounter = 0;
  //}
  if (movement == 0 && direction > 8) direction = 1;
  else if (movement == 1 && direction < 1) direction = 8;
  image(images[imageIndex], 0, 0, width, height);
  tint(255, 128);
  filter(shader);
  if (movement == 0 || movement == 1) shader.set("directionValue", direction);
  else shader.set("directionValue", int(random(9)));
  shader.set("offset", offset);
  shader.set("threshold", threshold);
  if (movement == 0) direction++;
  else if (movement == 1) direction--;
  drawMenu();
  manageArrowKeys();
}

void drawMenu(){
  if(showControlsMenu){
    fill(255, 175);
    rect(0, 0, width, 0.27*height);
    fill(0);
    line(0, 0.03*height, width, 0.03*height);
    line(0, 0.24*height, width, 0.24*height);
    textFont(font, 15*0.00075*width);
    textAlign(LEFT);
    text("A/D: cambiar imagen", 0.005*width, 0.05*height);
    text("Flecha arriba/abajo: cambiar umbral de luminosidad (entre mayor sea el umbral, menor será el área afectada por el shader)", 0.005*width, 0.08*height);
    text("Flecha izquierda/derecha: cambiar distancia entre píxeles (entre mayor sea la distancia, más borroso será el efecto provocado por el shader)", 0.005*width, 0.11*height);
    text("ENTER: cambiar efecto de movimiento (sentido de las agujas del reloj, sentido contrario a las agujas del reloj o aleatorio)", 0.005*width, 0.14*height);
    text("M: mostrar/ocultar este menú", 0.005*width, 0.17*height);
    text("N: mostrar/ocultar panel de valores usados actualmente", 0.005*width, 0.2*height);
    text("ESC: salir de la aplicación", 0.005*width, 0.23*height);
    text("Para más información, consulte el repositorio original", 0.005*width, 0.26*height);
    textFont(font, 20*0.00075*width);
    textAlign(CENTER);
    fill(0, 0, 255);
    text("CONTROLES", 0.5*width, 0.025*height);
  }else{
    fill(255, 175);
    rect(0, 0, 0.2*width, 0.04*height);
    textFont(font, 15*0.00075*width);
    textAlign(LEFT);
    fill(0);
    text("M: mostrar menú de controles", 0.005*width, 0.025*height);
  }
  
  if(showValuesPanel){
    String movementEffect = "";
    switch (movement){
      case 0:
        movementEffect = "sentido de las agujas del reloj";
        break;
      case 1:
        movementEffect = "sentido contrario a las agujas del reloj";
        break;
      case 2:
        movementEffect = "aleatorio";
        break;
      default:
        break;
    }
    fill(255, 175);
    rect(0.65*width, 0.85*height, width, height);
    fill(0);
    line(0.65*width, 0.88*height, width, 0.88*height);
    textFont(font, 15*0.00075*width);
    textAlign(LEFT);
    text("Obra actual: " + paintingTitles[imageIndex], 0.655*width, 0.9*height);
    text("Umbral de luminosidad: " + nf(threshold, 1, 2), 0.655*width, 0.93*height);
    text("Distancia entre píxeles: " + offset, 0.655*width, 0.96*height);
    text("Efecto de movimiento: " + movementEffect, 0.655*width, 0.99*height);
    textFont(font, 20*0.00075*width);
    textAlign(CENTER);
    fill(0, 0, 255);
    text("VALORES ACTUALES", 0.825*width, 0.875*height);
  }else{
    fill(255, 175);
    rect(0.8*width, 0.96*height, width, height);
    textFont(font, 15*0.00075*width);
    textAlign(LEFT);
    fill(0);
    text("N: mostrar panel de valores actuales", 0.805*width, 0.985*height);
  }
}

void manageArrowKeys(){
  if (isUpArrowPressed){
    threshold += 0.01;
    if (threshold > 1) threshold = 1;
  }
  if (isDownArrowPressed){
    threshold -= 0.01;
    if (threshold < 0) threshold = 0;
  }
  
  if (isRightArrowPressed){
    offset += 1;
    if (offset > 10) offset = 10;
  }
  if (isLeftArrowPressed){
    offset -= 1;
    if (offset < 1) offset = 1;
  }
}

void keyPressed(){
  if (key == 'M' || key == 'm') showControlsMenu = !showControlsMenu;
  if (key == 'N' || key == 'n') showValuesPanel = !showValuesPanel;
  if (key == ENTER || key == RETURN){
    movement++;
    if (movement > 2) movement = 0;  
  }
  if (key == 'A' || key == 'a'){
    imageIndex--;
    if (imageIndex < 0) imageIndex = images.length - 1;
  }
  if (key == 'D' || key == 'd'){
    imageIndex++;
    if (imageIndex > images.length - 1) imageIndex = 0;
  }
  manageArrowKeysPressed(true);
}

void keyReleased(){
  manageArrowKeysPressed(false);
}

void manageArrowKeysPressed(boolean isPressed){
  if (key == CODED && keyCode == LEFT) isLeftArrowPressed = isPressed;
  if (key == CODED && keyCode == UP) isUpArrowPressed = isPressed;
  if (key == CODED && keyCode == DOWN) isDownArrowPressed = isPressed;
  if (key == CODED && keyCode == RIGHT) isRightArrowPressed = isPressed;
}
