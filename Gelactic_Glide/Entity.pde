// Gelatic Glide
// Authors: Brandon Corbin, Caden Trca, Francisco Sanchez, and John Gionti
// File: Entity.pde
// Description: Entity.pde is the base class for the main moving objects in
//              the game including the player, enemies, and obstacles. 

class Entity {
  int xPos, yPos;
  int x_velocity, y_velocity;
  int size;
  
  Entity(int x_vel, int y_vel, int s) {
    x_velocity = x_vel;
    y_velocity = y_vel;
    size = s;
  }
  
  void Move() {
    
  }
}
