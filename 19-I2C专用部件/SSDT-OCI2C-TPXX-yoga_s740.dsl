// In config ACPI, TPD0:_STA to XSTA
// Count:          1
// Find:           5F 53 54 41 00
// Replace:        58 53 54 41 00
// Skip:           109
// TableSignature: 44 53 44 54
//
// TPxx is my new device
DefinitionBlock("", "SSDT", 2, "ACDT", "I2C-TPXX", 0)
{
    External(_SB.PCI0.I2C1, DeviceObj)
    External(_SB.PCI0.I2C1.TPD0, DeviceObj)
    External(_SB.GNUM, MethodObj)
    External(_SB.INUM, MethodObj)
    External(TPTY, FieldUnitObj)
    External(_SB.PCI0.HIDG, IntObj)
    External(_SB.PCI0.TP7G, IntObj)
    External(_SB.PCI0.HIDD, MethodObj)
    External(_SB.PCI0.TP7D, MethodObj)
    External(_SB.PCI0.I2CM, MethodObj)
    //External(_SB.PCI0.LPCB.EC0.ECTP, FieldUnitObj)

    Scope (_SB.PCI0.I2C1.TPD0)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    
    Scope (_SB.PCI0.I2C1)
    {
        Device (TPXX)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x002C, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, _Y3B, Exclusive,
                    )
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y3C)
                {
                    0x00000000,
                }
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y3B._ADR, BADR)
            CreateDWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y3B._SPE, SPED)
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C1.TPXX._Y3C._INT, INT2)
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                //If ((OSYS < 0x07DC))
                //{
                //    SRXO (0x06010010, One)
                //}

                INT1 = GNUM (0x06010010)
                INT2 = INUM (0x06010010)
                If ((TPTY == 0x02))
                {
                    _HID = "MSFT0001"
                    _SUB = "SYNA0001"
                    BADR = 0x2C
                    HID2 = 0x20
                    Return (Zero)
                }
            }           
            Name (_HID, "XXXX0000")
            Name (_CID, "PNP0C50" )
            Name (_SUB, "XXXX0000")
            Name (_S0W, 0x03)
            Method (_DSM, 4, Serialized)
            {
                If ((Arg0 == HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                If ((Arg0 == TP7G))
                {
                    Return (TP7D (Arg0, Arg1, Arg2, Arg3, SBFB, SBFG))
                }

                Return (Buffer (One)
                {
                     0x00
                })
            }
                
            Method (_CRS, 0, NotSerialized)
            {
                //Return (ConcatenateResTemplate (SBFB, SBFG))
                Return (ConcatenateResTemplate (SBFB, SBFI))
            }    
            
            
            /*
            Method (TPRD, 0, Serialized)
            {
                Return (\_SB.PCI0.LPCB.EC0.ECTP)
            }
            
            Method (TPWR, 1, Serialized)
            {
                \_SB.PCI0.LPCB.EC0.ECTP = Arg0
            }
            */
            
            Method (_STA, 0, Serialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}
//EOF