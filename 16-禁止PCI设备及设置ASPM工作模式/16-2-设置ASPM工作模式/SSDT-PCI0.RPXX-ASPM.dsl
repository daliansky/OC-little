// Set ASPM of PCI0.RP05(WiFi) to L1
DefinitionBlock ("", "SSDT", 2, "OCLT", "ASPM", 0)
{
    External (_SB.PCI0.RP05, DeviceObj)
    Scope (_SB.PCI0.RP05)
    {
        OperationRegion (LLLL, PCI_Config, 0x50, 1)
        Field (LLLL, AnyAcc, NoLock, Preserve)
        {
            L1,   1
        }
    }
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI0.RP05.L1 = Zero   //Set ASPM = L1
        }
    }
}
//EOF