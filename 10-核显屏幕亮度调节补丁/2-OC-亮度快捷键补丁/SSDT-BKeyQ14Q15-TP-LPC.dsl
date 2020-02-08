// BrightKey for TP
// In config ACPI, _Q14 to XQ14(TP-up)
// Find:     5F 51 31 34
// Replace:  58 51 31 34

// In config ACPI, _Q15 to XQ15(TP-down)
// Find:     5F 51 31 35
// Replace:  58 51 31 35
//
DefinitionBlock("", "SSDT", 2, "ACDT", "BrightFN", 0)
{
    External(_SB.PCI0.LPC.KBD, DeviceObj)
    External(_SB.PCI0.LPC.EC, DeviceObj)
    External(_SB.PCI0.LPC.EC.XQ14, MethodObj)
    External(_SB.PCI0.LPC.EC.XQ15, MethodObj)
    
    Scope (_SB.PCI0.LPC.EC)
    {
        Method (_Q14, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPC.KBD, 0x0406)
                Notify(\_SB.PCI0.LPC.KBD, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ14()
            }
        }

        Method (_Q15, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPC.KBD, 0x0405)
                Notify(\_SB.PCI0.LPC.KBD, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ15()
            }
        }
    }
}
//EOF
