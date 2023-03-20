defmodule Restaurant.RestaurantsFixtures do
  @doc """
  Generate a restaurant_query.
  """
  def restaurant_query_fixture(attrs \\ %{}) do
    {:ok, %{query: restaurant_query}} =
      attrs
      |> Enum.into(%{
        name: "some name",
        order_id: 42,
        restaurant_id: 42,
        status: "some status"
      })
      |> Restaurant.Restaurants.create_restaurant_query()

    restaurant_query
  end
end
