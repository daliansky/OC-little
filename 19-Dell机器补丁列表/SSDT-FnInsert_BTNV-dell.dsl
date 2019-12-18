// Overriding BTNV
// In config ACPI, BTNV to XTNV(dell-Fn+Insert)
// Find:     42 54 4E 56 02
// Replace:  58 54 4E 56 02
//
DefinitionBlock("", "SSDT", 2, "ACDT", "FnInsert", 0)
{
    External(_SB.PCI9.FNOK, IntObj)
    External(_SB.PCI9.MODE, IntObj)
    External(_SB.LID0, DeviceObj)
    External(_SB.XTNV, MethodObj)
    
    Scope (_SB)
    {
        Method (BTNV, 2, NotSerialized)
        {
            If (_OSI ("Darwin") && (Arg0 == 2))
            {
                If (\_SB.PCI9.MODE == 1) //PNP0C0E
                {
                    \_SB.PCI9.FNOK =1
                    \_SB.XTNV(Arg0, Arg1)
                }
                Else //PNP0C0D
                {
                    If (\_SB.PCI9.FNOK!=1)
                    {
                        \_SB.PCI9.FNOK =1
                    }
                    Else
                    {
                        \_SB.PCI9.FNOK =0
                    }
                    Notify (\_SB.LID0, 0x80)
                }
            }
            Else
            {
                \_SB.XTNV(Arg0, Arg1)
            }
        }
    }
}
//EOF