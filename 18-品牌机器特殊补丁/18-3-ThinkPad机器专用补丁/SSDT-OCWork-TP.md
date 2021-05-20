```dsl
//
DefinitionBlock("", "SSDT", 2, "OCLT", "OCWork", 0)
{
    External (NBCF, IntObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            NBCF = 1
        }
    }
}
//EOF
```
