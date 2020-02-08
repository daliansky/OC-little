// AOAC
// Dell5480: Change Fn+Insert to WakeScreen'KEY
// In config ACPI, BTNV to XTNV
// Find:     42 54 4E 56 02
// Replace:  58 54 4E 56 02
DefinitionBlock ("", "SSDT", 2, "ACDT", "Fn-AOAC", 0)
{
    External (_SB.LID0, DeviceObj)
    External (_SB.PCI8.AOAC, IntObj)
    External (_SB.XTNV, MethodObj)

    Scope (_SB)
    {
        Method (BTNV, 2, NotSerialized)
        {
            If ((_OSI ("Darwin") && (Arg0 == 0x02)))
            {
                //...
                \_SB.PCI8.AOAC = One
                Notify (\_SB.LID0, 0x80)
                Sleep (200)
                \_SB.PCI8.AOAC = Zero
                //...
            }
            Else
            {
                \_SB.XTNV (Arg0, Arg1)
            }
        }
    }
}

