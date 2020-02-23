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
    |> cast(attrs, [:metric_score, :metric_id, :entry_id])
    # is it ok to not validate referenced fields? like :entry_id?
    # what's the standard for referencing fields and validations?
    |> validate_required([:metric_score, :metric_id])
    |> assoc_constraint(:metric)
    |> assoc_constraint(:entry)
  end
end
