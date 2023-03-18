defmodule NPlusOne.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :age, :integer
    belongs_to :user, NPlusOne.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :age])
    |> validate_required([:user_id, :age])
  end
end
