library Snake;

import 'dart:html';
import 'dart:math';

part 'quad.dart';
part 'snake.dart';

CanvasElement canvas;
CanvasRenderingContext2D context;
List<bool> keys = new List<bool>(256);
Random random = new Random();
Game game;

const int STATE_RUNNING = 0;
const int STATE_OVER = 1;

class Game {
  Snake snake;
  int state = STATE_RUNNING;
  int score = 0;
  
  Quad apple;
  bool incr;
  int appleMove = 0;
  
  int lastTime = new DateTime.now().millisecondsSinceEpoch * 1000000;
  double ns = 1000000000.0 / 60.0;
  double delta = 0.0;
  
  int lastTimer = new DateTime.now().millisecondsSinceEpoch;
  int ticks = 0;
  int frames = 0;
  
  void start() {
    canvas = querySelector("#gameCanvas");
    canvas.width = 640;
    canvas.height = 480;
    context = canvas.getContext("2d");
    
    keys.fillRange(0, keys.length, false);
    
    snake = new Snake();
    createNewApple();
    listenForMovement();
    
    window.requestAnimationFrame(animate);
  }
  
  void setGameOver() {
    state = STATE_OVER;
  }
  
  void animate(double time) {
    int now = new DateTime.now().millisecondsSinceEpoch * 1000000;
    delta += (now - lastTime) / ns;
    lastTime = now;
    
    while (delta >= 1) {
      update();
      ticks++;
      delta--;
    }
    
    render();
    frames++;
    
    if (new DateTime.now().millisecondsSinceEpoch - lastTimer >= 1000) {
      lastTimer += 1000;
      print(ticks.toString() + " ticks, " + frames.toString() + " fps");
      ticks = 0;
      frames = 0;
    }
    
    window.requestAnimationFrame(animate);
  }
  
  void update() {
    if (state == STATE_RUNNING) {
      if (apple.width >= 20)
        incr = false;
      else if (apple.width <= 15)
        incr = true;
      
      appleMove++;
      if (appleMove % 2 == 0) {
        if (incr) {
          apple.width += 0.5;
          apple.height += 0.5;
          apple.x -= 0.25;
          apple.y -= 0.25;
        } else {
          apple.width -= 0.5;
          apple.height -= 0.5;
          apple.x += 0.25;
          apple.y += 0.25;
        }
        
        appleMove = 0;
      }
      
      snake.update();
    }
  }
  
  void render() {
    clear();
    
    if (state == STATE_RUNNING) {
      renderInGame();
    } else if (state == STATE_OVER) {
      renderGameOver();
    }
  }
  
  void renderInGame() {
    context.font = '20pt Consolas';
    context.fillStyle = '#000000';
    context.fillText("Score: " + score.toString(), 20, 30);
    snake.draw();
    apple.draw();
  }
  
  void renderGameOver() {
    context.font = '40pt Consolas';
    context.fillStyle = '#000000';
    context.fillText("Game Over! :C", 120, 200);
    
    context.font = '30pt Consolas';
    context.fillText("Score: " + score.toString(), 120, 280);
  }
  
  void clear() {
    context.clearRect(0, 0, canvas.width, canvas.height);
  }
  
  void createNewApple() {
    apple = new Quad(random.nextInt((canvas.width - 20) - 20).toDouble() + 20, random.nextInt((canvas.height - 20) - 20).toDouble() + 20, 15.0, 15.0, 'green');
  }

  void listenForMovement() {
    document.onKeyDown.listen((event) {
      if (event.keyCode > keys.length)
        return;
      
      keys[event.keyCode] = true;
    });
    
    document.onKeyUp.listen((event) {
        if (event.keyCode > keys.length)
          return;
        
        keys[event.keyCode] = false;
      });
  }
}

void main() {
  game = new Game();
  game.start();
}