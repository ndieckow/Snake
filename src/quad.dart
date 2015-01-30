part of Snake;

class Quad {
  double x, y;
  double width, height;
  String color;
  
  Quad(this.x, this.y, this.width, this.height, this.color);
  
  void move(int direction) {
    if (direction == 0) x -= width;
    if (direction == 1) x += width;
    if (direction == 2) y -= height;
    if (direction == 3) y += height;
  }
  
  bool collidesWith(Quad quad) {
    return this.x < quad.x + quad.width
        && this.x + this.width > quad.x
        && this.y < quad.y + quad.height
        && this.y + this.height > quad.y;
  }
  
  void draw() {
    context.beginPath();
    context.rect(x, y, width, height);
    context.fillStyle = color;
    context.fill();
    context.stroke();
    context.closePath();
  }
}