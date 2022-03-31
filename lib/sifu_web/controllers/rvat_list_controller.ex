defmodule SifuWeb.RVATListController do
    use SifuWeb, :controller

    def list(conn, _params) do
        render conn, "list.html", processes: Sifu.Workflow.RVAT.all()
    end
end