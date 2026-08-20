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
    {results, attrs} = Map.pop(attrs, "results", [])

    %__MODULE__{}
    |> Notionex.Object.populate(attrs)
    |> Map.put(:results, Enum.map(results, &Notionex.Object.Block.new/1))
  end

  def new(%{"object" => "list", "type" => "page_or_database"} = attrs) do
    Notionex.Object.populate(%__MODULE__{}, attrs)
  end
end
