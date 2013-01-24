/******************************************************************************\
 * Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
 * Leap Motion proprietary and confidential. Not for distribution.              *
 * Use subject to the terms of the Leap Motion SDK Agreement available at       *
 * https://developer.leapmotion.com/sdk_agreement, or another agreement         *
 * between Leap Motion and you, your company or other organization.             *
 \******************************************************************************/

import java.io.IOException;
import java.lang.Math;
import com.leapmotion.leap.*;

Boolean DEBUG = true;

void setup() {
  size(200, 200);
  frameRate(300);
}

void draw() {
  
  SampleListener listener = new SampleListener();
  Controller controller = new Controller();
  controller.addListener(listener);

  try {
    System.in.read();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Remove the sample listener when done
  controller.removeListener(listener);
}

class SampleListener extends Listener {
  public void onInit(Controller controller) {
    println("Initialized");
  }

  public void onConnect(Controller controller) {
    println("Connected");
  }

  public void onDisconnect(Controller controller) {
    println("Disconnected");
  }

  public void onExit(Controller controller) {
    println("Exited");
  }

  public void onFrame(com.leapmotion.leap.Controller controller) {
    // Get the most recent frame and report some basic information
    com.leapmotion.leap.Frame frame = controller.frame();
    if (DEBUG) { 
      println("Frame id: " + frame.id()
      + ", timestamp: " + frame.timestamp()
      + ", hands: " + frame.hands().count()
      + ", fingers: " + frame.fingers().count()
      + ", tools: " + frame.tools().count());
    }

    if (!frame.hands().empty()) {
      // Get the first hand
      Hand hand = frame.hands().get(0);

      // Check if the hand has any fingers
      FingerList fingers = hand.fingers();
      if (!fingers.empty()) {
        // Calculate the hand's average finger tip position
        com.leapmotion.leap.Vector avgPos = com.leapmotion.leap.Vector.zero();
        for (Finger finger : fingers) {
          avgPos = avgPos.plus(finger.tipPosition());
        }
        avgPos = avgPos.divide(fingers.count());
        if (DEBUG) {
          println("Hand has " + fingers.count()
          + " fingers, average finger tip position: " + avgPos);
        }
      }

      // Get the hand's sphere radius and palm position
      if (DEBUG) {
        println("Hand sphere radius: " + hand.sphereRadius()
        + " mm, palm position: " + hand.palmPosition());
      }

      // Get the hand's normal vector and direction
      com.leapmotion.leap.Vector normal = hand.palmNormal();
      com.leapmotion.leap.Vector direction = hand.direction();

      // Calculate the hand's pitch, roll, and yaw angles
      
      if (DEBUG) {
        println("Hand pitch: " + Math.toDegrees(direction.pitch()) + " degrees, "
        + "roll: " + Math.toDegrees(normal.roll()) + " degrees, "
        + "yaw: " + Math.toDegrees(direction.yaw()) + " degrees\n");
      }
    }
  }
}
