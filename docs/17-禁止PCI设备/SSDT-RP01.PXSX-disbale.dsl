// disable RP01.PXSX (ReadCARD)
DefinitionBlock ("", "SSDT", 2, "OCLT", "noRPxx", 0)
{
    External (_SB.PCI0.RP01, DeviceObj)

    Scope (_SB.PCI0.RP01)
    {
        OperationRegion (DE01, PCI_Config, 0x50, 1)
        Field (DE01, AnyAcc, NoLock, Preserve)
        {
                ,   4, 
            DDDD,   1
        }
        //possible start
        Method (_STA, 0, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
        }
        //possible end
    }
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI0.RP01.DDDD = One
        }
    }
}
//EOF