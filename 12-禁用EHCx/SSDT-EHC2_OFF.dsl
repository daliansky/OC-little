//
DefinitionBlock ("", "SSDT", 2, "ACDT", "EHCx_OFF", 0x00001000)
{
    Scope (\)
    {
        OperationRegion (RCRG, SystemMemory, 0xFED1F418, One)
        Field (RCRG, DWordAcc, Lock, Preserve)
        {
                ,   13, 
            EH2D,   1, 
                ,   1, 
            EH1D,   1
        }

        Method (_INI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                EH2D = One  // Disable EHC2
            }
        }
    }
}
