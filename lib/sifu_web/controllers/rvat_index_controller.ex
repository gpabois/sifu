defmodule SifuWeb.RVATIndexController do
    use SifuWeb, :controller
    import Ecto.Query
    
    alias Workflow.{Process, Repo}

    def index(conn, %{"pid" => pid}) do
        render conn, "index.html", process: Sifu.Workflow.RVAT.get(pid), tasks: Workflow.Task.get_tasks_by_process_id(pid)
    end

    def delete(conn, %{"pid" => pid}) do
        case Repo.get(Process, pid) |> Repo.delete() do
            {:ok, _} -> conn 
                |> put_flash(:info, "RVAT supprimé avec succés.")
                |> redirect(to: Routes.rvat_list_path(conn, :list))
            {:error, _} -> conn 
                |> put_flash(:info, "Le RVAT n'a pas été supprimé.")
                |> redirect(to: Routes.rvat_list_path(conn, :list))
        end
    end
end