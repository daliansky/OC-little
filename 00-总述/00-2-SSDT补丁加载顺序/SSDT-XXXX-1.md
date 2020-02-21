```swift
//Fake XXXX
DefinitionBlock ("", "SSDT", 2, "ACDT", "XXXX-1", 0)
{
    External (_SB.PCI0.LPCB, DeviceObj)
    Scope (_SB.PCI0.LPCB)
    {
        Device (XXXX)
        {
            Name (_HID, EisaId ("ABC1111"))
        }
    }
}
```