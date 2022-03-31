defmodule SifuWeb.RVATIndexController do
    use SifuWeb, :controller

    def index(conn, %{"pid" => pid}) do
        render conn, "index.html", process: Sifu.Workflow.RVAT.get(pid), tasks: Workflow.Task.get_tasks_by_process_id(pid)
    end
end