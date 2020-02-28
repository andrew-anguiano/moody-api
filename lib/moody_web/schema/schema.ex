defmodule MoodyWeb.Schema.Schema do
  use Absinthe.Schema
  alias Moody.{Accounts, Entries}
  alias MoodyWeb.Resolvers

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]
  import_types Absinthe.Type.Custom

  query do
    @desc "Get an entry by its ID"
    field :entry, :entry do
      arg :id, non_null :id

      resolve &Resolvers.Entries.entry/3
    end

    @desc "Get a list of entries"
    field :entries, list_of(:entry) do
      arg :limit, :integer
      resolve &Resolvers.Entries.entries/3
    end

    @desc "Get a user by their ID"
    field :user, :user do
      arg :id, non_null :id

      resolve &Resolvers.Accounts.user/3
    end
  end

  mutation do
    @desc "Create an entry"
    field :create_entry, :entry do
      arg :notes, :string
      arg :scores, list_of(:score_input)

      resolve &Resolvers.Entries.create_entry/3
    end

    @desc "Create a metric"
    field :create_metric, :metric do
      arg :metric_name, non_null :string
      arg :metric_type, non_null :metric_type

      resolve &Resolvers.Entries.create_metric/3
    end
  end

  input_object :score_input do
    field :metric_score, non_null :integer
    field :metric_id, non_null :id
  end

  object :entry do
    field :id, non_null :id
    field :notes, :string
    field :user, non_null(:user),  resolve: dataloader(Accounts)
    field :scores, list_of(:score), resolve: dataloader(Entries)
    field :inserted_at, non_null :naive_datetime
    field :updated_at, non_null :naive_datetime
  end

  object :user do
    field :username, non_null :string
    field :email, non_null :string
    field :entries, list_of(:entry),
      resolve: dataloader(Entries, :entries, args: %{scope: :user})
    field :metrics, list_of(:metric), resolve: dataloader(Entries)
  end

  object :score do
    field :id, non_null :id
    field :metric_score, non_null :integer
    field :metric, non_null(:metric), resolve: dataloader(Entries)
  end

  object :metric do
    field :id, non_null :id
    field :metric_name, non_null :string
    field :metric_type, non_null :metric_type
    field :inserted_at, non_null :naive_datetime
    field :updated_at, non_null :naive_datetime

    field :user, non_null(:user), resolve: dataloader(Accounts)
  end

  @desc "The type of metric"
  enum :metric_type do
    value :rating, as: "rating", description: "A 1-5 numerical rating scale"
  end

  def context(ctx) do
    ctx = Map.put(ctx, :current_user, Accounts.get_user!(1))

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
