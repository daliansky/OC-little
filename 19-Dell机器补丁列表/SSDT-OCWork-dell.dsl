//
DefinitionBlock("", "SSDT", 2, "ACDT", "OCWork", 0)
{
    External (_SB.ACOS, IntObj)
    External (_SB.ACSE, IntObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.ACOS = 0x80
            \_SB.ACSE = 0 //ACSE=0:win7;;ACSE=1:win8
        }
    }
}
//EOF
