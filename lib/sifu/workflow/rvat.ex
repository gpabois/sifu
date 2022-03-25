defmodule Sifu.Workflow.RVAT do
    alias Workflow.Flow.Builder, as: B

    @behavior Workflow.Engine
    @behavior Workflow.Flow

    def get_flow() do
        B.begin()
        |> B.start(:initiate)
        |> B.user_action(:initiate, &get_initiate_url/2, :verify) 
        |> B.user_action(:verify, &get_verification_url/2, :check_for_verification)
        |> B.condition(:check_for_verification, &check_for_verification?/2, :assign_for_approval, :reject)
        |> B.user_action(:approve, &get_approval_url/2, :check_for_approval)
        |> B.condition(:check_for_approval, &check_for_approval?/2, :end, :reject)
        |> B.job(:reject, &reject/2, :end)
        |> B.end()
        |> B.build(__MODULE__, __MODULE__.Task, __MODULE__.Process, __MODULE__)
    end
    
    def get_initiate_url(task, process) do
    end

    def get_verification_url(task, process) do
    end

    def get_approval_url(task, process) do
    end

    def on_task_created(task, process) do
        case task.flow_node_name do
        end
        {taks, process}
    end

    def on_task_transition(task, process, {old_status, new_status}, _args) do
        {task, process}
    end

    def on_process_created(process) do
        process
    end

    def on_process_transition(process, {old_status, new_status}, _args) do
        process
    end

    @doc """
        Reject the workflow job
    """
    def reject(task, process) do
        {:ok {task, process}}
    end

    def check_for_verification?(task, process) do
        task.verified
    end

    def check_for_approval?(task, process) do
        task.approved
    end
end