// PCI0.LPCB-AOACWake
//
DefinitionBlock("", "SSDT", 2, "ACDT", "AOACWake", 0)
{
    External(_SB.PCI0.LPCB, DeviceObj)
    External(_WAK, MethodObj)
    
    Scope (_SB.PCI0.LPCB)
    {
        If (_OSI ("Darwin"))
        {
            Method (_PS0, 0, Serialized)
            {
                \_WAK (0x03)
                //It is possible to customize the power data recovery method
            }
            
            Method (_PS3, 0, Serialized)
            {

            }
        }
    }
}
//EOF