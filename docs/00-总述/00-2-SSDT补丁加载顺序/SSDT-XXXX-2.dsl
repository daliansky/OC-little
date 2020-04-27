//
DefinitionBlock ("", "SSDT", 2, "ACDT", "XXXX-2", 0)
{
    External (_SB.PCI0.LPCB.XXXX, DeviceObj)
    Scope (_SB.PCI0.LPCB.XXXX)
    {
        Method (YYYY, 0, NotSerialized)
        {
            //do nothing
        }
    }
}

