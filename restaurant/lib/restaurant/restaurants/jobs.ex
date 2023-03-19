defmodule Restaurant.Restaurants.Jobs do
  use EctoJob.JobQueue, table_name: "jobs"
  import Integer, only: [is_even: 1, is_odd: 1]

  def perform(multi = %Ecto.Multi{}, job = %{"type" => "query_status", "query_id" => id}) do
    id
    |> Restaurant.Restaurants.get_restaurant_query!()
    |> query_status()
  end

  def perform(multi = %Ecto.Multi{}, job = %{"type" => "notify", "query_id" => id}) do
    id
    |> Restaurant.Restaurants.get_restaurant_query!()
    |> notify()
  end

  defp query_status(query) do
    # faking complex logic
    status =
      case query.restaurant_id do
        id when is_even(id) -> "confirmed"
        id when is_odd(id) -> "rejected"
      end

    :ok = Restaurant.Restaurants.RestaurantQuery.QueryStateMachine.transition_to(query, status)

    # enqueue notification so that its retried on failure
    :ok =
      :notify
      |> __MODULE__.new(%{"type" => "notify", "query_id" => query.id})
      |> Repo.insert()
  end

  defp notify(query) do
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
  end

  defp send_message(queue_url, message_body, opts \\ []) do
    case ExAws.SQS.send_message(queue_url, message_body, opts)
         |> ExAws.request() do
      {:ok, res} ->
        IO.inspect(res, "message sent to sqs")

        :ok

      {:error, error} ->
        IO.inspect(error, label: "error sending message to queue")

        {:error, error}
    end
  end
end
