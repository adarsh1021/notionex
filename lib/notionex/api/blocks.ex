defmodule Notionex.API.Blocks do
  alias Notionex.Client
  alias Notionex.Object.Block

  @doc """
  Retrieve a block.
  """
  def retrieve(block_id) do
    %Client.Request{
      method: :get,
      url: "blocks/#{block_id}"
    }
    |> Client.request!()
    |> Block.new()
  end
end
