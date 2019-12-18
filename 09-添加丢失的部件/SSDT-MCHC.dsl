//Add MCHC
DefinitionBlock ("", "SSDT", 2, "ACDT", "MCHC", 0)
{
    External (_SB.PCI0, DeviceObj)
    Scope (_SB.PCI0)
    {
        Device (MCHC)
        {
            Name (_ADR, Zero)
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
