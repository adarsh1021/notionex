defmodule Notionex.Object do
  @type t() :: %{
          object: binary,
          id: binary,
          created_time: binary,
          created_by: __MODULE__.User.t(),
          last_edited_time: binary,
          last_edited_by: __MODULE__.User.t(),
          archived: boolean()
        }

  def default_properties do
    [
      object: nil,
      id: nil,
      created_time: nil,
      created_by: %__MODULE__.User{},
      last_edited_time: nil,
      last_edited_by: %__MODULE__.User{},
      archived: false
    ]
  end
end
