defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string # oauth, e.g. github
      add :token, :string

      timestamps() # created_at, last_updated
    end
  end
end
