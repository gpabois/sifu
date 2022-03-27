defmodule Sifu.Workflow.RVAT do
    alias Workflow.Flow.Builder, as: B

    @behaviour Workflow.Flow

    def get_flow() do
        B.begin()
        |> B.start(:verify)
        |> B.user_action(:verify, &get_verification_url/1, &assign_user_for_verification/1, :check_for_verification)
        |> B.condition(:check_for_verification, &check_for_verification?/1, :assign_for_approval, :reject)
        |> B.user_action(:approve, &get_approval_url/1, &assign_user_for_approval/1, :check_for_approval)
        |> B.condition(:check_for_approval, &check_for_approval?/1, :end, :reject)
        |> B.job(:reject, &reject/1, :end)
        |> B.nend()
        |> B.build(__MODULE__)
    end

    def get_initiate_url(task) do
    end

    def get_verification_url(task) do
    end

    def get_approval_url(task) do
    end

    def assign_user_for_verification(task) do
    end

    def assign_user_for_approval(task) do
    end

    @doc """
        Reject the workflow job
    """
    def reject(task) do
        :ok
    end

    def check_for_verification?(task) do
        task.verified
    end

    def check_for_approval?(task) do
        task.approved
    end
end
