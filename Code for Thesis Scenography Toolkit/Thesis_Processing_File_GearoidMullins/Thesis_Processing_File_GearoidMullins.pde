/*Reference:
//Bouchard, D. (2013) Keystone [online], 
//available: http://keystonep5.sourceforge.net/ [accessed 14th June 2017].

// Fernstrom, M (2014) 'Drawaplay', CS4358: Interactive Multimedia [online], 
// available: http://www3.ul.ie/courses/MusicMediaAndPerformanceTechnology.php [accessed 9th Aug 2017].
*/

//Arduino library and arduino variables
import processing.serial.*;
Serial ardPort;
String ardBtn;
float ardBtnF;
int lf = 10;
boolean onoff1=true;
boolean onoff2=false;


//Real time audio processing
import processing.sound.*;
AudioIn input;
Amplitude analyzer;

//Video library CAMS and Videos
import processing.video.*;


//Keystone library Video Mapping
import deadpixel.keystone.*;
// the keystone object
Keystone ks; 

//Number of surfaces 5 + 1
int nofS=6;

//Defining Number of surfaces
CornerPinSurface surface1; 
CornerPinSurface surface2;
CornerPinSurface surface3; 
CornerPinSurface surface4;
CornerPinSurface surface5; 

// Instances for screens 
PGraphics offscreen1;  
PGraphics offscreen2; 
PGraphics offscreen3;
PGraphics offscreen4;
PGraphics offscreen5;

//Instances for images
PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage img5;

//To know which surface is using an image (jpg, png...)
boolean imgS1= false;
boolean imgS2= false;
boolean imgS3= false;
boolean imgS4= false;
boolean imgS5= false;

//Instances for videos
Movie mov1;
Movie mov2;
Movie mov3;
Movie mov4;
Movie mov5;

//To know which surface is using an image (jpg, png...)
boolean movS1= false;
boolean movS2= false;
boolean movS3= false;
boolean movS4= false;
boolean movS5= false;

//Variable call CAM. Identify the variable CAM with WEBCAM
Capture cam;
//To know which surface is using the webcam
boolean camS1= false;
boolean camS2= false;
boolean camS3= false;
boolean camS4= false;
boolean camS5= false;

//Boolean to know the states (Playing, Camera ON OFF)
boolean isPlaying = false;
boolean camon=true;

boolean fx=false;

//Size of the surfaces.
int widthS=640;
int heightS=360;


void setup() {
  
  //ARDUINO SETTING
  //Number of ports. 
  printArray(Serial.list()); 
  //Port 2 USB usually
  ardPort = new Serial(this, Serial.list()[2], 9600); 
  ardPort.bufferUntil(lf); 
  
  //Set full screen  
   fullScreen(P3D);
  
  //Keystone objetc
  ks = new Keystone(this); // init the keystoen object
   
  //SURFACES. Size= ScreenSize/4
  surface1 = ks.createCornerPinSurface(widthS, heightS, 20);
  surface2 = ks.createCornerPinSurface(widthS, heightS, 20);
  surface3 = ks.createCornerPinSurface(widthS, heightS, 20);
  surface4 = ks.createCornerPinSurface(widthS, heightS, 20);
  surface5 = ks.createCornerPinSurface(widthS, heightS, 20);
  
 
  //Drawing all screen buffers
  offscreen1 = createGraphics(widthS, heightS, P3D);
  offscreen2 = createGraphics(widthS, heightS, P3D);
  offscreen3 = createGraphics(widthS, heightS, P3D);
  offscreen4 = createGraphics(widthS, heightS, P3D);
  offscreen5 = createGraphics(widthS, heightS, P3D);
 
  
  //List of the cameras that are connected to the laptop 
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    exit();
  } else {
    for (int i = 0; i < cameras.length; i++) {
    }
    cam = new Capture(this, cameras[cameras.length-2]);  // For the Apeman gopro camera
    // Start the camera
    cam.start();  
  }   
  
  //Start the MIC
  input = new AudioIn(this, 0);
  input.start();
  analyzer = new Amplitude(this);  
  analyzer.input(input);
  }
// Listen to the serial port for the Arduino
void serialEvent(Serial ardPort) { 
  ardBtn = ardPort.readStringUntil(lf); 
  ardBtnF = float(ardBtn);
  if ((onoff1==false)&&(ardBtnF == 101)){
    ardPort.write('1');
   onoff1=true;
   cam.start();  //start camera
     camon=true;
  }else{
    onoff1=false;
    ardPort.write('0');
    cam.stop(); //stop camera
     camon=false; 
  }
  
  if ((onoff2==false)&&(ardBtnF == 102)){
    onoff2=true;
    ardPort.write('3');
    fx=true;
  }
  else{
    onoff2=false;
    ardPort.write('2');
     fx=false;
  }
} 



