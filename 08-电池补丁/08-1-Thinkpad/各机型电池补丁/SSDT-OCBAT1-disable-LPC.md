```swift
// battery for WTX30,WTX40,X260,X1C2014,X1C2016
//
// In config ACPI, _STA to XSTA
// Count:          1
// Find:           5F 53 54 41
// Replace:        58 53 54 41
// Skip:           12
// TableSignature: 44 53 44 54
//
// battery for WTX50,WTX60,X1C2015
//
// In config ACPI, _STA to XSTA
// Count:          1
// Find:           5F 53 54 41
// Replace:        58 53 54 41
// Skip:           11
// TableSignature: 44 53 44 54
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "BAT1-off", 0)
{
    External(_SB.PCI0.LPC.EC.BAT1, DeviceObj)
    External(_SB.PCI0.LPC.EC.BAT1.XSTA, MethodObj)
    
    Scope(\_SB.PCI0.LPC.EC.BAT1)
    {
        Method(_STA)
        {
            If (_OSI ("Darwin"))
            {
                Return (0)
            }
            Else
            {
                Return (\_SB.PCI0.LPC.EC.BAT1.XSTA ())
            }   
        }
    }
}
// EOF
```
