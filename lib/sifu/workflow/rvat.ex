defmodule Sifu.Workflow.RVAT do
    alias Workflow.Builder, as: B
    alias Workflow.Process

    use Arc.Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query

    @behaviour Workflow.Flow

    def get_flow() do
        B.begin("verifier")
        |> B.user_action("verifier", &get_verification_url/1, &assign_user_for_verification/1, "traitement_decision_verification")
        |> B.condition("traitement_decision_verification", &check_for_verification?/1, "approuver", "rejetter")
        |> B.user_action("approuver", &get_approval_url/1, &assign_user_for_approval/1, "traitement_decision_approbation")
        |> B.condition("traitement_decision_approbation", &check_for_approval?/1, "finaliser", "rejetter")
        |> B.job("rejetter", &reject/1, "end")
        |> B.job("finaliser", &finalise/1, "end")
        |> B.build("RVAT")
    end

    defstruct [:document, :status, :synthese, :approved, :verified, :approved_by_id, :verified_by]

    @types %{
        document: Sifu.Document.Type,
        status: :string,
        synthese: :string,
        approved: :boolean,
        verified: :boolean,
        approved_by_id: :integer,
        verified_by_id: :integer
    }

    def insert(changeset) do
        changeset
        |> apply_action(:insert)
    end

    def verify(changeset) do
        changeset
        |> apply_action(:update)
    end

    def approve(changeset) do
        changeset
        |> apply_action(:update)
    end


    def initiate_changeset(context, params) do
        params = params
        |> Map.merge(%{
            "status" => "en_cours",
            "verified" => false, 
            "approved" => false
        })

        {context, @types}
        |> cast(params, [:status, :synthese, :approved, :verified, :approved_by_id, :verified_by_id])
        |> cast_attachments(params, [:document])
        |> validate_required([
            :document, 
            :synthese,
            :verified, 
            :approved, 
            :approved_by_id, 
            :verified_by_id
        ])
    end

    def verify_changeset(context, params) do
        context = context |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
        {context, @types}
        |> cast(params, [:verified])
        |> validate_required([:verified])
    end

    def approve_changeset(context, params) do
        context = context |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
        {context, @types}
        |> cast(params, [:approved])
        |> validate_required([:approved])
    end

    def all() do
        from(p in Process, where: p.flow_type == "rvat") |> Workflow.Repo.all()
    end

    def get(pid) do
        from(p in Process, where: p.flow_type == "rvat", where: p.id == ^pid) |> Workflow.Repo.one()
    end

    def get_verification_url(task) do
        SifuWeb.Router.Helpers.rvat_verify_path(SifuWeb.Endpoint, :verify, task.id)
    end

    def get_approval_url(task) do
        SifuWeb.Router.Helpers.rvat_approval_path(SifuWeb.Endpoint, :approval, task.id)
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
        {:ok, context |> Map.put("status", "rejetté")}
    end

    def finalise(context) do
        {:ok, context |> Map.put("status", "terminé")}
    end

    def check_for_verification?(context) do
        context["verified"]
    end

    def check_for_approval?(context) do
        context["approved"]
    end
end
