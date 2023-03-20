defmodule Restaurant.Restaurants.Notify do
  alias Restaurant.Repo

  def enqueue(multi, query_id),
    do:
      Restaurant.Restaurants.Jobs.enqueue(
        multi,
        :query_status,
        %{
          "type" => "notify",
          "query_id" => query_id
        },
        max_attempts: 3
      )

  def perform(multi = %Ecto.Multi{}, %{"type" => "notify", "query_id" => id}) do
    IO.inspect(id, label: "notifying query")

    id
    |> Restaurant.Restaurants.get_restaurant_query!()
    |> notify(multi)
    |> Repo.transaction()
    |> IO.inspect(label: "notify job done")
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

    :ok = send_message(message)
    multi
  end

  defp send_message(message_body, opts \\ []) do
    Application.get_env(:restaurant, :restaurant_queue_url)
    |> ExAws.SQS.send_message(message_body, opts)
    |> ExAws.request()
    |> case do
      {:ok, res} ->
        IO.inspect(res, label: "message sent to sqs")

        :ok

      {:error, error} ->
        IO.inspect(error, label: "error sending message to queue")

        {:error, error}
    end
  end
end
