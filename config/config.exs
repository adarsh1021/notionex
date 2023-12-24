import Config

config :notionex,
  bearer_token: ""

if File.exists?("config/config.secret.exs") do
  import_config "config.secret.exs"
end
