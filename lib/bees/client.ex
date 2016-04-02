defmodule Bees.Client do
  use HTTPoison.Base

  defstruct access_token: nil, client_id: nil, client_secret: nil

  @type t :: %__MODULE__{
    access_token: String.t,
    client_id: String.t,
    client_secret: String.t,
  }

  @user_agent "bees"

  def request(client, method, path, params, body, headers) do
    url = url(path, params)
    headers = add_default_headers(client, headers)
    request(method, url, body, headers, [])
  end

  def get(client, path, params \\ :empty) do
    request(client, :get, path, params, "", [])
  end

  def post(client, path, body, params \\ :empty) do
    request(client, :post, path, params, body, [])
  end

  def delete(client, path, params \\ :empty) do
    request(client, :delete, path, params, "", [])
  end

  # Private Helpers

  defp add_default_headers(client, headers) do 
    headers = [user_agent_header()] ++ headers
    if client && client.access_token do
      headers = [{"Authorization", "Bearer #{client.access_token}"}] ++ headers
    end
    headers
  end

  defp user_agent_header() do
    {"User-Agent", "#{@user_agent}/#{Bees.version}"}
  end

  defp url(path, :empty), do: "https://api.foursquare.com/v2/" <> path
  defp url(path, params) do
    uri =
    url(path, :empty)
    |> URI.parse
    |> Map.put(:query, Plug.Conn.Query.encode(params))
    URI.to_string(uri)
  end

  defp convert_binary_keys_to_atoms_in(list) do
    Enum.map list, fn(inner_item) ->
      case inner_item do
        item when is_list(item) ->
          convert_binary_keys_to_atoms_in item
        { k, v } when is_list(v)  ->
          { String.to_atom(k), convert_binary_keys_to_atoms_in(v) }
        { k, v } ->
          { String.to_atom(k), v }
        unknown ->
          unknown
      end
    end
  end

  ## HTTPoison overrides

  #def process_response_body(body) do
    #  decoded = :jsx.decode body
    #convert_binary_keys_to_atoms_in(decoded)    
    #end
end