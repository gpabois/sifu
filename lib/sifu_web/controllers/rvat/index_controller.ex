defmodule SifuWeb.RVAT.IndexController do
    use SifuWeb, :controller

    def index(conn, %{"pid" => pid}) do
        render conn, "index.html", process: Sifu.Workflow.RVAT.get(pid)
    end
end