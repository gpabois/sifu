defmodule Workflow.Flow.Nodes.Condition do
    defstruct predicate: nil, if_node: nil, else_node: nil

    def next_nodes(activation, %__MODULE__{predicate: predicate, if_node: if_node, else_node: else_node} = node) do
        if predicate(activation) do
            if_node
        else
            else_node
        end
    end
end
