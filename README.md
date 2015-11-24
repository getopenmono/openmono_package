# Mono Application Project Template

The standard project template for mono applications. This template includes the complete mono framework as static libraries. It also include 3 template application files:

 * `main.cpp`: The application entry point. Used to setup the runtime environment. *You do not need to edit this file.*
 
 * `app_controller.h`: You app's main controller class. All mono apps must have one `AppController`object.
 
 * `app_controller.cpp`: A default implementation of the `AppController` class. It is here you write your code :-)

## Getting started

### 1. Download the template
You can find relase versions under the *[Releases](releases)* tab above.

### 2. Get ARM GCC
To compile mono applications, you need a compiler that supports the ARM Cortex-M3 MCU. We think the best one is ARM GCC. It's free, and you can download it pre-compiled. (Compiling compilers are kinda hairy.)

Specifically you should use the **ARM GCC NONE EABI** version.[^1] You can download it from [launchpad here](https://launchpad.net/gcc-arm-embedded)

### 3. Setup the `Makefile`
Now you must define the path to your installation of ARM GCC NONE EABI. Say you installed the compiler here: (If on Linux or Mac)

```
/usr/local/gcc-arm-none-eabi-4_9-2015q3
```

Or if Windows:

```
C:/gcc-arm-none-eabi-4_9-2015q3
```

Now you must reference the GCC installation in the projects `Makefile`. Open the Makefile and navigate to line 2, you should see something like this:

```
1  TARGET = mono_project
2  ARCH="/usr/local/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-"
```

Change the `ARCH` property to point to your GCC installation path. *Remember to add the `/bin/arm-none-eabi-`, after the path to the GCC main directory.*

To test that everything works, open a command window (terminal) and `cd` to the project folder. Type `make` to build the project - it will compile and link.

If you encounter errors, check that you entered the correct path again.[^2]

### 4. Code

You are ready to begin coding! Fire up your favorite text editor and open the 3 files. Here is a quick intro to what their purpose on this earth are:

#### The `main` function

This is the entry point of the application. There are already 4 lines of code here. Lets examine them one by one:

```
int main()
{
    AppController app; // 1.
    
    mono::IApplicationContext::Instance->setMonoApplication(&app); // 2.
    
    app.enterRunLoop(); // 3.
	
	return 0; // 4.
}
```

1. First the required AppController is instanciated. This is the class defined in `app_controller.h`.

2. All mono applications have a global static object called the `ApplicationContext`, that orchestrates the runtime environment. It handles things like power modes, I/O and the run loop. In this line we assign the `AppController` object to the `ApplicationContext`.

3. We begin executing the applications global run loop. To enabled timers, touch events, display painting and asynchronous function execution, the application implements a run loop.

4. Lastly C++ requires us to return an integer from the `main` function. But this code will never be reached, since the application's run loop will never return.

#### The `AppController` class

If you take a look in `app_controller.h`, you find three methods:

* `monoWakeFromReset()`
* `monoWillGotoSleep()`
* `monoWakeFromSleep()`

These methods are event callbacks and required by the AppController.

##### `monoWakeFromReset()`

This is the entry function of you code. It is called automatically when mono powers up, after a reset or power outage. You can think of it like Arduino's `setup()` function.

##### `monoWillGotoSleep()`

This method is called automatically when mono will enter sleep mode, to save power. If  you want to do any house-keeping before mono goes to sleep, do it in this method.

##### `monoWakeFromSleep()`

When mono wakes up from sleep this method is automatically called. Use this method to initialize saved data or restore states. Also, you should schedule repaint of your UI views.

## Further reading

If you would like a more in-depth introduction on how to code mono, I will recommend one of our getting started guides.

These will be available soon on [openmono.com](http://openmono.com/)

[^1]: The NONE EABI means that it builds *bare metal* executables. This means executables that run with no OS, (like Embedded Linux). Since Mono dont have an OS, we use the *bare metal* GCC compiler.

[^2]: I assume that you have build tools installed, like `make`.