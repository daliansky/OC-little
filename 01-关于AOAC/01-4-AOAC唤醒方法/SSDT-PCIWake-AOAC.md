```swift
// PCIWake
// NVMe path:_SB.PCI0.RP09.PXSX
//
DefinitionBlock("", "SSDT", 2, "ACDT", "PCIWake", 0)
{
    External(_SB.PCI0.RP09.PXSX, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC._Q0D, MethodObj)
    External(_SB.PCI0.LPCB.H_EC.LID0._LID, MethodObj)
    
    Scope (_SB.PCI0.RP09.PXSX)
    {
        If (_OSI ("Darwin"))
        {
            Method (_PS0, 0, Serialized)
            {
                If(\_SB.PCI0.LPCB.H_EC.LID0._LID()==Zero)
                {
                    \_SB.PCI0.LPCB.H_EC._Q0D()
                }
            }
            
            Method (_PS3, 0, Serialized)
            {

            }
        }
    }
}
```

