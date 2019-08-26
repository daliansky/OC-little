// GPI0 enable
DefinitionBlock("", "SSDT", 2, "hack", "GPI0", 0)
{
    External(SBRG, FieldUnitObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            SBRG = 1
        }
    }
}
//EOF