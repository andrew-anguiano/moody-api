defmodule MoodyWeb.Schema.Schema do
  use Absinthe.Schema
  alias Moody.{Accounts, Entries}
  alias MoodyWeb.Resolvers

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  query do
    @desc "Get an entry by its ID"
    field :entry, :entry do
      arg :id, non_null :id

      resolve &Resolvers.Entries.entry/3
    end

    @desc "Get a list of entries"
    field :entries, list_of(:entry) do
      resolve &Resolvers.Entries.entries/3
    end

    @desc "Get a user by their ID"
    field :user, :user do
      arg :id, non_null :id

      resolve &Resolvers.Accounts.user/3
    end
  end

  object :entry do
    field :id, non_null :id
    field :notes, :string
    field :user, non_null(:user) do
      arg :id, non_null :id
       resolve dataloader(Accounts)
    end
    field :scores, list_of(:score), resolve: dataloader(Entries)
  end

  object :user do
    field :username, non_null :string
    field :email, non_null :string
    field :entries, list_of(:entry), resolve: dataloader(Entries)
    field :metrics, list_of(:metric), resolve: dataloader(Entries)
  end

  object :score do
    field :id, non_null :id
    field :metric_score, non_null :integer
    field :metric, non_null(:metric), resolve: dataloader(Entries)
    field :entry, non_null :entry
  end

  object :metric do
    field :id, non_null :id
    field :metric_name, non_null :string
    field :metric_type, non_null :metric_type
  end

  @desc "The type of metric"
  enum :metric_type do
    value :rating, as: :r, description: "A 1-5 numerical rating scale"
  end

  def context(ctx) do
    source = Entries.datasource()

    loader = Dataloader.new
    |> Dataloader.add_source(Entries, source)
    |> Dataloader.add_source(Accounts, source)

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
