defmodule Sifu.Workflow.RVAT.Process do
    schema "rvat_processes" do
        Workflow.Process.mixin Sifu.Workflow.RVAT
        field doc_id,    :string
        field :verified, :boolean, default: false
        field :approved, :boolean, default: false
    end
end