void draw() {
   if (cam.available() == true) {
     //Reading values from webcam 
     cam.read();
  }
  
  //Audio parameters
  float vol = analyzer.analyze();

   

  //SURFACE1
  offscreen1.beginDraw(); // start writing into the buffer
  offscreen1.background(0,0,255);  // Set the color of each background
   if(imgS1){  // if imgS1,
     offscreen1.image(img1, 0, 0,widthS, heightS);  // Set image 1 to these parameters
     //println("IMG SURFACE1");
   }
   if(movS1){  // If MovS1
     offscreen1.image(mov1, 0, 0,widthS, heightS);  // Set the mov1 to these parameters
     //println("VIDEO SURFACE1");
   }
   if(camS1){  // If camS1
     offscreen1.image(cam, 0, 0,widthS, heightS);  // Set the live camera to these parameters
     //println("WEBCAM SURFACE1");
   }
     offscreen1.endDraw();  // Stop Drawing
  
    
  //SURFACE2
   offscreen2.beginDraw(); // start writing into the buffer
  offscreen2.background(0,255,0);
   if(imgS2){ // if imgS2,
     offscreen2.image(img2, 0, 0,widthS, heightS); // Set the img2 to these parameters
     //println("IMG SURFACE2");
   }
   if(movS2){ // if movS2,
     offscreen2.image(mov2, 0, 0,widthS, heightS); // Set the mov2 to these parameters
     //println("VIDEO SURFACE2");
   }
   if(camS2){ //if camS2
     offscreen2.image(cam, 0, 0,widthS, heightS); // Set the cam to these parameters
     //println("WEBCAM SURFACE2");
   }
     offscreen2.endDraw();
     
   //SURFACE3  
  offscreen3.beginDraw(); // start writing into the buffer
  offscreen3.background(255,0,0);
  if(imgS3){
     offscreen3.image(img3, 0, 0,widthS,heightS); // Set the img3 to these parameters
      //println("IMG SURFACE3");
   }
   if(movS3){
     offscreen3.image(mov3, 0, 0,widthS, heightS); // Set the mov3 to these parameters
      //println("VIDEO SURFACE3");
   }
   if(camS3){
     offscreen3.image(cam, 0, 0,widthS, heightS); // Set the cam to these parameters
     //println("WEBCAM SURFACE3");
   }
  offscreen3.endDraw(); // we are done 'recording'
    

 //SURFACE4  
  offscreen4.beginDraw(); // start writing into the buffer
  offscreen4.background(255,255,0);
  if(imgS4){
     offscreen4.image(img4, 0, 0,widthS,heightS); // Set the img4 to these parameters
      //println("IMG SURFACE4");
   }
   if(movS4){
     offscreen4.image(mov4, 0, 0,widthS, heightS); // Set the mov4 to these parameters
      //println("VIDEO SURFACE4");
   }
   if(camS4){
     if(fx==true)
     {
       tint(255);
       offscreen4.background(0,0,0);  // Set the background black
       offscreen4.image(cam, 0, 0,int(vol*5*widthS), int(vol*5*heightS)); // set the volume to contol the height and width
     ////println(int(vol*100)); 
     }
     else{ //otherwise
       tint(255);   
       offscreen4.image(cam, 0, 0,widthS, heightS); //set the image to these parameters
     }
     //println("WEBCAM SURFACE5");
   }
  offscreen4.endDraw(); // we are done 'recording'
    
    
     //SURFACE5  
  offscreen5.beginDraw(); // start writing into the buffer
  offscreen5.background(0,255,255);
  if(imgS5){
    if(fx==true){
     tint(int(vol*255),int(vol*255),int(vol*255));
     offscreen5.image(img5, 0, 0,widthS, heightS);
    }
    else
    {
     tint(255);
     offscreen5.image(img5, 0, 0,widthS,heightS);
    }
      //println("IMG SURFACE5");
   }
   if(movS5){
     if(fx==true)
     {
       tint(255);
       mov5.jump(int(vol*100)*mov5.duration()/100);
       offscreen5.image(mov5, 0, 0,widthS, heightS);
       
     }
     else{
       tint(255);
       offscreen5.image(mov5, 0, 0,widthS, heightS);
     }
      //println("VIDEO SURFACE5");
   }
   if(camS5){
     if(fx==true)
     {
       tint(255);
       offscreen5.background(0,0,0);
       offscreen5.image(cam, 0, 0,int(vol*5*widthS), int(vol*5*heightS));
     ////println(int(vol*100)); 
     }
     else{
       tint(255);   
       offscreen5.image(cam, 0, 0,widthS, heightS);
     }
   }

  offscreen5.endDraw(); // we are done 'recording'
    
  //Set Background to black
  background(0);

  //RENDER SURFACES
  if(nofS==5){
    surface5.render(offscreen5);
  }
  
  if(nofS==4){
    surface5.render(offscreen5);
    surface4.render(offscreen4);
   
  }
  if(nofS==3){  
    surface5.render(offscreen5);
    surface4.render(offscreen4);
    surface3.render(offscreen3);
  }
  if(nofS==2){  
    surface5.render(offscreen5);
    surface4.render(offscreen4);
    surface3.render(offscreen3);
    surface2.render(offscreen2);
  }
  if(nofS==1){  
    surface5.render(offscreen5);
    surface4.render(offscreen4);
    surface3.render(offscreen3);
    surface2.render(offscreen2);
    surface1.render(offscreen1);
  }
  
  
    //PRINT TEXT
    if(!isPlaying){
    textSize(16);
    int xdisplay=20;
    int ydisplay=150;
     String s1 = "SURFACES. Press ↓\n(n) create new surface\n(r) remove last surface\n(c) calibrate (edit mode) \n(s) save layout \n(l) load layout";
     fill(255);
     text(s1, xdisplay, displayHeight-ydisplay);
    if (nofS!=6){
     String s2 = "LOAD MEDIA. Press ↓ \n(i) load image\n(m) load video\n(k) load webcam - [button 1 red]\n(x) audio effect - [button 2 green] \n(p) play/pause all"; 
     text(s2, xdisplay+230, displayHeight-ydisplay);
     }
    String s3 = "MAPPING. Gearoid Mullins";
    text(s3, displayWidth-240, displayHeight-30);
    }
 
   
}



