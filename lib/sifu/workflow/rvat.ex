defmodule Sifu.Workflow.RVAT do
    alias Workflow.Builder, as: B
    alias Workflow.Process

    use Arc.Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query

    alias Workflow.Field

    def user_select_values() do
        Sifu.Accounts.all_users() 
        |> Enum.map(fn u -> {u.email, u.id} end) 
    end

    def get_flow() do
        B.begin([
            # Form fields
            Field.file(:document, Sifu.Document.Type, label: "Document", required: true),
            Field.text(:synthese, :string, input_type: :textarea, label: "Synthèse", required: true),
            Field.select(:verifier_par_id, :string, label: "Vérificateur", values_fn: &user_select_values/0, required: true),
            Field.select(:approuver_par_id, :string, label: "Approbateur", values_fn: &user_select_values/0, required: true),
            # Internal fields
            Field.text(:status, :string, internal: true, default: "en_cours")
        ], "verifier", 
            validations: [&cast_attachments(&1, &2, [:document])],
            view: SifuWeb.ProcessView
        )
        |> B.user_action(
            "verifier", 
            [
                Field.boolean(:verifier, 
                    values: [{"Accepter", true}, {"Refuser", false}], 
                    input_type: :radios, 
                    label: "Décision sur la vérification", 
                    required: true
                )
            ], 
            &assign_user_for_verification/1, 
            "traitement_decision_verification", 
            view: SifuWeb.TaskView
        )
        |> B.condition(
            "traitement_decision_verification", 
            &check_for_verification?/1, 
            "approuver", 
            "rejetter"
        )
        |> B.user_action("approuver", 
            [Field.boolean(:approuver, values: [{"Accepter", true}, {"Refuser", false}], input_type: :radios, label: "Décision sur l'approbation", required: true)],  
            &assign_user_for_approval/1, 
            "traitement_decision_approbation",
            view: SifuWeb.TaskView
        )
        |> B.condition(
            "traitement_decision_approbation", 
            &check_for_approval?/1, 
            "finaliser", 
            "rejetter"
        )
        |> B.job("rejetter", &reject/1, "end")
        |> B.job("finaliser", &finalise/1, "end")
        |> B.build("RVAT")
    end

    def assign_user_for_verification(context) do
        context["verified_by_id"]
    end

    def assign_user_for_approval(context) do
        context["approved_by_id"]
    end

    @doc """
        Reject the workflow job
    """
    def reject(context) do
        {:ok, context |> Map.put(:status, "rejetté")}
    end

    def finalise(context) do
        {:ok, context |> Map.put(:status, "terminé")}
    end

    def check_for_verification?(context) do
        context["verifier"]
    end

    def check_for_approval?(context) do
        context["approuver"]
    end
end
