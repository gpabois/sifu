defmodule Mix.Tasks.Sifu.Dev.CreateUserFixtures do
    use Mix.Task

    alias Ecto.Multi
    alias Sifu.Accounts.User

    @requirements ["phx.server"]

    defp user_fixtures() do
        Multi.new()
        |> Multi.insert(:redacteur, User.registration_changeset(%User{}, %{email: "redacteur@dev.org", password: "redacteur1234"}))
        |> Multi.insert(:verificateur,  User.registration_changeset(%User{}, %{email: "verificateur@dev.org", password: "verificateur1234"}))
        |> Multi.insert(:approbateur,  User.registration_changeset(%User{}, %{email: "approbateur@dev.org", password: "approbateur1234"}))
    end

    @impl Mix.Task
    def run(_) do
        Sifu.Repo.transaction(user_fixtures()) 
    end
end