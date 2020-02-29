defmodule Moody.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :role, :string, default: "user"
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :entries, Moody.Entries.Entry
    has_many :metrics, Moody.Entries.Metric

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    required_fields = [:username, :email, :password, :role]

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_length(:username, min: 2)
    |> validate_length(:password, min: 8)
    |> validate_inclusion(:role, ["user", "admin"])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
