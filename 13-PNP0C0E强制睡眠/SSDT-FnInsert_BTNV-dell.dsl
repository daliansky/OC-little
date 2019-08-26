// Overriding BTNV
// In config ACPI, BTNV to XTNV(dell-FnInsert)
// Find:     42 54 4E 56 02
// Replace:  58 54 4E 56 02
//
DefinitionBlock("", "SSDT", 2, "hack", "FnInsert", 0)
{
    External(_SB.PCI9.FNOK, IntObj)
    External(_SB.XTNV, MethodObj)
    
    Scope (_SB)
    {
        Method (BTNV, 2, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (Arg0 == 2)
                {
                    \_SB.PCI9.FNOK =1
                }
            }
            \_SB.XTNV(Arg0, Arg1)
        }
    }
}
//EOF