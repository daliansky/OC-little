```swift
//// battery
// In config ACPI, UPBI to XPBI
// Find:     5550424900
// Replace:  5850424900
//
// In config ACPI, UPBS  to XPBS
// Find:     5550425300
// Replace:  5850425300
//
// In config ACPI, IVBI to XVBI
// Find:     4956424900
// Replace:  5856424900
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "BAT0", 0x00000000)
{
    External (_SB.BAT0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.BAT0.XPBI, MethodObj)
    External (_SB.BAT0.XPBS, MethodObj)
    External (_SB.BAT0.XVBI, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ECWT, MethodObj)
    External (_SB.PCI0.LPCB.EC0.MBST, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BACR, FieldUnitObj)
    
    External (_SB.BAT0.PBIF, PkgObj)
    External (_SB.BAT0.PBST, PkgObj)
    External (_SB.BATM, MutexObj)
    External (_SB.BAT0.BTUR, IntObj)
    External (POSW, MethodObj)

    Method (B1B2, 2, NotSerialized)
    {
        Return ((Arg0 | (Arg1 << 0x08)))
    }

    Scope (_SB.PCI0.LPCB.EC0)
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
        OperationRegion (ERM2, EmbeddedControl, Zero, 0xFF)
        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
                Offset (0x70), 
                SCP0,8,SCP1,8, //DSCP,   16, 
                ACP0,8,ACP1,8, //LACP,   16, 
                SVG0,8,SVG1,8, //DSVG,   16,
                Offset (0x77), 
                //BANA,   64, Offset (0x77) ,RECB(0x77,64)

                Offset (0x82), 
                    ,8,
                CUR0,8,CUR1,8, //MCUR,   16, 
                BRM0,8,BRM1,8, //MBRM,   16, 
                BCV0,8,BCV1,8, //MBCV,   16,  
        }
    }
    
    Scope (_SB.BAT0)
    {
        Method (UPBI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Acquire (BATM, 0xFFFF)
                PBIF [One] = B1B2 (^^PCI0.LPCB.EC0.SCP0, ^^PCI0.LPCB.EC0.SCP1)
                PBIF [0x02] = B1B2 (^^PCI0.LPCB.EC0.ACP0, ^^PCI0.LPCB.EC0.ACP1)
                PBIF [0x04] = B1B2 (^^PCI0.LPCB.EC0.SVG0, ^^PCI0.LPCB.EC0.SVG1)
                PBIF [0x05] = (B1B2 (^^PCI0.LPCB.EC0.SCP0, ^^PCI0.LPCB.EC0.SCP1)/0x0A)
                PBIF [0x06] = (B1B2 (^^PCI0.LPCB.EC0.SCP0, ^^PCI0.LPCB.EC0.SCP1)/0x64)
                PBIF [0x09] = "MWL32b"
                If ((B1B2 (^^PCI0.LPCB.EC0.SCP0, ^^PCI0.LPCB.EC0.SCP1) < 0x1770))
                {
                    PBIF [0x09] = "MWL32b"
                }

                If ((B1B2 (^^PCI0.LPCB.EC0.SCP0, ^^PCI0.LPCB.EC0.SCP1) < 0x0BB8))
                {
                    PBIF [0x09] = "MWL31b"
                }

                Release (BATM)
            }
            Else
            {
                \_SB.BAT0.XPBI()
            }
        }
            
        Method (UPBS, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If ((B1B2 (^^PCI0.LPCB.EC0.BRM0, ^^PCI0.LPCB.EC0.BRM1) == Zero))
                {
                    BTUR = One
                }
                ElseIf ((BTUR == One))
                {
                    Notify (BAT0, 0x81) // Information Change
                    Notify (BAT0, 0x80) // Status Change
                    BTUR = Zero
                }

                Local5 = B1B2 (^^PCI0.LPCB.EC0.CUR0, ^^PCI0.LPCB.EC0.CUR1)
                PBST [One] = POSW (Local5)
                Local5 = B1B2 (^^PCI0.LPCB.EC0.BRM0, ^^PCI0.LPCB.EC0.BRM1)
                If ((^^PCI0.LPCB.EC0.BACR == One))
                {
                    Local5 = ((B1B2 (^^PCI0.LPCB.EC0.SCP0, ^^PCI0.LPCB.EC0.SCP1) / 0x32) + 
                        B1B2 (^^PCI0.LPCB.EC0.BRM0, ^^PCI0.LPCB.EC0.BRM1))
                }

                Local5 = B1B2 (^^PCI0.LPCB.EC0.BRM0, ^^PCI0.LPCB.EC0.BRM1)
                If (!(Local5 & 0x8000))
                {
                    If ((Local5 != DerefOf (PBST [0x02])))
                    {
                        PBST [0x02] = Local5
                    }
                }

                PBST [0x03] = B1B2 (^^PCI0.LPCB.EC0.BCV0, ^^PCI0.LPCB.EC0.BCV1)
                PBST [Zero] = ^^PCI0.LPCB.EC0.MBST
            }
            Else
            {
                \_SB.BAT0.XPBS()
            }
        }
            
        Method (IVBI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                PBIF [One] = 0xFFFFFFFF
                PBIF [0x02] = 0xFFFFFFFF
                PBIF [0x04] = 0xFFFFFFFF
                PBIF [0x09] = "Bad"
                PBIF [0x0A] = "Bad"
                PBIF [0x0B] = "Bad"
                PBIF [0x0C] = "Bad"
                ^^PCI0.LPCB.EC0.ECWT (Zero, ^^PCI0.LPCB.EC0.RECB (0x77, 64))
            }
            Else
            {
                \_SB.BAT0.XVBI()
            }
        }
    }
}

```
