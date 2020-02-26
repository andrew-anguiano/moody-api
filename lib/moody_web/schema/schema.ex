defmodule MoodyWeb.Schema.Schema do
  use Absinthe.Schema
  alias Moody.{Accounts, Entries}
  alias MoodyWeb.Resolvers

  query do
    @desc "Get an entry by its ID"
    field :entry, :entry do
      arg :id, non_null :id

      resolve &Resolvers.Entry.entry/3
    end

    @desc "Get a list of entries"
    field :entries, list_of(:entry) do
      resolve &Resolvers.Entry.entries/3
    end
  end

  object :entry do
    field :id, non_null :id
    field :notes, :string
    field :user, :user
    field :scores, non_null(list_of(:score))
  end

  object :user do
    field :id, non_null :id
    field :username, non_null :string
    field :email, non_null :string
    field :entries, list_of :entry
  end

  object :score do
    field :metric_score, non_null :integer
    field :metric, non_null :metric
    field :entry, non_null :entry
  end

  object :metric do
    field :metric_name, non_null :string
    field :metric_type, non_null :metric_type
  end

  @desc "The type of metric"
  enum :metric_type do
    value :rating, as: :r, description: "A 1-5 numerical rating scale"
  end
end
