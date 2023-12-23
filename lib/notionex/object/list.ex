defmodule Notionex.Object.List do
  @type t() :: %{
          has_more: boolean,
          next_cursor: binary,
          object: binary,
          results: [any],
          type: binary
        }

  defstruct has_more: false, next_cursor: nil, object: nil, results: [], type: nil

  def new(%{"object" => "list"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn {key, val}, acc ->
      acc
      |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
