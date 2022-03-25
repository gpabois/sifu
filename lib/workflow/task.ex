defmodule Workflow.Task do
    defmacro mixin(process_type) do
        Ecto.Schema.belongs_to :process, unquote(process_type)
        Ecto.Schema.has_one :previous, __MODULE__
        Ecto.Schema.field :flow_node_name, :string
        Ecto.Schema.field :token, :string
        Ecto.Schema.field :status, :string, default: :created
        Ecto.Schema.field :status_complement, :string, default: ""
        Ecto.Schema.field :started_at, :boolean
        Ecto.Schema.field :finished_at, :boolean 
    end

    def update(%__MODULE__{} = task, attrs) do
        __MODULE__.update(task, attrs)
    end

    def create(%__MODULE__{} = task, attrs) do
        __MODULE__.create(task, attrs)
    end
    
    def set_status(task, status) do
        task
        |> Map.put(:status, status)
    end
end
