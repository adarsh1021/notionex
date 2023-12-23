defmodule Notionex.Object.Page do
  alias Notionex.Object

  @type t() ::
          Object.t()
          | %{
              url: binary,
              public_url: binary,
              cover: Object.File.t(),
              icon: Object.File.t(),
              parent: Object.Parent.t(),
              properties: map
            }

  defstruct Object.default_properties() ++
              [url: nil, public_url: nil, cover: nil, icon: nil, parent: nil, properties: %{}]

  def new(%{"object" => "page"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn {key, val}, acc ->
      acc
      |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
