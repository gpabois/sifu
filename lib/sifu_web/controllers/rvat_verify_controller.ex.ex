defmodule SifuWeb.RVATVerifyController do
    use SifuWeb, :controller

    def verify(conn, %{"id" => task_id}) do
        task = Workflow.Repo.get(Workflow.Task, task_id)
        process = Workflow.Repo.get(Workflow.Process, task.process_id)

        render conn, "verify.html", task: task, process: process, changeset: Sifu.Workflow.RVAT.verify_changeset(process.context, %{})
    end

    def execute(conn, %{"id" => task_id} = params) do
        task = Workflow.Repo.get(Workflow.Task, task_id)
        process = Workflow.Repo.get(Workflow.Process, task.process_id)

        verification = Map.get(params, "verification", %{})

        result = case Workflow.done_if_ok task, fn context -> 
            ret = Sifu.Workflow.RVAT.verify_changeset(context, verification) |> Sifu.Workflow.RVAT.verify
            IO.inspect(ret)
            ret
        end do
            {:ok, %{valid?: false} = changeset} -> 
                {:error, changeset}

            other -> other
        end

        case result do
            {:error, changeset} ->
                render conn, "verify.html", task: task, process: process, changeset: changeset
            {:ok, _} ->
                conn
                |> put_flash(:info, "Vérification terminée !")
                |> redirect(to: Routes.rvat_index_path(conn, :index, process.id))
        end
    end
end
