# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Moody.Repo.insert!(%Moody.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Moody.Repo
alias Moody.Entries.{Entry, Metric, Score}
alias Moody.Accounts.User

test_user =
    %User{}
    |> User.changeset(%{
        username: "test",
        email: "test@example.com",
        password: "password123"
    })
    |> Repo.insert!

test_user_2 =
    %User{}
    |> User.changeset(%{
        username: "test2",
        email: "test2@example.com",
        password: "password456"
    })
    |> Repo.insert!

test_user_3 =
    %User{}
    |> User.changeset(%{
        username: "test3",
        email: "test3@example.com",
        password: "password789"
    })
    |> Repo.insert!

metric_1 =
        %Metric{
           metric_name: "Mood",
           user: test_user
        } |> Repo.insert!

metric_2 =
        %Metric{
           metric_name: "Anxiety",
           user: test_user
        } |> Repo.insert!

test_entry =
    %Entry{
        notes: "Test note -- test",
        user: test_user
    } |> Repo.insert!

entry_1 = %Entry{
    notes: "Test note 2 -- test2",
    user: test_user_2
} |> Repo.insert!

entry_2 = %Entry{
    notes: "Test note 2-1 -- test2",
    user: test_user_2,
} |> Repo.insert!

entry_3 = %Entry{
    notes: "Test note 2-2 -- test2",
    user: test_user_2
} |> Repo.insert!

entry_4 = %Entry{
    notes: "Test note 3 -- test3",
    user: test_user_3
} |> Repo.insert!

%Score{
    metric_score: 2,
    entry: entry_1,
    metric: metric_1
} |> Repo.insert!
