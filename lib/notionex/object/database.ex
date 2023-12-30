defmodule Notionex.Object.Database do
  alias Notionex.Object

  @type t() ::
          Object.t()
          | %{
              title: list(),
              description: list(),
              icon: map(),
              cover: map(),
              properties: map(),
              parent: map(),
              url: binary(),
              is_inline: boolean(),
              public_url: binary()
            }

  defstruct Object.default_properties() ++
              [
                title: [],
                description: [],
                icon: %{},
                cover: %{},
                properties: %{},
                parent: %{},
                url: "",
                is_inline: false,
                public_url: ""
              ]

  def new(%{"object" => "database"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn {key, val}, acc ->
      acc
      |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
