//
DefinitionBlock ("", "SSDT", 2, "hack", "OCWork", 0)
{
    External (_SB.PCI0.LPCB.EC0.AMBX, MethodObj)
    External (WIN7, IntObj)
    //External (WIN8, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            If (CondRefOf (\_SB.PCI0.LPCB.EC0.AMBX))
            {
                \_SB.PCI0.LPCB.EC0.AMBX (One, 0xA3F4, 0x03)
            }

            If (CondRefOf (WIN7))
            {
                WIN7 = One
            }
                
            /*
            If (CondRefOf (\_SB.PCI0.LPCB.EC0.AMBX))
            {
                \_SB.PCI0.LPCB.EC0.AMBX (One, 0xA3F4, 0x04)
            }

            If (CondRefOf (WIN8))
            {
                WIN8 = One
            }
            */
        }
    }
}
