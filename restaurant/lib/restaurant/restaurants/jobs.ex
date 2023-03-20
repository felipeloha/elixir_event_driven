defmodule Restaurant.Restaurants.Jobs do
  use EctoJob.JobQueue, table_name: "jobs"

  # Note: each failure over max attempts should notify the application monitoring
  # so that the failure is visible. That would be an extention of this or the JobQueue module

  def perform(multi = %Ecto.Multi{}, %{"type" => "query_status", "query_id" => _id} = params),
    do: Restaurant.Restaurants.QueryStatus.perform(multi, params)

  def perform(multi = %Ecto.Multi{}, %{"type" => "notify", "query_id" => _id} = params),
    do: Restaurant.Restaurants.Notify.perform(multi, params)
end
