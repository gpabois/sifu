defmodule Workflow.Engine do
    import Workflow.Flow
    
    @callback on_task_created(term, term, term, term)
    @callback on_process_created(term)
    @callback on_task_transition(term, term, term, term)
    @callback on_process_transition(term, term, term)

    defp task_transition(%task_type{status: prev_status} = task, process, status, %{} \\ args) do
        task = task |> Workflow.Flow.Task.set_status(task, status)

        {task, process} = flow.engine_type.on_task_transition(task, process, {old_status, status}, args)

        {task, process}
    end

    defp task_creation(task, process) do
        {task, process} = flow.engine_type.on_task_created(task, process)
    end
    
    defp process_transition(process, status, %{} \\ args) do
        process = process |> Workflow.Process.set_status(status)
        flow = get_flow(process.flow_type)
        flow.engine_type.on_process_transition(process, {old_status, status}, args)
    end

    def update(task, process) do
        {next_tasks, task, process} = step(task, process)
    end

    def step(%task_type{flow_node_name: flow_node_name, process: process} = task, %process_type{} = process) do
        flow = get_flow(process.flow_type)
        flow_node = get_flow_node(flow, flow_node_name)

        next_tasks = []

        case flow_node do
            %Workflow.Flow.Nodes.Start{next: next_node} ->
                process = process_transition(process, :started)
                {task, process} = task_transition(task, process, :finished)
                
                {new_task, process} = task_creation(%task_type{
                    process_id: process.id,
                    previous_id: task.id,
                    token: token,
                    flow_node_type: next_node
                }, process)

                next_tasks = [next_tasks | new_task]              
            
            %Workflow.Flow.Nodes.End{} -> 
                {task, process} = task_transition(task, process, :finished)
                process = process_transition(process, :finished)
                
            %Workflow.Flow.Nodes.Condition{predicate: predicate?, if_node: if_node, else_node: else_node} ->
                next_node = if predicate?(task) do: if_node, else: else_node
                
                next_tasks = [next_tasks | %task_type{
                    process: process,
                    previous: task,
                    token: token,
                    flow_node_type: next_node
                }]
                
                {task, process} = task_transition(task, process, :finished)

            %Workflow.Flow.Nodes.UserAction{next: next_node} -> 
                case task.status do
                    :created ->
                        {task, process} = task_transition(task, process, :idling)
                    
                    :inputted -> 
                        next_tasks = [next_tasks | %task_type{
                            process_id: process.id,
                            previous_id: task.id,
                            token: token,
                            flow_node_type: next_node
                        }]
                        
                        {task, process} = task_transition(task, process, :finished)
                end 
            
            %Workflow.Flow.Nodes.Job{work: work, next: next_node} ->
                case work(task, process) do
                    {:ok, {task, process}} -> 
                        {task, process} = task_transition(task, process, :finished)
                    {:error, error} ->
                        task_transition(task, process, :error, error)
                end
            end

            {next_tasks, task, process}
        end
    end
end

