defmodule RestaurantWeb.RestaurantQueryControllerTest do
  use RestaurantWeb.ConnCase

  import Restaurant.RestaurantsFixtures

  alias Restaurant.Restaurants.RestaurantQuery

  @create_attrs %{
    name: "some name",
    order_id: 42,
    restaurant_id: 42,
    status: "some status"
  }
  @update_attrs %{
    name: "some updated name",
    order_id: 43,
    restaurant_id: 43,
    status: "some updated status"
  }
  @invalid_attrs %{name: nil, order_id: nil, restaurant_id: nil, status: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all restaurant_queries", %{conn: conn} do
      conn = get(conn, ~p"/api/restaurant/query")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create restaurant_query" do
    test "renders restaurant_query when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/restaurant/query", restaurant_query: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/restaurant/query/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "order_id" => 42,
               "restaurant_id" => 42,
               "status" => "requested"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/restaurant/query", restaurant_query: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update restaurant_query" do
    setup [:create_restaurant_query]

    test "renders restaurant_query when data is valid", %{
      conn: conn,
      restaurant_query: %RestaurantQuery{id: id} = restaurant_query
    } do
      conn =
        put(conn, ~p"/api/restaurant/query/#{restaurant_query}", restaurant_query: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/restaurant/query/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "order_id" => 43,
               "restaurant_id" => 43,
               "status" => "requested"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, restaurant_query: restaurant_query} do
      conn =
        put(conn, ~p"/api/restaurant/query/#{restaurant_query}", restaurant_query: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete restaurant_query" do
    setup [:create_restaurant_query]

    test "deletes chosen restaurant_query", %{conn: conn, restaurant_query: restaurant_query} do
      conn = delete(conn, ~p"/api/restaurant/query/#{restaurant_query}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/restaurant/query/#{restaurant_query}")
      end
    end
  end

  defp create_restaurant_query(_) do
    restaurant_query = restaurant_query_fixture()
    %{restaurant_query: restaurant_query}
  end
end
