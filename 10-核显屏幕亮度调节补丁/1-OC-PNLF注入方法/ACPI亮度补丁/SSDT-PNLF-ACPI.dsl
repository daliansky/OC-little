//
DefinitionBlock("", "SSDT", 2, "ACDT", "PNLFACPI", 0)
{
    External(_SB.PCI0.IGPU, DeviceObj)
    External(_SB.PCI0.IGPU.DD1F._BCL, MethodObj)
    External(_SB.PCI0.IGPU.DD1F._BCM, MethodObj)
    External(_SB.PCI0.IGPU.DD1F._BQC, MethodObj)
    External(_SB.PCI0.IGPU._DOS, MethodObj)
    
    Scope(_SB.PCI0.IGPU)
    {
        Device(PNLF)
        {
            Name (_ADR, Zero)
            Name (_HID, EisaId ("APP0002"))
            Name (_CID, "backlight")
            Name (_UID, 10)
            // _BCM/_BQC: set/get for brightness level
            Method (_BCM, 1, NotSerialized)
            {
                ^^DD1F._BCM(Arg0)
            }
            Method (_BQC, 0, NotSerialized)
            {
                Return(^^DD1F._BQC())
            }
            Method (_BCL, 0, NotSerialized)
            {
                Return(^^DD1F._BCL())
            }
            Method (_DOS, 1, NotSerialized)
            {
                ^^_DOS(Arg0)
            }
            // extended _BCM/_BQC for setting "in between" levels
            Method (XBCM, 1, NotSerialized)
            {
                // Update backlight via existing DSDT methods
                ^^DD1F._BCM(Arg0)
            }
            Method (XBQC, 0, NotSerialized)
            {
                Return(^^DD1F._BQC())
            }
            // Use XOPT=1 to disable smooth transitions
            Name (XOPT, Zero)
            // XRGL/XRGH: defines the valid range
            Method (XRGL, 0, NotSerialized)
            {
                Store(_BCL(), Local0)
                Store(DerefOf(Index(Local0, 2)), Local0)
                Return(Local0)
            }
            Method (XRGH, 0, NotSerialized)
            {
                Store(_BCL(), Local0)
                Store(DerefOf(Index(Local0, Subtract(SizeOf(Local0), 1))), Local0)
                Return(Local0)
            }
            Method (_INI, 0, NotSerialized)
            {
                //XRGL()
                //XRGH()
            }
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0B)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }        
    }
}
//EOF