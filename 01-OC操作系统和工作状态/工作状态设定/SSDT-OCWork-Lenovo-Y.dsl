//
DefinitionBlock ("", "SSDT", 2, "hack", "OCWork", 0)
{
    External (_SB.PCI0.LPCB.EC0.OSTY, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            //win7
            If (CondRefOf (\_SB.PCI0.LPCB.EC0.OSTY))
            {
                \_SB.PCI0.LPCB.EC0.OSTY = 3
            }
                
            /*
            //win8
            If (CondRefOf (\_SB.PCI0.LPCB.EC0.OSTY))
            {
                \_SB.PCI0.LPCB.EC0.OSTY = 4
            }
                
            //win81
            If (CondRefOf (\_SB.PCI0.LPCB.EC0.OSTY))
            {
                \_SB.PCI0.LPCB.EC0.OSTY = 5
            }
            */
        }
    }
}
