// TP02 is my new Touch screen device
DefinitionBlock("", "SSDT", 2, "ACDT", "I2C0TP02", 0)
{
    External(_SB.PCI0.I2C0, DeviceObj)
    External(GPLI, FieldUnitObj)
    External(TPLT, FieldUnitObj)
    External(TPLS, FieldUnitObj)
    External(TPPD, FieldUnitObj)
    External(TPLH, FieldUnitObj)
    External(TPLB, FieldUnitObj)
    External(TPLM, FieldUnitObj)
    External(_SB.GNUM, MethodObj)
    External(_SB.INUM, MethodObj)
    External(_SB.SHPO, MethodObj)
    External(_SB.PCI0.HIDG, IntObj)
    External(_SB.PCI0.TP7G, IntObj)
    External(_SB.PCI0.HIDD, MethodObj)
    External(_SB.PCI0.TP7D, MethodObj)
    External(_SB.PCI0.I2CM, MethodObj)
    External(_SB.PCI0.I2C0.I2CX, IntObj)
    External(TPLT, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPLT = 0
        }
    }
    
    Scope (_SB.PCI0.I2C0)
    {
        Device (TP02)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0000, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "NULL",
                    0x00, ResourceConsumer, _Y41, Exclusive,
                    )
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, Exclusive, PullDefault, 0x0000,
                    "\\_SB.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, _Y42)
                {
                    0x00000000,
                }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C0.TP02._Y41._ADR, BADR)  // _ADR: Address
            CreateDWordField (SBFB, \_SB.PCI0.I2C0.TP02._Y41._SPE, SPED)  // _SPE: Speed
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C0.TP02._Y42._INT, INT2)  // _INT: Interrupts
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                //If ((OSYS < 0x07DC))
                //{
                //    SRXO (GPLI, One)
                //}

                INT1 = GNUM (GPLI)
                INT2 = INUM (GPLI)
                If ((TPLM == Zero))
                {
                    SHPO (GPLI, One)
                }

                /*
                If ((TPLT == One))
                {
                    _HID = "ATML3432"
                    HID2 = Zero
                    BADR = 0x4C
                    SPED = 0x00061A80
                    Return (Zero)
                }

                If ((TPLT == 0x02))
                {
                    _HID = "ATML2952"
                    HID2 = Zero
                    BADR = 0x4A
                    SPED = 0x00061A80
                    Return (Zero)
                }

                If ((TPLT == 0x03))
                {
                    _HID = "ELAN2097"
                    HID2 = One
                    BADR = 0x10
                    SPED = 0x00061A80
                    Return (Zero)
                }

                If ((TPLT == 0x04))
                {
                    _HID = "NTRG0001"
                    HID2 = One
                    BADR = 0x07
                    SPED = 0x00061A80
                    Return (Zero)
                }

                If ((TPLT == 0x05))
                {
                    _HID = "NTRG0002"
                    HID2 = One
                    BADR = 0x64
                    SPED = 0x00061A80
                    Return (Zero)
                }

                If ((TPLT == 0x06))
                {
                    _HID = "WCOM508E"
                    HID2 = One
                    BADR = 0x0A
                    If ((TPLS == Zero))
                    {
                        SPED = 0x00061A80
                    }

                    If ((TPLS == One))
                    {
                        SPED = 0x00061A80
                    }

                    If ((TPLS == 0x02))
                    {
                        SPED = 0x000F4240
                    }

                    Return (Zero)
                }
                */

                //If ((TPLT == 0x07))
                If ((TPLT == 0))
                {
                    _HID = "CUST0000"
                    HID2 = TPLH /* \TPLH */
                    BADR = TPLB /* \TPLB */
                    If ((TPLS == Zero))
                    {
                        SPED = 0x000186A0
                    }

                    If ((TPLS == One))
                    {
                        SPED = 0x00061A80
                    }

                    If ((TPLS == 0x02))
                    {
                        SPED = 0x000F4240
                    }

                    If (CondRefOf (TPPD))
                    {
                        _HID = ToString (TPPD, Ones)
                    }

                    Return (Zero)
                }
            }

            Name (_HID, "XXXX0000")  // _HID: Hardware ID
            Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
            Name (_S0W, 0x04)  // _S0W: S0 Device Wake State
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
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                //If ((OSYS < 0x07DC))
                //{
                //    Return (SBFI) /* \_SB_.PCI0.I2C0.TPL1.SBFI */
                //}

                //If ((TPLM == Zero))
                //{
                    Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFG))
                //}

                //Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFI))
            }
        }
    }
}
//EOF