//
DefinitionBlock("", "SSDT", 2, "hack", "EXT3", 0)
{
    External(_SI._SST, MethodObj)
    Method (EXT3, 1, NotSerialized)
    {   
        If (_OSI ("Darwin"))
        {
            If (3 == Arg0)
            {
                \_SI._SST (1)
            }
        }
    }
}
//EOF
