defmodule Workflow.Process do
    defmacro mixin(flow_type) do
        Ecto.Schema.field :flow_type, :string, default: unquote(flow_type |> to_string)
        Ecto.Schema.field :status, :string
        Ecto.Schema.field :created_at, :naive_datetime
        Ecto.Schema.field :finished_at, :naive_datetime 
    end
    
    def set_status(process, status) do
        process
        |> Map.put(:status, status)
    end
end