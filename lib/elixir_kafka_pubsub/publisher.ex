defmodule ElixirKafkaPubsub.Publisher do
  def publish(topic, key, message) do
    a = :brod.produce_sync(:kafka_client, topic, :hash, key, message)
    IO.inspect(a)
  end
end
