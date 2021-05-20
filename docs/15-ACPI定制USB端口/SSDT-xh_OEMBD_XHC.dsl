//
DefinitionBlock ("", "SSDT", 2, "OCLT", "MY_OEMBD", 0x00000000)
{
    External (_SB_.CBID, IntObj)
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
    External (_SB_.PCI0.XHC_.RHUB.SS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR1, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR2, DeviceObj)
    //External (CBID, UnknownObj)

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

        Method (TPLD, 2, Serialized)
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
            CreateField (DerefOf (PCKG [Zero]), 0x4A, 0x04, SHAP)
            SHAP = One
            CreateField (DerefOf (PCKG [Zero]), 0x20, 0x10, WID)
            WID = 0x08
            CreateField (DerefOf (PCKG [Zero]), 0x30, 0x10, HGT)
            HGT = 0x03
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.TPLD.PCKG */
        }

        Method (TUPC, 1, Serialized)
        {
            Name (PCKG, Package (0x04)
            {
                One, 
                Zero, 
                Zero, 
                Zero
            })
            PCKG [One] = Arg0
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.TUPC.PCKG */
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x03, 
                    0x00, 
                    0x00
                })
            }
            
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, One))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x03, 
                    0x00, 
                    0x00
                })
            }
            
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
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x03, 
                    0x00, 
                    0x00
                })
            }
            
            If ((CBID == 0x07A6))
            {
                Return (GUPC (Zero))
            }
            Else
            {
                Return (GUPC (One))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If ((CBID == 0x07A6))
            {
                Return (GPLD (Zero, Zero))
            }
            Else
            {
                Return (GPLD (One, 0x03))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x04))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0xFF, 
                    0x00, 
                    0x00
                })
            }
            
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x05))
        }

        Device (CAM5)
        {
            Name (_ADR, 0x05)  // _ADR: Address
            Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
            {
                ToPLD (
                    PLD_Revision           = 0x1,
                    PLD_IgnoreColor        = 0x1,
                    PLD_Red                = 0x0,
                    PLD_Green              = 0x0,
                    PLD_Blue               = 0x0,
                    PLD_Width              = 0x0,
                    PLD_Height             = 0x0,
                    PLD_UserVisible        = 0x1,
                    PLD_Dock               = 0x0,
                    PLD_Lid                = 0x1,
                    PLD_Panel              = "FRONT",
                    PLD_VerticalPosition   = "UPPER",
                    PLD_HorizontalPosition = "CENTER",
                    PLD_Shape              = "UNKNOWN",
                    PLD_GroupOrientation   = 0x0,
                    PLD_GroupToken         = 0x0,
                    PLD_GroupPosition      = 0x0,
                    PLD_Bay                = 0x0,
                    PLD_Ejectable          = 0x0,
                    PLD_EjectRequired      = 0x0,
                    PLD_CabinetNumber      = 0x0,
                    PLD_CardCageNumber     = 0x0,
                    PLD_Reference          = 0x0,
                    PLD_Rotation           = 0x0,
                    PLD_Order              = 0x0)

            })
        }

        Device (CAMC)
        {
            Name (_ADR, 0x0D)  // _ADR: Address
            Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
            {
                ToPLD (
                    PLD_Revision           = 0x1,
                    PLD_IgnoreColor        = 0x1,
                    PLD_Red                = 0x0,
                    PLD_Green              = 0x0,
                    PLD_Blue               = 0x0,
                    PLD_Width              = 0x0,
                    PLD_Height             = 0x0,
                    PLD_UserVisible        = 0x1,
                    PLD_Dock               = 0x0,
                    PLD_Lid                = 0x1,
                    PLD_Panel              = "FRONT",
                    PLD_VerticalPosition   = "UPPER",
                    PLD_HorizontalPosition = "CENTER",
                    PLD_Shape              = "UNKNOWN",
                    PLD_GroupOrientation   = 0x0,
                    PLD_GroupToken         = 0x0,
                    PLD_GroupPosition      = 0x0,
                    PLD_Bay                = 0x0,
                    PLD_Ejectable          = 0x0,
                    PLD_EjectRequired      = 0x0,
                    PLD_CabinetNumber      = 0x0,
                    PLD_CardCageNumber     = 0x0,
                    PLD_Reference          = 0x0,
                    PLD_Rotation           = 0x0,
                    PLD_Order              = 0x0)

            })
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS06)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS07)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0xFF, 
                    0x00, 
                    0x00
                })
            }
            
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x07))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS08)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (One))
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
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x09, 
                    0x00, 
                    0x00
                })
            }
            Return (TUPC (0x09))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (TPLD (One, 0x09))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS10)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0A))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.USR1)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.USR2)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
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
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x03, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, One))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x04))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x03, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x02))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x03, 
                    0x00, 
                    0x00
                })
            }
            If ((CBID == 0x07A6))
            {
                Return (GUPC (Zero))
            }
            Else
            {
                Return (GUPC (One))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If ((CBID == 0x07A6))
            {
                Return (GPLD (Zero, Zero))
            }
            Else
            {
                Return (GPLD (One, 0x03))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0x00,
                    0x00, 
                    0x00, 
                    0x00
                })
            }
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS06)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (_OSI ("Darwin"))
            {
                Return (Package ()
                {
                    0xFF,
                    0x09, 
                    0x00, 
                    0x00
                })
            }
            Return (TUPC (0x09))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (TPLD (One, 0x09))
        }
    }
}

