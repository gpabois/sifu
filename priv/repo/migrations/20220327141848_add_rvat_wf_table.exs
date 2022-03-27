defmodule Sifu.Repo.Migrations.AddRvatWfTable do
  use Ecto.Migration

  def change do
    create table(:rvat_contexts) do
      add :process, references(:workflow_processes, on_delete: :delete_all)
      add :verified_by, references(:users, on_delete: :delete_all)
      add :approved_by, references(:users, on_delete: :delete_all)
      add :verified, :boolean
      add :approved, :boolean
    end
  end
end
