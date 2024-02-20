defmodule Notionex.FileStore.Disk do
  @moduledoc """
  A file store that uses the local disk.
  """

  @behaviour Notionex.FileStore

  @impl true
  def get(path) do
    File.read!(path)
  end

  @impl true
  def put({path, content}) do
    File.write!(path, content)
  end

  @impl true
  def delete(path) do
    File.rm!(path)
  end
end
