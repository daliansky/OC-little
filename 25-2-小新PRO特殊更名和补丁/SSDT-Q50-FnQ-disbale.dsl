// disable lenovo Fn+Q
// In config ACPI, _Q50 to XQ50
// Find:     5F 51 35 30
// Replace:  58 51 35 30
DefinitionBlock ("", "SSDT", 2, "ACDT", "Fn+Q-fix", 0)
{
    External (_SB.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB.PCI0.LPCB.H_EC.XQ50, MethodObj)

    Scope (_SB.PCI0.LPCB.H_EC)
    {
        Method (_Q50, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ50()
            }
        }
    }
}
//EOF