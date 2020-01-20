// AOAC
// In config ACPI, _LID to XLID
// Find:     5F4C4944 00
// Replace:  584C4944 00
//
DefinitionBlock("", "SSDT", 2, "ACDT", "LID-AOAC", 0)
{
    //note:_LID 's path
    //path:_SB.PCI0.LPCB.H_EC.LID0._LID
    External(_SB.PCI0.LPCB.H_EC.LID0, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC.LID0.XLID, MethodObj)
    
    Scope (_SB)
    {
        Device (PCI8)
        {
            Name (_ADR, Zero)
            Name (AOAC, Zero)
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
    
    Scope (_SB.PCI0.LPCB.H_EC.LID0)
    {
        Method (_LID, 0, NotSerialized)
        {
            If ((_OSI ("Darwin") && (\_SB.PCI8.AOAC == One)))
            {
                Return (One)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.H_EC.LID0.XLID())
            }
        }
    }
}
//EOF