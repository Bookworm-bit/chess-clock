int screen = 0;
/*
0 - Menu
1 - Time selection
2 - Timer
*/
boolean leftTurn = false;
/*
True - Left timer will run
False - Right timer will run
*/
int leftTime = 300; // Remaining time on the left side
int rightTime = 300; // Remaining time on the right side
int startTime = 0; // Seconds since spacebar pressed to change side
boolean changingLeft = true; // Selecting time for left side (screen 1)
boolean started = false; // Has timer been started (i.e. has spacebar been pressed)
boolean flagged = false; // Has someone been flagged (i.e. has one of the times gone down to 0)

void setup(){
  size(1600,1200);
}

void draw(){
  if(screen == 0){
    drawMenu();
  }
  if(screen == 1){
    drawSelectTime();
  }
  if(screen == 2){
    drawTimer();
  }
}

void drawMenu(){
  background(255);
  fill(0);
  textSize(80);
  textAlign(CENTER);
  text("Chess Clock", width/2, height/2);
  textSize(40);
  text("Press any key to start.", width/2, 460);
  textSize(20);
  textAlign(LEFT);
  text("Copyright © 2022 Ethan Xu's mom under the MIT License", 20, 580);
  textAlign(RIGHT);
  text("Version 2022.03.07", width-20, 580);
}

void drawSelectTime(){
  background(255);
  textSize(64);
  fill(0);
  textAlign(CENTER);
  text(convertSeconds(leftTime), width/2-200, height/2);
  text(convertSeconds(rightTime), width/2+200, height/2);
  textSize(30);
  text("Left Time", width/2-200, height/2+50);
  text("Right Time", width/2+200, height/2+50);
  textAlign(LEFT);
  textSize(20);
  text("Time selection - " + stringChange(), 10, height-20);
  text("Press 'C' to continue (start game).", 10, 30);
  text("Press 'S' to sync right time with left time.", 10, 60);
  text("Press 'B' to return to the start screen.", 10, 90);
  text("Press the up and down arrows to change the time for the side selected.", 10, 120);
  text("Press the left and right arrows to select the side being changed.", 10, 150);
  
}

void drawTimer(){
  background(255);
  fill(0);
  if(leftTime == 0){
    flagged = true;
  }
  if(rightTime == 0){
    flagged = true;
  }
  if(flagged){
    textAlign(LEFT);
    fill(0);
    textSize(32);
    text("Press 'B' to return", 10, 30);
    text("to time selection.", 10, 60);
    // left side has been flagged
    if(leftTime == 0){
      textAlign(CENTER);
      text("Left side flagged!", width/2-200, height/2+50);
    }
    // right side has been flagged
    if(rightTime == 0){
      textAlign(CENTER);
      text("Right side flagged!", width/2+200, height/2+50);
    }
  }
  if(!started){
    textAlign(LEFT);
    textSize(32);
    text("Clock not started.", 10, 30);
    textSize(20);
    text("Press the spacebar to start the clock and to", 10, 60);
    text("change the side on which time is running.", 10, 90);
  }
  if(started && flagged == false){
    if(leftTurn){
      if(secondsElapsed() - startTime == 1){
        leftTime--;
        startTime = secondsElapsed();
      }
    }
    if(!leftTurn){
      if(secondsElapsed() - startTime == 1){
        rightTime--;
        startTime = secondsElapsed();
      }
    }
  }
  textSize(64);
  textAlign(CENTER);
  text(convertSeconds(leftTime), width/2-200, height/2);
  text(convertSeconds(rightTime), width/2+200, height/2);
  strokeWeight(3);
  line(width/2,0,width/2,height);
}

void keyPressed(){
  if(screen == 0){
    screen = 1;
  }
  if(screen == 1){
    if(keyCode == LEFT || keyCode == RIGHT){
      changingLeft = !changingLeft;
    }
    if(keyCode == UP){
      if(changingLeft){
        leftTime++;
      }
      if(changingLeft == false){
        rightTime++;
      }
    }
    if(keyCode == DOWN){
      if(changingLeft && leftTime > 1){
        leftTime--;
      }
      if(changingLeft == false && rightTime > 1){
        rightTime--;
      }
    }
    if(key == 'c' || key == 'C'){
      screen = 2;
    }
    if(key == 's' || key == 'S'){
      rightTime = leftTime;
    }
    if(key == 'b' || key == 'B'){
      screen = 0;
      leftTime = 300;
      rightTime = 300;
      changingLeft = true;
      started = false;
      flagged = false;
    }
  }
  if(screen == 2){
    if(key == ' '){
      if(started == false) started = true;
      startTime = secondsElapsed();
      leftTurn = !leftTurn;
    }
    if(key == 'b' || key == 'B'){
      screen = 1;
      leftTime = 300;
      rightTime = 300;
      changingLeft = true;
      started = false;
      flagged = false;
    }
  }
}

// Function to convert time in seconds to a string with the time in minutes and seconds (MM:SS)
String convertSeconds(int t){
  String minutes = str(floor(t/60));
  String seconds = "";
  if(t%60 < 10) seconds += "0";
  seconds += str(t%60);
  return minutes + ":" + seconds;
}

// Function to get the seconds elapsed since the initialization of the program
int secondsElapsed(){
  return floor(millis()/1000);
}

// Function to turn the current side being changed into a string
String stringChange(){
  if(changingLeft) return "Changing left time"; 
  return "Changing right time";
}
