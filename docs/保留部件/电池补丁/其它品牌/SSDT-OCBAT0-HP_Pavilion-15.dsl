/* battery
 * In config, ADJT to XDJT
 * Find:    41444A54 08
 * Replace: 58444A54 08
 * 
 * In config, CLRI to XLRI
 * Find:    434C5249 08
 * Replace: 584C5249 08
 * 
 * In config, _BST to XBST
 * Find:    5F425354 00
 * Replace: 58425354 00
 * 
 * In config, UPBI to XPBI
 * Find:    55504249 00
 * Replace: 58504249 00
 * 
 * In config, UPBS to XPBS
 * Find:    55504253 00
 * Replace: 58504253 00
 * 
 * In config, SMRD to XMRD
 * Find:    534D5244 04
 * Replace: 584D5244 04
 * 
 * In config, SMWR to XMWR
 * Find:    534D5752 04
 * Replace: 584D5752 04
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "BATT", 0)
{
    External (_SB.BAT0, DeviceObj)
    External (_SB.BAT0._STA, MethodObj)
    External (_SB.BAT0.FABL, IntObj)
    External (_SB.BAT0.IVBS, MethodObj)
    External (_SB.BAT0.PBIF, PkgObj)
    External (_SB.BAT0.PBST, PkgObj)
    External (_SB.BAT0.UPUM, MethodObj)
    External (_SB.BAT0.XBST, MethodObj)
    External (_SB.BAT0.XPBI, MethodObj)
    External (_SB.BAT0.XPBS, MethodObj)
    External (_SB.GBFE, MethodObj)
    External (_SB.LID0._LID, MethodObj)
    External (_SB.PBFE, MethodObj)
    External (_SB.PCI0.ACEL, DeviceObj)
    External (_SB.PCI0.ACEL._STA, MethodObj)
    External (_SB.PCI0.ACEL.CNST, IntObj)
    External (_SB.PCI0.ACEL.XDJT, MethodObj)
    External (_SB.PCI0.ACEL.XLRI, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.BACR, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BCNT, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BVHB, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BVLB, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.ECOK, IntObj)
    External (_SB.PCI0.LPCB.EC0.MBNH, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.MBST, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.MBTS, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.MUT0, MutexObj)
    External (_SB.PCI0.LPCB.EC0.PLGS, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.SMAD, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.SMB0, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.SMCM, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.SMPR, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.SMST, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.SW2S, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.XMRD, MethodObj)
    External (_SB.PCI0.LPCB.EC0.XMWR, MethodObj)
    External (PWRS, FieldUnitObj)

    Method (B1B2, 2, NotSerialized)
    {
        Local0 = (Arg1 << 0x08)
        Local0 |= Arg0
        Return (Local0)
    }

    Scope (\_SB.PCI0.LPCB.EC0)
    {
        OperationRegion (ERM2, EmbeddedControl, Zero, 0xFF)
        Field (ERM2, ByteAcc, Lock, Preserve)
        {
            Offset (0x70), 
            ADC0,   8, 
            ADC1,   8, 
            FCC0,   8, 
            FCC1,   8, 
            Offset (0x82), 
            Offset (0x83), 
            CUR0,   8, 
            CUR1,   8, 
            BRM0,   8, 
            BRM1,   8, 
            BCV0,   8, 
            BCV1,   8
        }

        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            MW00,   8, 
            MW01,   8
        }

        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE) /* \_SB.PCI0.LPCB.EC0.RE1B.BYTE */
        }

        Method (RECB, 2, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1){})
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                TEMP [Local0] = RE1B (Arg0)
                Arg0++
                Local0++
            }

            Return (TEMP) /* \_SB.PCI0.LPCB.EC0.RECB.TEMP */
        }

        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            BYTE = Arg1
        }

        Method (WECB, 3, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1){})
            TEMP = Arg2
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                WE1B (Arg0, DerefOf (TEMP [Local0]))
                Arg0++
                Local0++
            }
        }

        Method (SMRD, 4, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (!ECOK)
                {
                    Return (0xFF)
                }

                If ((Arg0 != 0x07))
                {
                    If ((Arg0 != 0x09))
                    {
                        If ((Arg0 != 0x0B))
                        {
                            If ((Arg0 != 0x47))
                            {
                                If ((Arg0 != 0xC7))
                                {
                                    Return (0x19)
                                }
                            }
                        }
                    }
                }

                Acquire (MUT0, 0xFFFF)
                Local0 = 0x04
                While ((Local0 > One))
                {
                    SMST &= 0x40
                    SMCM = Arg2
                    SMAD = Arg1
                    SMPR = Arg0
                    Local3 = Zero
                    While (!Local1 = (SMST & 0xBF))
                    {
                        Sleep (0x02)
                        Local3++
                        If ((Local3 == 0x32))
                        {
                            SMST &= 0x40
                            SMCM = Arg2
                            SMAD = Arg1
                            SMPR = Arg0
                            Local3 = Zero
                        }
                    }

                    If ((Local1 == 0x80))
                    {
                        Local0 = Zero
                    }
                    Else
                    {
                        Local0--
                    }
                }

                If (Local0)
                {
                    Local0 = (Local1 & 0x1F)
                }
                Else
                {
                    If ((Arg0 == 0x07))
                    {
                        Arg3 = SMB0 /* External reference */
                    }

                    If ((Arg0 == 0x47))
                    {
                        Arg3 = SMB0 /* External reference */
                    }

                    If ((Arg0 == 0xC7))
                    {
                        Arg3 = SMB0 /* External reference */
                    }

                    If ((Arg0 == 0x09))
                    {
                        Arg3 = B1B2 (MW00, MW00)
                    }

                    If ((Arg0 == 0x0B))
                    {
                        Local3 = BCNT /* External reference */
                        Local2 = 0x20
                        If ((Local3 > Local2))
                        {
                            Local3 = Local2
                        }

                        If ((Local3 < 0x09))
                        {
                            Local2 = RECB (0x04, 0x40)
                        }
                        ElseIf ((Local3 < 0x11))
                        {
                            Local2 = RECB (0x04, 0x80)
                        }
                        ElseIf ((Local3 < 0x19))
                        {
                            Local2 = RECB (0x04, 0xC0)
                        }
                        Else
                        {
                            Local2 = RECB (0x04, 0x0100)
                        }

                        Local3++
                        Local4 = Buffer (Local3){}
                        Local3--
                        Local5 = Zero
                        Name (OEMS, Buffer (0x46){})
                        ToBuffer (Local2, OEMS) /* \_SB.PCI0.LPCB.EC0.SMRD.OEMS */
                        While ((Local3 > Local5))
                        {
                            GBFE (OEMS, Local5, RefOf (Local6))
                            PBFE (Local4, Local5, Local6)
                            Local5++
                        }

                        PBFE (Local4, Local5, Zero)
                        Arg3 = Local4
                    }
                }

                Release (MUT0)
                Return (Local0)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XMRD (Arg0, Arg1, Arg2, Arg3))
            }
        }

        Method (SMWR, 4, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (!ECOK)
                {
                    Return (0xFF)
                }

                If ((Arg0 != 0x06))
                {
                    If ((Arg0 != 0x08))
                    {
                        If ((Arg0 != 0x0A))
                        {
                            If ((Arg0 != 0x46))
                            {
                                If ((Arg0 != 0xC6))
                                {
                                    Return (0x19)
                                }
                            }
                        }
                    }
                }

                Acquire (MUT0, 0xFFFF)
                Local0 = 0x04
                While ((Local0 > One))
                {
                    If ((Arg0 == 0x06))
                    {
                        SMB0 = Arg3
                    }

                    If ((Arg0 == 0x46))
                    {
                        SMB0 = Arg3
                    }

                    If ((Arg0 == 0xC6))
                    {
                        SMB0 = Arg3
                    }

                    If ((Arg0 == 0x08))
                    {
                        MW00 = Arg3
                        MW01 = (Arg3 >> 0x08)
                    }

                    If ((Arg0 == 0x0A))
                    {
                        WECB (0x04, 0x0100, Arg3)
                    }

                    SMST &= 0x40
                    SMCM = Arg2
                    SMAD = Arg1
                    SMPR = Arg0
                    Local3 = Zero
                    While (!Local1 = (SMST & 0xBF))
                    {
                        Sleep (0x02)
                        Local3++
                        If ((Local3 == 0x32))
                        {
                            SMST &= 0x40
                            SMCM = Arg2
                            SMAD = Arg1
                            SMPR = Arg0
                            Local3 = Zero
                        }
                    }

                    If ((Local1 == 0x80))
                    {
                        Local0 = Zero
                    }
                    Else
                    {
                        Local0--
                    }
                }

                If (Local0)
                {
                    Local0 = (Local1 & 0x1F)
                }

                Release (MUT0)
                Return (Local0)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XMWR (Arg0, Arg1, Arg2, Arg3))
            }
        }
    }

    Scope (\_SB.BAT0)
    {
        Method (_BST, 0, NotSerialized)  // _BST: Battery Status
        {
            If (_OSI ("Darwin"))
            {
                If ((^^PCI0.LPCB.EC0.ECOK == One))
                {
                    If (^^PCI0.LPCB.EC0.MBTS)
                    {
                        UPBS ()
                    }
                    Else
                    {
                        IVBS ()
                    }
                }
                Else
                {
                    IVBS ()
                }

                Return (PBST) /* External reference */
            }
            Else
            {
                Return (\_SB.BAT0.XBST ())
            }
        }

        Method (UPBI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Local5 = B1B2 (^^PCI0.LPCB.EC0.FCC0, ^^PCI0.LPCB.EC0.FCC1)
                If ((Local5 && !(Local5 & 0x8000)))
                {
                    Local5 >>= 0x05
                    Local5 <<= 0x05
                    PBIF [One] = Local5
                    PBIF [0x02] = Local5
                    Local2 = (Local5 / 0x64)
                    Local2 += One
                    If ((B1B2 (^^PCI0.LPCB.EC0.ADC0, ^^PCI0.LPCB.EC0.ADC1) < 0x0C80))
                    {
                        Local4 = (Local2 * 0x0E)
                        PBIF [0x05] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x09)
                        PBIF [0x06] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x0C)
                    }
                    Else
                    {
                        Local4 = (Local2 * 0x0C)
                        PBIF [0x05] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x07)
                        PBIF [0x06] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x0A)
                    }

                    FABL = (Local4 + 0x02)
                }

                If (^^PCI0.LPCB.EC0.MBNH)
                {
                    Local0 = ^^PCI0.LPCB.EC0.BVLB /* External reference */
                    Local1 = ^^PCI0.LPCB.EC0.BVHB /* External reference */
                    Local1 <<= 0x08
                    Local0 |= Local1
                    PBIF [0x04] = Local0
                    PBIF [0x09] = "OANI$"
                    PBIF [0x0B] = "NiMH"
                }
                Else
                {
                    Local0 = ^^PCI0.LPCB.EC0.BVLB /* External reference */
                    Local1 = ^^PCI0.LPCB.EC0.BVHB /* External reference */
                    Local1 <<= 0x08
                    Local0 |= Local1
                    PBIF [0x04] = Local0
                    Sleep (0x32)
                    PBIF [0x0B] = "LION"
                }

                PBIF [0x09] = "Primary"
                UPUM ()
                PBIF [Zero] = One
            }
            Else
            {
                \_SB.BAT0.XPBI ()
            }
        }

        Method (UPBS, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Local0 = B1B2 (^^PCI0.LPCB.EC0.CUR0, ^^PCI0.LPCB.EC0.CUR1)
                If ((Local0 & 0x8000))
                {
                    If ((Local0 == 0xFFFF))
                    {
                        PBST [One] = 0xFFFFFFFF
                    }
                    Else
                    {
                        Local1 = ~Local0
                        Local1++
                        Local3 = (Local1 & 0xFFFF)
                        PBST [One] = Local3
                    }
                }
                Else
                {
                    PBST [One] = Local0
                }

                Local5 = B1B2 (^^PCI0.LPCB.EC0.BRM0, ^^PCI0.LPCB.EC0.BRM1)
                If (!(Local5 & 0x8000))
                {
                    Local5 >>= 0x05
                    Local5 <<= 0x05
                    If ((Local5 != DerefOf (PBST [0x02])))
                    {
                        PBST [0x02] = Local5
                    }
                }

                If ((!^^PCI0.LPCB.EC0.SW2S && (^^PCI0.LPCB.EC0.BACR == One)))
                {
                    PBST [0x02] = FABL /* External reference */
                }

                PBST [0x03] = B1B2 (^^PCI0.LPCB.EC0.BCV0, ^^PCI0.LPCB.EC0.BCV1)
                PBST [Zero] = ^^PCI0.LPCB.EC0.MBST /* External reference */
            }
            Else
            {
                \_SB.BAT0.XPBS ()
            }
        }
    }

    Scope (\_SB.PCI0.ACEL)
    {
        Method (ADJT, 0, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                If (_STA ())
                {
                    If ((^^LPCB.EC0.ECOK == One))
                    {
                        Local0 = ^^LPCB.EC0.SW2S /* External reference */
                    }
                    Else
                    {
                        Local0 = PWRS /* External reference */
                    }

                    If (((^^^LID0._LID () == Zero) && (Local0 == Zero)))
                    {
                        If ((CNST != One))
                        {
                            CNST = One
                            Sleep (0x0BB8)
                            ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x36, 0x14)
                            ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x37, 0x10)
                            ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x34, 0x2A)
                            ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x24, Zero)
                            ^^LPCB.EC0.PLGS = Zero
                            ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x22, 0x20)
                        }
                    }
                    ElseIf ((CNST != Zero))
                    {
                        CNST = Zero
                        ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x36, One)
                        ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x37, 0x50)
                        ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x34, 0x7F)
                        ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x24, 0x02)
                        ^^LPCB.EC0.PLGS = One
                        ^^LPCB.EC0.SMWR (0xC6, 0x50, 0x22, 0x40)
                    }
                }
            }
            Else
            {
                \_SB.PCI0.ACEL.XDJT ()
            }
        }

        Method (CLRI, 0, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Local0 = Zero
                If ((^^LPCB.EC0.ECOK == One))
                {
                    If ((^^LPCB.EC0.SW2S == Zero))
                    {
                        If ((^^^BAT0._STA () == 0x1F))
                        {
                            If ((B1B2 (^^LPCB.EC0.BRM0, ^^LPCB.EC0.BRM1) <= 0x96))
                            {
                                Local0 = One
                            }
                        }
                    }
                }

                Return (Local0)
            }
            Else
            {
                Return (\_SB.PCI0.ACEL.XLRI ())
            }
        }
    }
}

