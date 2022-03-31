defmodule SifuWeb.UserTasksController do
    use SifuWeb, :controller
    
    def list(%{assigns: %{current_user: current_user}} = conn, _params) do
        render conn, "list.html", tasks: Workflow.Task.get_assigned_tasks(current_user.id)
    end
end
  