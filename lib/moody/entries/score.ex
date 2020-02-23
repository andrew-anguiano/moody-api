defmodule Moody.Entries.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_metric_scores" do
    field :metric_score, :integer

    belongs_to :metric, Moody.Entries.Metric
    belongs_to :entry, Moody.Entries.Entry
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:metric_score, :user_metric_id, :entry_id])
    |> validate_required([:metric_score, :user_metric_id, :entry_id])
    |> assoc_constraint(:metric)
    |> assoc_constraint(:entry)
  end
end
