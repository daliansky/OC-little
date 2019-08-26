// GPI0 enable
DefinitionBlock("", "SSDT", 2, "hack", "GPI0", 0)
{
    External(GPHD, FieldUnitObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            GPHD = 0
        }
    }
}
//EOF