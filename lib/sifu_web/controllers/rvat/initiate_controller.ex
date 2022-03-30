defmodule SifuWeb.RVAT.InitiateController do
    use SifuWeb, :controller


    def new(conn, _params) do
        changeset = Sifu.Workflow.RVAT.initiate_changeset(%{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"request" => request}) do
        case Workflow.create_if_ok "rvat", fn -> 
            Sifu.Workflow.RVAT.initiate_changeset(%{}, %{})
            |> Sifu.Workflow.RVAT.insert
        end do
            {:ok, {process, _}} ->
                conn
                |> put_flash(:info, "Flux de travail RVAT crée avec succés.")
                |> redirect(to: SifuWeb.Router.index_path(SifuWeb.RVAT.IndexController, :index, process.id))
            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset
        end
    end
end