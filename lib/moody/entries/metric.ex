defmodule Moody.Entries.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_metrics" do
    field :metric_name, :string
    field :metric_type, :string, default: "rating"

    belongs_to :user, Moody.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:metric_name, :metric_type, :user_id])
    |> validate_inclusion(:metric_type, ["rating"])
    |> validate_required([:metric_name, :metric_type])
    |> assoc_constraint(:user)
  end
end
