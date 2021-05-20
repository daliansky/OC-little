// battery
// In config ACPI, BTIF renamed XTIF
// Find:     42544946 09
// Replace:  58544946 09
//
// In config ACPI, BTST renamed XTST
// Find:     42545354 0A
// Replace:  58545354 0A
//
// In config ACPI, ITLB renamed XTLB
// Find:     49544C42 00
// Replace:  58544C42 00
//
// In config ACPI, GBTI renamed XBTI
// Find:     47425449 01
// Replace:  58425449 01
//
// In config ACPI, GBTC renamed XBTC
// Find:     47425443 00
// Replace:  58425443 00
//
// In config ACPI, SBTC renamed XSTC
// Find:     53425443 03
// Replace:  58535443 03
//
// In config ACPI, GCGC renamed XCGC
// Find:     47434743 08
// Replace:  58434743 08
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "BAT0", 0)
{
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.NDBS, PkgObj)
    External(_SB.NBST, PkgObj)
    External(_SB.NBTI, PkgObj)
    External(_SB.PCI0.LPCB.EC0.NGBF, IntObj)
    External(_SB.PCI0.LPCB.EC0.NGBT, IntObj)
    External(_SB.PCI0.LPCB.EC0.NLB1, IntObj)
    External(_SB.PCI0.LPCB.EC0.NLB2, IntObj)
    External(_SB.PCI0.LPCB.EC0.NLO2, IntObj)
    External(_SB.PCI0.LPCB.EC0.NDCB, IntObj)
    External(_SB.PCI0.LPCB.EC0.ECRG, IntObj)
    External(_SB.PCI0.LPCB.EC0.BTMX, MutexObj)
    External(_SB.PCI0.LPCB.EC0.ECMX, MutexObj)
    External(_SB.PCI0.LPCB.EC0.BSEL, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BST, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.LB1, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.LB2, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BATP, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BRCC, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BRCV, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BATN, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.INAC, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.INCH, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.IDIS, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.PSSB, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC0.BTDR, MethodObj)
    External(_SB.PCI0.LPCB.EC0.BSTA, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GBSS, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GACS, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GBMF, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GCTL, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GDNM, MethodObj)
    External(_SB.PCI0.LPCB.EC0.GDCH, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XTIF, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XTST, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XTLB, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XBTC, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XSTC, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XBTI, MethodObj)
    External(_TZ.XCGC, MethodObj)
    
    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }
    
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion (ERM0, EmbeddedControl, 0x00, 0xFF)           
        Field (ERM0, ByteAcc, Lock, Preserve)
        {
            Offset (0x87), 
			,    8, 
			,    8, 
			BDC0,8,BDC1,8, //BDC,    16, 
			Offset (0x8D), 
			BFC0,8,BFC1,8, //BFC,    16, 
			RTE0,8,RTE1,8, //BRTE,   16, 
			,    1, 
			Offset (0x92), 
			BME0,8,BME1,8, //BME,    16, 
			,    8, 
			BDV0,8,BDV1,8, //BDV,    16, 
			CV10,8,CV11,8, //BCV1,   16, 
			,    4, 
			Offset (0x9B), 
			ATE0,8,ATE1,8, //BATE,   16, 
			BPR0,8,BPR1,8, //BPR,    16, 
			BCR0,8,BCR1,8, //BCR,    16, 
			BRC0,8,BRC1,8, //BRC,    16, 
			BCC0,8,BCC1,8, //BCC,    16, 
			BPV0,8,BPV1,8, //BPV,    16, 
			CV20,8,CV21,8, //BCV2,   16, 
			CV30,8,CV31,8, //BCV3,   16, 
			CV40,8,CV41,8, //BCV4,   16, 
			,    16, 
			ATF0,8,ATF1,8, //BATF,   16, 
			,    16, 
			AXC0,8,AXC1,8, //MAXC,   16, 
			,   8, 
			,   1, 
			,   1, 
				,   2, 
			,   4, 
			STS0,8,STS1,8, //BSTS,   16, 
			,   8, 
			Offset (0xC9), 
			BSN0,8,BSN1,8, //BSN,    16, 
			DAT0,8,DAT1,8, //BDAT,   16, 
			,    8, 
			Offset (0xD5), 
			,   8, 
			,   8, 
			,   8, 
			,   8, 
			,   8, 
			,   8, 
			,   8, 
			,   8, 
			,   4, 
			,    4, 
			,   16, 
			CBT0,8,CBT1,8, //CBT,    16, 
        }
    }
        
    
    Scope(\_SB.PCI0.LPCB.EC0)
    {
        Method (BTIF, 1, Serialized)
	    {
            If (_OSI ("Darwin"))
            {
				Local7 = (One << Arg0)
				BTDR (One)
				If ((BSTA (Local7) == 0x0F))
				{
					Return (0xFF)
				}

				Acquire (BTMX, 0xFFFF)
				Local0 = NGBF /* \_SB_.PCI0.LPCB.EC0_.NGBF */
				Release (BTMX)
				If (((Local0 & Local7) == Zero))
				{
					Return (Zero)
				}

				NBST [Arg0] = NDBS /* \_SB_.NDBS */
				Acquire (BTMX, 0xFFFF)
				NGBT |= Local7
				Release (BTMX)
				Acquire (ECMX, 0xFFFF)
				If (ECRG)
				{
					BSEL = Arg0
					Local0 = B1B2 (BFC0,BFC1) /* \_SB_.PCI0.LPCB.EC0_.BFC_ */
					DerefOf (NBTI [Arg0]) [One] = Local0
					DerefOf (NBTI [Arg0]) [0x02] = Local0
					DerefOf (NBTI [Arg0]) [0x04] = B1B2 (BDV0,BDV1) /* \_SB_.PCI0.LPCB.EC0_.BDV_ */
					Local0 = (B1B2 (BFC0,BFC1) * NLB1) /* \_SB_.PCI0.LPCB.EC0_.NLB1 */
					Divide (Local0, 0x64, Local3, Local4)
					DerefOf (NBTI [Arg0]) [0x05] = Local4
					Local0 = (B1B2 (BFC0,BFC1) * NLO2) /* \_SB_.PCI0.LPCB.EC0_.NLO2 */
					Divide (Local0, 0x64, Local3, Local4)
					DerefOf (NBTI [Arg0]) [0x06] = Local4
					Local0 = B1B2 (BSN0,BSN1) /* \_SB_.PCI0.LPCB.EC0_.BSN_ */
					Local1 = B1B2 (DAT0,DAT1) /* \_SB_.PCI0.LPCB.EC0_.BDAT */
				}

				Release (ECMX)
				Local2 = GBSS (Local0, Local1)
				DerefOf (NBTI [Arg0]) [0x0A] = Local2
				Acquire (BTMX, 0xFFFF)
				NGBF &= ~Local7
				Release (BTMX)
				Return (Zero)
			}
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XTIF (Arg0))
            }
        }

		Method (BTST, 2, Serialized)
		{
            If (_OSI ("Darwin"))
            {
				Local7 = (One << Arg0)
				BTDR (One)
				If ((BSTA (Local7) == 0x0F))
				{
					NBST [Arg0] = Package (0x04)
						{
							Zero, 
							0xFFFFFFFF, 
							0xFFFFFFFF, 
							0xFFFFFFFF
						}
					Return (0xFF)
				}

				Acquire (BTMX, 0xFFFF)
				If (Arg1)
				{
					NGBT = 0xFF
				}

				Local0 = NGBT /* \_SB_.PCI0.LPCB.EC0_.NGBT */
				Release (BTMX)
				If (((Local0 & Local7) == Zero))
				{
					Return (Zero)
				}

				Acquire (ECMX, 0xFFFF)
				If (ECRG)
				{
					BSEL = Arg0
					Local0 = BST /* \_SB_.PCI0.LPCB.EC0_.BST_ */
					Local3 = B1B2 (BPR0,BPR1) /* \_SB_.PCI0.LPCB.EC0_.BPR_ */
					DerefOf (NBST [Arg0]) [0x02] = B1B2 (BRC0,BRC1) /* \_SB_.PCI0.LPCB.EC0_.BRC_ */
					DerefOf (NBST [Arg0]) [0x03] = B1B2 (BPV0,BPV1) /* \_SB_.PCI0.LPCB.EC0_.BPV_ */
				}

				Release (ECMX)
				If ((GACS () == One))
				{
					Local0 &= 0xFFFFFFFFFFFFFFFE
				}
				Else
				{
					Local0 &= 0xFFFFFFFFFFFFFFFD
				}

				If ((Local0 & One))
				{
					Acquire (BTMX, 0xFFFF)
					NDCB = Local7
					Release (BTMX)
				}

				DerefOf (NBST [Arg0]) [Zero] = Local0
				If ((Local0 & One))
				{
					If (((Local3 < 0x0190) || (Local3 > 0x1964)))
					{
						Local5 = DerefOf (DerefOf (NBST [Arg0]) [One])
						If (((Local5 < 0x0190) || (Local5 > 0x1964)))
						{
							Local3 = 0x0D7A
						}
						Else
						{
							Local3 = Local5
						}
					}
				}
				ElseIf (((Local0 & 0x02) == Zero))
				{
					Local3 = Zero
				}

				DerefOf (NBST [Arg0]) [One] = Local3
				Acquire (BTMX, 0xFFFF)
				NGBT &= ~Local7
				Release (BTMX)
				Return (Zero)
			}
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XTST (Arg0, Arg1))
            }
        }

		Method (ITLB, 0, NotSerialized)
		{
            If (_OSI ("Darwin"))
            {
				Local0 = (B1B2 (BFC0,BFC1) * NLB1) /* \_SB_.PCI0.LPCB.EC0_.NLB1 */
				Divide (Local0, 0x64, Local3, Local4)
				Divide ((Local4 + 0x09), 0x0A, Local0, Local1)
				Local0 = (B1B2 (BFC0,BFC1) * NLB2) /* \_SB_.PCI0.LPCB.EC0_.NLB2 */
				Divide (Local0, 0x64, Local3, Local4)
				Divide ((Local4 + 0x09), 0x0A, Local0, Local2)
				If (ECRG)
				{
					LB1 = Local1
					LB2 = Local2
				}
			}
            Else
            {
                \_SB.PCI0.LPCB.EC0.XTLB ()
            }
        }

		Method (GBTI, 1, NotSerialized)
		{
            If (_OSI ("Darwin"))
            {
				Debug = "Enter getbattinfo"
				Acquire (ECMX, 0xFFFF)
				If (ECRG)
				{
					If ((BATP & (One << Arg0)))
					{
						BSEL = Arg0
						Local0 = Package (0x02)
							{
								Zero, 
								Buffer (0x6B){}
							}
						DerefOf (Local0 [One]) [Zero] = B1B2 (BDC0,BDC1) /* \_SB_.PCI0.LPCB.EC0_.BDC_ */
						DerefOf (Local0 [One]) [One] = (B1B2 (BDC0,BDC1) >> 0x08
							)
						DerefOf (Local0 [One]) [0x02] = B1B2 (BFC0,BFC1) /* \_SB_.PCI0.LPCB.EC0_.BFC_ */
						DerefOf (Local0 [One]) [0x03] = (B1B2 (BFC0,BFC1) >> 0x08
							)
						DerefOf (Local0 [One]) [0x04] = B1B2 (BRC0,BRC1) /* \_SB_.PCI0.LPCB.EC0_.BRC_ */
						DerefOf (Local0 [One]) [0x05] = (B1B2 (BRC0,BRC1) >> 0x08
							)
						DerefOf (Local0 [One]) [0x06] = B1B2 (BME0,BME1) /* \_SB_.PCI0.LPCB.EC0_.BME_ */
						DerefOf (Local0 [One]) [0x07] = (B1B2 (BME0,BME1) >> 0x08
							)
						DerefOf (Local0 [One]) [0x08] = B1B2 (BCC0,BCC1) /* \_SB_.PCI0.LPCB.EC0_.BCC_ */
						DerefOf (Local0 [One]) [0x09] = (B1B2 (BCC0,BCC1) >> 0x08
							)
						Local1 = B1B2 (CBT0,CBT1) /* \_SB_.PCI0.LPCB.EC0_.CBT_ */
						Local1 -= 0x0AAC
						Divide (Local1, 0x0A, Local2, Local3)
						DerefOf (Local0 [One]) [0x0A] = Local3
						DerefOf (Local0 [One]) [0x0B] = (Local3 >> 0x08
							)
						DerefOf (Local0 [One]) [0x0C] = B1B2 (BPV0,BPV1) /* \_SB_.PCI0.LPCB.EC0_.BPV_ */
						DerefOf (Local0 [One]) [0x0D] = (B1B2 (BPV0,BPV1) >> 0x08
							)
						Local1 = B1B2 (BPR0,BPR1) /* \_SB_.PCI0.LPCB.EC0_.BPR_ */
						If (Local1)
						{
							If ((B1B2 (STS0,STS1) & 0x40))
							{
								Local1 = (~Local1 + One)
								Local1 &= 0xFFFF
							}
						}

						DerefOf (Local0 [One]) [0x0E] = Local1
						DerefOf (Local0 [One]) [0x0F] = (Local1 >> 0x08
							)
						DerefOf (Local0 [One]) [0x10] = B1B2 (BDV0,BDV1) /* \_SB_.PCI0.LPCB.EC0_.BDV_ */
						DerefOf (Local0 [One]) [0x11] = (B1B2 (BDV0,BDV1) >> 0x08
							)
						DerefOf (Local0 [One]) [0x12] = B1B2 (STS0,STS1) /* \_SB_.PCI0.LPCB.EC0_.BSTS */
						DerefOf (Local0 [One]) [0x13] = (B1B2 (STS0,STS1) >> 0x08
							)
						DerefOf (Local0 [One]) [0x14] = B1B2 (CV10,CV11) /* \_SB_.PCI0.LPCB.EC0_.BCV1 */
						DerefOf (Local0 [One]) [0x15] = (B1B2 (CV10,CV11) >> 0x08
							)
						DerefOf (Local0 [One]) [0x16] = B1B2 (CV20,CV21) /* \_SB_.PCI0.LPCB.EC0_.BCV2 */
						DerefOf (Local0 [One]) [0x17] = (B1B2 (CV20,CV21) >> 0x08
							)
						DerefOf (Local0 [One]) [0x18] = B1B2 (CV30,CV31) /* \_SB_.PCI0.LPCB.EC0_.BCV3 */
						DerefOf (Local0 [One]) [0x19] = (B1B2 (CV30,CV31) >> 0x08
							)
						DerefOf (Local0 [One]) [0x1A] = B1B2 (CV40,CV41) /* \_SB_.PCI0.LPCB.EC0_.BCV4 */
						DerefOf (Local0 [One]) [0x1B] = (B1B2 (CV40,CV41) >> 0x08
							)
						CreateField (DerefOf (Local0 [One]), 0xE0, 0x80, BTSN)
						BTSN = GBSS (B1B2 (BSN0,BSN1), B1B2 (DAT0,DAT1))
						Local1 = GBMF ()
						Local2 = SizeOf (Local1)
						CreateField (DerefOf (Local0 [One]), 0x0160, (Local2 * 0x08), BMAN)
						BMAN = Local1
						Local2 += 0x2C
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x80, CLBL)
						CLBL = GCTL (Zero)
						Local2 += 0x11
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x38, DNAM)
						DNAM = GDNM (Zero)
						Local2 += 0x07
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x20, DCHE)
						DCHE = GDCH (Zero)
						Local2 += 0x04
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, BMAC)
						BMAC = Zero
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, BMAD)
						BMAD = B1B2 (DAT0,DAT1) /* \_SB_.PCI0.LPCB.EC0_.BDAT */
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, BCCU)
						BCCU = BRCC /* \_SB_.PCI0.LPCB.EC0_.BRCC */
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, BCVO)
						BCVO = BRCV /* \_SB_.PCI0.LPCB.EC0_.BRCV */
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, BAVC)
						Local1 = B1B2 (BCR0,BCR1) /* \_SB_.PCI0.LPCB.EC0_.BCR_ */
						If (Local1)
						{
							If ((B1B2 (STS0,STS1) & 0x40))
							{
								Local1 = (~Local1 + One)
								Local1 &= 0xFFFF
							}
						}

						BAVC = Local1
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, RTTE)
						RTTE = B1B2 (RTE0,RTE1) /* \_SB_.PCI0.LPCB.EC0_.BRTE */
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, ATTE)
						RTTE = B1B2 (ATE0,ATE1) /* \_SB_.PCI0.LPCB.EC0_.BATE */
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x10, ATTF)
						RTTE = B1B2 (ATF0,ATF1) /* \_SB_.PCI0.LPCB.EC0_.BATF */
						Local2 += 0x02
						CreateField (DerefOf (Local0 [One]), (Local2 * 0x08), 0x08, NOBS)
						NOBS = BATN /* \_SB_.PCI0.LPCB.EC0_.BATN */
					}
					Else
					{
						Local0 = Package (0x01)
							{
								0x34
							}
					}
				}
				Else
				{
					Local0 = Package (0x01)
						{
							0x0D
						}
				}

				Release (ECMX)
				Return (Local0)
			}
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XBTI (Arg0))
            }
        }

		Method (GBTC, 0, NotSerialized)
		{
            If (_OSI ("Darwin"))
            {
				Debug = "Enter GetBatteryControl"
				Acquire (ECMX, 0xFFFF)
				If (ECRG)
				{
					Local0 = Package (0x02)
						{
							Zero, 
							Buffer (0x04){}
						}
					If ((BATP & One))
					{
						BSEL = Zero
						DerefOf (Local0 [One]) [Zero] = Zero
						If ((((INAC == Zero) && (INCH == Zero)) && (IDIS == Zero)))
						{
							DerefOf (Local0 [One]) [Zero] = Zero
						}
						ElseIf (((((INAC == Zero) && (INCH == 0x02)) && (
							IDIS == One)) && (B1B2 (AXC0,AXC1) == Zero)))
						{
							DerefOf (Local0 [One]) [Zero] = One
						}
						ElseIf (((INAC == One) && (IDIS == 0x02)))
						{
							DerefOf (Local0 [One]) [Zero] = 0x02
						}
						ElseIf (((((INAC == Zero) && (INCH == 0x02)) && (
							IDIS == One)) && (B1B2 (AXC0,AXC1) == 0xFA)))
						{
							DerefOf (Local0 [One]) [Zero] = 0x03
						}
						ElseIf (((INAC == Zero) && (INCH == 0x03)))
						{
							DerefOf (Local0 [One]) [Zero] = 0x04
						}
					}
					Else
					{
						DerefOf (Local0 [One]) [Zero] = 0xFF
					}

					If ((BATP & 0x02))
					{
						BSEL = One
						DerefOf (Local0 [One]) [One] = Zero
						If ((((INAC == Zero) && (INCH == Zero)) && (IDIS == Zero)))
						{
							DerefOf (Local0 [One]) [One] = Zero
						}
						ElseIf (((((INAC == Zero) && (INCH == One)) && (
							IDIS == 0x02)) && (B1B2 (AXC0,AXC1) == Zero)))
						{
							DerefOf (Local0 [One]) [One] = One
						}
						ElseIf (((INAC == One) && (IDIS == One)))
						{
							DerefOf (Local0 [One]) [One] = 0x02
						}
						ElseIf (((((INAC == Zero) && (INCH == One)) && (
							IDIS == 0x02)) && (B1B2 (AXC0,AXC1) == 0xFA)))
						{
							DerefOf (Local0 [One]) [One] = 0x03
						}
						ElseIf (((INAC == Zero) && (INCH == 0x03)))
						{
							DerefOf (Local0 [One]) [One] = 0x04
						}
					}
					Else
					{
						DerefOf (Local0 [One]) [One] = 0xFF
					}
				}
				Else
				{
					Local0 = Package (0x02)
						{
							0x35, 
							Zero
						}
				}

				Release (ECMX)
				Return (Local0)
			}
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XBTC ())
            }
        }

		Method (SBTC, 3, NotSerialized)
		{
            If (_OSI ("Darwin"))
            {
				Debug = "Enter SetBatteryControl"
				Acquire (ECMX, 0xFFFF)
				If (ECRG)
				{
					Local0 = Arg2
					Debug = Local0
					Local4 = Package (0x01)
						{
							0x06
						}
					Local1 = Zero
					Local2 = Zero
					Local1 = DerefOf (Local0 [Zero])
					If ((Local1 == Zero))
					{
						Debug = "battery 0"
						If ((BATP & One))
						{
							Local2 = DerefOf (Local0 [One])
							If ((Local2 == Zero))
							{
								INCH = Zero
								IDIS = Zero
								INAC = Zero
								B1B2 (AXC0, AXC1) = Package (){Zero}
								PSSB = One
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == One))
							{
								INAC = Zero
								INCH = 0x02
								IDIS = One
								B1B2 (AXC0,AXC1) = Package (){Zero}
								PSSB = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x02))
							{
								INAC = One
								INCH = One
								IDIS = 0x02
								PSSB = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x03))
							{
								INCH = 0x02
								IDIS = One
								INAC = Zero
								B1B2 (AXC0,AXC1) = Package (){0xFA}
								PSSB = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x04))
							{
								B1B2 (AXC0,AXC1) = Package (){0xFA}
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x05))
							{
								INAC = Zero
								INCH = 0x03
								Local4 = Package (0x01)
									{
										Zero
									}
							}
						}
						Else
						{
							Local4 = Package (0x01)
								{
									0x34
								}
						}
					}

					If ((Local1 == One))
					{
						If ((BATP & 0x02))
						{
							Debug = "battery 1"
							Local2 = DerefOf (Local0 [One])
							If ((Local2 == Zero))
							{
								INCH = Zero
								IDIS = Zero
								INAC = Zero
								B1B2 (AXC0,AXC1) = Package (){Zero}
								PSSB = One
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == One))
							{
								INAC = Zero
								INCH = One
								IDIS = 0x02
								B1B2 (AXC0,AXC1) = Package (){Zero}
								PSSB = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x02))
							{
								INAC = One
								INCH = 0x02
								IDIS = One
								PSSB = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x03))
							{
								INCH = One
								IDIS = 0x02
								INAC = Zero
								B1B2 (AXC0,AXC1) = Package (){0xFA}
								PSSB = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x04))
							{
								INCH = Zero
								IDIS = Zero
								INAC = Zero
								Local4 = Package (0x01)
									{
										Zero
									}
							}

							If ((Local2 == 0x05))
							{
								INAC = Zero
								INCH = 0x03
								Local4 = Package (0x01)
									{
										Zero
									}
							}
						}
						Else
						{
							Local4 = Package (0x01)
								{
									0x34
								}
						}
					}
				}

				Release (ECMX)
				Return (Local4)
			}
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.XSTC (Arg0, Arg1, Arg2))
            }
        }
    }
    Scope (_TZ)
    {
        Method (GCGC, 0, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Name (LTMP, Buffer (0x02){})
                If (\_SB.PCI0.LPCB.EC0.ECRG)
                {
                    Acquire (\_SB.PCI0.LPCB.EC0.ECMX, 0xFFFF)
                    LTMP = B1B2 (\_SB.PCI0.LPCB.EC0.BPR0, \_SB.PCI0.LPCB.EC0.BPR1)
                    Release (\_SB.PCI0.LPCB.EC0.ECMX)
                }

                Return (LTMP) /* \_TZ_.GCGC.LTMP */
            }
            Else
            {
                Return (\_TZ.XCGC ())
            }
        }
    }
}

