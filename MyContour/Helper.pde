
void Densify(ArrayList<PVector> pars, float interval){
  //println(pars.size());
  if(interval == 0)
  return;
  
  ArrayList<PVector> tmpPars = new ArrayList<PVector>();
  
  for(int i =0;i<pars.size()-1;i++){
    PVector v = pars.get(i).copy();
    tmpPars.add(v.copy());
    PVector tv= pars.get(i+1);
    PVector dir = PVector.sub(tv,v);
    float maxDist = dir.mag();
    dir.normalize();
    dir.mult(interval);
    
    for(int j =0; j < (int)(maxDist/interval);j++){
      v.add(dir);
      tmpPars.add(v.copy());
    }
    
  }
  //pars = tmpPars;
  pars.clear();
  for(PVector v : tmpPars){
    pars.add(v);
  }
  
  //println(pars.size());
}
