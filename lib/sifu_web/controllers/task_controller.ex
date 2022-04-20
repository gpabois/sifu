defmodule SifuWeb.TaskController do
    use SifuWeb, :controller

    use Workflow.TaskController,
        redirect: fn conn, _task, process ->
            Routes.process_path(conn, :show, process.id)
        end

end