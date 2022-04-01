defmodule SifuWeb.PageController do
  use SifuWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.rvat_list_path(conn, :list))
  end
end
