require "supabase"

SUPABASE_CLIENT = Supabase::Client.new(
  url: ENV["SUPABASE_URL"],
  key: ENV["SUPABASE_ANON_KEY"]
)