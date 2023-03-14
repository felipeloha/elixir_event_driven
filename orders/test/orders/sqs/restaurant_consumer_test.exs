defmodule Orders.SQS.RestaurantConsumerTest do
  use Orders.DataCase

  alias Orders.Deliveries

  describe "restaurant_consumer" do
    setup do
      {:ok, order} = Deliveries.create_order(%{name: "test_order"})
      {:ok, %{order: order}}
    end

    test "Consumes message successfully", %{order: order} do
      event =
        %{
          "id" => "random_id",
          "type" => "order.update",
          "payload" => %{
            "order_id" => order.id,
            "status" => "confirmed"
          }
        }
        |> Jason.encode!()

      ref = Broadway.test_message(Orders.SQS.RestaurantConsumer, event)
      assert_receive {:ack, ^ref, [%{status: :ok}], _failed}, 1000

      assert %{status: "confirmed"} = Deliveries.get_order!(order.id)
    end

    test "fails to consume message", %{order: order} do
      event =
        %{
          "id" => "random_id",
          "type" => "order.update",
          "payload" => %{
            "order_id" => order.id,
            "status" => "wrong"
          }
        }
        |> Jason.encode!()

      ref = Broadway.test_message(Orders.SQS.RestaurantConsumer, event)

      assert_receive {:ack, ^ref, [],
                      [%{status: {:failed, {:error, "Transition to this state isn't declared."}}}]},
                     1000

      assert %{status: "requested"} = Deliveries.get_order!(order.id)
    end
  end
end
