```dsl
/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200528 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLppx7Ir.aml, Sat Oct 10 10:34:37 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000018C2 (6338)
 *     Revision         0x02
 *     Checksum         0xF8
 *     OEM ID           "LENOVO"
 *     OEM Table ID     "CB-01   "
 *     OEM Revision     0x00000001 (1)
 *     Compiler ID      "ACPI"
 *     Compiler Version 0x00040000 (262144)
 */
DefinitionBlock ("", "SSDT", 2, "LENOVO", "CB-01   ", 0x00000001)
{
    /*
     * iASL Warning: There were 4 external control methods found during
     * disassembly, but only 0 were resolved (4 unresolved). Additional
     * ACPI tables may be required to properly disassemble the code. This
     * resulting disassembler output file may not compile because the
     * disassembler did not know how many arguments to assign to the
     * unresolved methods. Note: SSDTs can be dynamically loaded at
     * runtime and may or may not be available via the host OS.
     *
     * To specify the tables needed to resolve external control method
     * references, the -e option can be used to specify the filenames.
     * Example iASL invocations:
     *     iasl -e ssdt1.aml ssdt2.aml ssdt3.aml -d dsdt.aml
     *     iasl -e dsdt.aml ssdt2.aml -d ssdt1.aml
     *     iasl -e ssdt*.aml -d dsdt.aml
     *
     * In addition, the -fe option can be used to specify a file containing
     * control method external declarations with the associated method
     * argument counts. Each line of the file must be of the form:
     *     External (<method pathname>, MethodObj, <argument count>)
     * Invocation:
     *     iasl -fe refs.txt -d dsdt.aml
     *
     * The following methods were unresolved and many not compile properly
     * because the disassembler had to guess at the number of arguments
     * required for each:
     */
    External (_PR_.CPPC, UnknownObj)
    External (_SB_.ADP1, UnknownObj)
    External (_SB_.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, UnknownObj)
    External (_SB_.PCI0.PEG0.PEGP.PSAP, IntObj)
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS07, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS08, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS09, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS10, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS11, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS12, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS13, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS14, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS07, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS08, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR1, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR2, DeviceObj)
    External (BNUM, UnknownObj)
    External (DHCF, MethodObj)    // Warning: Unknown method, guessing 2 arguments
    External (E907, UnknownObj)
    External (ECA2, IntObj)
    External (LIDM, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (P8XH, MethodObj)    // Warning: Unknown method, guessing 2 arguments
    External (PNOT, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (PWRS, UnknownObj)

    Scope (\_SB.PCI0.LPCB.H_EC)
    {
        OperationRegion (PRT0, SystemIO, 0xB2, 0x04)
        Field (PRT0, DWordAcc, Lock, Preserve)
        {
            SSMP,   8, 
            SSM2,   8
        }

        OperationRegion (I2EC, SystemIO, 0x0380, 0x04)
        Field (I2EC, ByteAcc, Lock, Preserve)
        {
            Offset (0x01), 
            ADDH,   8, 
            ADDL,   8, 
            ADDA,   8
        }

        OperationRegion (ECF4, EmbeddedControl, Zero, 0xFF)
        Field (ECF4, ByteAcc, Lock, Preserve)
        {
            Offset (0x18), 
            Offset (0x19), 
            Offset (0x1A), 
            Offset (0x1B), 
            Offset (0x1C), 
            Offset (0x3C), 
            Offset (0x3D), 
            Offset (0x3E), 
            Offset (0x3F), 
            Offset (0x40), 
            VPWR,   1
        }

        OperationRegion (ECF3, EmbeddedControl, Zero, 0xFF)
        Field (ECF3, ByteAcc, Lock, Preserve)
        {
            VCMD,   8, 
            VDAT,   8, 
            VSTA,   8, 
            Offset (0x04), 
            AIND,   8, 
            ANUM,   8, 
            F1PW,   8, 
            F2PW,   8, 
            F1RM,   8, 
            F2RM,   8, 
            ECLC,   1, 
            BTSM,   1, 
            CDMB,   1, 
            CD2B,   1, 
            BTCM,   1, 
            BCCM,   1, 
            MBBD,   1, 
            BTIL,   1, 
            BTPF,   1, 
            FCGM,   1, 
            M2BD,   1, 
            BTOV,   1, 
                ,   1, 
                ,   1, 
            BT1S,   1, 
            QKSP,   1, 
            ACST,   2, 
            SPSU,   1, 
            ADSU,   1, 
            B2CD,   1, 
            B2CM,   1, 
            SHPS,   1, 
            Offset (0x13), 
            PSTA,   8, 
            DSTA,   8, 
            Offset (0x18), 
            SMPR,   8, 
            SMST,   8, 
            SMAD,   8, 
            SMCM,   8, 
            SMD0,   256, 
            BCNT,   8, 
            SMAL,   8, 
            SMA0,   8, 
            SMA1,   8, 
            RPWR,   1, 
            WPSR,   1, 
            LSTE,   1, 
            TAST,   1, 
            Offset (0x41), 
            S3ON,   1, 
            S4ON,   1, 
            S5ON,   1, 
            Offset (0x42), 
            NOST,   1, 
            CRRE,   1, 
            Offset (0x43), 
            ACOS,   1, 
            KBLS,   1, 
            KBEN,   1, 
            TPOK,   1, 
            TPDS,   1, 
            RCST,   1, 
            UCSP,   1, 
            UCEN,   1, 
            SYSA,   1, 
            AUMO,   1, 
            HTKC,   1, 
            S4FG,   1, 
                ,   1, 
            BFUC,   2, 
            FG78,   1, 
                ,   7, 
            TPCS,   1, 
            ALSC,   1, 
            AKBC,   1, 
            AKBS,   1, 
            ALSS,   1, 
            KBLC,   1, 
                ,   1, 
            HTKS,   1, 
            Offset (0x47), 
            EVS2,   8, 
            EVS3,   8, 
            OSSW,   1, 
            ROLO,   1, 
            LSTA,   1, 
            PRNO,   1, 
            VOLD,   1, 
            VOLU,   1, 
            BTON,   1, 
            WLEN,   1, 
            MIF2,   8, 
            MIF3,   8, 
            MIF4,   8, 
            BRIL,   8, 
            CRKF,   8, 
            PAID,   1, 
            PAIG,   1, 
            I2CS,   1, 
            Offset (0x50), 
            DR0T,   8, 
            DR1T,   8, 
            TPTP,   8, 
            VGAT,   8, 
            PCHT,   8, 
            SYST,   8, 
            SCPT,   8, 
            CTMP,   8, 
            FTMP,   7, 
            Offset (0x5E), 
            TMPC,   8, 
            Offset (0x60), 
            B1CH,   32, 
            B2CH,   32, 
            B1MO,   16, 
            B2MO,   16, 
            B1SN,   16, 
            B2SN,   16, 
            B1DT,   16, 
            B2DT,   16, 
            B1CY,   16, 
            FUSL,   8, 
            FUSH,   8, 
            BMIL,   8, 
            BMIH,   8, 
            HIDL,   8, 
            HIDH,   8, 
            FMVL,   8, 
            FMVH,   8, 
            DAVL,   8, 
            DAVH,   8, 
            B2IN,   1, 
            B2VA,   1, 
            B2IC,   1, 
            B2FU,   1, 
                ,   1, 
            B2DE,   1, 
            B2AN,   1, 
            Offset (0x81), 
                ,   1, 
            B2WC,   1, 
            B2PC,   1, 
            B2NC,   1, 
            B2DO,   1, 
            B2WO,   1, 
            B2PO,   1, 
            B2NO,   1, 
            B2TM,   16, 
            Offset (0x86), 
            Offset (0x88), 
            B2RS,   16, 
            Offset (0x8B), 
            TPTY,   3, 
            Offset (0x8C), 
            Offset (0x8F), 
            B1MA,   64, 
            Offset (0x98), 
            B2MA,   64, 
            Offset (0xA2), 
            Offset (0xA4), 
            Offset (0xA6), 
            B2CV,   16, 
            Offset (0xAA), 
            RTEP,   16, 
            BET2,   16, 
            Offset (0xB0), 
            CPUT,   8, 
            Offset (0xB2), 
            Offset (0xB3), 
            Offset (0xB4), 
            GPUT,   8, 
            Offset (0xB6), 
            B1TM,   16, 
            BAPV,   16, 
            Offset (0xBC), 
            B1CV,   16, 
            Offset (0xC1), 
            B1DI,   1, 
            B1IC,   1, 
            BATN,   1, 
            Offset (0xC2), 
            BARC,   16, 
            BADC,   16, 
            BADV,   16, 
            BDCW,   16, 
            BDCL,   16, 
            BAFC,   16, 
            BAPR,   16, 
            B1CR,   16, 
            B1AR,   16, 
            Offset (0xE0), 
            LUX1,   8, 
            LUX2,   8, 
            SBMA,   8, 
            Offset (0xF0), 
            BAPS,   1, 
            B1FU,   1, 
            BATT,   1, 
            B1DE,   1, 
            B1AN,   1, 
            Offset (0xF1), 
                ,   1, 
            B1WC,   1, 
            B1PC,   1, 
            B1NC,   1, 
            B1DO,   1, 
            B1WO,   1, 
            B1PO,   1, 
            B1NO,   1, 
            Offset (0xF5), 
            F1SP,   16, 
            F2SP,   16, 
            FAN1,   8, 
            FAN2,   8, 
            BCG1,   16, 
            BCG2,   16
        }

        Mutex (BATM, 0x07)
        Device (BAT1)
        {
            Name (_HID, EisaId ("PNP0C0A") /* Control Method Battery */)  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (ECA2)
                {
                    If ((BNUM & One))
                    {
                        Return (0x1F)
                    }
                }

                Return (0x0B)
            }

            Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
            {
                Name (BPKG, Package (0x0D)
                {
                    Zero, 
                    Ones, 
                    Ones, 
                    One, 
                    Ones, 
                    Zero, 
                    Zero, 
                    0x64, 
                    Zero, 
                    "VIUU4", 
                    "BAT20101001", 
                    "LiP", 
                    "Lenovo IdeaPad"
                })
                Name (BPKH, Package (0x0D)
                {
                    Zero, 
                    Ones, 
                    Ones, 
                    One, 
                    Ones, 
                    Zero, 
                    Zero, 
                    0x64, 
                    Zero, 
                    "VIUU4", 
                    "BAT20101001", 
                    "LION", 
                    "Lenovo IdeaPad"
                })
                Name (MDST, Buffer (0x05)
                {
                    "    "
                })
                Name (SNST, Buffer (0x05)
                {
                    "    "
                })
                Name (TPST, Buffer (0x05)
                {
                    "    "
                })
                Name (LENV, Buffer (0x09)
                {
                    "        "
                })
                If (ECA2)
                {
                    Local0 = BAFC /* \_SB_.PCI0.LPCB.H_EC.BAFC */
                    If (Local0)
                    {
                        BPKG [One] = BADC /* \_SB_.PCI0.LPCB.H_EC.BADC */
                        BPKG [0x02] = Local0
                        BPKG [0x04] = BADV /* \_SB_.PCI0.LPCB.H_EC.BADV */
                        Divide (Local0, 0x0A, Local1, Local2)
                        BPKG [0x05] = Local2
                        Divide (Local0, 0x14, Local1, Local2)
                        BPKG [0x06] = Local2
                        BPKH [One] = BADC /* \_SB_.PCI0.LPCB.H_EC.BADC */
                        BPKH [0x02] = Local0
                        BPKH [0x04] = BADV /* \_SB_.PCI0.LPCB.H_EC.BADV */
                        Divide (Local0, 0x0A, Local1, Local2)
                        BPKH [0x05] = Local2
                        Divide (Local0, 0x14, Local1, Local2)
                        BPKH [0x06] = Local2
                    }
                }

                If ((B1CH == 0x0050694C))
                {
                    Return (BPKG) /* \_SB_.PCI0.LPCB.H_EC.BAT1._BIF.BPKG */
                }
                Else
                {
                    Return (BPKH) /* \_SB_.PCI0.LPCB.H_EC.BAT1._BIF.BPKH */
                }
            }

            Method (POSW, 1, NotSerialized)
            {
                If ((Arg0 & 0x8000))
                {
                    If ((Arg0 == 0xFFFF))
                    {
                        Return (Ones)
                    }
                    Else
                    {
                        Local0 = ~Arg0
                        Local0++
                        Local0 &= 0xFFFF
                        Return (Local0)
                    }
                }
                Else
                {
                    Return (Arg0)
                }
            }

            Method (_BST, 0, NotSerialized)  // _BST: Battery Status
            {
                Acquire (BATM, 0xFFFF)
                Name (PKG1, Package (0x04)
                {
                    Ones, 
                    Ones, 
                    Ones, 
                    Ones
                })
                If (ECA2)
                {
                    Local0 = (B1IC << One)
                    Local1 = (B1DI | Local0)
                    PKG1 [Zero] = Local1
                    Local2 = B1CR /* \_SB_.PCI0.LPCB.H_EC.B1CR */
                    Local2 = POSW (Local2)
                    Local3 = BAPV /* \_SB_.PCI0.LPCB.H_EC.BAPV */
                    Divide (Local3, 0x03E8, Local4, Local3)
                    Local2 *= Local3
                    PKG1 [One] = Local2
                    PKG1 [0x02] = BARC /* \_SB_.PCI0.LPCB.H_EC.BARC */
                    PKG1 [0x03] = BAPV /* \_SB_.PCI0.LPCB.H_EC.BAPV */
                }

                Release (BATM)
                Return (PKG1) /* \_SB_.PCI0.LPCB.H_EC.BAT1._BST.PKG1 */
            }

            Method (_PCL, 0, NotSerialized)  // _PCL: Power Consumer List
            {
                Return (_SB) /* \_SB_ */
            }
        }

        Device (VPC0)
        {
            Name (_HID, "VPC2004")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_VPC, 0xFCFDE104)
            Name (VPCD, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CFG, 0, NotSerialized)
            {
                Return (_VPC) /* \_SB_.PCI0.LPCB.H_EC.VPC0._VPC */
            }

            Method (VPCR, 1, Serialized)
            {
                If ((Arg0 == One))
                {
                    VPCD = VCMD /* \_SB_.PCI0.LPCB.H_EC.VCMD */
                }
                Else
                {
                    VPCD = VDAT /* \_SB_.PCI0.LPCB.H_EC.VDAT */
                }

                Return (VPCD) /* \_SB_.PCI0.LPCB.H_EC.VPC0.VPCD */
            }

            Method (VPCW, 2, Serialized)
            {
                If ((Arg0 == One))
                {
                    VCMD = Arg1
                }
                Else
                {
                    VDAT = Arg1
                }

                Return (Zero)
            }

            Method (SVCR, 1, Serialized)
            {
                If ((Arg0 == Zero)){}
                If ((Arg0 == One)){}
                If ((Arg0 == 0x02))
                {
                    AUMO = Zero
                }

                If ((Arg0 == 0x03))
                {
                    AUMO = One
                }
            }

            Method (HALS, 0, NotSerialized)
            {
                Local0 = Zero
                If ((One == KBLC))
                {
                    Local0 |= 0x10
                }

                If ((One == KBLS))
                {
                    Local0 |= 0x20
                }

                If ((One == UCSP))
                {
                    Local0 |= 0x40
                }

                If ((One == UCEN))
                {
                    Local0 |= 0x80
                }

                If ((One == HTKS))
                {
                    Local0 |= 0x0200
                }

                If ((Zero == HTKC))
                {
                    Local0 |= 0x0400
                }

                Return (Local0)
            }

            Method (SALS, 1, Serialized)
            {
                If ((Arg0 == 0x08))
                {
                    KBLS = One
                    Return (Zero)
                }

                If ((Arg0 == 0x09))
                {
                    KBLS = Zero
                    Return (Zero)
                }

                If ((Arg0 == 0x0A))
                {
                    UCEN = One
                    SSM2 = 0x33
                    SSMP = 0xCA
                    Return (Zero)
                }

                If ((Arg0 == 0x0B))
                {
                    UCEN = Zero
                    SSM2 = 0x32
                    SSMP = 0xCA
                    Return (Zero)
                }

                If ((Arg0 == 0x0E))
                {
                    HTKC = Zero
                    SSM2 = 0x31
                    SSMP = 0xCA
                    Return (Zero)
                }

                If ((Arg0 == 0x0F))
                {
                    HTKC = One
                    SSM2 = 0x30
                    SSMP = 0xCA
                    Return (Zero)
                }

                Return (Zero)
            }

            Method (GBMD, 0, NotSerialized)
            {
                Local0 = 0x10000000
                If ((One == CDMB))
                {
                    Local0 |= One
                }

                If ((One == BTSM))
                {
                    Local0 |= 0x02
                }

                If ((One == FCGM))
                {
                    Local0 |= 0x04
                }

                If ((One == MBBD))
                {
                    Local0 |= 0x08
                }

                If ((One == M2BD))
                {
                    Local0 |= 0x10
                }

                If ((One == BTSM))
                {
                    Local0 |= 0x20
                }

                If ((One == BTIL))
                {
                    Local0 |= 0x80
                }

                If ((One == BTPF))
                {
                    Local0 |= 0x0100
                }

                If ((Zero == BTCM))
                {
                    Local0 |= 0x0200
                }

                If ((One == BTOV))
                {
                    Local0 |= 0x0800
                }

                If ((One == ACST))
                {
                    Local0 |= 0x8000
                }

                If ((0x02 == ACST))
                {
                    Local0 |= 0x00010000
                }

                If ((0x03 == ACST))
                {
                    Local0 |= 0x00018000
                }

                If ((One == QKSP))
                {
                    Local0 |= 0x00020000
                }

                If ((One == SPSU))
                {
                    Local0 |= 0x00040000
                }

                If ((One == ADSU))
                {
                    Local0 |= 0x00080000
                }

                If ((One == SHPS))
                {
                    Local0 |= 0x00400000
                }

                Return (Local0)
            }

            Method (SBMC, 1, NotSerialized)
            {
                If ((Arg0 == Zero))
                {
                    CDMB = Zero
                    Return (Zero)
                }

                If ((Arg0 == One))
                {
                    CDMB = One
                    Return (Zero)
                }

                If ((Arg0 == 0x03))
                {
                    BTCM = One
                    Return (Zero)
                }

                If ((Arg0 == 0x05))
                {
                    BTCM = Zero
                    Return (Zero)
                }

                If ((Arg0 == 0x06))
                {
                    BTSM = Zero
                }

                If ((Arg0 == 0x07))
                {
                    SBMA = Arg0
                    Return (Zero)
                }

                If ((Arg0 == 0x08))
                {
                    SBMA = Arg0
                    Return (Zero)
                }

                If ((Arg0 == 0x09))
                {
                    SHPS = One
                    Return (Zero)
                }

                If ((Arg0 == 0x0A)){}
                If ((Arg0 == 0x0B)){}
                If ((Arg0 == 0x10))
                {
                    SHPS = Zero
                    Return (Zero)
                }

                Return (Zero)
            }

            Method (MHCF, 1, NotSerialized)
            {
                Local0 = Arg0
                (Local0 & 0x20)
                Local0 >>= 0x05
                BFUC = Local0
                Return (Local0)
            }

            Method (MHPF, 1, NotSerialized)
            {
                Name (BFWB, Buffer (0x25){})
                CreateByteField (BFWB, Zero, FB0)
                CreateByteField (BFWB, One, FB1)
                CreateByteField (BFWB, 0x02, FB2)
                CreateByteField (BFWB, 0x03, FB3)
                CreateField (BFWB, 0x20, 0x0100, FB4)
                CreateByteField (BFWB, 0x24, FB5)
                If ((SizeOf (Arg0) <= 0x25))
                {
                    If ((SMPR != Zero))
                    {
                        FB1 = SMST /* \_SB_.PCI0.LPCB.H_EC.SMST */
                    }
                    Else
                    {
                        BFWB = Arg0
                        SMAD = FB2 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB2_ */
                        SMCM = FB3 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB3_ */
                        BCNT = FB5 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB5_ */
                        Local0 = FB0 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB0_ */
                        If (((Local0 & One) == Zero))
                        {
                            SMD0 = FB4 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB4_ */
                        }

                        SMPR = FB0 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB0_ */
                        Local0 = 0x03E8
                        While (SMPR)
                        {
                            Sleep (One)
                            Local0--
                        }

                        Local0 = FB0 /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.FB0_ */
                        If (((Local0 & One) != Zero))
                        {
                            FB4 = SMD0 /* \_SB_.PCI0.LPCB.H_EC.SMD0 */
                        }

                        FB1 = SMST /* \_SB_.PCI0.LPCB.H_EC.SMST */
                    }

                    Return (BFWB) /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHPF.BFWB */
                }
            }

            Method (SMTF, 1, NotSerialized)
            {
                If ((Arg0 == Zero))
                {
                    Return (BET2) /* \_SB_.PCI0.LPCB.H_EC.BET2 */
                }

                If ((Arg0 == One))
                {
                    Return (Zero)
                }

                Return (Zero)
            }

            Method (MHIF, 1, NotSerialized)
            {
                If ((Arg0 == Zero))
                {
                    Name (RETB, Buffer (0x0A){})
                    RETB [Zero] = FUSL /* \_SB_.PCI0.LPCB.H_EC.FUSL */
                    RETB [One] = FUSH /* \_SB_.PCI0.LPCB.H_EC.FUSH */
                    RETB [0x02] = BMIL /* \_SB_.PCI0.LPCB.H_EC.BMIL */
                    RETB [0x03] = BMIH /* \_SB_.PCI0.LPCB.H_EC.BMIH */
                    RETB [0x04] = HIDL /* \_SB_.PCI0.LPCB.H_EC.HIDL */
                    RETB [0x05] = HIDH /* \_SB_.PCI0.LPCB.H_EC.HIDH */
                    RETB [0x06] = FMVL /* \_SB_.PCI0.LPCB.H_EC.FMVL */
                    RETB [0x07] = FMVH /* \_SB_.PCI0.LPCB.H_EC.FMVH */
                    RETB [0x08] = DAVL /* \_SB_.PCI0.LPCB.H_EC.DAVL */
                    RETB [0x09] = DAVH /* \_SB_.PCI0.LPCB.H_EC.DAVH */
                    Return (RETB) /* \_SB_.PCI0.LPCB.H_EC.VPC0.MHIF.RETB */
                }
            }

            Method (GSBI, 1, NotSerialized)
            {
                Name (BT11, Zero)
                Name (BTIF, Buffer (0x53){})
                CreateWordField (BTIF, Zero, IFDC)
                CreateWordField (BTIF, 0x02, IFFC)
                CreateWordField (BTIF, 0x04, IFRC)
                CreateWordField (BTIF, 0x06, IFAT)
                CreateWordField (BTIF, 0x08, IFAF)
                CreateWordField (BTIF, 0x0A, IFVT)
                CreateWordField (BTIF, 0x0C, IFCR)
                CreateWordField (BTIF, 0x0E, IFTP)
                CreateWordField (BTIF, 0x10, IFMD)
                CreateWordField (BTIF, 0x12, IFFD)
                CreateWordField (BTIF, 0x14, IFDV)
                CreateField (BTIF, 0xB0, 0x50, IFCH)
                CreateField (BTIF, 0x0100, 0x40, IFDN)
                CreateField (BTIF, 0x0140, 0x60, IFMN)
                CreateField (BTIF, 0x01A0, 0xB8, IFBC)
                CreateField (BTIF, 0x0258, 0x40, IFBV)
                IFDC = (BADC / 0x0A)
                IFFC = (BAFC / 0x0A)
                IFRC = (BARC / 0x0A)
                IFAT = RTEP /* \_SB_.PCI0.LPCB.H_EC.RTEP */
                IFAF = BET2 /* \_SB_.PCI0.LPCB.H_EC.BET2 */
                IFVT = BAPV /* \_SB_.PCI0.LPCB.H_EC.BAPV */
                IFCR = B1CR /* \_SB_.PCI0.LPCB.H_EC.B1CR */
                IFTP = B1TM /* \_SB_.PCI0.LPCB.H_EC.B1TM */
                IFMD = B1DT /* \_SB_.PCI0.LPCB.H_EC.B1DT */
                IFFD = B1DT /* \_SB_.PCI0.LPCB.H_EC.B1DT */
                IFDV = BADV /* \_SB_.PCI0.LPCB.H_EC.BADV */
                IFCH = Zero
                IFCH = B1CH /* \_SB_.PCI0.LPCB.H_EC.B1CH */
                IFDN = Zero
                IFDN = B2MA /* \_SB_.PCI0.LPCB.H_EC.B2MA */
                IFMN = Zero
                IFMN = B1MA /* \_SB_.PCI0.LPCB.H_EC.B1MA */
                IFBC = Zero
                BT11 = 0x17
                While (BT11)
                {
                    ADDH = 0x08
                    ADDL = (0x41 + BT11)
                    Sleep (0x02)
                    BTIF [(0x33 + BT11)] = ADDA /* \_SB_.PCI0.LPCB.H_EC.ADDA */
                    BT11--
                }

                IFBV = Zero
                BTIF [0x4B] = BMIL /* \_SB_.PCI0.LPCB.H_EC.BMIL */
                BTIF [0x4C] = BMIH /* \_SB_.PCI0.LPCB.H_EC.BMIH */
                BTIF [0x4D] = HIDL /* \_SB_.PCI0.LPCB.H_EC.HIDL */
                BTIF [0x4E] = HIDH /* \_SB_.PCI0.LPCB.H_EC.HIDH */
                BTIF [0x4F] = FMVL /* \_SB_.PCI0.LPCB.H_EC.FMVL */
                BTIF [0x50] = FMVH /* \_SB_.PCI0.LPCB.H_EC.FMVH */
                BTIF [0x51] = DAVL /* \_SB_.PCI0.LPCB.H_EC.DAVL */
                BTIF [0x52] = DAVH /* \_SB_.PCI0.LPCB.H_EC.DAVH */
                E907 = BTIF /* \_SB_.PCI0.LPCB.H_EC.VPC0.GSBI.BTIF */
                Return (BTIF) /* \_SB_.PCI0.LPCB.H_EC.VPC0.GSBI.BTIF */
            }

            Method (HODD, 0, NotSerialized)
            {
                Return (0xFF)
            }

            Method (SODD, 1, Serialized)
            {
            }

            Method (GBID, 0, Serialized)
            {
                Name (GBUF, Package (0x04)
                {
                    Buffer (0x02)
                    {
                         0x00, 0x00                                       // ..
                    }, 

                    Buffer (0x02)
                    {
                         0x00, 0x00                                       // ..
                    }, 

                    Buffer (0x08)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // ........
                    }, 

                    Buffer (0x08)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // ........
                    }
                })
                DerefOf (GBUF [Zero]) [Zero] = B1CY /* \_SB_.PCI0.LPCB.H_EC.B1CY */
                DerefOf (GBUF [One]) [Zero] = Zero
                DerefOf (GBUF [0x02]) [Zero] = BMIL /* \_SB_.PCI0.LPCB.H_EC.BMIL */
                DerefOf (GBUF [0x02]) [One] = BMIH /* \_SB_.PCI0.LPCB.H_EC.BMIH */
                DerefOf (GBUF [0x02]) [0x02] = HIDL /* \_SB_.PCI0.LPCB.H_EC.HIDL */
                DerefOf (GBUF [0x02]) [0x03] = HIDH /* \_SB_.PCI0.LPCB.H_EC.HIDH */
                DerefOf (GBUF [0x02]) [0x04] = FMVL /* \_SB_.PCI0.LPCB.H_EC.FMVL */
                DerefOf (GBUF [0x02]) [0x05] = FMVH /* \_SB_.PCI0.LPCB.H_EC.FMVH */
                DerefOf (GBUF [0x02]) [0x06] = DAVL /* \_SB_.PCI0.LPCB.H_EC.DAVL */
                DerefOf (GBUF [0x02]) [0x07] = DAVH /* \_SB_.PCI0.LPCB.H_EC.DAVH */
                DerefOf (GBUF [0x03]) [Zero] = Zero
                Return (GBUF) /* \_SB_.PCI0.LPCB.H_EC.VPC0.GBID.GBUF */
            }
        }

        Method (_Q30, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x30)
            Sleep (0x012C)
            PWRS = One
            PNOT ()
        }

        Method (_Q31, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x31)
            Sleep (0x012C)
            PWRS = Zero
            PNOT ()
        }

        Method (_Q0A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x31)
            PWRS = RPWR /* \_SB_.PCI0.LPCB.H_EC.RPWR */
            Notify (\_SB.ADP1, 0x80) // Status Change
            PNOT ()
        }

        Method (_Q50, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            Notify (\_SB.PCI0.LPCB.H_EC.VPC0, 0x80) // Status Change
        }

        Method (_Q38, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x38)
            Sleep (0x012C)
            DHCF (0x02, Zero)
        }

        Method (_Q39, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x39)
            Sleep (0x012C)
            DHCF (0x03, Zero)
        }

        Method (_Q32, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x32)
            PNOT ()
        }

        Method (_Q0B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x33)
            Sleep (0x05DC)
            BNUM = Zero
            BNUM |= BAPS /* \_SB_.PCI0.LPCB.H_EC.BAPS */
            Notify (\_SB.PCI0.LPCB.H_EC.BAT1, 0x80) // Status Change
            Sleep (0x05DC)
            Notify (\_SB.PCI0.LPCB.H_EC.BAT1, 0x81) // Information Change
            PNOT ()
        }

        Method (_Q0C, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            LIDM ()
        }

        Method (_Q0D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            LIDM ()
        }

        Name (ECPS, Zero)
        Method (PCA2, 0, NotSerialized)
        {
            Local0 = ECPS /* \_SB_.PCI0.LPCB.H_EC.ECPS */
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP.PSAP))
            {
                If ((ECPS < \_SB.PCI0.PEG0.PEGP.PSAP))
                {
                    Local0 = \_SB.PCI0.PEG0.PEGP.PSAP /* External reference */
                }
            }

            If (CondRefOf (\_PR.CPU0._PPC))
            {
                \_PR.CPPC = Local0
                PNOT ()
            }

            Return (Local0)
        }

        Method (_Q72, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x72)
            If ((PSTA != 0xFF))
            {
                ECPS = PSTA /* \_SB_.PCI0.LPCB.H_EC.PSTA */
                PCA2 ()
                PAID = Zero
            }
        }

        Method (_Q73, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            P8XH (Zero, 0x73)
            Notify (\_SB.PCI0.PEG0.PEGP, DSTA)
            PAIG = Zero
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB)
    {
        Method (GPLD, 2, Serialized)
        {
            Name (PCKG, Package (0x01)
            {
                Buffer (0x10){}
            })
            CreateField (DerefOf (PCKG [Zero]), Zero, 0x07, REV)
            REV = One
            CreateField (DerefOf (PCKG [Zero]), 0x40, One, VISI)
            VISI = Arg0
            CreateField (DerefOf (PCKG [Zero]), 0x57, 0x08, GPOS)
            GPOS = Arg1
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.GPLD.PCKG */
        }

        Method (GUPC, 1, Serialized)
        {
            Name (PCKG, Package (0x04)
            {
                Zero, 
                0xFF, 
                Zero, 
                Zero
            })
            PCKG [Zero] = Arg0
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.GUPC.PCKG */
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.USR1)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x04))
        }

        Device (CRGB)
        {
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_ADR, 0, Serialized)  // _ADR: Address
            {
                Return (0x04)
            }

            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Name (UPCP, Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.HS04.CRGB._UPC.UPCP */
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Name (PLDS, Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00   // $.......
                    }
                })
                Name (PLDR, Package (0x01)
                {
                    Buffer (0x14)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x80, 0x07, 0x00, 0x00, 0x00, 0x00,  // $.......
                        /* 0010 */  0xC8, 0x00, 0xA1, 0x00                           // ....
                    }
                })
                Return (PLDR) /* \_SB_.PCI0.XHC_.RHUB.HS04.CRGB._PLD.PLDR */
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x05))
        }

        Device (CRGB)
        {
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_ADR, 0, Serialized)  // _ADR: Address
            {
                Return (0x05)
            }

            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Name (UPCP, Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.HS05.CRGB._UPC.UPCP */
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Name (PLDS, Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00   // $.......
                    }
                })
                Name (PLDR, Package (0x01)
                {
                    Buffer (0x14)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x80, 0x07, 0x00, 0x00, 0x00, 0x00,  // $.......
                        /* 0010 */  0xC8, 0x00, 0xA1, 0x00                           // ....
                    }
                })
                Return (PLDR) /* \_SB_.PCI0.XHC_.RHUB.HS05.CRGB._PLD.PLDR */
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS07)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x07))
        }

        Device (CRGB)
        {
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_ADR, 0, Serialized)  // _ADR: Address
            {
                Return (0x07)
            }

            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Name (UPCP, Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.HS07.CRGB._UPC.UPCP */
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Name (PLDS, Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00   // $.......
                    }
                })
                Name (PLDR, Package (0x01)
                {
                    Buffer (0x14)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x80, 0x07, 0x00, 0x00, 0x00, 0x00,  // $.......
                        /* 0010 */  0xC8, 0x00, 0xA1, 0x00                           // ....
                    }
                })
                Return (PLDR) /* \_SB_.PCI0.XHC_.RHUB.HS07.CRGB._PLD.PLDR */
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x05))
        }

        Device (CRGB)
        {
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_ADR, 0, Serialized)  // _ADR: Address
            {
                Return (0x14)
            }

            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Name (UPCP, Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.SS04.CRGB._UPC.UPCP */
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Name (PLDS, Package (0x01)
                {
                    Buffer (0x10)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00   // $.......
                    }
                })
                Name (PLDR, Package (0x01)
                {
                    Buffer (0x14)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x24, 0x01, 0x80, 0x07, 0x00, 0x00, 0x00, 0x00,  // $.......
                        /* 0010 */  0xC8, 0x00, 0xA1, 0x00                           // ....
                    }
                })
                Return (PLDR) /* \_SB_.PCI0.XHC_.RHUB.SS04.CRGB._PLD.PLDR */
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x02))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x03))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS06)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, One))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS08)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x08))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS09)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x09))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS10)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0A))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.USR2)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x03))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x02))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x06))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS06)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0C))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS11)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0D))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS12)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0E))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS13)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0F))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS14)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x10))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS07)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x11))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS08)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x12))
        }
    }
}
```