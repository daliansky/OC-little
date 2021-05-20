```swift
// battery
DefinitionBlock ("", "SSDT", 2, "OCLT", "BATT", 0)
{
    External (_SB.PCI0.LPCB.EC, DeviceObj)
    External (_SB.PCI0.LPCB.EC.AC._PSR, MethodObj)
    External (_SB.PCI0.LPCB.EC.B0I0, IntObj)
    External (_SB.PCI0.LPCB.EC.B0I1, IntObj)
    External (_SB.PCI0.LPCB.EC.B0I2, IntObj)
    External (_SB.PCI0.LPCB.EC.B0I3, IntObj)
    External (_SB.PCI0.LPCB.EC.B1I0, IntObj)
    External (_SB.PCI0.LPCB.EC.B1I1, IntObj)
    External (_SB.PCI0.LPCB.EC.B1I2, IntObj)
    External (_SB.PCI0.LPCB.EC.B1I3, IntObj)
    External (_SB.PCI0.LPCB.EC.BATM, MutexObj)
    External (_SB.PCI0.LPCB.EC.BATW, MethodObj)
    External (_SB.PCI0.LPCB.EC.BSWA, IntObj)
    External (_SB.PCI0.LPCB.EC.BSWR, IntObj)
    External (_SB.PCI0.LPCB.EC.HB0S, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC.HB1S, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC.HIID, FieldUnitObj)
    //
    External(_SB.PCI0.LPCB.EC.XBIF, MethodObj)
    External(_SB.PCI0.LPCB.EC.XBIX, MethodObj)
    External(_SB.PCI0.LPCB.EC.XBST, MethodObj)
    External(_SB.PCI0.LPCB.EC.XJTP, MethodObj)

    Method (B1B2, 2, NotSerialized)
    {
        Local0 = (Arg1 << 0x08)
        Local0 |= Arg0
        Return (Local0)
    }

    Method (B1B4, 4, NotSerialized)
    {
        Local0 = Arg3
        Local0 = (Arg2 | (Local0 << 0x08))
        Local0 = (Arg1 | (Local0 << 0x08))
        Local0 = (Arg0 | (Local0 << 0x08))
        Return (Local0)
    }

    Scope (\_SB.PCI0.LPCB.EC)
    {
        Method (RE1B, 1, NotSerialized)
		{
			OperationRegion (ECOR, EmbeddedControl, Arg0, One)
			Field (ECOR, ByteAcc, NoLock, Preserve)
			{
				BYTE,   8
			}

			Return (BYTE)
		}

		Method (RECB, 2, Serialized)
		{
			Arg1 >>= 0x03
			Name (TEMP, Buffer (Arg1){})
			Arg1 += Arg0
			Local0 = Zero
			While ((Arg0 < Arg1))
			{
				TEMP [Local0] = RE1B (Arg0)
				Arg0++
				Local0++
			}

			Return (TEMP)
		}

		OperationRegion (BRAM, EmbeddedControl, Zero, 0x0100)
		Field (BRAM, ByteAcc, NoLock, Preserve)
		{
			Offset (0xA0), 
			RC00,   8, RC01,   8,      //SBRC,   16,
			FC00,   8, FC01,   8,      //SBFC,   16,
			,   16, 
			,   16, 
			AC00,   8, AC01,   8,      //SBAC,   16,
			BV00,   8, BV01,   8,      //SBVO,   16,
		    ,   16, 
			,   16
		}

		Field (BRAM, ByteAcc, NoLock, Preserve)
		{
			Offset (0xA0), 
			SB00,   8, SB01,   8,      //SBBM,   16,
			,   16, 
			CC00,   8, CC01,   8,     //SBCC,   16 //E470,T470S
		}

		Field (BRAM, ByteAcc, NoLock, Preserve)
		{
			Offset (0xA0), 
			DC00,   8, DC01,   8,      //SBDC,   16,
			DV00,   8, DV01,   8,      //SBDV,   16,
			,   16, 
			,   16, 
			,   16, 
			SN00,   8, SN01,   8       //SBSN,   16
		}

		Field (BRAM, ByteAcc, NoLock, Preserve)
		{
			Offset (0xA0), 
			CH00,   8, CH01,   8, CH02,   8, CH03,   8 //SBCH,   32
		}

        Method (GBIF, 3, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Acquire (BATM, 0xFFFF)
                If (Arg2)
                {
                    HIID = (Arg0 | One)
                    Local7 = B1B2 (SB00, SB01)
                    Local7 >>= 0x0F
                    Arg1 [Zero] = (Local7 ^ One)
                    HIID = Arg0
                    If (Local7)
                    {
                        Local1 = (B1B2 (FC00, FC01) * 0x0A)
                    }
                    Else
                    {
                        Local1 = B1B2 (FC00, FC01)
                    }

                    Arg1 [0x02] = Local1
                    HIID = (Arg0 | 0x02)
                    If (Local7)
                    {
                        Local0 = (B1B2 (DC00, DC01) * 0x0A)
                    }
                    Else
                    {
                        Local0 = B1B2 (DC00, DC01)
                    }

                    Arg1 [One] = Local0
                    Divide (Local1, 0x14, Local2, Arg1 [0x05])
                    If (Local7)
                    {
                        Arg1 [0x06] = 0xC8
                    }
                    ElseIf (B1B2 (DV00, DV01))
                    {
                        Divide (0x00030D40, B1B2 (DV00, DV01), Local2, Arg1 [0x06])
                    }
                    Else
                    {
                        Arg1 [0x06] = Zero
                    }

                    Arg1 [0x04] = B1B2 (DV00, DV01)
                    Local0 = B1B2 (SN00, SN01)
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
                    Arg1 [0x09] = RECB (0xA0, 0x80)
                    HIID = (Arg0 | 0x04)
                    Name (BTYP, Buffer (0x05)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00
                    })
                    BTYP = B1B4 (CH00, CH01, CH02, CH03)
                    Arg1 [0x0B] = BTYP
                    HIID = (Arg0 | 0x05)
                    Arg1 [0x0C] = RECB (0xA0, 0x80)
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

        Method (GBIX, 3, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Acquire (BATM, 0xFFFF)
                If (Arg2)
                {
                    HIID = (Arg0 | One)
                    Local7 = B1B2 (CC00, CC01)
                    Arg1 [0x08] = Local7
                    Local7 = B1B2 (SB00, SB01)
                    Local7 >>= 0x0F
                    Arg1 [One] = (Local7 ^ One)
                    HIID = Arg0
                    If (Local7)
                    {
                        Local1 = (B1B2 (FC00, FC01) * 0x0A)
                    }
                    Else
                    {
                        Local1 = B1B2 (FC00, FC01)
                    }

                    Arg1 [0x03] = Local1
                    HIID = (Arg0 | 0x02)
                    If (Local7)
                    {
                        Local0 = (B1B2 (DC00, DC01) * 0x0A)
                    }
                    Else
                    {
                        Local0 = B1B2 (DC00, DC01)
                    }

                    Arg1 [0x02] = Local0
                    Divide (Local1, 0x14, Local2, Arg1 [0x06])
                    If (Local7)
                    {
                        Arg1 [0x07] = 0xC8
                    }
                    ElseIf (B1B2 (DV00, DV01))
                    {
                        Divide (0x00030D40, B1B2 (DV00, DV01), Local2, Arg1 [0x07])
                    }
                    Else
                    {
                        Arg1 [0x07] = Zero
                    }

                    Arg1 [0x05] = B1B2 (DV00, DV01)
                    Local0 = B1B2 (SN00, SN01)
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
                    Arg1 [0x10] = RECB (0xA0, 0x80)
                    HIID = (Arg0 | 0x04)
                    Name (BTYP, Buffer (0x05)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00
                    })
                    BTYP = B1B4 (CH00, CH01, CH02, CH03)
                    Arg1 [0x12] = BTYP
                    HIID = (Arg0 | 0x05)
                    Arg1 [0x13] = RECB (0xA0, 0x80)
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

        Method (GBST, 4, NotSerialized)
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

                If ((Arg1 & 0x07)){}
                Else
                {
                    Local0 |= 0x04
                }

                If (((Arg1 & 0x07) == 0x07))
                {
                    Local0 = 0x04
                    Local1 = Zero
                    Local2 = Zero
                    Local3 = Zero
                }
                Else
                {
                    HIID = Arg0
                    Local3 = B1B2 (BV00, BV01)
                    If (Arg2)
                    {
                        Local2 = (B1B2 (RC00, RC01) * 0x0A)
                    }
                    Else
                    {
                        Local2 = B1B2 (RC00, RC01)
                    }

                    Local1 = B1B2 (AC00, AC01)
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
                BSWA |= BSWR
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
                            Arg3 [Zero] = B0I0
                            Arg3 [One] = B0I1
                            Arg3 [0x02] = B0I2
                            Arg3 [0x03] = B0I3
                        }
                        Else
                        {
                            Arg3 [Zero] = B1I0
                            Arg3 [One] = B1I1
                            Arg3 [0x02] = B1I2
                            Arg3 [0x03] = B1I3
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

        Method (AJTP, 3, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Local0 = Arg1
                Acquire (BATM, 0xFFFF)
                HIID = Arg0
                Local1 = B1B2 (RC00, RC01)
                Release (BATM)
                If ((Arg0 == Zero))
                {
                    Local2 = HB0S
                }
                Else
                {
                    Local2 = HB1S
                }

                If ((Local2 & 0x20))
                {
                    If ((Arg2 > Zero))
                    {
                        Local0 += One
                    }

                    If ((Local0 <= Local1))
                    {
                        Local0 = (Local1 + One)
                    }
                }
                ElseIf ((Local2 & 0x40))
                {
                    If ((Local0 >= Local1))
                    {
                        Local0 = (Local1 - One)
                    }
                }

                Return (Local0)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC.XJTP(Arg0, Arg1, Arg2))
            }
        }
    }
}
```

