defmodule Notionex.Object.Page do
  alias Notionex.Object

  @type t() ::
          Object.t()
          | %{
              created_by: Object.User.t(),
              last_edited_by: Object.User.t(),
              cover: Object.File.t(),
              icon: Object.File.t(),
              in_trash: boolean(),
              is_locked: boolean(),
              url: binary,
              public_url: binary,
              developer_survey: binary,
              request_id: binary,
              parent: Object.Parent.t(),
              properties: map
            }

  defstruct Object.default_properties() ++
              [
                created_by: %Object.User{},
                last_edited_by: %Object.User{},
                cover: nil,
                icon: nil,
                in_trash: false,
                is_locked: false,
                url: nil,
                public_url: nil,
                developer_survey: nil,
                request_id: nil,
                parent: nil,
                properties: %{}
              ]

  def new(%{"object" => "page"} = attrs) do
    attrs
    |> Enum.reduce(%__MODULE__{}, fn {key, val}, acc ->
      acc
      |> Map.put(String.to_existing_atom(key), val)
    end)
  end
end
