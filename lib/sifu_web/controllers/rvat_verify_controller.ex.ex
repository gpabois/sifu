defmodule SifuWeb.RVATVerifyController do
    use SifuWeb, :controller

    def verify(conn, %{"id" => task_id}) do
        task = Workflow.Repo.get(Workflow.Task, task_id)
        process = Workflow.Repo.get(Workflow.Process, task.process_id)

        render conn, "verify.html", task: task, process: process
    end

    def execute(conn, %{"verification" => verification}) do

    end
end
