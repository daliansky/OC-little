//add ALS0
DefinitionBlock ("", "SSDT", 2, "ACDT", "ALS0", 0)
{
    Scope (_SB)
    {
        Device (ALS0)
        {
            Name (_HID, "ACPI0008" )
            Name (_CID, "smc-als")
            Name (_ALI, 0x012C)
            Name (_ALR, Package (0x01)
            {
                Package (0x02)
                {
                    0x64, 
                    0x012C
                }
            })
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
}

