defmodule Restaurant.Restaurants do
  @moduledoc """
  The Restaurants context.
  """

  import Ecto.Query, warn: false
  alias Restaurant.Repo

  alias Restaurant.Restaurants.RestaurantQuery

  @doc """
  Returns the list of restaurant_queries.

  ## Examples

      iex> list_restaurant_queries()
      [%RestaurantQuery{}, ...]

  """
  def list_restaurant_queries do
    Repo.all(RestaurantQuery)
  end

  @doc """
  Gets a single restaurant_query.

  Raises `Ecto.NoResultsError` if the Restaurant query does not exist.

  ## Examples

      iex> get_restaurant_query!(123)
      %RestaurantQuery{}

      iex> get_restaurant_query!(456)
      ** (Ecto.NoResultsError)

  """
  def get_restaurant_query!(id), do: Repo.get!(RestaurantQuery, id)

  @doc """
  Creates a restaurant_query.

  ## Examples

      iex> create_restaurant_query(%{field: value})
      {:ok, %RestaurantQuery{}}

      iex> create_restaurant_query(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_restaurant_query(attrs \\ %{}) do
    # use machinery for state management and handle errors
    # send message to sqs
    # refute or confirm depending on call
    %RestaurantQuery{}
    |> RestaurantQuery.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a restaurant_query.

  ## Examples

      iex> update_restaurant_query(restaurant_query, %{field: new_value})
      {:ok, %RestaurantQuery{}}

      iex> update_restaurant_query(restaurant_query, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_restaurant_query(%RestaurantQuery{} = restaurant_query, attrs) do
    restaurant_query
    |> RestaurantQuery.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a restaurant_query.

  ## Examples

      iex> delete_restaurant_query(restaurant_query)
      {:ok, %RestaurantQuery{}}

      iex> delete_restaurant_query(restaurant_query)
      {:error, %Ecto.Changeset{}}

  """
  def delete_restaurant_query(%RestaurantQuery{} = restaurant_query) do
    Repo.delete(restaurant_query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking restaurant_query changes.

  ## Examples

      iex> change_restaurant_query(restaurant_query)
      %Ecto.Changeset{data: %RestaurantQuery{}}

  """
  def change_restaurant_query(%RestaurantQuery{} = restaurant_query, attrs \\ %{}) do
    RestaurantQuery.changeset(restaurant_query, attrs)
  end
end
