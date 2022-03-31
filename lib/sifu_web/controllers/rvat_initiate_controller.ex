defmodule SifuWeb.RVATInitiateController do
    use SifuWeb, :controller

    def new(conn, _params) do
        changeset = Sifu.Workflow.RVAT.initiate_changeset(%{}, %{})
        render conn, "new.html", changeset: changeset, users: Sifu.Accounts.all_users()
    end

    def create(%{assigns: %{current_user: current_user}} = conn, %{"initiate" => initiate}) do
        case Workflow.create_if_ok("rvat", fn -> 
            Sifu.Workflow.RVAT.initiate_changeset(%{}, initiate)
            |> Sifu.Workflow.RVAT.insert
        end, created_by: current_user.id) do
            {:ok, {process, _}} ->
                conn
                |> put_flash(:info, "Flux de travail RVAT crée avec succés.")
                |> redirect(to: SifuWeb.Router.rvat_index_path(conn, :index, process.id))
            {:ok, %{valid?: false} = changeset} -> 
                render conn, "new.html", changeset: changeset, users: Sifu.Accounts.all_users()
        end
    end
end