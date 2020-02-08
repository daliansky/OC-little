//Fix HPET,RTC,TIMR
DefinitionBlock ("", "SSDT", 2, "ACDT", "HRTfix", 0)
{
    External (_SB.PCI0.LPCB, DeviceObj)
    External (_SB.PCI0.LPCB.RTC, DeviceObj)
    External (_SB.PCI0.LPCB.TIMR, DeviceObj)
    External (HPAE, IntObj)
    //External (HPTE, IntObj)
    
    //disable HPET
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            HPAE =0
            //HPTE =0
        }
    }
    
    //disable RTC
    Scope (_SB.PCI0.LPCB.RTC)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (0)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    
    //disable TIMR
    Scope (_SB.PCI0.LPCB.TIMR)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (0)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    
    Scope (_SB.PCI0.LPCB)
    {
        //Fake HPE0
        Device (HPE0)
        {
            Name (_HID, EisaId ("PNP0103"))
            Name (_UID, Zero)
            Name (BUF0, ResourceTemplate ()
            {
                IRQNoFlags() { 0, 8 }
                Memory32Fixed (ReadWrite,
                    0xFED00000,
                    0x00000400,
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
                    Return (0)
                }
            }
            Method (_CRS, 0, Serialized)
            {
                Return (BUF0)
            }
        }

        //Fake RTC0
        Device (RTC0)
        {
            Name (_HID, EisaId ("PNP0B00"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0070, 
                    0x0070, 
                    0x01, 
                    0x02,
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
                    Return (0)
                }
            }
        }
        
        //Fake TIM0
        Device (TIM0)
        {
            Name (_HID, EisaId ("PNP0100"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0040,
                    0x0040,
                    0x01,
                    0x04,
                    )
                IO (Decode16,
                    0x0050,
                    0x0050,
                    0x10,
                    0x04,
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
                    Return (0)
                }
            }
        }
    }
}

