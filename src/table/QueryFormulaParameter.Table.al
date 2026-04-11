table 51101 "Query Formula Parameter TPE"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Query Formula Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Code of the related query formula.';
        }
        field(2; "Parameter Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Code of the parameter.';
        }
    }

    keys
    {
        key(Key1; "Query Formula Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}