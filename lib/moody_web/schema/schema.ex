defmodule MoodyWeb.Schema.Schema do
  use Absinthe.Schema
  alias Moody.{Accounts, Entries}
  alias MoodyWeb.Resolvers
  alias MoodyWeb.Schema.Middleware

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]
  import_types Absinthe.Type.Custom

  query do
    @desc "Get current users information"
    field :me, :user do
      resolve &Resolvers.Accounts.me/3
    end
  end

  mutation do
    @desc "Create an entry"
    field :create_entry, :entry do
      arg :notes, :string
      arg :scores, list_of(:score_input)

      middleware Middleware.Authenticate
      resolve &Resolvers.Entries.create_entry/3
    end

    @desc "Delete an entry"
    field :delete_entry, :entry do
      arg :entry_id, non_null :id

      middleware Middleware.Authenticate
      resolve &Resolvers.Entries.delete_entry/3
    end

    @desc "Create a metric"
    field :create_metric, :metric do
      arg :metric_name, non_null :string
      arg :metric_type, non_null :metric_type

      middleware Middleware.Authenticate
      resolve &Resolvers.Entries.create_metric/3
    end

    @desc "Delete a metric"
    field :delete_metric, :metric do
      arg :metric_id, non_null :id

      middleware Middleware.Authenticate
      resolve &Resolvers.Entries.delete_metric/3
    end

    @desc "Create a user account"
    field :signup, :session do
      arg :username, non_null :string
      arg :email, non_null :string
      arg :password, non_null :string

      resolve &Resolvers.Accounts.signup/3
    end

    @desc "Sign a user in"
    field :signin, :session do
      arg :username, non_null :string
      arg :password, non_null :string
      resolve &Resolvers.Accounts.signin/3
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
    field :role, non_null :user_role
    field :entries, list_of(:entry),
      resolve: dataloader(Entries, :entries, args: %{scope: :user})
    field :metrics, list_of(:metric), resolve: dataloader(Entries)
  end

  object :session do
    field :user, non_null :user
    field :token, non_null :string
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
  end

  @desc "The type of metric"
  enum :metric_type do
    value :rating, as: "rating", description: "A 1-5 numerical rating scale"
  end

  @desc "User roles"
  enum :user_role do
    value :user, as: "user", description: "The standard user role."
    value :admin, as: "admin", description: "Administrator user role."
  end

  def context(ctx) do
    loader = Dataloader.new
    |> Dataloader.add_source(Entries, Entries.datasource)
    |> Dataloader.add_source(Accounts, Accounts.datasource)

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
