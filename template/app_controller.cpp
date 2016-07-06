
#include "app_controller.h"

using namespace mono::geo;

// Contructor
// Initializes the label object with position and text content
// You should init only data here, since I/O is not setup yet.
AppController::AppController() :

    // Call the TextLabel's constructor, with a Rect and a static text
    helloLabel(Rect(0,100,176,20), "Hi, I'm Mono!")
{

    // the label is the full width of screen, set it to be center aligned
    helloLabel.setAlignment(TextLabelView::ALIGN_CENTER);
    
    // set another text color
    helloLabel.setTextColor(display::TurquoiseColor);
}

void AppController::monoWakeFromReset()
{
    // At this point after reset we can safely expect all peripherals and
    // I/O to be setup & ready.

    // tell the label to show itself on the screen
    helloLabel.show();
}

void AppController::monoWillGotoSleep()
{
    // Do any clean up here, before system goes to sleep and power
    // off peripherals.

}

void AppController::monoWakeFromSleep()
{
    // The Cypress USB port does not work after wake up from deep sleep!
    // To make the USB port work again, we must reset.
    // Remove the line below, to just wake up without the USB port working.
    // See more here: http://developer.openmono.com/en/latest/tutorials/sleep-mode.html#sleep-and-usb
    mono::IApplicationContext::SoftwareResetToApplication();


    // After sleep, the screen memory has been cleared - tell the label to
    // draw itself again
    helloLabel.scheduleRepaint();
}