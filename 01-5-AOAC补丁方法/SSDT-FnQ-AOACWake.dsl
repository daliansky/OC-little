// AOAC
// lenovoPRO13: Change Fn+Q to WakeScreen'KEY
// In config ACPI, _Q50 to XQ50
// Find:     5F 51 35 30
// Replace:  58 51 35 30
DefinitionBlock ("", "SSDT", 2, "ACDT", "Fn-AOAC", 0)
{
    External (_SB.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB.PCI0.LPCB.H_EC.XQ50, MethodObj)
    External (_SB.PCI0.LPCB.H_EC.LID0, DeviceObj)
    External (_SB.PCI8.AOAC, IntObj)

    Scope (_SB.PCI0.LPCB.H_EC)
    {
        //Fn+Q,Fn+space,LID,Fn+F4,Fn+F6,Fn+F7
        Method (_Q50, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                //...
                \_SB.PCI8.AOAC = One
                Notify (\_SB.PCI0.LPCB.H_EC.LID0, 0x80)
                Sleep (200)
                \_SB.PCI8.AOAC = Zero
                //...
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ50()
            }
        }
    }
}
//EOF