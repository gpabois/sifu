defmodule Sifu.Workflow.RVAT.Task do
    use Ecto.Schema

    schema "rvat_tasks" do
        Workflow.Task.mixin Sifu.Workflow.RVAT.Process
    end
end