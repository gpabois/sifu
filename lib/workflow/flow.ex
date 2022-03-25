defmodule Workflow.Flow do
    @callback get_flow()

    defstruct flow_type: nil, task_type: nil, process_type: nil, engine_type: nil, nodes: %{}

    def get_flow(type) do
        apply(type, :get_flow, [])
    end

    def get_flow_node(flow, node_name) do 
        flow[node_name]
    end
end