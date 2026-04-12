table 51103 "Query Formula Execution TPE"
{
    DataClassification = SystemMetadata;
    DrillDownPageId = "Query Formula Exec. Steps TPE";
    LookupPageId = "Query Formula Exec. List TPE";
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the execution code.';
        }
        field(10; Description; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the description for the execution.';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Code = '' then
            Error('Code is required.');
    end;

    trigger OnDelete()
    var
        ExecutionStep: Record "Query Formula Exec. Step TPE";
    begin
        ExecutionStep.Reset();
        ExecutionStep.SetRange("Query Formula Execution Code", Rec.Code);
        ExecutionStep.DeleteAll(true);
    end;
}
