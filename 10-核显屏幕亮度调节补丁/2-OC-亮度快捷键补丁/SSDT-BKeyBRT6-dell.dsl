// BrightKey for dell
// In config ACPI, BRT6 to XRT6(dell)
// Find:     42 52 54 36 02 A0 0B 93
// Replace:  58 52 54 36 02 A0 0B 93
//
DefinitionBlock("", "SSDT", 2, "ACDT", "BrightFN", 0)
{
    External(_SB.PCI0.GFX0, DeviceObj)
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.GFX0.XRT6, MethodObj)

    Scope (_SB.PCI0.GFX0)
    {
        Method (BRT6, 2, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If ((Arg0 == One))
                {
                    Notify (\_SB.PCI0.LPCB.PS2K, 0x0406)
                    Notify (\_SB.PCI0.LPCB.PS2K, 0x10)
                }

                If ((Arg0 & 0x02))
                {
                    Notify (\_SB.PCI0.LPCB.PS2K, 0x0405)
                    Notify (\_SB.PCI0.LPCB.PS2K, 0x20)
                }
            }
            Else
            {
                \_SB.PCI0.GFX0.XRT6(Arg0, Arg1)
            }
        }
    }
}
//EOF
