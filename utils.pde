
public static class Utils{
  public static DateTime GetNonLeapYear(){
    return new DateTime(2001,1,1,0,0,0,0);
  }
  
  public static String GetFilenameForDate(String path, int year, int dayOfYear){
    File f;
    String filename;
    
    if(year < 1979) return "";
    if(year >= 2017) return "";
    
    if(year == 1987 && dayOfYear > 336) return "";   //Missing data in 1987
    
    // Years up to 1988 only have data for every second day so if png doesn't exist then try the next day
    do{
      DateTime dt = GetNonLeapYear().withDayOfYear(dayOfYear);
            
      int month = dt.monthOfYear().get();
      int day = dt.dayOfMonth().get();
      
      //filename = String.format( path+"..\\..\\combinedPngsSouth\\nt_%d%02d%02d_s.png", year, month, day);
      filename = String.format( path+"..\\..\\combinedPngs\\nt_%d%02d%02d_n.png", year, month, day);
            
      f = new File(filename);
            
      dayOfYear++;
      if(dayOfYear > 365) dayOfYear = dayOfYear - 3; // Don't go to the next next, simply skip back a few days - close enough!
    }
    while(!f.exists());
    
    return f.getAbsolutePath();
  }
}