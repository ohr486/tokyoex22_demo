defmodule NPlusOne.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :user_id, :integer
      add :age, :integer

      timestamps()
    end
  end
end
