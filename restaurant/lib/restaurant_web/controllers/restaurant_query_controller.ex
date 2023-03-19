defmodule RestaurantWeb.RestaurantQueryController do
  use RestaurantWeb, :controller

  alias Restaurant.Restaurants
  alias Restaurant.Restaurants.RestaurantQuery

  action_fallback(RestaurantWeb.FallbackController)

  def index(conn, _params) do
    restaurant_queries = Restaurants.list_restaurant_queries()
    render(conn, :index, restaurant_queries: restaurant_queries)
  end

  def create(conn, %{"restaurant_query" => restaurant_query_params}) do
    with {:ok, %{query: %RestaurantQuery{} = restaurant_query}} <-
           Restaurants.create_restaurant_query(restaurant_query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/restaurant/query/#{restaurant_query}")
      |> render(:show, restaurant_query: restaurant_query)
    end
  end

  def show(conn, %{"id" => id}) do
    restaurant_query = Restaurants.get_restaurant_query!(id)
    render(conn, :show, restaurant_query: restaurant_query)
  end

  def update(conn, %{"id" => id, "restaurant_query" => restaurant_query_params}) do
    restaurant_query = Restaurants.get_restaurant_query!(id)

    with {:ok, %RestaurantQuery{} = restaurant_query} <-
           Restaurants.update_restaurant_query(restaurant_query, restaurant_query_params) do
      render(conn, :show, restaurant_query: restaurant_query)
    end
  end

  def delete(conn, %{"id" => id}) do
    restaurant_query = Restaurants.get_restaurant_query!(id)

    with {:ok, %RestaurantQuery{}} <- Restaurants.delete_restaurant_query(restaurant_query) do
      send_resp(conn, :no_content, "")
    end
  end
end
