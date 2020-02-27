defmodule MoodyWeb.Resolvers.Accounts do
  alias Moody.Accounts

  def user(_, %{id: id}, _) do
    {:ok, Accounts.get_user!(id)}
  end
end
