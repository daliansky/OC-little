//enable RTC
//disable AWAC
DefinitionBlock ("", "SSDT", 2, "ACDT", "RTCAWAC", 0x00000000)
{
    External (STAS, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = One
        }
    }
}

