//
//  app_controller.h
//  
//
//  
//
//

#ifndef app_controller_h
#define app_controller_h

#include <mono.h>

using namespace mono;
using namespace mono::ui;

class AppController : public mono::IApplication {
    
    // This is the text label object that will displayed
    TextLabelView helloLabel;
    
public:
    
    AppController();
    
    void monoWakeFromReset();

    void monoWillGotoSleep();

    void monoWakeFromSleep();
    
};

#endif /* app_controller_h */
