defmodule SifuWeb.RVATApprovalController do
    use SifuWeb, :controller

    def approval(conn, %{"id" => task_id}) do
        task = Workflow.Repo.get(Workflow.Task, task_id)
        process = Workflow.Repo.get(Workflow.Process, task.process_id)

        render conn, "approval.html", task: task, process: process, changeset: Sifu.Workflow.RVAT.approve_changeset(process.context, %{})
    end

    def execute(conn, %{"id" => task_id} = params) do
        task = Workflow.Repo.get(Workflow.Task, task_id)
        process = Workflow.Repo.get(Workflow.Process, task.process_id)

        approval = Map.get(params, "approval", %{})

        result = case Workflow.done_if_ok task, fn context -> 
            Sifu.Workflow.RVAT.approve_changeset(context, approval) |> Sifu.Workflow.RVAT.approve
        end do
            {:ok, %{valid?: false} = changeset} -> 
                {:error, changeset}

            other -> other
        end

        case result do
            {:error, changeset} ->
                render conn, "approval.html", task: task, process: process, changeset: changeset
            {:ok, _} ->
                conn
                |> put_flash(:info, "Approbation terminée !")
                |> redirect(to: Routes.rvat_index_path(conn, :index, process.id))
        end
    end
end
