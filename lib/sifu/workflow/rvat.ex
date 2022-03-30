defmodule Sifu.Workflow.RVAT do
    alias Workflow.Builder, as: B
    alias Workflow.Process

    use Arc.Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query

    @behaviour Workflow.Flow

    def get_flow() do
        B.begin("verify")
        |> B.user_action("verify", &get_verification_url/1, &assign_user_for_verification/1, "check_for_verification")
        |> B.condition("check_for_verification", &check_for_verification?/1, :assign_for_approval, "reject")
        |> B.user_action("approve", &get_approval_url/1, &assign_user_for_approval/1, "check_for_approval")
        |> B.condition("check_for_approval", &check_for_approval?/1, "end", "reject")
        |> B.job("reject", &reject/1, :end)
        |> B.build("RVAT")
    end

    @types %{
        document: Sifu.Document.Type, 
        approved: :boolean,
        verified: :boolean,
        approved_by_id: :integer, 
        verified_by_id: :integer
    }

    def insert(changeset) do
        changeset
        |> apply_action(:insert)
    end

    def initiate_changeset(context, params) do
        {context, @types}
        |> cast(params |> Map.merge(%{verified: false, approved: false}), [:document, :approved, :verified, :approved_by_id, :verified_by_id])
        |> validate_required([:document, :verified, :approved, :aproved_by_id, :verified_by_id])
    end

    def all() do
        from(p in Process, where: p.flow_type == "rvat") |> Workflow.Repo.all()
    end

    def get(pid) do
        from(p in Process, where: p.flow_type == "rvat", where: p.id == ^pid) |> Workflow.Repo.one()
    end

    def get_initiate_url(_task) do
    end

    def get_verification_url(_task) do
    end

    def get_approval_url(_task) do
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
        context
        |> Map.put("status", "rejected")
    end

    def check_for_verification?(context) do
        context["verified"]
    end

    def check_for_approval?(context) do
        context["approved"]
    end
end
