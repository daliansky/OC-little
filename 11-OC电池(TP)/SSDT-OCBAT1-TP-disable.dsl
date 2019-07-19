//
DefinitionBlock("", "SSDT", 2, "hack", "NOBAT1", 0)
{
    External (WNTF, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            If (CondRefOf (WNTF))
            {
                WNTF = One
            }
        }
    }
}
//EOF