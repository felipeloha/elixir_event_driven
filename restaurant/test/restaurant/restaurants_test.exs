defmodule Restaurant.RestaurantsTest do
  use Restaurant.DataCase

  alias Restaurant.Restaurants

  describe "restaurant_queries" do
    alias Restaurant.Restaurants.RestaurantQuery

    import Restaurant.RestaurantsFixtures

    @invalid_attrs %{name: nil, order_id: nil, restaurant_id: nil, status: nil}

    test "list_restaurant_queries/0 returns all restaurant_queries" do
      restaurant_query = restaurant_query_fixture()
      assert Restaurants.list_restaurant_queries() == [restaurant_query]
    end

    test "get_restaurant_query!/1 returns the restaurant_query with given id" do
      restaurant_query = restaurant_query_fixture()
      assert Restaurants.get_restaurant_query!(restaurant_query.id) == restaurant_query
    end

    test "create_restaurant_query/1 with valid data creates a restaurant_query" do
      valid_attrs = %{name: "some name", order_id: 42, restaurant_id: 42, status: "some status"}

      assert {:ok, %RestaurantQuery{} = restaurant_query} =
               Restaurants.create_restaurant_query(valid_attrs)

      assert restaurant_query.name == "some name"
      assert restaurant_query.order_id == 42
      assert restaurant_query.restaurant_id == 42
      assert restaurant_query.status == "some status"
    end

    test "create_restaurant_query/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Restaurants.create_restaurant_query(@invalid_attrs)
    end

    test "update_restaurant_query/2 with valid data updates the restaurant_query" do
      restaurant_query = restaurant_query_fixture()

      update_attrs = %{
        name: "some updated name",
        order_id: 43,
        restaurant_id: 43,
        status: "some updated status"
      }

      assert {:ok, %RestaurantQuery{} = restaurant_query} =
               Restaurants.update_restaurant_query(restaurant_query, update_attrs)

      assert restaurant_query.name == "some updated name"
      assert restaurant_query.order_id == 43
      assert restaurant_query.restaurant_id == 43
      assert restaurant_query.status == "some updated status"
    end

    test "update_restaurant_query/2 with invalid data returns error changeset" do
      restaurant_query = restaurant_query_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Restaurants.update_restaurant_query(restaurant_query, @invalid_attrs)

      assert restaurant_query == Restaurants.get_restaurant_query!(restaurant_query.id)
    end

    test "delete_restaurant_query/1 deletes the restaurant_query" do
      restaurant_query = restaurant_query_fixture()
      assert {:ok, %RestaurantQuery{}} = Restaurants.delete_restaurant_query(restaurant_query)

      assert_raise Ecto.NoResultsError, fn ->
        Restaurants.get_restaurant_query!(restaurant_query.id)
      end
    end

    test "change_restaurant_query/1 returns a restaurant_query changeset" do
      restaurant_query = restaurant_query_fixture()
      assert %Ecto.Changeset{} = Restaurants.change_restaurant_query(restaurant_query)
    end
  end
end
