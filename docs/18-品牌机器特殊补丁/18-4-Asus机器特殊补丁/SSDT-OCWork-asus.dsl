//
DefinitionBlock("", "SSDT", 2, "OCLT", "OCWork", 0)
{
    External (OSME, IntObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            OSME = 0x0100
        }
    }
}
//EOF
