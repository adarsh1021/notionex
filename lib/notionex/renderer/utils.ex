defmodule Notionex.Renderer.Utils do
  alias Notionex.Object

  # Current and prev blocks are numbered_list_items
  def update_numbered_list_item_number(
        %Object.Block{type: "numbered_list_item"} = block,
        %Object.Block{
          type: "numbered_list_item",
          numbered_list_item_number: numbered_list_item_number
        } = _prev_block
      ) do
    block
    |> Map.put(:numbered_list_item_number, numbered_list_item_number + 1)
  end

  # Current block is numbered_list_item, prev block is not
  def update_numbered_list_item_number(
        %Object.Block{type: "numbered_list_item"} = block,
        _prev_block
      ) do
    block
    |> Map.put(:numbered_list_item_number, 1)
  end

  def update_numbered_list_item_number(block, prev_block), do: block
end
