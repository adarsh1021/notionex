defmodule Notionex.Object.Parent do
  @type t() :: %{
          type: binary,
          database_id: binary,
          page_id: binary,
          workspace: boolean,
          block_id: binary
        }
end
