// battery
// In config ACPI, _BIF renamed XBIF
// Find:     5F 42 49 46
// Replace:  58 42 49 46
//
// In config ACPI, _BST renamed XBST
// Find:     5F 42 53 54
// Replace:  58 42 53 54
//
DefinitionBlock ("", "SSDT", 2, "ACDT", "BAT1", 0)
{
    External(_SB.PCI0.LPCB.H_EC, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC.BAT1, DeviceObj)
    External(_SB.PCI0.LPCB.H_EC.BAT1.XBIF, MethodObj)
    External(_SB.PCI0.LPCB.H_EC.BAT1.XBST, MethodObj)
    External(_SB.PCI0.LPCB.H_EC.BAT1.POSW, MethodObj)
    External(_SB.PCI0.LPCB.H_EC.ECAV, IntObj)
    External(_SB.PCI0.LPCB.H_EC.B1IC, FieldUnitObj)
    External(_SB.PCI0.LPCB.H_EC.B1DI, FieldUnitObj)
    
    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }
    Scope(_SB.PCI0.LPCB.H_EC)
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
        OperationRegion (BAM0, EmbeddedControl, 0x00, 0xFF)           
        Field (BAM0, ByteAcc, Lock, Preserve)
        {
                Offset (0x62), 
                    ,   16, //B1TM,   16,
                BVT0,8,BVT1,8,//B1VT,   16, 
                BCR0,8,BCR1,8,//B1CR,   16, 
                    ,   16, 
                BRC0,8,BRC1,8,//B1RC,   16, 
                BFC0,8,BFC1,8,//B1FC,   16, 

                Offset (0x76), 
                BDC0,8,BDC1,8,//B1DC,   16, 
                BDV0,8,BDV1,8,//B1DV,   16, 
                    ,   16, //BDCW,   16,
                    ,   16, //BDCL,   16,
                    ,   16, //B1AR,   16,
                //B1MA,   64, //Offset (0x80) ,RECB(0x80,64)
        }
    }
        
    Scope(_SB.PCI0.LPCB.H_EC.BAT1)
    {
        Method (_BIF, 0, Serialized)
        {
                If (_OSI ("Darwin"))
                {        
                    Name (BPK1, Package (0x0D)
                    {
                        Zero, 
                        0xFFFFFFFF, 
                        0xFFFFFFFF, 
                        One, 
                        0xFFFFFFFF, 
                        Zero, 
                        Zero, 
                        0x0100, 
                        0x40, 
                        "BASE-BAT", 
                        "123456789", 
                        "LiP", 
                        "Simplo"
                    })
                    If (\_SB.PCI0.LPCB.H_EC.ECAV)
                    {
                        Local0 = B1B2 (BFC0, BFC1) * 0x0A
                        If (Local0)
                        {
                            BPK1 [One] = B1B2 (BDC0, BDC1) * 0x0A
                            BPK1 [0x02] = Local0
                            BPK1 [0x04] = B1B2 (BDV0, BDV1)
                            Divide (Local0, 0x0A, Local1, Local2)
                            BPK1 [0x05] = Local2
                            Divide (Local0, 0x32, Local1, Local2)
                            BPK1 [0x06] = Local2
                            If ((RECB(0x80,64) == 0x0000313100504D53))
                            {
                                BPK1 [0x0C] = "Simplo"
                            }

                            If ((RECB(0x80,64) == 0x20534F432D545043))
                            {
                                BPK1 [0x0C] = "Celxpert"
                            }

                            If ((RECB(0x80,64) == 0x74726570786C6543))
                            {
                                BPK1 [0x0C] = "Celxpert"
                            }

                            If ((RECB(0x80,64) == 0x3831303200504D53))
                            {
                                BPK1 [0x0C] = "Simplo"
                            }

                            If ((RECB(0x80,64) == 0x393130320043474C))
                            {
                                BPK1 [0x0C] = "LGC"
                            }

                            If ((RECB(0x80,64) == 0x0061646F776E7553))
                            {
                                BPK1 [0x0C] = "Sunwoda"
                            }
                        }
                    }

                    Return (BPK1)
                }
                Else
                {
                    Return (\_SB.PCI0.LPCB.H_EC.BAT1.XBIF())
                }
        }
    
        Method (_BST, 0, Serialized)
        {
                If (_OSI ("Darwin"))
                {
                    Name (PKG1, Package (0x04)
                    {
                        0xFFFFFFFF, 
                        0xFFFFFFFF, 
                        0xFFFFFFFF, 
                        0xFFFFFFFF
                    })
                    If (\_SB.PCI0.LPCB.H_EC.ECAV)
                    {
                        Local0 = B1IC << One
                        Local1 = B1DI | Local0
                        PKG1 [Zero] = Local1
                        Local2 = B1B2 (BCR0, BCR1)
                        Local2 = POSW (Local2)
                        Local3 = B1B2 (BVT0, BVT1)
                        Divide (Local3, 0x03E8, Local4, Local3)
                        Local2 *= Local3
                        PKG1 [One] = Local2
                        PKG1 [0x02] = B1B2 (BRC0, BRC1) * 0x0A
                        PKG1 [0x03] = B1B2 (BVT0, BVT1)
                    }

                    Return (PKG1)
                }
                Else
                {
                    Return (\_SB.PCI0.LPCB.H_EC.BAT1.XBST())
                }
        }
    }
}
//EOF

