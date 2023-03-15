defmodule Orders.SQS.RestaurantConsumer do
  use Broadway

  alias Broadway.Message
  alias Orders.Deliveries

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwaySQS.Producer,
           queue_url: "https://localhost:4566/000000000000/restaurant-queue",
           config: [
             access_key_id: "dummy",
             secret_access_key: "dummy"
           ]}
      ],
      processors: [
        default: []
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 2000
        ]
      ]
    )
  end

  @impl true
  def handle_message(
        _,
        %Message{
          data: data
        } = message,
        _
      ) do
    with decoded_data <- data |> Jason.decode!(),
         {:ok, _order} <- decoded_data |> handle() do
      message
    else
      error -> Broadway.Message.failed(message, error)
    end
  end

  defp handle(
         %{
           "type" => "order.update",
           "payload" => %{"status" => new_order_status, "order_id" => order_id}
         } = msg
       ) do
    IO.inspect(msg, label: "handling valid message")

    order_id
    |> Deliveries.get_order!()
    |> Machinery.transition_to(Deliveries.Order.OrderStateMachine, new_order_status)
  end

  defp handle(msg) do
    IO.inspect(msg, label: "ignoring invalid message")
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)

    IO.inspect(list,
      label: "Got batch of finished jobs from processors, sending ACKs to SQS as a batch."
    )

    messages
  end
end
