//
DefinitionBlock ("", "SSDT", 2, "hack", "OCWork", 0)
{
    External (_SB.GDCK.XHOS, IntObj)
    External (WIN7, IntObj)
    //External (WIN8, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            If (CondRefOf (\_SB.GDCK.XHOS))
            {
                \_SB.GDCK.XHOS = 0x01
            }

            If (CondRefOf (WIN7))
            {
                WIN7 = One
            }
                
            /*
            If (CondRefOf (WIN8))
            {
                WIN8 = One
            }
            */
        }
    }
}
