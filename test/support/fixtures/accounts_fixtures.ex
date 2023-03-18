defmodule NPlusOne.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NPlusOne.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> NPlusOne.Accounts.create_user()

    user
  end

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        age: 42,
        user_id: 42
      })
      |> NPlusOne.Accounts.create_profile()

    profile
  end
end
