defmodule Moody.Repo.Migrations.CreateUserMetrics do
  use Ecto.Migration

  def change do
    create table(:user_metrics) do
      add :metric_name, :string, null: false
      add :metric_type, :string, [null: false, default: "scale"]
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:user_metrics, [:user_id])
  end
end
