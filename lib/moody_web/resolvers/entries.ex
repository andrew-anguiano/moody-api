defmodule MoodyWeb.Resolvers.Entries do
  alias Moody.Entries
  alias MoodyWeb.Schema.ChangesetErrors

  def entry(_, %{id: id}, _) do
    {:ok, Entries.get_entry!(id)}
  end

  def entries(_, _, _) do
    {:ok, Entries.list_entries}
  end

  def create_entry(_, args, %{context: %{current_user: user}}) do
    case Entries.create_entry(user, args) do
      {:ok, entry} ->
        {:ok, entry}
      {:error, changeset} ->
        {
          :error,
          message: "Could not create entry.",
          details: ChangesetErrors.error_details(changeset)
        }
    end
  end

  def metrics(_, _, %{context: %{current_user: user}}) do
    {:ok, Entries.list_metrics_by_user(user)}
  end

  def create_metric(_, args, %{context: %{current_user: user}}) do
    case Entries.create_metric(user, args) do
      {:ok, metric} ->
        {:ok, metric}
      {:error, changeset} ->
        {
          :error,
          message: "Could not crete metric.",
          details: ChangesetErrors.error_details(changeset)
        }
    end
  end

end
