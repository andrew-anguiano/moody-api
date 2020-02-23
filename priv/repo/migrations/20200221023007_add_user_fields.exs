defmodule Moody.Repo.Migrations.AddUserFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
    end

    create unique_index(:users, [:email, :username])
  end
end
