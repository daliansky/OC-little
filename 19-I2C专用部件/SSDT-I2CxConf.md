```swift
/*
 * Attention! Before you use this hotpatch!
 * Please follow the instructions below!
 * Otherwise you may receive ACPI Errors!
 *
 * ============================ *
 *                              *
 * 1. Rename SSCN to XSCN       *
 * ---- Find:     5353434e ---- *
 * ---- Replace:  5853434e ---- *
 *                              *
 *============================= *
 *                              *
 * 1. Rename FMCN to XMCN       *
 * ---- Find:     464d434e ---- *
 * ---- Replace:  584d434e ---- *
 *                              *
 *============================= *
 *
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "I2CxConf", 0x00000000)
{
    External (_SB.PCI0.GPI0._HID, MethodObj)
    External (_SB.PCI0.I2C0, DeviceObj)
    External (_SB.PCI0.I2C0.XMCN, MethodObj)
    External (_SB.PCI0.I2C0.XSCN, MethodObj)
    External (_SB.PCI0.I2C1, DeviceObj)
    External (_SB.PCI0.I2C1.XMCN, MethodObj)
    External (_SB.PCI0.I2C1.XSCN, MethodObj)
    External (USTP, FieldUnitObj)
    External (FMD0, IntObj)
    External (FMD1, IntObj)
    External (FMH0, IntObj)
    External (FMH1, IntObj)
    External (FML0, IntObj)
    External (FML1, IntObj)
    External (SSD0, IntObj)
    External (SSD1, IntObj)
    External (SSH0, IntObj)
    External (SSH1, IntObj)
    External (SSL0, IntObj)
    External (SSL1, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            Method (XXEN, 0, NotSerialized)
            {
                If ((\_SB.PCI0.GPI0._HID() == "INT344B") || (\_SB.PCI0.GPI0._HID() == "INT345D"))
                {
                    Return (One)
                }

                Return (Zero)
            }

            Method (PKGX, 3, Serialized)
            {
                Name (PKG, Package (0x03)
                {
                    Zero, 
                    Zero, 
                    Zero
                })
                PKG [Zero] = Arg0
                PKG [One] = Arg1
                PKG [0x02] = Arg2
                Return (PKG)
            }
        }
    }

    Scope (_SB.PCI0.I2C0)
    {
        Method (SSCN, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (((CondRefOf (SSH0) && CondRefOf (SSL0)) && CondRefOf (SSD0)))
                {
                    Return (PKGX (SSH0, SSL0, SSD0))
                }

                If (\XXEN ())
                {
                    Return (PKGX (0x01B0, 0x01FB, 0x1E))
                }

                Return (PKGX (0x03F2, 0x043D, 0x62))
            }
            ElseIf (CondRefOf (\_SB.PCI0.I2C0.XSCN))
            {
                If (USTP)
                {
                    Return (\_SB.PCI0.I2C0.XSCN ())
                }
            }

            Return (Zero)
        }

        Method (FMCN, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (((CondRefOf (FMH0) && CondRefOf (FML0)) && CondRefOf (FMD0)))
                {
                    Return (PKGX (FMH0, FML0, FMD0))
                }

                If (\XXEN ())
                {
                    Return (PKGX (0x48, 0xA0, 0x1E))
                }

                Return (PKGX (0x0101, 0x012C, 0x62))
            }
            ElseIf (CondRefOf (\_SB.PCI0.I2C0.XMCN))
            {
                If (USTP)
                {
                    Return (\_SB.PCI0.I2C0.XMCN ())
                }
            }

            Return (Zero)
        }
    }

    Scope (_SB.PCI0.I2C1)
    {
        Method (SSCN, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (((CondRefOf (SSH1) && CondRefOf (SSL1)) && CondRefOf (SSD1)))
                {
                    Return (PKGX (SSH1, SSL1, SSD1))
                }

                If (\XXEN ())
                {
                    Return (PKGX (0x0210, 0x0280, 0x1E))
                }

                Return (PKGX (0x03F2, 0x043D, 0x62))
            }
            ElseIf (CondRefOf (\_SB.PCI0.I2C1.XSCN))
            {
                If (USTP)
                {
                    Return (\_SB.PCI0.I2C1.XSCN ())
                }
            }
        
            Return (Zero)
        }

        Method (FMCN, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If (((CondRefOf (FMH1) && CondRefOf (FML1)) && CondRefOf (FMD1)))
                {
                    Return (PKGX (FMH1, FML1, FMD1))
                }

                If (\XXEN ())
                {
                    Return (PKGX (0x80, 0xA0, 0x1E))
                }

                Return (PKGX (0x0101, 0x012C, 0x62))
            }
            ElseIf (CondRefOf (\_SB.PCI0.I2C1.XMCN))
            {
                If (USTP)
                {
                    Return (\_SB.PCI0.I2C1.XMCN ())
                }
            }

            Return (Zero)
        }
    }
}
//EOF
```
