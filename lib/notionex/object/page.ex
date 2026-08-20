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
                cover: nil,
                icon: nil,
                is_locked: false,
                url: nil,
                public_url: nil,
                developer_survey: nil,
                request_id: nil,
                parent: nil,
                properties: %{}
              ]

  def new(%{"object" => "page"} = attrs) do
    Object.populate(%__MODULE__{}, attrs)
  end
end
