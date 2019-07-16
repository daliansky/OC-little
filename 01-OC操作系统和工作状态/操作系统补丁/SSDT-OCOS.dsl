// ....
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "OCOS", 0)
{
#endif
    External(OSYS, FieldUnitObj)
    Scope (_SB)
    {
        Device (PCI1)
        {
            Name (_ADR, Zero)
            Method (_INI, 0, NotSerialized)
            {
                OSYS = 0x07DC
                //0x07D9:win7;
                //0x07DC:win8;
                //0x07DD:win81;
                //0x07DF:win10
            }
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
