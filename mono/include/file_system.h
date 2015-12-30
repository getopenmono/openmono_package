//
//  file_system.h
//
//
//  Created by Kristoffer Andersen on 08/12/2015.
//  Copyright © 2015 your name. All rights reserved.
//

#ifndef file_system_h
#define file_system_h

#include <PinNames.h>
#include <SDFileSystem.h>

namespace mono { namespace io {
    
    class IFileSystem
    {
        
    };
    
    //static const SDFileSystem sdfs(SD_SPI_MOSI, SD_SPI_MISO, SD_SPI_CLK, SD_SPI_CS, "");
} }

#endif /* file_system_h */
