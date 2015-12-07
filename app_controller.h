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

class AppController : public mono::IApplication {
    
    mono::ui::TextLabelView helloLabel;
    
public:
    
    AppController();
    
    void monoWakeFromReset();

    void monoWillGotoSleep();

    void monoWakeFromSleep();
    
    
};

#endif /* app_controller_h */
