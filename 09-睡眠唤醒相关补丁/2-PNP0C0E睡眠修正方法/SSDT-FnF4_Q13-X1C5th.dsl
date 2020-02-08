// In config ACPI, _Q13 to XQ13(TP-Fn+F4)
// Find:     5F 51 31 33
// Replace:  58 51 31 33
//
DefinitionBlock("", "SSDT", 2, "ACDT", "FnF4", 0)
{
    External(_SB.PCI9.FNOK, IntObj)
    External(_SB.PCI9.MODE, IntObj)
    External(_SB.LID, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.XQ13, MethodObj)

    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_Q13, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (\_SB.PCI9.MODE == 1) //PNP0C0E
                {
                    \_SB.PCI9.FNOK =1
                    \_SB.PCI0.LPCB.EC.XQ13()
                }
                Else //PNP0C0D
                {
                    If (\_SB.PCI9.FNOK!=1)
                    {
                        \_SB.PCI9.FNOK =1
                    }
                    Else
                    {
                        \_SB.PCI9.FNOK =0
                    }
                    Notify (\_SB.LID, 0x80)
                }
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ13()
            }
        }
    }
}
//EOF