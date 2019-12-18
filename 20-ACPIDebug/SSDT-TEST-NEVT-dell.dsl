// In config ACPI, NEVT to XEVT
// Find:     4E 45 56 54 00
// Replace:  58 45 56 54 00
//
DefinitionBlock("", "SSDT", 2, "ACDT", "TEST", 0)
{
    External(XEVT, MethodObj)
    External(RMDT.P1, MethodObj)
    
    Method (NEVT, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            \RMDT.P1("AAA001")
        }
        \XEVT()
    }
}
//EOF