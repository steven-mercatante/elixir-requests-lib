# HTTPoison.post "http://httparrot.herokuapp.com/post", "{\"body\": \"test\"}", [{"Content-Type", "application/json"}]
# Requests.post_json "http://httparrot.herokuapp.com/post", %{"body" => "foo"}

# r Requests

defmodule Requests do
    use HTTPoison.Base

    def post_json(url, body \\ %{}, headers \\ [], options \\ []) do
        body = Poison.encode! body
        HTTPoison.post(url, body, headers, options)
    end
end