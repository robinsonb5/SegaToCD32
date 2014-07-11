#include <project.h>
#include <stdio.h>

static int Sega_Direction;
static int Sega_SixButton;
static int Sega_BC;
static int Sega_AStart;
static int Sega_XYZMode;
static int CD32_Buttons;

char buf[64];


CY_ISR(timerISR)
{
    static int framectr=255;
    static int sixbutton;
    FrameTimer_ReadStatusRegister();

    switch(framectr)
    {
        case 8:
            // Read regular button statuses here, immediately prior to first low pulse
            Sega_Direction=Sega_Inputs_Read();
            Sega_BC=(Sega_Direction<<2)&0xc0;  // C -> Blue, B -> Red
            Sega_Direction&=0xf;
            sixbutton=1; // Assume we're dealing with a six-button controller unless proved otherwise
            break;
        case 7:
            // Read regular button statuses here, on trailing edge of first low pulse
            Sega_AStart=Sega_Inputs_Read();
            Sega_AStart=((Sega_AStart&0x20)>>4) | (Sega_AStart&0x10); // Start -> Play, A -> Green 
            break;

            // Nothing exciting happens during the second low pulse
            // (fall through)
        case 6:
        case 5:
            // Third low pulse
        case 4:
            break;

        case 3:
            // If we have a six-button pad, then the direction lines will be low here
            if(Sega_Inputs_Read() & 0xf)
                sixbutton=0;    // Not a six-button pad
            break;
        case 2:
            // After the trailing edge of the third low pulse, XYZ and mode are readable.
            Sega_XYZMode=Sega_Inputs_Read();
            if(!(Sega_XYZMode&0x8))
                Sega_Direction&=0xfe; // Mode -> Up
            Sega_XYZMode=((Sega_XYZMode&0x2)<<4) |    // Y -> Yellow
            ((Sega_XYZMode&0x1)<<3) | (Sega_XYZMode&0x4);  // X -> Rew, Z -> FF
            break;

        case 1:
            // Finally, after the last low pulse, the four direction lines should all read high.
            if((~Sega_Inputs_Read()) & 0xf)
                sixbutton=0;    // Not a six-button pad            
            Sega_SixButton=sixbutton;
            
            // Now send the button status to the CD32 Shifter.
            CD32_Directions_Write(Sega_Direction);
            CD32_Buttons=Sega_BC | Sega_AStart | 1;
            if(sixbutton)
                CD32_Buttons|=Sega_XYZMode;
            else
                CD32_Buttons|=0xf;
            CD32Shifter_1_Data_Reg=CD32_Buttons;
                // Pass Red button status through to pin 6.
            CD32Shifter_1_Fire_Reg=(Sega_BC&0x40) ? 0x00 : 0xff;
            break;

        default:
            break;
    }

    // Send four low pulses
    if(framectr<9)
        Sega_Select_Write(framectr&1);

    --framectr;
    if(framectr==0)
        framectr=63;
}


int main()
{
    Isr_Timer_StartEx(timerISR);
    FrameTimer_Start();
    CyGlobalIntEnable;
    CySysPmSleep();
    return(0);
}

/* [] END OF FILE */
