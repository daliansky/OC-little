// TPxx is my new's device
DefinitionBlock("", "SSDT", 2, "ACDT", "I2C-TPXX", 0)
{
    External(_SB.PCI0.I2C1, DeviceObj)
    External(_SB.GNUM, MethodObj)
    External(_SB.INUM, MethodObj)
    External(_SB.SHPO, MethodObj)
    External(GPDI, FieldUnitObj)
    External(TPDM, FieldUnitObj)
    External(TPDT, FieldUnitObj)
    External(TPTY, FieldUnitObj)
    External(TPDS, FieldUnitObj)
    External(TPTP, FieldUnitObj)
    External(_SB.PCI0.HIDG, IntObj)
    External(_SB.PCI0.TP7G, IntObj)
    External(_SB.PCI0.HIDD, MethodObj)
    External(_SB.PCI0.TP7D, MethodObj)
    External(_SB.PCI0.I2CM, MethodObj)
    External(_SB.PCI0.I2C1.I2CX, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPDT = 0
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
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0000
                    }
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y3C)
                {
                    0x00000000,
                }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y3B._ADR, BADR)
            CreateDWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y3B._SPE, SPED)
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C1.TPXX._Y3C._INT, INT2)
            Method (_INI, 0, NotSerialized)
            {
                //If ((OSYS < 0x07DC))
                //{
                //    SRXO (GPDI, One)
                //}

                INT1 = GNUM (GPDI)
                INT2 = INUM (GPDI)
                //If ((TPDM == Zero))
                //{
                SHPO (GPDI, One)
                //}

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
                //{
                    If ((TPTY == One))
                    {
                        //ADBG ("TPTY=1")
                        _HID = "MSFT0001"
                        _SUB = "ELAN0001"
                        BADR = 0x15
                        HID2 = One
                    }

                    If ((TPTY == 0x02))
                    {
                        //ADBG ("TPTY=2")
                        If ((TPTP == 0xCDF4))
                        {
                            _HID = "SYNACDF4"
                        }
                        Else
                        {
                            _HID = "SYNACD3E"
                        }

                        _SUB = "SYNA0001"
                        BADR = 0x2C
                        HID2 = 0x20
                    }

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
                //}
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
                Return (ConcatenateResTemplate (I2CM (I2CX, BADR, SPED), SBFG))
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
        }
    }
}
//EOF