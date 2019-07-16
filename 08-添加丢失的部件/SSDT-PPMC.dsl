//Add PPMC
DefinitionBlock ("", "SSDT", 2, "hack", "PPMC", 0)
{
    External (_SB_.PCI0, DeviceObj)

    Scope (_SB.PCI0)
    {
        Device (PPMC)
        {
            Name (_ADR, 0x001F0002)
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

