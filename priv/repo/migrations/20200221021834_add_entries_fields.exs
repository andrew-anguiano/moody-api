defmodule Moody.Repo.Migrations.AddEntriesFields do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :notes, :string
      add :user_id, references(:users), null: false
    end
  end
end
