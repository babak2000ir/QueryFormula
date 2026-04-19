table 51100 "Query Formula TPE"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Code of the query formula.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Description of the query formula.';
        }
        field(20; "Table ID"; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
            ToolTip = 'Specifies the table ID.';

            trigger OnValidate()
            var
                QueryFormulaFilterTPE: Record "Query Formula Filter TPE";
            begin
                if (xRec."Table ID" <> 0) and (Rec."Table ID" <> xRec."Table ID") then
                    if Confirm('Changing the table will reset the fields. Do you want to continue?', false, 'Confirm Table Change') then begin
                        Rec.Validate("Field ID", 0);
                        QueryFormulaFilterTPE.Reset();
                        QueryFormulaFilterTPE.SetRange("Query Formula Code", Rec.Code);
                        QueryFormulaFilterTPE.DeleteAll();
                    end else
                        Error('');

                Rec.CalcFields("Table Name");
            end;
        }
        field(21; "Table Name"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the table name.';
        }
        field(30; "Query Type"; Enum "Query Type TPE")
        {
            DataClassification = SystemMetadata;
            ToolTip = 'Specifies the query type.';
        }
        field(40; "Field ID"; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = Field."No." where(TableNo = field("Table ID"));
            ToolTip = 'Specifies the field ID.';

            trigger OnValidate()
            var
                Field: Record Field;
            begin
                if (Rec."Field ID" <> 0) and not Field.Get(Rec."Table ID", Rec."Field ID") then
                    Error('Field ID %1 is not valid for Table ID %2', Rec."Field ID", Rec."Table ID");

                Rec.CalcFields("Field Name");
            end;

            trigger OnLookup()
            var
                Field: Record Field;
                FieldsLookup: Page "Fields Lookup";
            begin
                if Rec."Table ID" <> 0 then begin
                    Field.Reset();
                    Field.SetRange(TableNo, Rec."Table ID");
                    FieldsLookup.SetTableView(Field);
                    FieldsLookup.LookupMode(true);

                    if FieldsLookup.RunModal() = Action::LookupOK then begin
                        FieldsLookup.GetRecord(Field);
                        Rec.Validate("Field ID", Field."No.");
                    end;
                end;
            end;
        }
        field(41; "Field Name"; Text[250])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table ID"), "No." = field("Field ID")));
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the field name.';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}