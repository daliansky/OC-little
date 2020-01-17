//
// IORegistryExplorer
// IOService:/AppleACPIPlatformExpert/IOPMrootDomain:
// IOPMDeepIdleSupported = true
// IOPMSystemSleepType = 7
// PMStatusCode = ?
//
DefinitionBlock("", "SSDT", 2, "ACDT", "DIDLE", 0)
{
    Scope (_SB)
    {
        Method (LPS0, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (One)
            }
        }
    }
    
    Scope (_GPE)
    {
        Method (LXEN, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (One)
            }
        }
    }
}