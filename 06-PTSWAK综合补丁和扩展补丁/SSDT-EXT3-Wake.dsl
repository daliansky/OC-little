//
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "EXT3", 0)
{
#endif
    External(_SB.LID, DeviceObj)
    External(_SB.LID0, DeviceObj)
    External(_SB.PCI0.LPCB.LID, DeviceObj)
    External(_SB.PCI0.LPCB.LID0, DeviceObj)
    
    Method (EXT3, 1, NotSerialized)
    {   
        If (_OSI ("Darwin"))
        {
            If (3 == Arg0)
            {
                If (CondRefOf (\_SB.LID))
                {
                    Notify (\_SB.LID, 0x80)
                }
                If (CondRefOf (\_SB.LID0))
                {
                    Notify (\_SB.LID0, 0x80)
                }
                //
                If (CondRefOf (\_SB.PCI0.LPCB.LID))
                {
                    Notify (\_SB.PCI0.LPCB.LID, 0x80)
                }
                If (CondRefOf (\_SB.PCI0.LPCB.LID0))
                {
                    Notify (\_SB.PCI0.LPCB.LID0, 0x80)
                }
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
