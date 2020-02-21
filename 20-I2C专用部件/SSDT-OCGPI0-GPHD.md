```swift
// GPI0 enable
DefinitionBlock("", "SSDT", 2, "OCLT", "GPI0", 0)
{
    External(GPHD, FieldUnitObj)
    

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            GPHD = 2
        }
    }

}
//EOF
```

