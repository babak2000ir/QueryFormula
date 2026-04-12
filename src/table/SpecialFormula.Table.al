table 51105 "Special Formula TPE"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(2; Description; Text[250])
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}