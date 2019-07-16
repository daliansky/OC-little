//Add PWRB
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "PNP0C0C", 0)
{
#endif
    //search PNP0C0C
    Scope (\_SB)
    {
        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
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
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF