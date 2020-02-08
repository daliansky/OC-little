//
DefinitionBlock ("", "SSDT", 2, "ACDT", "RTCfix", 0)
{
    External(_SB.PCI0.LPCB, DeviceObj)

    /*
    //Example 1;;disable RTC
    External(_SB.PCI0.LPCB.RTC, DeviceObj)
    Scope (_SB.PCI0.LPCB.RTC)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    */

    
    //Example 2;;disable RTC
    External (STAS, FieldUnitObj)
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 2
        }
    }
    
    //Fake RTC0
    Scope (_SB.PCI0.LPCB)
    {
        Device (RTC0)
        {
            Name (_HID, EisaId ("PNP0B00")) 
            Name (_CRS, ResourceTemplate () 
            {
                IO (Decode16,
                    0x0070, 
                    0x0070,
                    0x01,
                    0x02,//0x08,
                    )
            })
            
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}
//EOF