// battery
// In config ACPI, GBIF03 to XBIF03
// Find:     47424946 03
// Replace:  58424946 03
//
// In config ACPI, GBST0C to XBST0C
// Find:     47425354 0C
// Replace:  58425354 0C
//
// In config ACPI, GBIX0B to XBIX0B
// Find:     47424958 0B
// Replace:  58424958 0B
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "BAT0", 0)
{
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.AC._PSR, MethodObj)
    External(_SB.PCI0.LPCB.EC.BSWR, IntObj)
    External(_SB.PCI0.LPCB.EC.BSWA, IntObj)
    External(_SB.PCI0.LPCB.EC.BATM, MutexObj)
    External(_SB.PCI0.LPCB.EC.HIID, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.B0I0, IntObj)
    External(_SB.PCI0.LPCB.EC.B0I1, IntObj)
    External(_SB.PCI0.LPCB.EC.B0I2, IntObj)
    External(_SB.PCI0.LPCB.EC.B0I3, IntObj)
    External(_SB.PCI0.LPCB.EC.B1I0, IntObj)
    External(_SB.PCI0.LPCB.EC.B1I1, IntObj)
    External(_SB.PCI0.LPCB.EC.B1I2, IntObj)
    External(_SB.PCI0.LPCB.EC.B1I3, IntObj)
    //
    External(_SB.PCI0.LPCB.EC.XBIF, MethodObj)
    External(_SB.PCI0.LPCB.EC.XBIX, MethodObj)
    External(_SB.PCI0.LPCB.EC.XBST, MethodObj)

    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)

    }
    Method (B1B4, 4, NotSerialized)
    {
        Store (Arg3, Local0)
        Or (Arg2, ShiftLeft (Local0, 0x08), Local0)
        Or (Arg1, ShiftLeft (Local0, 0x08), Local0)
        Or (Arg0, ShiftLeft (Local0, 0x08), Local0)
        Return (Local0)
    }
    Scope(\_SB.PCI0.LPCB.EC)
    {    
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
            Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Return(BYTE)
        }
        Method (RECB, 2, Serialized)
        {
            ShiftRight(Arg1, 3, Arg1)
            Name(TEMP, Buffer(Arg1) { })
            Add(Arg0, Arg1, Arg1)
            Store(0, Local0)
            While (LLess(Arg0, Arg1))
            {
                Store(RE1B(Arg0), Index(TEMP, Local0))
                Increment(Arg0)
                Increment(Local0)
            }
            Return(TEMP)
        }
        OperationRegion (BRAM, EmbeddedControl, 0x00, 0x0100)            
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0), 
            BRCA,8,BRCB,8,     //SBRC,   16,
            BFC0,8,BFC1,8,     //SBFC,   16,s2
                               //SBAE,   16, 
                               //SBRS,   16, 
            Offset (0xA8),
            BAC0,8,BAC1,8,     //SBAC,   16,s2
            BVO0,8,BVO1,8,     //SBVO,   16,
                               //SBAF,   16, 
                               //SBBS,   16
        }
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0), 
            BBM0,8,BBM1,8,     //SBBM,   16,
                               //SBMD,   16, 
            Offset (0xA4),
            BC00,8,BC01,8,     //SBCC,   16 //E470,T470S
                
        }
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0), 
            BDC0,8,BDC1,8,     //SBDC,   16,s2
            BDV0,8,BDV1,8,     //SBDV,   16,s2
                               //SBOM,   16, 
                               //SBSI,   16, 
                               //SBDT,   16, 
            Offset (0xAA),
            BSN0,8,BSN1,8      //SBSN,   16,s2
        }
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0), 
            BCH0,8,BCH1,8,BCH2,8,BCH3,8 //SBCH,   32
        }

        Method (GBIF, 3, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Acquire (BATM, 0xFFFF)
                If (Arg2)
                {
                    HIID = (Arg0 | One)
                    Local7 = B1B2 (BBM0, BBM1)
                    Local7 >>= 0x0F                
                    Arg1 [Zero] = (Local7 ^ One)
                    HIID = Arg0
                    If (Local7)
                    {
                        Multiply (B1B2 (BFC0, BFC1), 0x0A, Local1)
                    }
                    Else
                    {
                        Local1 = B1B2 (BFC0, BFC1)
                    }

                    Arg1 [0x02] = Local1
                    HIID = (Arg0 | 0x02)
                    If (Local7)
                    {
                        Multiply (B1B2 (BDC0, BDC1), 0x0A, Local0)
                    }
                    Else
                    {
                        Local0 = B1B2 (BDC0, BDC1)
                    }

                    Arg1 [One] = Local0
                    Divide (Local1, 0x14, Local2, Arg1 [0x05])
                    If (Local7)
                    {
                        Arg1 [0x06] = 0xC8
                    }
                    ElseIf (B1B2 (BDV0, BDV1))
                    {
                        Divide (0x00030D40, B1B2 (BDV0, BDV1), Local2, Index (Arg1, 0x06))
                    }
                    Else
                    {
                        Arg1 [0x06] = Zero
                    }

                    Arg1 [0x04] = B1B2 (BDV0, BDV1)
                    Local0 = B1B2 (BSN0, BSN1)
                    Name (SERN, Buffer (0x06)
                    {
                        "     "
                    })
                    Local2 = 0x04
                    While (Local0)
                    {
                        Divide (Local0, 0x0A, Local1, Local0)
                        SERN [Local2] = (Local1 + 0x30)
                        Local2--
                    }

                    Arg1 [0x0A] = SERN
                    HIID = (Arg0 | 0x06)
                    Arg1 [0x09] = RECB(0xA0,128) //Arg1 [0x09] = SBDN
                    HIID = (Arg0 | 0x04)
                    Name (BTYP, Buffer (0x05)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00                   
                    })
                    BTYP = B1B4 (BCH0, BCH1, BCH2, BCH3)
                    Arg1 [0x0B] = BTYP
                    HIID = (Arg0 | 0x05)
                    Arg1 [0x0C] = RECB(0xA0,128) //Arg1 [0x0C] = SBMN
                }
                Else
                {
                    Arg1 [One] = 0xFFFFFFFF
                    Arg1 [0x05] = Zero
                    Arg1 [0x06] = Zero
                    Arg1 [0x02] = 0xFFFFFFFF
                }
            
                Release (BATM)
                Return (Arg1)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC.XBIF(Arg0, Arg1, Arg2))
            }
        }
        
        Method (GBIX, 3, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Acquire (BATM, 0xFFFF)
                If (Arg2)
                {
                    HIID = (Arg0 | One)
                    Local7 = B1B2 (BC00, BC01)
                    Arg1 [0x08] = Local7
                    Local7 = B1B2 (BBM0, BBM1)
                    Local7 >>= 0x0F                
                    Arg1 [One] = (Local7 ^ One)
                    HIID = Arg0
                    If (Local7)
                    {
                        Multiply (B1B2 (BFC0, BFC1), 0x0A, Local1)
                    }
                    Else
                    {
                        Local1 = B1B2 (BFC0, BFC1)
                    }

                    Arg1 [0x03] = Local1
                    HIID = (Arg0 | 0x02)
                    If (Local7)
                    {
                        Multiply (B1B2 (BDC0, BDC1), 0x0A, Local0)
                    }
                    Else
                    {
                        Local0 = B1B2 (BDC0, BDC1)
                    }

                    Arg1 [0x02] = Local0
                    Divide (Local1, 0x14, Local2, Arg1 [0x06])
                    If (Local7)
                    {
                        Arg1 [0x07] = 0xC8
                    }
                    ElseIf (B1B2 (BDV0, BDV1))
                    {
                        Divide (0x00030D40, B1B2 (BDV0, BDV1), Local2, Index (Arg1, 0x07))
                    }
                    Else
                    {
                        Arg1 [0x07] = Zero
                    }

                    Arg1 [0x05] = B1B2 (BDV0, BDV1)
                    Local0 = B1B2 (BSN0, BSN1)
                    Name (SERN, Buffer (0x06)
                    {
                        "     "
                    })
                    Local2 = 0x04
                    While (Local0)
                    {
                        Divide (Local0, 0x0A, Local1, Local0)
                        SERN [Local2] = (Local1 + 0x30)
                        Local2--
                    }

                    Arg1 [0x11] = SERN
                    HIID = (Arg0 | 0x06)
                    Arg1 [0x10] = RECB(0xA0,128) //Arg1 [0x10] = SBDN
                    HIID = (Arg0 | 0x04)
                    Name (BTYP, Buffer (0x05)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00                   
                    })
                    BTYP = B1B4 (BCH0, BCH1, BCH2, BCH3)
                    Arg1 [0x12] = BTYP
                    HIID = (Arg0 | 0x05)
                    Arg1 [0x13] = RECB(0xA0,128) //Arg1 [0x13] = SBMN
                }
                Else
                {
                    Arg1 [0x02] = 0xFFFFFFFF
                    Arg1 [0x06] = Zero
                    Arg1 [0x07] = Zero
                    Arg1 [0x03] = 0xFFFFFFFF
                }
            
                Release (BATM)
                Return (Arg1)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC.XBIX(Arg0, Arg1, Arg2))
            }
        
        }

        Method (GBST, 4, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Acquire (BATM, 0xFFFF)
                If ((Arg1 & 0x20))
                {
                    Local0 = 0x02
                }
                ElseIf ((Arg1 & 0x40))
                {
                    Local0 = One
                }
                Else
                {
                    Local0 = Zero
                }

                If (And (Arg1, 0x07)) {}
                Else
                {
                    Local0 |= 0x04
                }

                If (((Arg1 & 0x07) == 0x07))
                {
                    Local1 = 0xFFFFFFFF
                    Local2 = 0xFFFFFFFF
                    Local3 = 0xFFFFFFFF
                }
                Else
                {
                    HIID = Arg0
                    Local3 = B1B2 (BVO0, BVO1)
                    If (Arg2)
                    {
                        Local2 = (B1B2 (BRCA, BRCB) * 0x0A)
                    }
                    Else
                    {
                        Local2 = B1B2 (BRCA, BRCB)
                    }

                    Local1 = B1B2 (BAC0, BAC1)
                    If ((Local1 >= 0x8000))
                    {
                        If ((Local0 & One))
                        {
                            Local1 = (0x00010000 - Local1)
                        }
                        Else
                        {
                            Local1 = Zero
                        }
                    }
                    ElseIf (!(Local0 & 0x02))
                    {
                        Local1 = Zero
                    }

                    If (Arg2)
                    {
                        Local1 *= Local3
                        Divide (Local1, 0x03E8, Local7, Local1)
                    }
                }

                Local5 = (One << (Arg0 >> 0x04))
                BSWA |= BSWR /* \_SB_.PCI0.LPCB.EC__.BSWR */
                If (((BSWA & Local5) == Zero))
                {
                    Arg3 [Zero] = Local0
                    Arg3 [One] = Local1
                    Arg3 [0x02] = Local2
                    Arg3 [0x03] = Local3
                    If ((Arg0 == Zero))
                    {
                        B0I0 = Local0
                        B0I1 = Local1
                        B0I2 = Local2
                        B0I3 = Local3
                    }
                    Else
                    {
                        B1I0 = Local0
                        B1I1 = Local1
                        B1I2 = Local2
                        B1I3 = Local3
                    }
                }
                Else
                {
                    If (\_SB.PCI0.LPCB.EC.AC._PSR ())
                    {
                        If ((Arg0 == Zero))
                        {
                            Arg3 [Zero] = \_SB.PCI0.LPCB.EC.B0I0
                            Arg3 [One] = \_SB.PCI0.LPCB.EC.B0I1
                            Arg3 [0x02] = \_SB.PCI0.LPCB.EC.B0I2
                            Arg3 [0x03] = \_SB.PCI0.LPCB.EC.B0I3
                        }
                        Else
                        {
                            Arg3 [Zero] = \_SB.PCI0.LPCB.EC.B1I0
                            Arg3 [One] = \_SB.PCI0.LPCB.EC.B1I1
                            Arg3 [0x02] = \_SB.PCI0.LPCB.EC.B1I2
                            Arg3 [0x03] = \_SB.PCI0.LPCB.EC.B1I3
                        }
                    }
                    Else
                    {
                        Arg3 [Zero] = Local0
                        Arg3 [One] = Local1
                        Arg3 [0x02] = Local2
                        Arg3 [0x03] = Local3
                    }

                    If ((((Local0 & 0x04) == Zero) && ((Local2 > Zero) && 
                        (Local3 > Zero))))
                    {
                        BSWA &= ~Local5
                        Arg3 [Zero] = Local0
                        Arg3 [One] = Local1
                        Arg3 [0x02] = Local2
                        Arg3 [0x03] = Local3
                    }
                }

                Release (BATM)
                Return (Arg3)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC.XBST(Arg0, Arg1, Arg2, Arg3))
            }
        }
    }
}
//EOF

