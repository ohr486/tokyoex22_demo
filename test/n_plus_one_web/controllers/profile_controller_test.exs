defmodule NPlusOneWeb.ProfileControllerTest do
  use NPlusOneWeb.ConnCase

  import NPlusOne.AccountsFixtures

  @create_attrs %{age: 42, user_id: 42}
  @update_attrs %{age: 43, user_id: 43}
  @invalid_attrs %{age: nil, user_id: nil}

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, ~p"/profiles")
      assert html_response(conn, 200) =~ "Listing Profiles"
    end
  end

  describe "new profile" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/profiles/new")
      assert html_response(conn, 200) =~ "New Profile"
    end
  end

  describe "create profile" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/profiles", profile: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/profiles/#{id}"

      conn = get(conn, ~p"/profiles/#{id}")
      assert html_response(conn, 200) =~ "Profile #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/profiles", profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profile"
    end
  end

  describe "edit profile" do
    setup [:create_profile]

    test "renders form for editing chosen profile", %{conn: conn, profile: profile} do
      conn = get(conn, ~p"/profiles/#{profile}/edit")
      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  describe "update profile" do
    setup [:create_profile]

    test "redirects when data is valid", %{conn: conn, profile: profile} do
      conn = put(conn, ~p"/profiles/#{profile}", profile: @update_attrs)
      assert redirected_to(conn) == ~p"/profiles/#{profile}"

      conn = get(conn, ~p"/profiles/#{profile}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, profile: profile} do
      conn = put(conn, ~p"/profiles/#{profile}", profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  describe "delete profile" do
    setup [:create_profile]

    test "deletes chosen profile", %{conn: conn, profile: profile} do
      conn = delete(conn, ~p"/profiles/#{profile}")
      assert redirected_to(conn) == ~p"/profiles"

      assert_error_sent 404, fn ->
        get(conn, ~p"/profiles/#{profile}")
      end
    end
  end

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end
end
