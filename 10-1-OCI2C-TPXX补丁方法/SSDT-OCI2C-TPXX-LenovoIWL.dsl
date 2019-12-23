// TPxx is my new's device
DefinitionBlock("", "SSDT", 2, "ACDT", "I2C-TPXX", 0)
{
    External(_SB.PCI0.I2C0, DeviceObj)
    External(TPDD, FieldUnitObj)
    External(TPDF, FieldUnitObj)
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPDD = 3
        }
    }
    
    //path:_SB.PCI0.I2C0.TPAD
    Scope (_SB.PCI0.I2C0)
    {
        Device (TPXX)
        {
                Name (_ADR, One)  // _ADR: Address
                Name (_UID, One)  // _UID: Unique ID
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Name (HID2, Zero)
                Name (TPID, Package (0x04)
                {
                    Package (0x05)
                    {
                        0x10, 
                        0x15, 
                        One, 
                        "MSFT0002", 
                        "PNP0C50"
                    }, 

                    Package (0x05)
                    {
                        0x11, 
                        0x2C, 
                        0x20, 
                        "MSFT0004", 
                        "PNP0C50"
                    }, 

                    Package (0x05)
                    {
                        0xFE, 
                        0x2C, 
                        0x20, 
                        "MSFT0001", 
                        "PNP0C50"
                    }, 

                    Package (0x05)
                    {
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        "MSFT0003", 
                        0x030FD041
                    }
                })
                Name (SBFB, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0000, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.PCI0.I2C0",
                        0x00, ResourceConsumer, _Y4B, Exclusive,
                        )
                })
                Name (SBFI, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, )
                    {
                        0x00000050,
                    }
                })
                Name (SBFG, ResourceTemplate ()
                {
                    GpioInt (Level, ActiveLow, Exclusive, PullUp, 0x0000,
                        "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0038
                        }
                })
                CreateWordField (SBFB, \_SB.PCI0.I2C0.TPXX._Y4B._ADR, ADR0)
                Method (_HID, 0, Serialized)
                {
                    If (~CondRefOf (TPDF))
                    {
                        Name (TPDF, 0xFE)
                    }

                    Switch (One)
                    {
                        Case (Zero)
                        {
                            TPDF = 0xFE
                        }
                        Case (One)
                        {
                        }
                        Default
                        {
                            TPDF = 0xFE
                        }

                    }

                    Return (TPDS (0x03, 0xFE, "MSFT0001"))
                }

                Method (_CID, 0, Serialized)  // _CID: Compatible ID
                {
                    If (~CondRefOf (TPDF))
                    {
                        Name (TPDF, 0xFE)
                    }

                    Switch (One)
                    {
                        Case (Zero)
                        {
                            TPDF = 0xFE
                        }
                        Case (One)
                        {
                        }
                        Default
                        {
                            TPDF = 0xFE
                        }

                    }

                    Return (TPDS (0x04, 0xFE, "PNP0C50"))
                }

                Method (TPDS, 3, NotSerialized)
                {
                    Local0 = Zero
                    Local1 = Zero
                    Local1 = DerefOf (DerefOf (TPID [Local0]) [Zero])
                    While (((Local1 != Arg1) && (Local1 != TPDF)))
                    {
                        Local0++
                        If ((Local0 >= SizeOf (TPID)))
                        {
                            Return (Arg2)
                        }

                        Local1 = DerefOf (DerefOf (TPID [Local0]) [Zero])
                    }

                    Return (DerefOf (DerefOf (TPID [Local0]) [Arg0]))
                }

                Method (_DSM, 4, NotSerialized)
                {
                    If ((Arg0 == ToUUID ("3cdff6f7-4267-4555-ad05-b30a3d8938de")))
                    {
                        If ((Arg2 == Zero))
                        {
                            If ((Arg1 == One))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                      
                                })
                            }
                            Else
                            {
                                Return (Buffer (One)
                                {
                                     0x00                      
                                })
                            }
                        }

                        If ((Arg2 == One))
                        {
                            Return (HID2)
                        }
                    }
                    Else
                    {
                        Return (Buffer (One)
                        {
                             0x00                         
                        })
                    }

                    If ((Arg0 == ToUUID ("ef87eb82-f951-46da-84ec-14871ac6f84b")))
                    {
                        If ((Arg2 == Zero))
                        {
                            If ((Arg1 == One))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                              
                                })
                            }
                            Else
                            {
                                Return (Buffer (One)
                                {
                                     0x00                                       
                                })
                            }
                        }

                        If ((Arg2 == One))
                        {
                            Return (ConcatenateResTemplate (SBFB, SBFG))
                        }
                    }
                    Else
                    {
                        Return (Buffer (One)
                        {
                             0x00                                     
                        })
                    }

                    Return (Buffer (One)
                    {
                         0x00                                
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

                Method (_CRS, 0, Serialized)
                {
                    Local0 = Zero
                    Local1 = Zero
                    Local1 = DerefOf (DerefOf (TPID [Local0]) [Zero])
                    While (((Local1 != 0xFE) && (Local1 != TPDF)))
                    {
                        Local0++
                        If ((Local0 >= SizeOf (TPID)))
                        {
                            Break
                        }

                        Local1 = DerefOf (DerefOf (TPID [Local0]) [Zero])
                    }

                    ADR0 = DerefOf (DerefOf (TPID [Local0]) [One])
                    HID2 = DerefOf (DerefOf (TPID [Local0]) [0x02])

                    //Return (ConcatenateResTemplate (SBFB, SBFG))
                    Return (ConcatenateResTemplate (SBFB, SBFI))
                }
        }
    }
}
//EOF