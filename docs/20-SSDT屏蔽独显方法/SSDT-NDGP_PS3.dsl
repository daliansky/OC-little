//
DefinitionBlock("", "SSDT", 2, "OCLT", "NDGP", 0)
{
    External(_SB.PCI0.RP13.PXSX._PS0, MethodObj)
    External(_SB.PCI0.RP13.PXSX._PS3, MethodObj)
    External(_SB.PCI0.RP13.PXSX._DSM, MethodObj)
 
    If (_OSI ("Darwin"))
    {
        Device(DGPU)
        {
            Name(_HID, "DGPU1000")
            Method (_INI, 0, NotSerialized)
            {
                _OFF()
            }
            
            Method (_ON, 0, NotSerialized)
            {
                //path:
                If (CondRefOf (\_SB.PCI0.RP13.PXSX._PS0))
                {
                    \_SB.PCI0.RP13.PXSX._PS0()
                }
            }
            
            Method (_OFF, 0, NotSerialized)
            {
                //path:
                If (CondRefOf (\_SB.PCI0.RP13.PXSX._PS3))
                {
                    \_SB.PCI0.RP13.PXSX._DSM (Buffer ()
                    {                        /* 0000 */ 0xF8, 0xD8, 0x86, 0xA4, 0xDA, 0x0B, 0x1B, 0x47,                        /* 0008 */ 0xA7, 0x2B, 0x60, 0x42, 0xA6, 0xB5, 0xBE, 0xE0
                    }, 0x0100, 0x1A,Buffer ()
                    { 0x01, 0x00, 0x00, 0x03 })
                    \_SB.PCI0.RP13.PXSX._PS3()
                }
            }
        }
    }
}
//EOF
