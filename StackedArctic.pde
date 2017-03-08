
void setup() {
  size(1000,1000,P3D);
  noStroke();
}

void draw() {
  
  
  if(frameCount >= 365)
    exit();
  
  background(0, 6, 134);
  fill(255,255,255);
  
  //translate( width/2, height/2, 0);
  
  camera
  (
    -160, -150, -90,
    0, 40, 0,
    0, 1, 0
  );
  
  doLights();
  generateIce(frameCount);
  
   
  save(String.format("frames/frame%04d.png", frameCount));
  //if(frameCount >= 9999){exit();}
}


void doLights()
{
  lights();
  pointLight(127, 127, 127, 0, -800, -200);
  ambientLight(127, 127, 127);
  //lightSpecular(255, 255, 255);
}

int _maxX = 304;
int _maxY = 2017 - 1979;
int _maxZ = 432;
  
void generateIce(int dayNum){  
  translate(-_maxX/2, 0, -_maxZ/2);
   
  for(int y = 0; y < _maxY; y++)
  {
    translate(0,-1,0);
    String mapFileName = Utils.GetFilenameForDate(sketchPath(""), 1979 + y, dayNum); //<>//
    if(mapFileName == "") continue;
    PImage map = loadImage(mapFileName).get(18,35,304,432);
    map.loadPixels();
    
    
    for(int x = 0; x < _maxX; x++)
    {
      translate(1,0,0);
      for(int z = 0; z < _maxZ; z++)
      {
        translate(0,0,1);
        
        if(isLonePixel(map, x, z)) continue;
        
        color pixel = map.pixels[x+(z*_maxX)];
                
        fill(pixel);
        
        if(isShoreLine(pixel))
        {
          fill(119,119,119); // Make it look like land
          box(1);
          continue;
        }
        
        if(!isPolarHole(pixel) && !isLand(pixel) && !isWater(pixel)) box(1); // Don't draw land or water 
        
        if(isLand(pixel) && y + 1979 >= 2016) box(1); 
        if(isPolarHole(pixel) && y + 1979 >= 2016) box(1);
      }
      translate(0,0,-_maxZ);
    }
    translate(-_maxX,0,0);
  }
}

boolean isPolarHole(color pixel)
{
  return (red(pixel) == 79 && green(pixel) == 79 && blue(pixel) == 79);
}

boolean isShoreLine(color pixel)
{
  return (red(pixel) == 0 && green(pixel) == 0 && blue(pixel) == 0);
}

boolean isWater(color pixel)
{
  return (red(pixel) == 0 && green(pixel) == 6 && blue(pixel) == 134);
}
boolean isLand(color pixel)
{
  return (red(pixel) == 119 && green(pixel) == 119 && blue(pixel) == 119);
}
boolean isIce(color pixel)
{
  return (!isLand(pixel) && !isPolarHole(pixel) && !isShoreLine(pixel) && !isWater(pixel));
}

boolean isLonePixel(PImage map, int x, int z)
{
  color pixel = map.pixels[x+(z*_maxX)];
  
  if(!isIce(pixel)) return false;
  
  if(onEdge(x, z)) return false;
  
  color n = map.pixels[x+((z + 1) * _maxX)];
  color s = map.pixels[x+((z - 1) *_maxX)];
  color e = map.pixels[(x + 1) + (z*_maxX)];
  color w = map.pixels[(x - 1) + (z*_maxX)];
  
  if(isWater(s)) return true;
  if(isWater(n)) return true;
  if(isWater(w)) return true;
  if(isWater(e)) return true;
  
  if(areAllLandOrWater(n, s, e, w)) return true;
  
  return false;
}

boolean onEdge(int x, int z)
{
  if(x==0 || z==0) return true;
  if(x==_maxX-1 || z==_maxZ-1) return true;
  return false;
}

boolean areAllLandOrWater(color p1, color p2, color p3, color p4)
{ 
  return (isShoreLine(p1) || isWater(p1)) && (isShoreLine(p2) || isWater(p2)) && (isShoreLine(p3) || isWater(p3)) && (isShoreLine(p4) || isWater(p4));
  
}