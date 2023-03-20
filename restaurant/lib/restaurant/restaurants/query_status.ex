defmodule Restaurant.Restaurants.QueryStatus do
  import Integer, only: [is_even: 1, is_odd: 1]

  alias Ecto.Multi
  alias Restaurant.Repo
  alias Restaurant.Restaurants.RestaurantQuery.QueryStateMachine

  def enqueue(query_id),
    do:
      Restaurant.Restaurants.Jobs.enqueue(
        Multi.new(),
        :query_status,
        %{
          "type" => "query_status",
          "query_id" => query_id
        },
        max_attempts: 3
      )

  def perform(multi = %Ecto.Multi{}, %{"type" => "query_status", "query_id" => id}) do
    IO.inspect(id, label: "querying status for query")

    id
    |> Restaurant.Restaurants.get_restaurant_query!()
    |> query_status(multi)
    |> Repo.transaction()
    |> IO.inspect(label: "query_status job done")
  end

  defp query_status(query, multi) do
    # faking complex logic
    status =
      case query.restaurant_id do
        id when is_even(id) -> "available"
        id when is_odd(id) -> "unavailable"
      end

    # downside of the machinery library that it cannot handle multis,
    # if the notification insert fails we would have an inconsistent state
    {:ok, _} = Machinery.transition_to(query, QueryStateMachine, status) |> IO.inspect()

    # enqueue notification so that its retried on failure
    Restaurant.Restaurants.Notify.enqueue(multi, query.id)
  end
end
