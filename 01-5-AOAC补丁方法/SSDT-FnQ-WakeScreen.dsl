// disable lenovoPRO13 Fn+Q
// In config ACPI, _Q50 to XQ50
// Find:     5F 51 35 30
// Replace:  58 51 35 30
DefinitionBlock ("", "SSDT", 2, "ACDT", "Fn+Q-fix", 0)
{
    External (_SB.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB.PCI0.LPCB.H_EC.XQ50, MethodObj)
    External (_SB.PCI0.LPCB.H_EC.LID0, DeviceObj)
    External (LIDS, IntObj)

    Scope (_SB.PCI0.LPCB.H_EC)
    {
        //Fn+Q,Fn+space,LID,Fn+F4,Fn+F6,Fn+F7
        Method (_Q50, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                LIDS = One
                Notify (\_SB.PCI0.LPCB.H_EC.LID0, 0x80)
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ50()
            }
        }
    }
}
//EOF