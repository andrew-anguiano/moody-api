defmodule Moody.Repo.Migrations.CreateUserMetricScores do
  use Ecto.Migration

  def change do
    create table(:user_metric_scores) do
      add :metric_id, references(:user_metrics, on_delete: :delete_all)
      add :metric_score, :integer, null: false
      add :entry_id, references(:entries, on_delete: :delete_all)
    end

    create index(:user_metric_scores, [:metric_id])
    create index(:user_metric_scores, [:entry_id])
  end
end
