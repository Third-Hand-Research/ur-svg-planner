class Post {
  PrintWriter ur;
  int count = 0;
  
  Post(String filename){
    ur = createWriter(filename);
  }
  
  void print(String cmd){
    ur.println(cmd);
    count++;
  }
  
  void movej(float a1, float a2, float a3, float a4, float a5, float a6){
    ur.println("movej(["+deg2rad(a1)+","+deg2rad(a2)+","+deg2rad(a3)+","+deg2rad(a4)+","+deg2rad(a5)+","+deg2rad(a6)+"], rapid_ms, accel_ms, 0, blend_radius_m)");
  }
  
  void movej(float a1, float a2, float a3, float a4, float a5, float a6, float b){
    ur.println("movej(["+deg2rad(a1)+","+deg2rad(a2)+","+deg2rad(a3)+","+deg2rad(a4)+","+deg2rad(a5)+","+deg2rad(a6)+"], rapid_ms, accel_ms, 0, "+b+")");
  }
  
  void movel(float x, float y, float z){
    
    if (!checkBounds(x, minX, maxX) || !checkBounds(y, minY, maxY) || !checkBounds(z, minZ, maxZ)) {
      println("Coordinate is out of bounds!");
      return;
    }
    
    ur.println("movel(pose_trans(feature, p["+x+","+y+","+z+",0,0,0]), rapid_ms, accel_ms, 0, blend_radius_m)");
    count++;
  }
  
  void movel(float x, float y, float z, float b){
    
    if (!checkBounds(x, minX, maxX) || !checkBounds(y, minY, maxY) || !checkBounds(z, minZ, maxZ)) {
      println("Coordinate is out of bounds!");
      return;
    }
    
    ur.println("movel(pose_trans(feature, p["+x+","+y+","+z+",0,0,0]), rapid_ms, accel_ms, 0, "+b+")");
    count++;
  }
  
  void movel(float x, float y, float z, float rx, float ry, float rz, float b){
    
    if (!checkBounds(x, minX, maxX) || !checkBounds(y, minY, maxY) || !checkBounds(z, minZ, maxZ)) {
      println("Coordinate is out of bounds!");
      return;
    }
    
    ur.println("movel(pose_trans(feature, p["+x+","+y+","+z+","+rx+","+ry+","+rz+"]), rapid_ms, accel_ms, 0, "+b+")");
    count++;
  }
  
  void sleep(int t){
    ur.println("sleep("+t+")");
    count++;
  }
  
  void setDO(int id, boolean state){
    ur.println("set_standard_digital_out("+id+","+(state?"True":"False")+")");
    count++;
  }
  
  void popup(String message){
    ur.println("popup(\""+message+"\", title=\"UR SVG Planner Popup\" blocking=True)");
    count++;
  }
  
  void halt(){
    ur.println("halt()");
    count++;
  }
  
  int getCount(){
    return count;
  }
  
  void export(){
    ur.flush();
    ur.close();
  }
}
