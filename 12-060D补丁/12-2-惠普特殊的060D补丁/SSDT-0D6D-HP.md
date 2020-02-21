```swift
// 0D6D patch
DefinitionBlock("", "SSDT", 2, "OCLT", "0D6D", 0)
{
    External(USWE, FieldUnitObj)
    External(WOLE, FieldUnitObj)
    
    //0D6D patch:HP-XHC
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            USWE = 0
        }
    }

    //0D6D patch:HP-GLAN
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            WOLE = 0
        }
    }
}
//EOF
```
