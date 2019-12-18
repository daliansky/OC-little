// GPI0 enable
DefinitionBlock("", "SSDT", 2, "ACDT", "GPI0", 0)
{
    External(GPEN, FieldUnitObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            GPEN = 1
        }
    }
}
//EOF