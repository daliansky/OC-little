```swift
// TP01 is my new TouchPad device
DefinitionBlock("", "SSDT", 2, "ACDT", "I2C1TP01", 0)
{
    External(_SB.PCI0.I2C1, DeviceObj)
    External(GPDI, FieldUnitObj)
    External(TPDT, FieldUnitObj)
    External(PHID, FieldUnitObj)
    External(TPDH, FieldUnitObj)
    External(TPDB, FieldUnitObj)
    External(TPDS, FieldUnitObj)
    External(TPDM, FieldUnitObj)
    External(_SB.GNUM, MethodObj)
    External(_SB.INUM, MethodObj)
    External(_SB.SHPO, MethodObj)
    External(_SB.PCI0.HIDG, IntObj)
    External(_SB.PCI0.TP7G, IntObj)
    External(_SB.PCI0.HIDD, MethodObj)
    External(_SB.PCI0.TP7D, MethodObj)
    External(_SB.PCI0.I2CM, MethodObj)
    External(_SB.PCI0.I2C1.I2CX, IntObj)
    External(TPDT, FieldUnitObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPDT = 0
        }
    }
    
    Scope (_SB.PCI0.I2C1)
    {
        Device (TP01)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0000, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "NULL",
                    0x00, ResourceConsumer, _Y43, Exclusive,
                    )
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y44)
                {
                    0x00000000,
                }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C1.TP01._Y43._ADR, BADR)  // _ADR: Address
            CreateDWordField (SBFB, \_SB.PCI0.I2C1.TP01._Y43._SPE, SPED)  // _SPE: Speed
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C1.TP01._Y44._INT, INT2)  // _INT: Interrupts
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                //If ((OSYS < 0x07DC))
                //{
                //    SRXO (GPDI, One)
                //}

                INT1 = GNUM (GPDI)
                INT2 = INUM (GPDI)
                If ((TPDM == Zero))
                {
                    SHPO (GPDI, One)
                }

                /*
                If ((TPDT == One))
                {
                    _HID = "SYNA2393"
                    HID2 = 0x20
                    Return (Zero)
                }

                If ((TPDT == 0x02))
                {
                    _HID = "06CB2846"
                    HID2 = 0x20
                    Return (Zero)
                }

                If ((TPDT == 0x06))
                {
                    _HID = "ALPS0000"
                    HID2 = 0x20
                    BADR = 0x2C
                    Return (Zero)
                }
                */

                //If ((TPDT == 0x05))
                If ((TPDT == 0))
                {
                    _HID = "CUST0001"
                    If (CondRefOf (PHID))
                    {
                        _HID = ToString (PHID, Ones)
                    }

                    HID2 = TPDH /* \TPDH */
                    BADR = TPDB /* \TPDB */
                    If ((TPDS == Zero))
                    {
                        SPED = 0x000186A0
                    }

                    If ((TPDS == One))
                    {
                        SPED = 0x00061A80
                    }

                    If ((TPDS == 0x02))
                    {
                        SPED = 0x000F4240
                    }

                    Return (Zero)
                }
            }

            Name (_HID, "XXXX0000")  // _HID: Hardware ID
            Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
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
                     0x00                                             // .
                })
            }
            
            Method (_STA, 0, NotSerialized)
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
            
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                //If ((OSYS < 0x07DC))
                //{
                //    Return (SBFI) /* \_SB_.PCI0.I2C1.TPD0.SBFI */
                //}

                //If ((TPDM == Zero))
                //{
                    Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFG))
                //}

                //Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFI))
            }
        }
    }
}
//EOF
```
