```dsl
// battery
// In config ACPI, _BIF renamed XBIF
// Find:     5F 42 49 46
// Replace:  58 42 49 46
//
// In config ACPI, _BST renamed XBST
// Count:    1
// Find:     5F 42 53 54
// Replace:  58 42 53 54
// Skip:     3
// TableSignature: 44 53 44 54
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "BAT0", 0)
{
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.BAT0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.XBIF, MethodObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.XBST, MethodObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.BBIF, PkgObj)
    External(_SB.PCI0.LPCB.EC0.BAT0.BBST, PkgObj)
    External(_SB.PCI0.LPCB.EC0.BSTS, FieldUnitObj)
    //

    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }
    
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion (ERM0, EmbeddedControl, Zero, 0xFF)          
        Field (ERM0, ByteAcc, Lock, Preserve)
        {
            Offset (0x60), 
            GCP0,8,GCP1,8, //DGCP,   16, 
            LCP0,8,LCP1,8, //FLCP,   16, 
            GVO0,8,GVO1,8, //DGVO,   16, 
            BDW0,8,BDW1,8, //BDW,    16, 
            BDL0,8,BDL1,8, //BDL,    16, 
            BPR0,8,BPR1,8, //BPR,    16, 
            BRC0,8,BRC1,8, //BRC,    16, 
            BPV0,8,BPV1,8, //BPV,    16
        }
    }      
    
    Scope(_SB.PCI0.LPCB.EC0.BAT0)
    {
        Method (_BIF, 0, NotSerialized)
	    {
            If (_OSI ("Darwin"))
            {
                Sleep (0x0A)
                BBIF [One] = B1B2 (\_SB.PCI0.LPCB.EC0.GCP0,\_SB.PCI0.LPCB.EC0.GCP1)
                Sleep (0x0A)
                BBIF [0x02] = B1B2 (\_SB.PCI0.LPCB.EC0.LCP0,\_SB.PCI0.LPCB.EC0.LCP1)
                Sleep (0x0A)
                BBIF [0x04] = B1B2 (\_SB.PCI0.LPCB.EC0.GVO0,\_SB.PCI0.LPCB.EC0.GVO1)
                Sleep (0x0A)
                BBIF [0x05] = B1B2 (\_SB.PCI0.LPCB.EC0.BDW0,\_SB.PCI0.LPCB.EC0.BDW1)
                Sleep (0x0A)
                BBIF [0x06] = B1B2 (\_SB.PCI0.LPCB.EC0.BDL0,\_SB.PCI0.LPCB.EC0.BDL1)
                Return (\_SB.PCI0.LPCB.EC0.BAT0.BBIF)
			}
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.BAT0.XBIF ())
            }
        }

		Method (_BST, 0, NotSerialized)
		{
            If (_OSI ("Darwin"))
            {
                Sleep (0x0A)
                BBST [Zero] = \_SB.PCI0.LPCB.EC0.BSTS
                Sleep (0x0A)
                BBST [One] = B1B2 (\_SB.PCI0.LPCB.EC0.BPR0,\_SB.PCI0.LPCB.EC0.BPR1)
                Sleep (0x0A)
                BBST [0x02] = B1B2 (\_SB.PCI0.LPCB.EC0.BRC0,\_SB.PCI0.LPCB.EC0.BRC1)
                Sleep (0x0A)
                BBST [0x03] = B1B2 (\_SB.PCI0.LPCB.EC0.BPV0,\_SB.PCI0.LPCB.EC0.BPV1)
                Return (\_SB.PCI0.LPCB.EC0.BAT0.BBST)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.EC0.BAT0.XBST ())
            }
        }
    }
}
//EOF
```
