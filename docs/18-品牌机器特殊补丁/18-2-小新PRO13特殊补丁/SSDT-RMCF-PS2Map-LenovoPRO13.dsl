//
DefinitionBlock ("", "SSDT", 2, "ACDT", "RMCF", 0)
{
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.PS2K)
    {
        If (_OSI ("Darwin"))
        {
            Name (RMCF,Package() 
            {
                "Keyboard", Package()
                {
                    "Custom PS2 Map", Package()
                    {
                        Package(){},
                        "e037=0", //disable Fn+S
                        "e052=0", //disable PrtSc
                        "46=0",   //disable Fn+C
                        "e045=0"  //disable Fn+P
                    }
                }
            })
        }
    }
}
//EOF