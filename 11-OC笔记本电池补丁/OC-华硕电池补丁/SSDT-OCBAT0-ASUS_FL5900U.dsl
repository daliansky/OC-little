// battery
// In config ACPI, _BIX renamed XBIX
// Find:     5F 42 49 58
// Replace:  58 42 49 58
//
// In config ACPI, SMBR renamed XMBR
// Find:     53 4D 42 52 0B
// Replace:  58 4D 42 52 0B
//
// In config ACPI, SMBW renamed XMBW
// Find:     53 4D 42 57 0D
// Replace:  58 4D 42 57 0D
//
// In config ACPI, ECSB renamed XCSB
// Find:     45 43 53 42 07
// Replace:  58 43 53 42 07
//
DefinitionBlock ("", "SSDT", 2, "ACDT", "BAT0", 0)
{
    External(_SB.PCI0.BAT0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.BATP, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GBTT, MethodObj)
    External(_SB.PCI0.BAT0._BIF, MethodObj)
    External(_SB.PCI0.BAT0.XBIX, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XMBR, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XMBW, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XCSB, MethodObj)
    
    External(_SB.PCI0.BAT0.NBIX, PkgObj)
    External(_SB.PCI0.BAT0.PBIF, PkgObj)
    External(_SB.PCI0.BAT0.BIXT, PkgObj)
    //
    External(_SB.PCI0.LPCB.EC0.ECAV, MethodObj)
    External(_SB.PCI0.LPCB.EC0.RDBL, IntObj)
    External(_SB.PCI0.LPCB.EC0.RDWD, IntObj)
    External(_SB.PCI0.LPCB.EC0.RDBT, IntObj)
    External(_SB.PCI0.LPCB.EC0.RCBT, IntObj)
    External(_SB.PCI0.LPCB.EC0.RDQK, IntObj)
    External(_SB.PCI0.LPCB.EC0.WRBL, IntObj)
    External(_SB.PCI0.LPCB.EC0.WRWD, IntObj)
    External(_SB.PCI0.LPCB.EC0.WRBT, IntObj)
    External(_SB.PCI0.LPCB.EC0.SDBT, IntObj)
    External(_SB.PCI0.LPCB.EC0.WRQK, IntObj)
    External(_SB.PCI0.LPCB.EC0.SBBY, IntObj)
    //
    External(_SB.PCI0.LPCB.EC0.MUEC, MutexObj)
    External(_SB.PCI0.LPCB.EC0.PRTC, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.ADDR, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.CMDB, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BCNT, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.DAT0, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.DAT1, FieldUnitObj)
    
    External(_SB.PCI0.LPCB.EC0.PRT2, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.ADD2, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.CMD2, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BCN2, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.DA20, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.DA21, FieldUnitObj)
        
    External(_SB.PCI0.LPCB.EC0.SSTS, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.SST2, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.SWTC, MethodObj)
    //
    
    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }
    
    Scope(_SB.PCI0.LPCB.EC0)
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
        
        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
            Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Store(Arg1, BYTE)
        }
        Method (WECB, 3, Serialized)
        {
            ShiftRight(Arg1, 3, Arg1)
            Name(TEMP, Buffer(Arg1) { })
            Store(Arg2, TEMP)
            Add(Arg0, Arg1, Arg1)
            Store(0, Local0)
            While (LLess(Arg0, Arg1))
            {
                WE1B(Arg0, DerefOf(Index(TEMP, Local0)))
                Increment(Arg0)
                Increment(Local0)
            }
        }
        
        OperationRegion (BAM0, EmbeddedControl, 0x00, 0xFF)           
        Field (BAM0, ByteAcc, Lock, Preserve)
        {
            Offset (0xBE), 
                ,16,
                ,16,
                ,16,
            B030,8,B031,8,    //B0C3,   16,
        }       
        OperationRegion (BAM1, EmbeddedControl, 0x18, 0x28)
        Field (BAM1, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            XXXX,    256,     //BDAT,   256,
        }
        Field (BAM1, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            DT20,8,DT21,8,    //DT2B,   16
        }
        
        OperationRegion (BAM2, EmbeddedControl, 0x40, 0x28)
        Field (BAM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            YYYY,    256,     //BDA2,   256,
        }
    }
        
    Scope(_SB.PCI0.BAT0)
    {      
        Method (_BIX, 0, NotSerialized)
        {
          If (_OSI ("Darwin"))
          {
            If (LNot (^^LPCB.EC0.BATP (Zero)))
            {
                Return (\_SB.PCI0.BAT0.NBIX)
            }

            If (LEqual (^^LPCB.EC0.GBTT (Zero), 0xFF))
            {
                Return (\_SB.PCI0.BAT0.NBIX)
            }

            _BIF ()
                BIXT [One] = DerefOf (PBIF [Zero])
                BIXT [0x02] = DerefOf (PBIF [One])
                BIXT [0x03] = DerefOf (PBIF [0x02])
                BIXT [0x04] = DerefOf (PBIF [0x03])
                BIXT [0x05] = DerefOf (PBIF [0x04])
                BIXT [0x06] = DerefOf (PBIF [0x05])
                BIXT [0x07] = DerefOf (PBIF [0x06])
                BIXT [0x0E] = DerefOf (PBIF [0x07])
                BIXT [0x0F] = DerefOf (PBIF [0x08])
                BIXT [0x10] = DerefOf (PBIF [0x09])
                BIXT [0x11] = DerefOf (PBIF [0x0A])
                BIXT [0x12] = DerefOf (PBIF [0x0B])
                BIXT [0x13] = DerefOf (PBIF [0x0C])
            If ((DerefOf (BIXT [One]) == One))
            {
                    BIXT [One] = Zero
                    Local0 = DerefOf (BIXT [0x05])
                    BIXT [0x02] = (DerefOf (BIXT [0x02]) * Local0)
                    BIXT [0x03] = (DerefOf (BIXT [0x03]) * Local0)
                    BIXT [0x06] = (DerefOf (BIXT [0x06]) * Local0)
                    BIXT [0x07] = (DerefOf (BIXT [0x07]) * Local0)
                    BIXT [0x0E] = (DerefOf (BIXT [0x0E]) * Local0)
                    BIXT [0x0F] = (DerefOf (BIXT [0x0F]) * Local0)
                    Divide (DerefOf (BIXT [0x02]), 0x03E8, Local0, BIXT [0x02])
                    Divide (DerefOf (BIXT [0x03]), 0x03E8, Local0, BIXT [0x03])
                    Divide (DerefOf (BIXT [0x06]), 0x03E8, Local0, BIXT [0x06])
                    Divide (DerefOf (BIXT [0x07]), 0x03E8, Local0, BIXT [0x07])
                    Divide (DerefOf (BIXT [0x0E]), 0x03E8, Local0, BIXT [0x0E])
                    Divide (DerefOf (BIXT [0x0F]), 0x03E8, Local0, BIXT [0x0F])
            }

            BIXT [0x08] = B1B2 (^^LPCB.EC0.B030, ^^LPCB.EC0.B031)
            BIXT [0x09] = 0x0001869F
            Return (\_SB.PCI0.BAT0.BIXT)
          }
          Else
          {
            Return (\_SB.PCI0.BAT0.XBIX())
          }
        }
    }
    //
    Scope(\_SB.PCI0.LPCB.EC0)
    {
        Method (SMBR, 3, Serialized)
        {
          If (_OSI ("Darwin"))
          {
            Store (Package (0x03)
                {
                    0x07, 
                    Zero, 
                    Zero
                }, Local0)
            If (LNot (ECAV ()))
            {
                Return (Local0)
            }

            If (LNotEqual (Arg0, RDBL))
            {
                If (LNotEqual (Arg0, RDWD))
                {
                    If (LNotEqual (Arg0, RDBT))
                    {
                        If (LNotEqual (Arg0, RCBT))
                        {
                            If (LNotEqual (Arg0, RDQK))
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Store (\_SB.PCI0.LPCB.EC0.PRTC, Local1)
            Store (Zero, Local2)
            While (LNotEqual (Local1, Zero))
            {
                Stall (0x0A)
                Increment (Local2)
                If (LGreater (Local2, 0x03E8))
                {
                    Store (\_SB.PCI0.LPCB.EC0.SBBY, Index (Local0, Zero))
                    Store (Zero, Local1)
                }
                Else
                {
                    Store (\_SB.PCI0.LPCB.EC0.PRTC, Local1)
                }
            }

            If (LLessEqual (Local2, 0x03E8))
            {
                ShiftLeft (Arg1, One, Local3)
                Or (Local3, One, Local3)
                Store (Local3, ADDR)
                If (LNotEqual (Arg0, RDQK))
                {
                    If (LNotEqual (Arg0, RCBT))
                    {
                        Store (Arg2, CMDB)
                    }
                }

                WECB (0x04, 0x0100, Zero) //BDAT
                Store (Arg0, \_SB.PCI0.LPCB.EC0.PRTC)
                Store (SWTC (Arg0), Index (Local0, Zero))
                If (LEqual (DerefOf (Index (Local0, Zero)), Zero))
                {
                    If (LEqual (Arg0, RDBL))
                    {
                        Store (\_SB.PCI0.LPCB.EC0.BCNT, Index (Local0, One))
                        Store (RECB(0x04,0x100), Index (Local0, 0x02))//BDAT
                    }

                    If (LEqual (Arg0, RDWD))
                    {
                        Store (0x02, Index (Local0, One))
                        Store (B1B2 (\_SB.PCI0.LPCB.EC0.DT20, \_SB.PCI0.LPCB.EC0.DT21), Index (Local0, 0x02))
                        //DT2B
                    }

                    If (LEqual (Arg0, RDBT))
                    {
                        Store (One, Index (Local0, One))
                        Store (\_SB.PCI0.LPCB.EC0.DAT0, Index (Local0, 0x02))
                    }

                    If (LEqual (Arg0, RCBT))
                    {
                        Store (One, Index (Local0, One))
                        Store (\_SB.PCI0.LPCB.EC0.DAT0, Index (Local0, 0x02))
                    }
                }
            }

            Release (MUEC)
            Return (Local0)
          }
          Else
          {
            Return (\_SB.PCI0.LPCB.EC0.XMBR())
          }
        }
        
        Method (SMBW, 5, Serialized)
        {
          If (_OSI ("Darwin"))
          {
            Store (Package (0x01)
                {
                    0x07
                }, Local0)
            If (LNot (ECAV ()))
            {
                Return (Local0)
            }

            If (LNotEqual (Arg0, WRBL))
            {
                If (LNotEqual (Arg0, WRWD))
                {
                    If (LNotEqual (Arg0, WRBT))
                    {
                        If (LNotEqual (Arg0, SDBT))
                        {
                            If (LNotEqual (Arg0, WRQK))
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Store (\_SB.PCI0.LPCB.EC0.PRTC, Local1)
            Store (Zero, Local2)
            While (LNotEqual (Local1, Zero))
            {
                Stall (0x0A)
                Increment (Local2)
                If (LGreater (Local2, 0x03E8))
                {
                    Store (\_SB.PCI0.LPCB.EC0.SBBY, Index (Local0, Zero))
                    Store (Zero, Local1)
                }
                Else
                {
                    Store (\_SB.PCI0.LPCB.EC0.PRTC, Local1)
                }
            }

            If (LLessEqual (Local2, 0x03E8))
            {
                WECB (0x04, 0x0100, Zero) //BDAT
                ShiftLeft (Arg1, One, Local3)
                Store (Local3, ADDR)
                If (LNotEqual (Arg0, WRQK))
                {
                    If (LNotEqual (Arg0, SDBT))
                    {
                        Store (Arg2, CMDB)
                    }
                }

                If (LEqual (Arg0, WRBL))
                {
                    Store (Arg3, \_SB.PCI0.LPCB.EC0.BCNT)
                    WECB (0x04, 0x0100, Arg4) //BDAT
                }

                If (LEqual (Arg0, WRWD))
                {
                    Store (Arg4, B1B2 (\_SB.PCI0.LPCB.EC0.DT20, \_SB.PCI0.LPCB.EC0.DT21))   
                    //DT2B
                }

                If (LEqual (Arg0, WRBT))
                {
                    Store (Arg4, \_SB.PCI0.LPCB.EC0.DAT0)
                }

                If (LEqual (Arg0, SDBT))
                {
                    Store (Arg4, \_SB.PCI0.LPCB.EC0.DAT0)
                }

                Store (Arg0, \_SB.PCI0.LPCB.EC0.PRTC)
                Store (SWTC (Arg0), Index (Local0, Zero))
            }

            Release (MUEC)
            Return (Local0)
          }
          Else
          {
            Return (\_SB.PCI0.LPCB.EC0.XMBW())
          }
        }   
    
        Method (ECSB, 7, NotSerialized)
        {
          If (_OSI ("Darwin"))
          {
            Local1 = Package (0x05)
                {
                    0x11, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Buffer (0x20){}
                }
            If ((Arg0 > One))
            {
                Return (Local1)
            }

            If (ECAV ())
            {
                Acquire (MUEC, 0xFFFF)
                If ((Arg0 == Zero))
                {
                    Local0 = \_SB.PCI0.LPCB.EC0.PRTC /* \_SB_.PCI0.LPCB.EC0_.PRTC */
                }
                Else
                {
                    Local0 = \_SB.PCI0.LPCB.EC0.PRT2 /* \_SB_.PCI0.LPCB.EC0_.PRT2 */
                }

                Local2 = Zero
                While ((Local0 != Zero))
                {
                    Stall (0x0A)
                    Local2++
                    If ((Local2 > 0x03E8))
                    {
                        Local1 [Zero] = \_SB.PCI0.LPCB.EC0.SBBY /* \_SB_.PCI0.LPCB.EC0_.SBBY */
                        Local0 = Zero
                    }
                    ElseIf ((Arg0 == Zero))
                    {
                        Local0 = \_SB.PCI0.LPCB.EC0.PRTC /* \_SB_.PCI0.LPCB.EC0_.PRTC */
                    }
                    Else
                    {
                        Local0 = \_SB.PCI0.LPCB.EC0.PRT2 /* \_SB_.PCI0.LPCB.EC0_.PRT2 */
                    }
                }

                If ((Local2 <= 0x03E8))
                {
                    If ((Arg0 == Zero))
                    {
                        ADDR = Arg2
                        CMDB = Arg3
                        If (((Arg1 == 0x0A) || (Arg1 == 0x0B)))
                        {
                            \_SB.PCI0.LPCB.EC0.BCNT = DerefOf (Arg6 [Zero])
                            WECB (0x04, 0x0100, DerefOf (Arg6 [One])) //BDAT
                        }
                        Else
                        {
                            \_SB.PCI0.LPCB.EC0.DAT0 = Arg4
                            \_SB.PCI0.LPCB.EC0.DAT1 = Arg5
                        }

                        \_SB.PCI0.LPCB.EC0.PRTC = Arg1
                    }
                    Else
                    {
                        ADD2 = Arg2
                        CMD2 = Arg3
                        If (((Arg1 == 0x0A) || (Arg1 == 0x0B)))
                        {
                            \_SB.PCI0.LPCB.EC0.BCN2 = DerefOf (Arg6 [Zero])
                            WECB (0x04, 0x0100, DerefOf (Arg6 [One])) //BDA2
                        }
                        Else
                        {
                            \_SB.PCI0.LPCB.EC0.DA20 = Arg4
                            \_SB.PCI0.LPCB.EC0.DA21 = Arg5
                        }

                        \_SB.PCI0.LPCB.EC0.PRT2 = Arg1
                    }

                    Local0 = 0x7F
                    If ((Arg0 == Zero))
                    {
                        While (\_SB.PCI0.LPCB.EC0.PRTC)
                        {
                            Sleep (One)
                            Local0--
                        }
                    }
                    Else
                    {
                        While (\_SB.PCI0.LPCB.EC0.PRT2)
                        {
                            Sleep (One)
                            Local0--
                        }
                    }

                    If (Local0)
                    {
                        If ((Arg0 == Zero))
                        {
                            Local0 = \_SB.PCI0.LPCB.EC0.SSTS /* \_SB_.PCI0.LPCB.EC0_.SSTS */
                            Local1 [One] = \_SB.PCI0.LPCB.EC0.DAT0 /* \_SB_.PCI0.LPCB.EC0_.DAT0 */
                            Local1 [0x02] = \_SB.PCI0.LPCB.EC0.DAT1 /* \_SB_.PCI0.LPCB.EC0_.DAT1 */
                            Local1 [0x03] = \_SB.PCI0.LPCB.EC0.BCNT /* \_SB_.PCI0.LPCB.EC0_.BCNT */                            
                            Local1 [0x04] = RECB(0x04,0x100) //BDAT                            
                        }
                        Else
                        {
                            Local0 = \_SB.PCI0.LPCB.EC0.SST2 /* \_SB_.PCI0.LPCB.EC0_.SST2 */
                            Local1 [One] = \_SB.PCI0.LPCB.EC0.DA20 /* \_SB_.PCI0.LPCB.EC0_.DA20 */
                            Local1 [0x02] = \_SB.PCI0.LPCB.EC0.DA21 /* \_SB_.PCI0.LPCB.EC0_.DA21 */
                            Local1 [0x03] = \_SB.PCI0.LPCB.EC0.BCN2 /* \_SB_.PCI0.LPCB.EC0_.BCN2 */
                            Store (RECB(0x04,0x100), Local1 [0x04])//BDA2
                        }

                        Local0 &= 0x1F
                        If (Local0)
                        {
                            Local0 += 0x10
                        }

                        Local1 [Zero] = Local0
                    }
                    Else
                    {
                        Local1 [Zero] = 0x10
                    }
                }

                Release (MUEC)
            }

            Return (Local1)
          }
          Else
          {
            Return (\_SB.PCI0.LPCB.EC0.XCSB())
          }
        }
    }
}
//EOF

