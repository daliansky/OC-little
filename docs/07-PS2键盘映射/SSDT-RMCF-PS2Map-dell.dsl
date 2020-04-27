//
DefinitionBlock ("", "SSDT", 2, "ACDT", "RMCF", 0)
{
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.PS2K)
    {
        Name (RMCF,Package() 
        {
            "Mouse", Package ()
            {
                "ActLikeTrackpad", 
                ">y"
            }, 
            
            "Keyboard", Package()
            {
                "Custom PS2 Map", Package()
                {
                    Package(){},
                    "46=0",    // disable Fn+S and F6
                    "e045=0",  // disable Fn+B
                    "e037=64", // PrtSc=F13
                    "57=65",   // F11=F14
                    "58=66",   // F12=F15
                },
            }
        })
    }
}
//EOF