//
DefinitionBlock ("", "SSDT", 2, "hack", "LedFlash", 0)
{
    External (_SB.ACOS, IntObj)
    External (_SB.ACSE, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.ACOS = 0x80
            \_SB.ACSE = 0
        }
    }
}