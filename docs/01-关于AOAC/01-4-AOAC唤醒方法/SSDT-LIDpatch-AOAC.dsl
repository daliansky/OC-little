// AOAC wake
// In config ACPI, _LID to XLID
// Find:     5F4C4944 00
// Replace:  584C4944 00
//
DefinitionBlock("", "SSDT", 2, "OCLT", "LID-AOAC", 0)
{
    //path:_SB.PCI0.LPCB.H_EC.LID0._LID
    External(_SB.PCI0.LPCB.H_EC.LID0, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC.LID0.XLID, MethodObj)
    
    Scope (_SB.PCI0.LPCB.H_EC.LID0)
    {
        Name (AOAC, Zero)
        Method (_LID, 0, NotSerialized)
        {
            If ((_OSI ("Darwin") && (AOAC == One)))
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