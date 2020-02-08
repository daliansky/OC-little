// BrightKey for LenovoPRO13
// In config ACPI, _Q39 to XQ39(LenovoPRO13-down)
// Find:     5F 51 31 39
// Replace:  58 51 31 39

// In config ACPI, _Q38 to XQ38(LenovoPRO13-up)
// Find:     5F 51 31 38
// Replace:  58 51 31 38
//
DefinitionBlock("", "SSDT", 2, "ACDT", "BrightFN", 0)
{
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC.XQ38, MethodObj)
    External(_SB.PCI0.LPCB.H_EC.XQ39, MethodObj)
    
    Scope (_SB.PCI0.LPCB.H_EC)
    {
        Method (_Q39, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ39()
            }
        }
    
        Method (_Q38, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0406)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ38()
            }
        }
    }
}
//EOF
