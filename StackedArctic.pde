
void setup() {
  size(1000,1000,P3D);
  noStroke();
}

int dayNum = 0;
void draw() {
  
  
  if(dayNum >= 365)
    exit();
  dayNum++;
  
  background(0, 6, 134);
  fill(255,255,255);
  
  //translate( width/2, height/2, 0);
  
  camera
  (
    0, -height/2.0, 150,
    0, 40, 0,
    0, 1, 0
  );
  
  doLights();
  generateIce(dayNum);
  
   
  save(String.format("frames/frame%04d.png", frameCount));
  //if(frameCount >= 9999){exit();}
}


void doLights()
{
  lights();
  pointLight(255, 255, 255, 0, 800, -200);
  ambientLight(25, 25, 25);
  lightSpecular(255, 255, 255);
}

void generateIce(int dayNum){  
  int maxX = 304;
  int maxY = 2017 - 1979;
  int maxZ = 432;
  translate(-maxX/2, 0, -maxZ/2);
   
  for(int y = 0; y < maxY; y++)
  {
    translate(0,-1,0);
    String mapFileName = Utils.GetFilenameForDate(sketchPath(""), 1979 + y, dayNum); //<>//
    if(mapFileName == "") continue;
    PImage map = loadImage(mapFileName).get(18,35,304,432);
    map.loadPixels();
    
    
    for(int x = 0; x < maxX; x++)
    {
      translate(1,0,0);
      for(int z = 0; z < maxZ; z++)
      {
        translate(0,0,1);
        color pixel = map.pixels[x+(z*maxX)];
        
        int greenByte = int(green(pixel));
        int blueByte = int(blue(pixel));
        int redByte = int(red(pixel));
        fill(red(pixel),green(pixel),blue(pixel));
        
        if(redByte == 0 && greenByte == 0 && blueByte == 0)     // shoreline
          fill(119,119,119); // Make it look like land
        
        if(greenByte != 119 && greenByte != 6) box(1); // Don't draw land or water 
        
        if(greenByte == 119 && y + 1979 >= 2016) box(1); // Only draw land in 2016/17
      }
      translate(0,0,-maxZ);
    }
    translate(-maxX,0,0);
  }
  
}