// Disables DGPU---lenovo PRO13
//
DefinitionBlock("", "SSDT", 2, "ACDT", "NDGP", 0)
{
    External(_SB.PCI0.RP13.PXSX._OFF, MethodObj)//lenovo PRO13
 
    If (_OSI ("Darwin"))
    {
        Device(DGPU)
        {
            Name(_HID, "DGPU1000")
            Method (_INI, 0, NotSerialized)
            {
                _OFF()
            }
        
            Method (_OFF, 0, NotSerialized)
            {
                If (CondRefOf (\_SB.PCI0.RP13.PXSX._OFF))//lenovo PRO13
                {
                    \_SB.PCI0.RP13.PXSX._OFF()
                }
            }
        }
    }
}
//EOF