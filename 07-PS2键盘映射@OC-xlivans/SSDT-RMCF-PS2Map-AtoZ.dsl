//
DefinitionBlock ("", "SSDT", 2, "hack", "RMCF", 0)
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
                    "1e=2c",
                },
                
                "Custom ADB Map", Package()
                {
                    Package(){},
                    "1e=06",
                }
            },
        })
    }
}
//EOF