void keyPressed() {
  switch(key) {
  case 'n':
  if(nofS>1){
  nofS--;
  }
  break; 
 case 'r':
  if(nofS<=5){
  nofS++;
  }
  break;    
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;
  
  case 'l':
    // loads the saved layout
    ks.load();
    break;
  
  case 's':
    // saves the layout
    ks.save();
    break;  
  
   case 'o':
   //ON OFF CAMERA
     if (camon){  
     cam.stop();
     camon=false;  
   }
   else{
     cam.start();
     camon=true; 
   }   
   break;   
  
  case 'i':
   selectInput("Select a file to process:", "imageSelected"); 
   break;
  
  case 'm':
   selectInput("Select a file to process:", "videoSelected");
    break;    

  case 'x':
  if (fx)
  {
  fx=false;
  }
  else{
   fx=true; 
  }
  break;
  
  case 'p':
    // play/pause the movie on keypress
    if (isPlaying == false) {
      if (movS1){mov1.loop();}
      if (movS2){mov2.loop();}
      if (movS3){mov3.loop();}
      if (movS4){mov4.loop();}
      if (movS5){mov5.loop();}
      cam.start(); 
      isPlaying = true;
    } else {
      if (movS1){mov1.pause();}
      if (movS2){mov2.pause();}
      if (movS3){mov3.pause();}
      if (movS4){mov4.pause();}
      if (movS5){mov5.pause();}
      isPlaying = false;
      cam.stop();
    }
    break;
   
    case 'k':
    if(nofS==1){camS1=true; movS1=false; imgS1=false; }
    if(nofS==2){camS2=true; movS2=false; imgS2=false; }
    if(nofS==3){camS3=true; movS3=false; imgS3=false; }
    if(nofS==4){camS4=true; movS4=false; imgS4=false; }
    if(nofS==5){camS5=true; movS5=false; imgS5=false; }
    break;  
    
  }
}

void imageSelected(File selection) {
  if (selection == null) {
    //println("Window was closed or the user hit cancel.");
  } else {
    //println("User selected " + selection.getAbsolutePath());
   if (nofS==1){img1 = loadImage(selection.getAbsolutePath()); imgS1=true; movS1=false; camS1=false;} 
   if (nofS==2){img2 = loadImage(selection.getAbsolutePath()); imgS2=true; movS2=false; camS2=false;} 
   if (nofS==3){img3 = loadImage(selection.getAbsolutePath()); imgS3=true; movS3=false; camS3=false;}
   if (nofS==4){img4 = loadImage(selection.getAbsolutePath()); imgS4=true; movS4=false; camS4=false;}
   if (nofS==5){img5 = loadImage(selection.getAbsolutePath()); imgS5=true; movS5=false; camS5=false;}
 }
}

void videoSelected(File selection) {
  if (selection == null) {
    //println("Window was closed or the user hit cancel.");
  } else {
    //println("User selected " + selection.getAbsolutePath());
    if (nofS==1){mov1 = new Movie(this, selection.getAbsolutePath()); mov1.loop(); mov1.volume(0); movS1=true; imgS1=false; camS1=false;} 
    if (nofS==2){mov2 = new Movie(this, selection.getAbsolutePath()); mov2.loop(); mov2.volume(0); movS2=true; imgS2=false; camS2=false;}
    if (nofS==3){mov3 = new Movie(this, selection.getAbsolutePath()); mov3.loop(); mov3.volume(0); movS3=true; imgS3=false; camS3=false;}
    if (nofS==4){mov4 = new Movie(this, selection.getAbsolutePath()); mov4.loop(); mov4.volume(0); movS4=true; imgS4=false; camS4=false;}
    if (nofS==5){mov5 = new Movie(this, selection.getAbsolutePath()); mov5.loop(); mov5.volume(0); movS5=true; imgS5=false; camS5=false;}

 }
}

void movieEvent(Movie m) {
  m.read();
}