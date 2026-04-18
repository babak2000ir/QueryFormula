table 51107 "Query Execution Log TPE"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(10; "Message"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure Insert(LogMessage: Text)
    var
        NextEntryNo: Integer;
    begin
        Rec.Reset();
        if Rec.FindLast() then;
        NextEntryNo := Rec."Entry No." + 1;
        Rec.Init();
        Rec."Entry No." := NextEntryNo;
        Rec."Message" := CopyStr(LogMessage, 1, 2048);
        Rec.Insert();
    end;
}