table 51104 "Query Formula Exec. Step TPE"
{
    Caption = 'Query Formula Execution Step';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Query Formula Execution Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            TableRelation = "Query Formula Execution TPE";
            ToolTip = 'Specifies the execution code.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the line number for display.';
        }
        field(10; "Variable Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "Query Formula Parameter TPE"."Parameter Code";
            ToolTip = 'Specifies the variable code. Empty for main lines.';
        }

        field(20; "Statement Type"; Enum "Value Type Statement TPE")
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';

            trigger OnValidate()
            begin
                if xRec."Statement Type" <> Rec."Statement Type" then
                    Rec."Statement" := '';
            end;
        }
        field(21; Statement; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';

            trigger OnLookup()
            begin
                this.LookupValue(Rec, Rec."Statement");
            end;
        }
    }

    keys
    {
        key(Key1; "Query Formula Execution Code", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure SetLineNo()
    var
        lQueryFormulaExecSteps: Record "Query Formula Exec. Step TPE";
    begin
        lQueryFormulaExecSteps.Reset();
        if lQueryFormulaExecSteps.FindLast() then
            Rec."Line No." := lQueryFormulaExecSteps."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

    procedure LookupValue(QueryFormulaExecStepTPE: Record "Query Formula Exec. Step TPE"; var Value: Text[250])
    var
        GeneralFunctions: Codeunit "General Functions TPE";
    begin
        case QueryFormulaExecStepTPE."Statement Type" of
            "Value Type Statement TPE"::Const:
                GeneralFunctions.LookupValueFields(QueryFormulaExecStepTPE.RecordId.TableNo, QueryFormulaExecStepTPE.FieldNo(Statement), Value);
            "Value Type Statement TPE"::SpecialFormula:
                GeneralFunctions.LookupValueSpecialFormula(Value);
            "Value Type Statement TPE"::FormulaParameter:
                GeneralFunctions.LookupValueFormulaParameter(Value);
            "Value Type Statement TPE"::QueryFormula:
                GeneralFunctions.LookupValueQueryFormula(Value);
        end;
    end;
}