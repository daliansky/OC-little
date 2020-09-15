```swift
//Fix IPIC
DefinitionBlock ("", "SSDT", 2, "OCLT", "IPIC", 0)
{
    External (_SB.PCI0.LPCB, DeviceObj)
    External (_SB.PCI0.LPCB.PIC, DeviceObj)
    //External (_SB.PCI0.LPCB.IPIC, DeviceObj)
    
    //disable IPIC
    Scope (_SB.PCI0.LPCB.PIC)    // Scope (_SB.PCI0.LPCB.IPIC)
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
        //Fake IPIC
        Device (IPI0)
        {
            Name (_HID, EisaId ("PNP0000"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0020,
                    0x0020,
                    0x01,
                    0x02,
                    )
                IO (Decode16,
                    0x00A0,
                    0x00A0,
                    0x01,
                    0x02,
                    )
                IO (Decode16,
                    0x04D0,
                    0x04D0,
                    0x01,
                    0x02,
                    )
                // Remove IRQNoFlags
                /*
                 * IRQNoFlags ()
                 * {2}
                 */
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
```

