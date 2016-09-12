#ifndef app_controller_h
#define app_controller_h

#include <mono.h>

class AppController : public mono::IApplication {
public:

    AppController();

    void monoWakeFromReset();
    void monoWillGotoSleep();
    void monoWakeFromSleep();

};

#endif /* app_controller_h */
