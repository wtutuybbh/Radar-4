import processing.serial.*;               // imports library for serial communication

Serial myPort;                         // defines Object for Serial

String ang="";
String distance="";
String data="";

int angle, dist;

void setup() {
  
   size (1200, 700); // screen size in pixels
   
   myPort = new Serial(this,"COM5", 9600);        // starts the serial communication with usb port COM5
   myPort.bufferUntil('.');    // reads the data from the serial port up to the character '.' before calling serialEvent

  background(0);
}

void draw() {
  
                              //for the blur effect
      fill(0,6);              //colour,opacity
      noStroke();
      rect(0, 0, width, height*0.93); 
      
      noStroke();
      fill(0,255);
      rect(0,height*0.93,width,height);                   // so that the text having angle and distance doesnt blur out
      
      
      drawRadar(); // draws the radar interface
      drawLine(); // draws the moving line 
      drawObject(); // draws the moveing line read when located an object
      drawText(); // writes the text on the radar interface
}


void serialEvent (Serial myPort) {                                                     // starts reading data from the Serial Port
                                                                                      // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
      data = myPort.readStringUntil('.');
      data = data.substring(0,data.length()-1);
      
      int index1 = data.indexOf(",");                                                    
      ang= data.substring(0, index1);                                                 
      distance= data.substring(index1+1, data.length());                            
      
      angle = 180-int(ang);
      dist = int(distance);
      System.out.println(angle);
}

void drawRadar() 
{
    pushMatrix();
    noFill();
    stroke(0,255,0);        //green
    strokeWeight(3);
    
    translate(width/2,height-height*0.06);
    
    line(-width/2,0,width/2,0);
    
    arc(0,0,(width*0.5),(width*0.5),PI,TWO_PI);
    arc(0,0,(width*0.25),(width*0.25),PI,TWO_PI);
    arc(0,0,(width*0.75),(width*0.75),PI,TWO_PI);
    arc(0,0,(width*0.95),(width*0.95),PI,TWO_PI);
    
    line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
    line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
    line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
    line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
    line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));


    popMatrix();
}

void drawLine() {
  
    pushMatrix();
    
    strokeWeight(9);
    stroke(0,255,0);
    translate(width/2,height-height*0.06); 
    
   line(0,0,(width/2)*cos(radians(angle)),(-width/2)*sin(radians(angle)));
   

    popMatrix();
    
}


void drawObject() {
  
    pushMatrix();
    
    strokeWeight(9);
    stroke(255,0,0);
    translate(width/2,height-height*0.06);
   
    float pixleDist = (dist/200.0)*(width/2.0);                        // covers the distance from the sensor from cm to pixels
    float pd=(width/2)-pixleDist;
    
             
    float x=-pixleDist*cos(radians(angle));
    float y=-pixleDist*sin(radians(angle));
    
    if(dist<=200)                                                  // limiting the range to 200 cm
    {                               
       //line(0,0,pixleDist,0);  
       line(-x,y,-x+(pd*cos(radians(angle))),y-(pd*sin(radians(angle))));
    }
    popMatrix();
}

void drawText()
{
    pushMatrix();
    
    fill(0,255,0);
    textSize(25);
    
    text("50cm",(width/2)+(width*0.115),height*0.980);
    text("100cm",(width/2)+(width*0.23),height*0.980);
    text("150cm",(width/2)+(width*0.355),height*0.980);
    text("200cm",(width/2)+(width*0.44),height*0.980);
    
    textSize(40);
    text("Angle :"+angle,width*0.30,height*0.99);
    
    if(dist<=200) {
      text("Distance :"+dist,width*0.05,height*0.99);
    }
      
   translate(width/2,height-height*0.06);
   textSize(25);
   
   text(" 30°",(width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
   text(" 60°",(width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
   text("90°",(width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
   text("120°",(width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
   text("150°  ",(width/2)*cos(radians(160)),(-width/2)*sin(radians(150)));
    
    popMatrix();  
  
}
