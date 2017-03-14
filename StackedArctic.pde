import java.util.Arrays; 
PFont helveticaSmall;
PFont helveticaLarge;
Ani _droppingAni;
float _droppingHeight = 145;

void setup() {
  size(1000,1000,P3D);
  noStroke();
  helveticaSmall = createFont("helvetica-normal-58c348882d347.ttf", 12);
  helveticaLarge = createFont("helvetica-normal-58c348882d347.ttf", 32);
  textFont(helveticaSmall);
  textMode(SHAPE);
  Ani.init(this);
  Ani.setDefaultTimeMode(Ani.FRAMES);
}

boolean _isDropping = false;
int _yearToDrop = 1980;

void draw() {
  //background(0);
  camera
  (
    -180, -150, -140,
    0, 0, 0,
    0, 1, 0
  );
  
  
  _level = _yearToDrop - 1978;
  background(0, 6, 134);
  
  showTitle();
  
  translate( -152, 0, -216);
  
  doLights();
  
  startDropping();
  if(_isDropping) 
  {
    println(_droppingHeight + ", " + _yearToDrop);
    generateIceYear(_yearToDrop, (frameCount % 365) + 1, _droppingHeight, false);
  }
  
  generateIce((frameCount % 365)+1, _yearToDrop-1);
  
   
  save(String.format("frames/frame%05d.png", frameCount));
  //if(frameCount >= 9999){exit();}
}

void startDropping()
{
  if(Arrays.asList
      (
        365,         // 1980
        365 +  15,   // 1981
        365 +  30,   // 1982
        365 +  45,   // 1983
        365 +  60,   // 1984
        365 +  75,   // 1985
        365 +  90,   // 1986
        365 + 105,   // 1987
        365 + 120,   // 1988
        365 + 135,   // 1989
        365 + 150,   // 1990
        365 + 300,   // 1991
        365 + 315,   // 1992
        365 + 330,   // 1993
        365 + 345,   // 1994
      2*365,         // 1995
      2*365 +  15,   // 1996
      2*365 +  30,   // 1997
      2*365 +  45,   // 1998
      2*365 +  60,   // 1999
      2*365 +  75,   // 2000
      2*365 +  90,   // 2001
      2*365 + 105,   // 2002
      2*365 + 120,   // 2003
      2*365 + 135,   // 2004
      2*365 + 150,   // 2005
      2*365 + 300,   // 2006
      2*365 + 315,   // 2007
      2*365 + 330,   // 2008
      2*365 + 345,   // 2009
      3*365,         // 2010
      3*365 +  15,   // 2011
      3*365 +  30,   // 2012
      3*365 +  45,   // 2013
      3*365 +  60,   // 2014
      3*365 +  75,   // 2015
      3*365 +  90    // 2016
      ).contains(frameCount) )
  {
    drop();
  }
  
  if(frameCount > 3*365 + 320 && _yearToDrop > 1979)
  {
    _yearToDrop--;
  }
  
  if(frameCount == 4 * 365)
  {
    exit();
  }
}

void drop()
{
  _isDropping = true;
  _droppingHeight = 145;
  _droppingAni = new Ani(this, 15, "_droppingHeight", _yearToDrop - 1979, Ani.SINE_OUT, "onEnd:endDropping");
  _droppingAni.start();
}

void endDropping()
{
  _isDropping = false;
  _yearToDrop++;
}

int getUpToYear(int frame)
{
  return 1979 + (frame / 90);
}

void doLights()
{
  lights();
  pointLight(127, 127, 127, 0, -800, -200);
  ambientLight(127, 127, 127);
  //lightSpecular(255, 255, 255);
}

int _maxX = 304;
int _maxY = 1980 - 1979;
int _maxZ = 432;
int _level = 0;

void generateIce(int dayNum, int upToYear){
  //translate(-_maxX/2, 0, -_maxZ/2);
  _maxY = upToYear - 1978;
  pushMatrix();
  for(int year = 1979; year <= upToYear; year++)
  {
    generateIceYear(year, dayNum, year-1979, year != upToYear); //<>//
  }
  popMatrix();
}

void generateIceYear(int year, int dayNum, float yPos, boolean isHollow)
{
  if(year < 1979 || year > 2016) return;
  if(dayNum < 1 || dayNum > 365) return;
  
  if(!isHollow) 
  {
    showYear(year, dayNum, yPos);
    showPlaceNames(yPos);
  }
  
  String mapFileName = Utils.GetFilenameForDate(sketchPath(""), year, dayNum);
  if(mapFileName == "") return;
  PImage map = loadImage(mapFileName).get(18,35,304,432);
  map.loadPixels();
  
  pushMatrix();
    translate(0,-yPos,0);
  
    for(int x = 0; x < _maxX; x++)
    {
      translate(1,0,0);
      pushMatrix();
        for(int z = 0; z < _maxZ; z++)
        {
          translate(0,0,1);
          
          // Filter out as much noise as possible
          if(isLonePixel(map, x, z)) continue;
          
          color pixel = map.pixels[x+(z*_maxX)];
                  
          fill(pixel);
          
          // To reduce number of cubes drawn only draw the shoreline and the top layer of land i.e. the land is hollow.
          if(isShoreLine(pixel))
          {
            fill(119,119,119); // Make it look like land
            box(1);
            continue;
          }
          
          if(!isPolarHole(pixel) && !isLand(pixel) && !isWater(pixel)) box(1); // Don't draw land or water 
          
          if(isLand(pixel) && !isHollow) 
            box(1); 
            
          if(isPolarHole(pixel) && !isHollow) 
          {
            fill(255);
            box(1);
          }
        }
      popMatrix();
      //translate(0,0,-_maxZ);
    }
  popMatrix();
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
  
  // Meh.  Just filter out any ice that is in direct contact with water.
  
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

void showPlaceNames(float level){
  pushStyle();
  pushMatrix();
    textFont(helveticaSmall);
    translate( 152, 0, 216);
    fill(0);
    rotateY(-PI/2);
    rotateX(PI/2);
    text("Greenland",  50,  -5, level+1);
    text("Russia",   -120,   0, level+1);
    text("Alaska",    -30, 110, level+1);
  popMatrix();
  popStyle();
}

void showYear(int year, int dayNum, float level)
{
  pushStyle();
  pushMatrix();
  textFont(helveticaLarge);
  translate( 152, 0, 216);
  fill(150);
  rotateY(-PI/2);
  rotateX(PI/2);
  text(year, -50 ,30, level+1);
  textFont(helveticaSmall);
  text(getMonth(dayNum), -50, 45, level+1);
  popMatrix();
  popStyle();
}

void showTitle()
{
  pushStyle();
  pushMatrix();
    translate( 152, 0, 216);
    fill(255);
    rotateY(-PI/2);
    textFont(helveticaLarge);
    text("Arctic Sea Ice", -300 ,-80, 0);
    textFont(helveticaSmall);
    text("@kevpluck\nImagery from the SMMR and DMSP SSM/I-SSMIS instruments, courtesy NASA NSIDC DAAC", -300, -65, 0);
  popMatrix();
  popStyle();
}

String getMonth(int dayNum)
{
  DateTime dt = Utils.GetNonLeapYear().withDayOfYear(dayNum);
  int month = dt.monthOfYear().get();
  String[] months = new String[]{"?", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  return months[month];
}