defmodule Sifu.Repo.Migrations.AddWorkflowTable do
  use Ecto.Migration

  def change do
    Workflow.Migrations.change()
  end
end
