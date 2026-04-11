table 51103 "Query Formula Execution TPE"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the execution code.';
        }
        field(10; "Query Formula Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Query Formula TPE".Code;
            ToolTip = 'Specifies the query formula code. Empty for main lines.';
        }
        field(11; "Parameter Name"; Code[20])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the parameter name. Empty for main lines.';
        }
        field(20; "Line Type"; Enum "Execution Line Type TPE")
        {
            DataClassification = SystemMetadata;
            Editable = false;
            ToolTip = 'Specifies whether the line is the main execution line or a parameter line.';
        }
        field(30; "Indentation Level"; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            ToolTip = 'Specifies indentation level for display.';
        }
    }

    keys
    {
        key(Key1; Code, "Parameter Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Code = '' then
            Error('Code is required.');

        Rec."Line Type" := Rec."Line Type"::Main;
        Rec."Parameter Name" := '';
        Rec."Indentation Level" := 0;

        if "Query Formula Code" <> '' then
            Rec.InsertParameterLines();
    end;

    trigger OnModify()
    begin
        if xRec.Code <> Code then
            Error('Code cannot be changed. Delete the execution and create it again.');

        if (xRec."Query Formula Code" = '') and (Rec."Query Formula Code" <> xRec."Query Formula Code") then
            Rec.InsertParameterLines()
        else
            Error('Changing the Query Formula Code is not allowed. Delete the execution and create it again.');
    end;

    trigger OnDelete()
    var
        ExecutionLine: Record "Query Formula Execution TPE";
    begin
        if not Confirm('This will delete all lines related to execution code %1. Are you sure?', false, Rec.Code) then
            exit;

        ExecutionLine.Reset();
        ExecutionLine.SetRange(Code, Rec.Code);
        ExecutionLine.DeleteAll(false);
    end;

    procedure InsertParameterLines()
    var
        QueryFormulaParameter: Record "Query Formula Parameter TPE";
        ExecutionLine: Record "Query Formula Execution TPE";
    begin
        QueryFormulaParameter.Reset();
        QueryFormulaParameter.SetRange("Query Formula Code", "Query Formula Code");
        if QueryFormulaParameter.FindSet() then
            repeat
                ExecutionLine.Init();
                ExecutionLine.Code := Code;
                ExecutionLine."Query Formula Code" := "Query Formula Code";
                ExecutionLine."Parameter Name" := QueryFormulaParameter."Parameter Code";
                ExecutionLine."Line Type" := ExecutionLine."Line Type"::Parameter;
                ExecutionLine."Indentation Level" := 1;
                ExecutionLine.Insert(false);
            until QueryFormulaParameter.Next() = 0;
    end;
}
