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

    # test lasts too long comment skip to run it
    @tag :skip
    test "non consumed messages should go to dead letter queue" do
      # reset queues
      assert {:ok, _} = purge()
      assert {:ok, _} = purge("restaurant-queue-dlq")

      assert {:ok, _} =
               ExAws.SQS.send_message(
                 "https://localhost:4566/000000000000/restaurant-queue",
                 %{message: "a message"} |> Jason.encode!()
               )
               |> ExAws.request()

      # make sure no messages are in dql
      assert [] = receive_sqs_msgs("restaurant-queue-dlq")

      # receive the first time
      assert [%{}] = receive_sqs_msgs()

      # wait for visibility time to lapse
      Process.sleep(6000)

      # 2 time
      assert [%{}] = receive_sqs_msgs()

      Process.sleep(6000)

      # 3 time is not there and is going to the dlq
      assert [] = receive_sqs_msgs()

      assert [%{body: "{\"message\":\"a message\"}"}] = receive_sqs_msgs("restaurant-queue-dlq")
    end

    defp receive_sqs_msgs(queue_name \\ "restaurant-queue") do
      ExAws.SQS.receive_message("https://localhost:4566/000000000000/#{queue_name}")
      |> ExAws.request()
      |> elem(1)
      |> Map.get(:body)
      |> Map.get(:messages)
    end

    defp purge(queue_name \\ "restaurant-queue") do
      ExAws.SQS.purge_queue("https://localhost:4566/000000000000/#{queue_name}")
      |> ExAws.request()
    end
  end
end
