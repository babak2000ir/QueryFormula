table 51102 "Query Formula Filter TPE"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Query Formula Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Query Formula TPE";
            ToolTip = 'Specifies the query formula code.';
        }
        field(2; "Field ID"; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = Field."No.";
            ToolTip = 'Specifies the field ID to filter.';
        }
        field(3; "Field Name"; Text[250])
        {
            Editable = false;
            ToolTip = 'Specifies the field name.';
        }
        field(4; "Filter Type"; Enum "Filter Type TPE")
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter type.';
        }
        field(10; "Value 1"; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';
        }
        field(11; "Value 2"; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the second filter value.';
        }
    }

    keys
    {
        key(Key1; "Query Formula Code", "Field ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Field ID" = 0 then
            Error('Field ID must not be 0. Please select a valid field before saving.');
    end;
}
