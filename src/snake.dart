part of Snake;

class Snake {
  List<Quad> parts = new List<Quad>();
  int direction = 1;
  int canMove = 0;
  
  Snake() {
    for (int i = 0; i < 3; i++) {
      grow();
    }
  }
  
  void move() {
    for (int i = parts.length - 1; i > 0; i--) {
      parts[i].x = parts[i - 1].x;
      parts[i].y = parts[i - 1].y;
    }
    
    parts[0].move(direction);
  }
  
  void grow() {
    double x, y;
    if (parts.isEmpty) {
      x = 200.0;
      y = 50.0;
    } else {
      x = parts.last.x;
      y = parts.last.y;
    }
    
    parts.add(new Quad(x, y, 15.0, 15.0, 'red'));
  }
  
  void update() {
    canMove++;
    if (keys[37]) {
      if (direction != 1) direction = 0;
    } else if (keys[38]) {
      if (direction != 3) direction = 2;
    } else if (keys[39]) {
      if (direction != 0) direction = 1;
    } else if (keys[40]) {
      if (direction != 2) direction = 3;
    }
    
    if (canMove % 3 == 0) {
      move();
      canMove = 0;
    }
    
    if (parts[0].collidesWith(game.apple)) {
      grow();
      game.score++;
      game.createNewApple();
    }
    
    if (collides()) {
      game.setGameOver();
    }
  }
  
  bool collides() {
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].x < 0 || parts[i].x + parts[i].width > canvas.width || parts[i].y < 0 || parts[i].y + parts[i].height > canvas.height)
        return true;
      
      if (i > 4 && parts[i].collidesWith(parts[0]))
        return true;
    }
    
    return false;
  }
  
  void draw() {
    parts.forEach((quad) => quad.draw());
  }
}