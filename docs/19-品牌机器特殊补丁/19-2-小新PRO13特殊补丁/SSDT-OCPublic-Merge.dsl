// This is an integrated file
// 
DefinitionBlock ("", "SSDT", 2, "OCLT", "OC-Merge", 0x00001000)
{
    If (_OSI ("Darwin"))
    {
        Method(_SB.HELP)
        {
            Store("This is an integrated file", Debug)
            Store("It includes SSDT-EC.aml and is located at _SB", Debug)
            Store("It includes SSDT-RTC0.aml and is located at _SB", Debug)
            Store("It includes SSDT-USBX.aml", Debug)
            Store("It includes SSDT-ALS0.aml", Debug)
            Store("It includes SSDT-MCHC.aml", Debug)
        }
    }
    
    Scope (_SB)
    {
        If (_OSI ("Darwin"))
        {
            Device (EC)
            {
                Name (_HID, "ACID0001")
            }
            //
            Device (RTC0)
            {
                Name (_HID, EisaId ("PNP0B00"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0070, 
                        0x0070, 
                        0x01, 
                        0x08,
                        )
                    //IRQNoFlags ()
                    //    {8}
                })
            }
            //
            Device (USBX)
            {
                Name (_ADR, Zero)
                Method (_DSM, 4, NotSerialized)
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03
                        })
                    }

                    Return (Package (0x08)
                    {
                        "kUSBSleepPowerSupply", 
                        0x13EC, 
                        "kUSBSleepPortCurrentLimit", 
                        0x0834, 
                        "kUSBWakePowerSupply", 
                        0x13EC, 
                        "kUSBWakePortCurrentLimit", 
                        0x0834
                    })
                }
            }
            //
            Device (ALS0)
            {
                Name (_HID, "ACPI0008")
                Name (_CID, "smc-als")
                Name (_ALI, 0x012C)
                Name (_ALR, Package (0x01)
                {
                    Package (0x02)
                    {
                        0x64, 
                        0x012C
                    }
                })
            }
        }
    }
    
    External (_SB_.PCI0, DeviceObj)
    Scope (_SB.PCI0)
    {
        If (_OSI ("Darwin"))
        {
            Device (MCHC)
            {
                Name (_ADR, Zero)
            }
        }
    }
}
