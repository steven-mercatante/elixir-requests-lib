defmodule Requests do
    use HTTPoison.Base
    alias HTTPoison.Error

    def process_response_body(body) do
        body
        |> Poison.decode!
    end

    def get_json!(url, headers \\ [], options \\ []) do
        case get_json(url, headers, options) do
            {:ok, response} -> response
            {:error, %Error{reason: reason}} -> raise Error, reason: reason
        end
    end

    def get_json(url, headers \\ [], options \\ []) do
        request(:get, url, "", headers, options)
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
        Requests.post(url, body, headers, options)
    end
end