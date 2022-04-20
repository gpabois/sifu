defmodule SifuWeb.ProcessController do
    use SifuWeb, :controller
        
    use Workflow.ProcessController, 
        redirect: fn conn, process -> 
            Routes.process_path(conn, :show, process.id)
        end

    def list_rvat(conn, _args) do
        conn
        |> render("list_rvat.html", processes: Workflow.Process.get_by_flow_type("RVAT"))
    end

end