//
DefinitionBlock("", "SSDT", 2, "OCLT", "EXT3", 0)
{
    External(_SI._SST, MethodObj)
    Method (EXT3, 1, NotSerialized)
    {
        If ((3 == Arg0) && CondRefOf (\_SI._SST))
        {
            \_SI._SST (1)
        }
    }
}
//EOF
