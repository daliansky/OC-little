// Overriding _PTS and _WAK
// In config ACPI, _PTS to ZPTS(1,N)
// Find:     5F50545301
// Replace:  5A50545301
// or 
// In config ACPI, _PTS to ZPTS(1,S)
// Find:     5F50545309
// Replace:  5A50545309
//
// In config ACPI, _WAK to ZWAK(1,N)
// Find:     5F57414B01
// Replace:  5A57414B01
// or
// In config ACPI, _WAK to ZWAK(1,S)
// Find:     5F57414B09
// Replace:  5A57414B09
//
// In config ACPI, _TTS to ZTTS(1,N)
// Find:     5F54545301
// Replace:  5A54545301
// or
// In config ACPI, _TTS to ZTTS(1,S)
// Find:     5F54545309
// Replace:  5F54545309
//
DefinitionBlock("", "SSDT", 2, "OCLT", "PTSWAK", 0)
{
    External(ZPTS, MethodObj)
    External(ZWAK, MethodObj)
    External(ZTTS, MethodObj)
    External(EXT1, MethodObj)
    External(EXT2, MethodObj)
    External(EXT3, MethodObj)
    External(EXT4, MethodObj)
    External(EXT5, MethodObj)
    External(EXT6, MethodObj)
    External(DGPU._ON, MethodObj)
    External(DGPU._OFF, MethodObj)

    Scope (_SB)
    {
        Device (PCI9)
        {
            Name (_ADR, Zero)
            Name (FNOK, Zero)
            Name (MODE, Zero)
            //
            Name (TPTS, Zero)
            Name (TWAK, Zero)
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
        }
    }

    Method (_PTS, 1, NotSerialized) //Method (_PTS, 1, Serialized)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI9.TPTS = Arg0
            
            if(\_SB.PCI9.FNOK ==1)
            {
                Arg0 = 3
            }
            
            If (CondRefOf (\DGPU._ON))
            {
                \DGPU._ON ()
            }
            
            If (CondRefOf(EXT1))
            {
                EXT1(Arg0)
            }
            If (CondRefOf(EXT2))
            {
                EXT2(Arg0)
            }
        }

        ZPTS(Arg0)
    }

    Method (_WAK, 1, NotSerialized) //Method (_WAK, 1, Serialized)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI9.TWAK = Arg0
            
            if(\_SB.PCI9.FNOK ==1)
            {
                \_SB.PCI9.FNOK =0
                Arg0 = 3
            }

            If (CondRefOf (\DGPU._OFF))
            {
                \DGPU._OFF ()
            }
            
            If (CondRefOf(EXT3))
            {
                EXT3(Arg0)
            }
            If (CondRefOf(EXT4))
            {
                EXT4(Arg0)
            }
        }

        Local0 = ZWAK(Arg0)
        Return (Local0)
    }

    Method (_TTS, 1, NotSerialized) //Method (_TTS, 1, Serialized)
    {
        If (_OSI ("Darwin"))
        {
            If (CondRefOf(EXT5))
            {
                EXT5(Arg0)
            }
            If (CondRefOf(EXT6))
            {
                EXT6(Arg0)
            }
        }

        If (CondRefOf(ZTTS))
        {
            ZTTS(Arg0)
        }
    }
}
//EOF
