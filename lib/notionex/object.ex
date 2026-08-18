defmodule Notionex.Object do
  @type t() :: %{
          object: binary,
          id: binary,
          created_time: binary,
          created_by: __MODULE__.User.t(),
          last_edited_time: binary,
          last_edited_by: __MODULE__.User.t(),
          archived: boolean(),
          in_trash: boolean()
        }

  @doc """
  Builds the given struct from a string-keyed map, ignoring any keys that
  are not fields of the struct. Fields Notion adds to its API responses
  are silently dropped instead of raising.
  """
  def populate(struct, attrs) when is_struct(struct) and is_map(attrs) do
    known =
      struct
      |> Map.from_struct()
      |> Map.keys()
      |> Map.new(fn key -> {Atom.to_string(key), key} end)

    Enum.reduce(attrs, struct, fn {key, val}, acc ->
      case known do
        %{^key => atom_key} -> Map.put(acc, atom_key, val)
        _ -> acc
      end
    end)
  end

  def default_properties do
    [
      object: nil,
      id: nil,
      created_time: nil,
      created_by: %__MODULE__.User{},
      last_edited_time: nil,
      last_edited_by: %__MODULE__.User{},
      archived: false,
      in_trash: false
    ]
  end
end
