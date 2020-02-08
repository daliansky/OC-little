// disable RP01.PXSX (ReadCARD)
DefinitionBlock ("", "SSDT", 2, "ACDT", "noRPxx", 0)
{
    External (_SB.PCI0.RP01, DeviceObj)

    Scope (_SB.PCI0.RP01)
    {
        OperationRegion (DE01, PCI_Config, 0x50, 1)
        Field (DE01, AnyAcc, NoLock, Preserve)
        {
                ,   1, 
                ,   3, 
            DDDD,   1
        }
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