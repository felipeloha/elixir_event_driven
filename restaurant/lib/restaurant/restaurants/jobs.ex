defmodule Restaurant.Restaurants.Jobs do
  use EctoJob.JobQueue, table_name: "jobs"

  import Integer, only: [is_even: 1, is_odd: 1]

  alias Ecto.Multi
  alias Restaurant.Repo
  alias Restaurant.Restaurants.RestaurantQuery.QueryStateMachine

  #each failure over max attempts should notify the application monitoring
  #so that the failure is visible

  #TODO move all this logic to caller
  def perform(multi = %Ecto.Multi{}, %{"type" => "query_status", "query_id" => id}) do
    IO.inspect(id, label: "querying status for query")

    id
    |> Restaurant.Restaurants.get_restaurant_query!()
    |> query_status(multi)
    |> Repo.transaction()
    |> IO.inspect(label: "query_status job done")
  end

  def perform(multi = %Ecto.Multi{}, %{"type" => "notify", "query_id" => id}) do
    IO.inspect(id, label: "notifying query")

    id
    |> Restaurant.Restaurants.get_restaurant_query!()
    |> notify(multi)
    |> Repo.transaction()
    |> IO.inspect(label: "notify job done")
  end

  defp query_status(query, multi) do
    # faking complex logic
    status =
      case query.restaurant_id do
        id when is_even(id) -> "confirmed"
        id when is_odd(id) -> "rejected"
      end

    # downside of the machinery library that it cannot handle multis,
    # if the notification insert fails we would have an inconsistent state
    {:ok, _} = Machinery.transition_to(query, QueryStateMachine, status) |> IO.inspect()

    # enqueue notification so that its retried on failure
    Multi.insert(
      multi,
      :notify,
      __MODULE__.new(%{"type" => "notify", "query_id" => query.id})
    )
  end

  defp notify(query, multi) do
    message =
      %{
        "id" => "random_id",
        "type" => "order.update",
        "payload" => %{
          "order_id" => query.order_id,
          "status" => query.status
        }
      }
      |> Jason.encode!()

    :ok = send_message("https://localhost:4566/000000000000/restaurant-queue", message)

    multi
  end

  defp send_message(queue_url, message_body, opts \\ []) do
    case ExAws.SQS.send_message(queue_url, message_body, opts)
         |> ExAws.request() do
      {:ok, res} ->
        IO.inspect(res, label: "message sent to sqs")

        :ok

      {:error, error} ->
        IO.inspect(error, label: "error sending message to queue")

        {:error, error}
    end
  end
end
