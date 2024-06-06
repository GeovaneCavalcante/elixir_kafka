defmodule ElixirKafkaPubsub.Consumer do
  @behaviour :brod_group_subscriber_v2

  def child_spec(_arg) do
    config = %{
      client: :kafka_client,
      group_id: "teste",
      topics: ["api-users.create"],
      cb_module: __MODULE__,
      consumer_config: [{:begin_offset, :earliest}],
      init_data: [],
      message_type: :message_set,
      group_config: [
        offset_commit_policy: :commit_to_kafka_v2,
        offset_commit_interval_seconds: 5,
        rejoin_delay_seconds: 60,
        reconnect_cool_down_seconds: 60
      ]
    }

    %{
      id: __MODULE__,
      start: {:brod_group_subscriber_v2, :start_link, [config]},
      type: :worker,
      restart: :temporary,
      shutdown: 5000
    }
  end

  @impl :brod_group_subscriber_v2
  def init(_group_id, _init_data), do: {:ok, []}

  @impl :brod_group_subscriber_v2
  def handle_message(message, _state) do
    IO.inspect(message, label: "message")
    {:ok, :commit, []}
  end
end
