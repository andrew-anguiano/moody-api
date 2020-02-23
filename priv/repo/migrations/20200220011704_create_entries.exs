defmodule Moody.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do

      timestamps()
    end

  end
end
