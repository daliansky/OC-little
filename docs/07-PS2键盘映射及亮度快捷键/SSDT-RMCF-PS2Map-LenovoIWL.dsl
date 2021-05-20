//
DefinitionBlock ("", "SSDT", 2, "ACDT", "RMCF", 0)
{
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.PS2K)
    {
        Name (RMCF,Package() 
        {
            "Keyboard", Package()
            {
                "Custom PS2 Map", Package()
                {
                    Package(){},
                    "e037=e022"
                },
                
                "Custom ADB Map", Package()
                {
                    Package(){},
                    "46=80", 
                    "e045=80", 
                    "e04e=4d", 
                    "e003=42", 
                    "e04c=6b", 
                    "e054=71"
                }
            }
        })
    }
}
//EOF