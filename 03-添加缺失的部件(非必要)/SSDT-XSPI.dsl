//Add XSPI
DefinitionBlock ("", "SSDT", 2, "ACDT", "XSPI", 0)
{
    External (_SB.PCI0, DeviceObj)
    Scope (_SB.PCI0)
    {
        Device (XSPI)
        {
            Name (_ADR, 0x001F0005)
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
}

