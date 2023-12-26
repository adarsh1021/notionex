defmodule Notionex.Object.List do
  @type t() :: %{
          has_more: boolean,
          next_cursor: binary,
          object: binary,
          results: [any],
          type: binary,
          page_or_database: map
        }

  defstruct has_more: false,
            next_cursor: nil,
            object: nil,
            results: [],
            type: nil,
            page_or_database: %{}

  def new(%{"object" => "list", "type" => "block"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn
      {"results", val}, acc ->
        acc
        |> Map.put(:results, Enum.map(val, &Notionex.Object.Block.new/1))

      {key, val}, acc ->
        acc
        |> Map.put(String.to_existing_atom(key), val)
    end)
  end

  def new(%{"object" => "list", "type" => "page_or_database"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn
      {"results", %{"object" => "page"} = val}, acc ->
        acc
        |> Map.put(:results, Enum.map(val, &Notionex.Object.Page.new/1))

      {"results", %{"object" => object}}, _acc ->
        raise "Unknown object type: #{object}"

      {key, val}, acc ->
        acc
        |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
