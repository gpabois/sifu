defmodule Sifu.Workflow.RVAT.Context do
    use Ecto.Schema
    import Ecto.Changeset

    schema "rvat_contexts" do
        belongs_to :process, Workflow.Process
        field :doc_id, :string
        belongs_to :verified_by, Sifu.Accounts.User
        belongs_to :approved_by, Sifu.Accounts.User
        field :verified, :boolean, default: false
        field :approved, :boolean, default: false
    end

    def initiator_changeset(%__MODULE__{} = rvat, params) do
        rvat
        |> cast(params, [:doc_id, :verified_by, :approved_by])
        |> validate_required([:doc_id, :verified_by, :approved_by])
    end
end
