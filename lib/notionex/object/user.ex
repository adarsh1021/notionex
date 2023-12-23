defmodule Notionex.Object.User do
  @type t() :: %{
          object: binary,
          id: binary
        }

  defstruct object: "user", id: ""
end
