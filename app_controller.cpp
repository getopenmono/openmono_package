//
//  app_controller.cpp
//
//
//
//  
//

#include "app_controller.h"

// Contructor
// initializes the label object with position and text content
// You should init data here, since I/O is not setup yet.
AppController::AppController() :
    helloLabel(mono::geo::Rect(0,100,176,20),"Hi, I'm Mono!")
{
    // the label is width of screen, set it to be center aligned
    helloLabel.setAlignment(mono::ui::TextLabelView::ALIGN_CENTER);
    
    // set another text color
    helloLabel.setTextColor(mono::display::TurquoiseColor);
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