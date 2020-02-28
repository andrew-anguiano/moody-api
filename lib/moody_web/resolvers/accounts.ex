defmodule MoodyWeb.Resolvers.Accounts do
  alias Moody.Accounts
  alias MoodyWeb.Schema.ChangesetErrors

  def user(_, %{id: id}, _) do
    {:ok, Accounts.get_user!(id)}
  end

  def signup(_, args, _) do
    case Accounts.create_user(args) do
      {:ok, user} -> 
        token = MoodyWeb.AuthToken.sign(user)

        {:ok, %{user: user, token: token}}
      {:error, changeset} ->
        {
          :error,
          message: "Couldn't create account!",
          details: ChangesetErrors.error_details(changeset)
        } 
    end
  end

  def signin(_, %{username: username, password: password}, _) do
    case Accounts.authenticate(username, password) do
      {:ok, user} -> 
        token = MoodyWeb.AuthToken.sign(user)

        {:ok, %{user: user, token: token}}
      :error ->
        {:error, "Invalid credentials."}
    end
  end
end
