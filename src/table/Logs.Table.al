table 51107 "Logs TPE"
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
        field(10; "Entity Key"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Category Code"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Message"; Text[2048])
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

    procedure Insert(EntityKey: Text; CategoryCode: Text; LogMessage: Text)
    begin
        Rec.Insert(EntityKey, CategoryCode, LogMessage, '', '');
    end;

    procedure Insert(EntityKey: Text; CategoryCode: Text; LogMessage: Text; Param: Text)
    begin
        Rec.Insert(EntityKey, CategoryCode, LogMessage, Param, '');
    end;

    procedure Insert(EntityKey: Text; CategoryCode: Text; LogMessage: Text; Param1: Text; Param2: Text)
    var
        NextEntryNo: Integer;
    begin
        LogMessage := StrSubstNo(LogMessage, Param1, Param2);

        Rec.Reset();
        if Rec.FindLast() then;
        NextEntryNo := Rec."Entry No." + 1;
        Rec.Init();
        Rec."Entry No." := NextEntryNo;
        Rec."Entity Key" := CopyStr(EntityKey, 1, 250);
        Rec."Category Code" := CopyStr(CategoryCode, 1, 250);
        Rec."Message" := CopyStr(LogMessage, 1, 2048);

        Rec.Insert();
    end;

    procedure ShowLogs()
    begin
        if not Rec.IsEmpty() then
            Page.Run(Page::"Log List TPE", Rec);
    end;
}