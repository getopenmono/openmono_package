//
//  app_controller.cpp
//
//
//
//  
//

#include "app_controller.h"

using namespace mono::geo;

// Contructor
// initializes the label object with position and text content
// You should init data here, since I/O is not setup yet.
AppController::AppController() :
    helloLabel(Rect(0,100,176,20), "Hi, I'm Mono!")
{
    // the label is width of screen, set it to be center aligned
    helloLabel.setAlignment(TextLabelView::ALIGN_CENTER);
    
    // set another text color
    helloLabel.setTextColor(display::TurquoiseColor);
}

void AppController::monoWakeFromReset()
{
    mono::defaultSerial.printf(""); // force enumeration
    
    //tell the label to show itself
    helloLabel.show();
}

void AppController::monoWillGotoSleep()
{
    
}

void AppController::monoWakeFromSleep()
{
    //after sleep, the screen memory has been cleared - tell the label to
    // draw itself again
    helloLabel.scheduleRepaint();
}