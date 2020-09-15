```swift
//Debug
DefinitionBlock("", "SSDT", 2, "OCLT", "BrightFN", 0)
{
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XQXX, MethodObj)
    //
    External(RMDT.P2, MethodObj)
    External(_SB.PCI9.TPTS, IntObj)
    External(_SB.PCI9.TWAK, IntObj)
    //
    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (_QXX, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                //Debug...
                \RMDT.P2 ("ABCD-_PTS-Arg0=", \_SB.PCI9.TPTS)
                \RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)
                //Debug...end
                
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQXX()
            }
        }
    }
}
//EOF
```
