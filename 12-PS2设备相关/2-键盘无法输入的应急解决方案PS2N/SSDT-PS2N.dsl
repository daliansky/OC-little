//Add new PS2N
DefinitionBlock("", "SSDT", 2, "ACDT", "PS2N", 0)
{
    External(_SB.PCI0.LPCB, DeviceObj)
    Scope (_SB.PCI0.LPCB)
    {
        Device (PS2N)
        {
            Method (_HID, 0, NotSerialized)
            {
                Return ("PS2N")
            }
            Name (_CID, Package ()
            {
                EisaId ("PNP0F13"), 
                EisaId ("PNP0F03"), 
                EisaId ("PNP0F0E"), 
                EisaId ("PNP0F0B"), 
                EisaId ("PNP0F12")
            })
            Name (_CRS, ResourceTemplate ()
            {
                IRQNoFlags ()
                    {12}
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
