defmodule SifuWeb.ObanController do
    use SifuWeb, :controller

    import Ecto.Query

    def list(conn, _params) do
      render(conn, "list.html", jobs: from(j in Oban.Job) |> Workflow.Repo.all())
    end

    def retry(conn, %{"id" => id}) do
        job = Workflow.Repo.get(Oban.Job, id)
        Oban.retry_job(job.id)
        
        conn
        |> put_flash(:info, "Redémarrage du travail.")
        |> redirect(to: Routes.oban_path(conn, :list))
    end
end