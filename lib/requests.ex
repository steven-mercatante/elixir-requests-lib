# TODO: add type specs
defmodule Requests do
    use HTTPoison.Base
    alias HTTPoison.Error
    alias HTTPoison.Response

    def get_json!(url, headers \\ [], options \\ []) do
        case get_json(url, headers, options) do
            {:ok, response} -> response
            {:error, %Error{reason: reason}} -> raise Error, reason: reason
        end
    end

    def get_json(url, headers \\ [], options \\ []) do
        headers = Keyword.put(headers, :"Content-Type", "application/json")
        case get(url, headers, options) do
            {:ok, response} -> {:ok, maybe_decode_response_body(response)}
            {:error, %Error{reason: reason}} -> raise Error, reason: reason
        end
    end

    def post_json!(url, body, headers \\ [], options \\ []) do
        case post_json(url, body, headers, options) do
            {:ok, response} -> response
            {:error, %Error{reason: reason}} -> raise Error, reason: reason
        end
    end

    def post_json(url, body, headers \\ [], options \\ []) do
        body = Poison.encode!(body)
        headers = Keyword.put(headers, :"Content-Type", "application/json")
        case post(url, body, headers, options) do
            {:ok, response} -> {:ok, maybe_decode_response_body(response)}
            {:error, %Error{reason: reason}} -> raise Error, reason: reason
        end
    end

    defp maybe_decode_response_body(response) do
        content_type =
            response.headers
            |> Enum.map(fn {k, v} -> {String.downcase(k), v} end)
            |> Enum.into(%{})
            |> Map.get("content-type", "")

        case String.downcase(content_type) =~ "application/json" do
            true -> %Response{response | body: Poison.decode!(response.body)}
            false -> response
        end
    end
end
