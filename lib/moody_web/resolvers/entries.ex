defmodule MoodyWeb.Resolvers.Entries do
  alias Moody.Entries

  def entry(_, %{id: id}, _) do
    {:ok, Entries.get_entry!(id)}
  end

  def entries(_, _, _) do
    {:ok, Moody.Entries.list_entries}
  end
end
