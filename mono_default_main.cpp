// This software is part of OpenMono, see http://developer.openmono.com
// and is available under the MIT license, see LICENSE.txt

#include <mono.h>
#include "app_controller.h"

/* This is the default main function fir mono applications */
/* It must create an AppController object and start the run loop */
__attribute__((weak)) int main()
{
    AppController app;

    mono::IApplicationContext::Instance->setMonoApplication(&app);

    app.enterRunLoop();

    return 0;
}
