//
// For ACPI Patch:
// _Q22 to XQ22:
// Find:    5f51 3232
// Replace: 5851 3232
//
// _Q24 to XQ24:
// Find:    5f51 3234
// Replace: 5851 3234
//
// _Q25 to XQ25:
// Find:    5f51 3235
// Replace: 5851 3235
//
// _Q4A to XQ4A:
// Find:    5f51 3441
// Replace: 5851 3441
//
// _Q4B to XQ4B:
// Find:    5f51 3442
// Replace: 5851 3442
//
// _Q4C to XQ4C:
// Find:    5f51 3443
// Replace: 5851 3443
//
// _Q4D to XQ4D:
// Find:    5f51 3444
// Replace: 5851 3444
//
// BATW to XATW:
// Find:    4241 545701
// Replace: 5841 545701
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "NTFY", 0)
{
    External (\_SB.PCI0.LPC.EC, DeviceObj)
    External (\_SB.PCI0.LPC.EC.BATC, DeviceObj)
    //
    External (\_SB.PCI0.LPC.EC.BAT1.XB1S, IntObj)
    External (\_SB.PCI0.LPC.EC.BAT1.B1ST, IntObj)
    External (\_SB.PCI0.LPC.EC.BAT1.SBLI, IntObj)
    //
    External (\_SB.PCI0.LPC.EC.CLPM, MethodObj)
    External (\_SB.PCI0.LPC.EC.HKEY.MHKQ, MethodObj)
    //
    External (\BT2T, FieldUnitObj)
    External (\_SB.PCI0.LPC.EC.SLUL, FieldUnitObj)
    External (\_SB.PCI0.LPC.EC.HB0A, FieldUnitObj)
    External (\_SB.PCI0.LPC.EC.HB1A, FieldUnitObj)
    //
    External (\_SB.PCI0.LPC.EC.XQ22, MethodObj)
    External (\_SB.PCI0.LPC.EC.XQ24, MethodObj)
    External (\_SB.PCI0.LPC.EC.XQ25, MethodObj)
    External (\_SB.PCI0.LPC.EC.XQ4A, MethodObj)
    External (\_SB.PCI0.LPC.EC.XQ4B, MethodObj)
    External (\_SB.PCI0.LPC.EC.XQ4C, MethodObj)
    External (\_SB.PCI0.LPC.EC.XQ4D, MethodObj)
    External (\_SB.PCI0.LPC.EC.XATW, MethodObj)

    Scope (\_SB.PCI0.LPC.EC)
    {
        Method (_Q22, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                CLPM ()
                If (HB0A)
                {
                    Notify (BATC, 0x80) // Status Change
                }

                If (HB1A)
                {
                    Notify (BATC, 0x80) // Status Change
                }
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ22 ()
            }
        }
        
        Method (_Q24, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                CLPM ()
                Notify (BATC, 0x80) // Status Change
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ24 ()
            }
        }
            
        Method (_Q25, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                If ((^BAT1.B1ST & ^BAT1.XB1S))
                {
                    CLPM ()
                    Notify (BATC, 0x80) // Status Change
                }
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ25 ()
            }
        }
        
        Method (_Q4A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                CLPM ()
                Notify (BATC, 0x81) // Information Change
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ4A ()
            }
        }
        
        Method (_Q4B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                CLPM ()
                Notify (BATC, 0x80) // Status Change
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ4B ()
            }
        }
        
        Method (_Q4C, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                \_SB.PCI0.LPC.EC.CLPM ()
                If (\_SB.PCI0.LPC.EC.HB1A)
                {
                    \_SB.PCI0.LPC.EC.HKEY.MHKQ (0x4010)
                    Notify (\_SB.PCI0.LPC.EC.BATC, 0x01) // Device Check
                }
                Else
                {
                    \_SB.PCI0.LPC.EC.HKEY.MHKQ (0x4011)
                    If (\_SB.PCI0.LPC.EC.BAT1.XB1S)
                    {
                        Notify (\_SB.PCI0.LPC.EC.BATC, 0x03) // Eject Request
                    }
                }
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ4C ()
            }
        }
            
        Method (_Q4D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                CLPM ()
                If (\BT2T)
                {
                    If ((^BAT1.SBLI == 0x01))
                    {
                        Sleep (0x0A)
                        If ((HB1A && (SLUL == 0x00)))
                        {
                            ^BAT1.XB1S = 0x01
                            Notify (\_SB.PCI0.LPC.EC.BATC, 0x01) // Device Check
                        }
                    }
                    ElseIf ((SLUL == 0x01))
                    {
                        ^BAT1.XB1S = 0x00
                        Notify (\_SB.PCI0.LPC.EC.BATC, 0x03) // Eject Request
                    }
                }

                If ((^BAT1.B1ST & ^BAT1.XB1S))
                {
                    Notify (BATC, 0x80) // Status Change
                }
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ4D ()
            }
        }
        
        Method (BATW, 1, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (\BT2T)
                {
                    Local0 = \_SB.PCI0.LPC.EC.BAT1.XB1S
                    If ((HB1A && !SLUL))
                    {
                        Local1 = 0x01
                    }
                    Else
                    {
                        Local1 = 0x00
                    }

                    If ((Local0 ^ Local1))
                    {
                        \_SB.PCI0.LPC.EC.BAT1.XB1S = Local1
                        Notify (\_SB.PCI0.LPC.EC.BATC, 0x01) // Device Check
                    }
                }
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XATW (Arg0)
            }
        }
    }
}

