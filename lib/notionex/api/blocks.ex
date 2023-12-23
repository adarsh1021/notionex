defmodule Notionex.API.Blocks do
  alias Notionex.Client
  alias Notionex.Object.{Block, List}

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

  @doc """
  Retrieve block children.
  """
  def list(block_id, params \\ []) do
    %Client.Request{
      method: :get,
      url: "blocks/#{block_id}/children",
      params: params
    }
    |> Client.request!()
    |> List.new()
  end
end
