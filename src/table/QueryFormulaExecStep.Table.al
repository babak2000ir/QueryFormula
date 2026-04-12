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
            ToolTip = 'Specifies the execution code.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            ToolTip = 'Specifies the line number for display.';
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
        field(20; "Indentation Level"; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            ToolTip = 'Specifies indentation level for display.';
        }
        field(21; "Parent Line No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            ToolTip = 'Specifies the line number of the parent line. Used for display purposes.';
        }
        field(30; "Value Query"; Boolean)
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';

            trigger OnValidate()
            begin
                if xRec."Value Query" <> Rec."Value Query" then
                    Rec."Value" := '';
            end;
        }
        field(31; Value; Text[250])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the filter value.';

            trigger OnLookup()
            var
                QueryFormula: Record "Query Formula TPE";
                QueryFormulaLookup: Page "Query Formula Lookup TPE";
            begin
                if "Value Query" then begin
                    QueryFormula.Reset();
                    if not QueryFormula.IsEmpty then begin
                        QueryFormulaLookup.SetTableView(QueryFormula);
                        QueryFormulaLookup.LookupMode(true);

                        if QueryFormulaLookup.RunModal() = Action::LookupOK then begin
                            QueryFormulaLookup.GetRecord(QueryFormula);
                            Rec.Validate("Value", QueryFormula.Code);
                        end;
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                this.InsertParameterLines(xRec, Rec);
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

    trigger OnInsert()
    var
        ExecutionLine: Record "Query Formula Exec. Step TPE";
    begin
        if Rec."Query Formula Execution Code" = '' then
            Error('Execution Code must have a value.');

        ExecutionLine.Reset();
        ExecutionLine.SetRange("Query Formula Execution Code", Rec."Query Formula Execution Code");
        ExecutionLine.SetRange("Indentation Level", 0);
        if not ExecutionLine.IsEmpty then
            Error('Only one main line with indentation level 0 is allowed for each execution code.');

        Rec."Parameter Name" := '';
        Rec."Indentation Level" := 0;
        Rec.SetLineNo();

        if "Query Formula Code" <> '' then
            this.InsertParameterLines(Rec);
    end;

    trigger OnModify()
    begin
        this.InsertParameterLines(xRec, Rec)
    end;

    trigger OnDelete()
    var
        ExecutionLine: Record "Query Formula Exec. Step TPE";
        ExecutionLine2: Record "Query Formula Exec. Step TPE";
    begin

        if Rec."Indentation Level" = 0 then begin
            ExecutionLine.Reset();
            ExecutionLine.SetRange("Query Formula Execution Code", Rec."Query Formula Execution Code");
            ExecutionLine.DeleteAll(true);
        end else begin
            case Rec."Indentation Level" of
                1:
                    begin
                        // Delete the Parent Lines Value
                        ExecutionLine.Reset();
                        ExecutionLine.SetRange("Query Formula Execution Code", Rec."Query Formula Execution Code");
                        ExecutionLine.SetRange("Line No.", Rec."Parent Line No.");
                        if ExecutionLine.FindFirst() then begin
                            ExecutionLine."Query Formula Code" := '';
                            ExecutionLine.Modify();
                        end;
                    end;
                else begin
                    // Delete the Parent Lines Value
                    ExecutionLine.Reset();
                    ExecutionLine.SetRange("Query Formula Execution Code", Rec."Query Formula Execution Code");
                    ExecutionLine.SetRange("Line No.", Rec."Parent Line No.");
                    if ExecutionLine.FindFirst() then begin
                        ExecutionLine.Value := '';
                        ExecutionLine.Modify();
                    end;
                end;
            end;

            ExecutionLine.Reset();
            ExecutionLine.SetRange("Query Formula Execution Code", Rec."Query Formula Execution Code");
            ExecutionLine.SetRange("Query Formula Code", Rec."Query Formula Code");
            ExecutionLine.SetRange("Parent Line No.", Rec."Parent Line No.");
            if ExecutionLine.FindSet() then
                repeat
                    ExecutionLine2.Reset();
                    ExecutionLine2.SetRange("Query Formula Execution Code", ExecutionLine."Query Formula Execution Code");
                    ExecutionLine2.SetRange("Parent Line No.", ExecutionLine."Line No.");
                    ExecutionLine2.DeleteAll(true);

                    ExecutionLine.Delete(true);
                until ExecutionLine.Next() = 0;
        end;
    end;

    procedure SetLineNo()
    begin
        Rec.SetLineNo('', '');
    end;

    procedure SetLineNo(QueryFormulaExecCode: Code[20])
    begin
        Rec.SetLineNo(QueryFormulaExecCode, '');
    end;

    procedure SetLineNo(QueryFormulaExecCode: Code[20]; QueryFormulaCode: Code[20])
    var
        lQueryFormulaExecSteps: Record "Query Formula Exec. Step TPE";
        Seed: Integer;
    begin
        Seed := 10000;
        lQueryFormulaExecSteps.Reset();

        if QueryFormulaExecCode <> '' then begin
            lQueryFormulaExecSteps.SetRange("Query Formula Execution Code", QueryFormulaExecCode);
            Seed := 1000;
        end;

        if QueryFormulaCode <> '' then begin
            lQueryFormulaExecSteps.SetRange("Query Formula Code", QueryFormulaCode);
            Seed := 100;
        end;

        if lQueryFormulaExecSteps.FindLast() then
            Rec."Line No." := lQueryFormulaExecSteps."Line No." + Seed
        else
            Rec."Line No." := Seed;
    end;

    procedure InsertParameterLines(xQueryFormulaExecStep: Record "Query Formula Exec. Step TPE"; pQueryFormulaExecStep: Record "Query Formula Exec. Step TPE")
    begin
        if (xRec."Query Formula Code" <> '') and (Rec."Query Formula Code" <> xRec."Query Formula Code") then
            if Confirm('This will remove all existing parameter lines for query formula code %1 and insert new ones based on the new query formula code. Are you sure?', false, xRec."Query Formula Code") then begin
                this.DeleteParameterLines(xRec);
                this.InsertParameterLines(Rec);
            end;
    end;

    procedure DeleteParameterLines(pQueryFormulaExecStep: Record "Query Formula Exec. Step TPE")
    var
        ExecutionLine: Record "Query Formula Exec. Step TPE";
    begin
        ExecutionLine.Reset();
        ExecutionLine.SetRange("Query Formula Execution Code", pQueryFormulaExecStep."Query Formula Execution Code");
        ExecutionLine.SetRange("Query Formula Code", pQueryFormulaExecStep."Query Formula Code");
        ExecutionLine.SetRange("Parent Line No.", pQueryFormulaExecStep."Line No.");
        ExecutionLine.DeleteAll(true);
    end;

    procedure InsertParameterLines(pQueryFormulaExecStep: Record "Query Formula Exec. Step TPE")
    var
        QueryFormulaParameter: Record "Query Formula Parameter TPE";
        ExecutionLine: Record "Query Formula Exec. Step TPE";
    begin
        Case pQueryFormulaExecStep."Indentation Level" of
            0:
                begin
                    QueryFormulaParameter.Reset();
                    QueryFormulaParameter.SetRange("Query Formula Code", pQueryFormulaExecStep."Query Formula Code");
                    if QueryFormulaParameter.FindSet() then
                        repeat
                            ExecutionLine.Init();
                            ExecutionLine."Query Formula Execution Code" := pQueryFormulaExecStep."Query Formula Execution Code";
                            ExecutionLine.SetLineNo(pQueryFormulaExecStep."Query Formula Execution Code");
                            ExecutionLine."Query Formula Code" := pQueryFormulaExecStep."Query Formula Code";
                            ExecutionLine."Parameter Name" := QueryFormulaParameter."Parameter Code";
                            ExecutionLine."Indentation Level" := 1;
                            ExecutionLine."Parent Line No." := pQueryFormulaExecStep."Line No.";
                            ExecutionLine.Insert(false);
                        until QueryFormulaParameter.Next() = 0;
                end;
            else begin
                QueryFormulaParameter.Reset();
                QueryFormulaParameter.SetRange("Query Formula Code", pQueryFormulaExecStep.Value);
                if QueryFormulaParameter.FindSet() then
                    repeat
                        ExecutionLine.Init();
                        ExecutionLine."Query Formula Execution Code" := pQueryFormulaExecStep."Query Formula Execution Code";
                        ExecutionLine.SetLineNo(pQueryFormulaExecStep."Query Formula Execution Code", pQueryFormulaExecStep."Query Formula Code");
                        ExecutionLine."Query Formula Code" := pQueryFormulaExecStep.Value;
                        ExecutionLine."Parameter Name" := QueryFormulaParameter."Parameter Code";
                        ExecutionLine."Indentation Level" := pQueryFormulaExecStep."Indentation Level" + 1;
                        ExecutionLine."Parent Line No." := pQueryFormulaExecStep."Line No.";
                        ExecutionLine.Insert(false);
                    until QueryFormulaParameter.Next() = 0;
            end;
        End;
    end;
}