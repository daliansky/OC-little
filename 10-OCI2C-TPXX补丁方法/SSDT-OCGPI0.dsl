// GPI0 enable
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "GPI0", 0)
{
#endif
    //External(SBRG, FieldUnitObj)
    External(GPEN, FieldUnitObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            GPEN = 1
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF