defmodule Discuss.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users) # comment belongs to 1 user
      add :topic_id, references(:topics) # comment is for 1 topic

      timestamps()
    end
  end
end
