defmodule SifuWeb.PageController do
  use SifuWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.process_path(conn, :list_rvat))
  end
end
