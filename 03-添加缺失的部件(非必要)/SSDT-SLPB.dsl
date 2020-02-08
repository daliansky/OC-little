//Add SLPB 
DefinitionBlock("", "SSDT", 2, "ACDT", "PNP0C0E", 0)
{
    //search PNP0C0E
    Scope (\_SB)
    {
        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E"))
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0B)
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