// PCI.LPCB-AOACWake
//
DefinitionBlock("", "SSDT", 2, "ACDT", "AOACWake", 0)
{
    External(_SB.PCI0.LPCB, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC._Q0D, MethodObj)
    External(_SB.PCI0.LPCB.H_EC.LID0._LID, MethodObj)
    
    Scope (_SB.PCI0.LPCB)
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