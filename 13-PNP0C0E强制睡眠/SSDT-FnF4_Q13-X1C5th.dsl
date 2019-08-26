// In config ACPI, _Q13 to XQ13(TP-FnF4)
// Find:     5F 51 31 33
// Replace:  58 51 31 33
//
DefinitionBlock("", "SSDT", 2, "hack", "FnF4", 0)
{
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.XQ13, MethodObj)
    External(_SB.PCI9.FNOK, IntObj)

    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_Q13, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                \_SB.PCI9.FNOK =1
            }
            \_SB.PCI0.LPCB.EC.XQ13()
        }
    }
}
//EOF