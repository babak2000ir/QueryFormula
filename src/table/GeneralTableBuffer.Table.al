table 51106 "General Table Buffer TPE"
{
    Caption = '';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(10; Field1; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(11; Field2; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(12; Field3; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(13; Field4; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(14; Field5; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(15; Field6; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(16; Field7; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(17; Field8; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(18; Field9; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(19; Field10; Text[250])
        {
            Caption = '';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}

