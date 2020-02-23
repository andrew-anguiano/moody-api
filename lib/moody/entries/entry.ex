defmodule Moody.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :notes, :string

    belongs_to :user, Moody.Accounts.User
    has_many :scores, Moody.Entries.Score

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    required_fields = [:user_id]
    optional_fields = [:notes]

    entry
    |> cast(attrs, required_fields ++ optional_fields)
    |> assoc_constraint(:user)
  end
end
