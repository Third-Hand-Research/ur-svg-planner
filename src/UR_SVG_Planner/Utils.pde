boolean checkBounds(float val, float min, float max){
  return val >= min && val <= max;
}

float deg2rad(float d){
  return d*(PI/180); 
}

float rad2deg(float r){
  return r*(180/PI); 
}
