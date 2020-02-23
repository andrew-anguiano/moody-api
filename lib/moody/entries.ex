defmodule Moody.Entries do
  @moduledoc """
  The Entries context.
  """

  import Ecto.Query, warn: false
  alias Moody.Repo

  alias Moody.Entries.{Entry, Metric, Score}
  alias Moody.Accounts.User

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(%User{} = user, attrs) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    # |> Ecto.Changeset.put_assoc(:scores, attrs.scores)
    |> Repo.insert()
  end

  @doc """
  Creates an entry and scores simultaneously.
  This feels janky too... not sure the best way.
  """
  def create_entry(%User{} = user, scores, attrs) do
    {:ok, entry} = create_entry(user, attrs)
    Enum.map(scores, fn s -> create_score(entry, s) end)
  end

  def create_score(%Entry{} = entry, attrs) do
    %Score{}
    |> Score.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:entry, entry)
    |> Repo.insert()
  end

  # def create_entry(%User{} = user, [%Score{}] = scores, attrs) do

  #   score_ids = Enum.map(scores, fn s ->
  #     %{Score}
  #     |> Score.changeset(score)
  #   end
  #   )
  # end

  # def create_score(%User{} = user, attrs) do
  #   %Score{}
  #   |> Score.changeset(attrs)
  #   |>
  # end

  @doc """
  Creates a new metric for the given user
 """
  def create_metric(%User{} = user, attrs) do
    %Metric{}
    |> Metric.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{source: %Entry{}}

  """
  def change_entry(%Entry{} = entry) do
    Entry.changeset(entry, %{})
  end
end
