import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;
import processing.video.*;
import java.awt.*;

OpenCV opencv;

void setup() {
  size(640, 800);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}

void draw(){
  background(0);
  image(opencv.getOutput(), 0, 0 );
  
  OpenCV imageLeft = new OpenCV(this, loadImage("left.jpg"));  
  OpenCV imageRight = new OpenCV(this, loadImage("right.jpg"));
  imageLeft.gray();
  imageRight.gray();
  
  Mat grayLeft = imageLeft.getGray();
  Mat grayRight = imageRight.getGray();
  
  Mat disparity = OpenCV.imitate(grayLeft);
  StereoBM stereo = new StereoBM();
  stereo.compute(grayLeft, grayRight, disparity);
  
  Mat depthMat = OpenCV.imitate(grayLeft);
  disparity.convertTo(depthMat, depthMat.type());
  
  PImage depth = createImage(depthMat.width(), depthMat.height(), RGB);  
  imageLeft.toPImage(depthMat, depth);  
  image(depth, 0, 0, 640, 480);
  
  image(imageLeft.getSnapshot(), 0, 480, 320, 150);
  image(imageRight.getSnapshot(), 320, 480, 320, 150);
}

void captureEvent(Capture c) {
  c.read();
}