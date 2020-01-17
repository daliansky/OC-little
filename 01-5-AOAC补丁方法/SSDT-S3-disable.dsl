// In config ACPI, _S3 to XS3
// Find:     5F53335F
// Replace:  5853335F
//
DefinitionBlock("", "SSDT", 2, "ACDT", "S3-Fix", 0)
{
    If (_OSI ("Darwin"))
    {
        //
    }
    Else
    {
        Name (_S3, Package (0x04)
        {
            0x05, 
            Zero, 
            Zero, 
            Zero
        })
    }
}
//EOF