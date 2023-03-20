defmodule RestaurantWeb.RestaurantQueryJSON do
  alias Restaurant.Restaurants.RestaurantQuery

  @doc """
  Renders a list of restaurant_queries.
  """
  def index(%{restaurant_queries: restaurant_queries}) do
    %{data: for(restaurant_query <- restaurant_queries, do: data(restaurant_query))}
  end

  @doc """
  Renders a single restaurant_query.
  """
  def show(%{restaurant_query: restaurant_query}) do
    %{data: data(restaurant_query)}
  end

  defp data(%RestaurantQuery{} = restaurant_query) do
    %{
      id: restaurant_query.id,
      name: restaurant_query.name,
      status: restaurant_query.status,
      restaurant_id: restaurant_query.restaurant_id,
      order_id: restaurant_query.order_id
    }
  end
end
