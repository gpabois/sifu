defmodule Workflow.Flow.Builder do
    alias Workflow.Flow.Nodes.{Start, UserAction, Job, Condition, End}

    @types [
        user_action,
        condition,
    ]

    def begin() do
        %{}
    end

    def start(flow, next) do
        flow 
        |> Map.put(:start, %Start{next: next})
    end

    def end(flow) do
        flow
        |> Map.put(:end, %End{})
    end

    def user_action(flow, id, view, next) do
        flow
        |> Map.put(id, %UserAction{view: view, next: next})
    end

    def job(flow, id, work, next) do
        flow
        |> Map.put(id, %Job{work: work, next: next})
    end

    def condition(flow, id, predicate, if_task, else_task) do
        flow
        |> Map.put(id, %Condition{predicate: predicate, if_task: if_task, else_task: else_task})
    end

    def build(nodes, flow_type, task_type, process_type, engine_type) do
        %Workflow.Flow{
            flow_type:      flow_type, 
            task_type:      task_type, 
            process_type:   process_type, 
            engine_type:    engine_type, 
            nodes:          nodes
        }
    end
end