defmodule MoodyWeb.Resolvers.Entries do
  alias Moody.Entries
  alias MoodyWeb.Schema.ChangesetErrors

  def entry(_, %{id: id}, _) do
    {:ok, Entries.get_entry!(id)}
  end

  def entries(_, args, _) do
    {:ok, Entries.list_entries(args)}
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

  def delete_entry(_, args, %{context: %{current_user: user}}) do
    entry = Entries.get_entry!(args[:entry_id])

    if(entry.user_id == user.id) do
      case Entries.delete_entry(entry) do
        {:ok, entry} ->
          {:ok, entry}
        {:error, changeset} ->
          {
            :error,
            message: "Could not delete metric!",
            details: ChangesetErrors.error_details(changeset)
          }
      end
    else
      {
        :error,
        message: "You are not authorized to delete this entry."
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
          message: "Could not create metric.",
          details: ChangesetErrors.error_details(changeset)
        }
    end
  end

  def delete_metric(_, args, %{context: %{current_user: user}}) do
    metric = Entries.get_metric!(args[:metric_id])

    if(metric.user_id == user.id) do
      case Entries.delete_metric(metric) do
        {:ok, metric} ->
          {:ok, metric}
        {:error, changeset} ->
          {
            :error,
            message: "Could not delete metric!",
            details: ChangesetErrors.error_details(changeset)
          }
      end
    else
      {
        :error,
        message: "You are not authorized to delete this metric."
      }
    end
  end
end
