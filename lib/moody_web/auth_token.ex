defmodule MoodyWeb.AuthToken do
    @user_salt "#1 lawyer mug"

    @doc """
    Encodes the given user and signs it, reurning a token clients can use
    as identification when using the API.
    """
    def sign(user) do
        Phoenix.Token.sign(MoodyWeb.Endpoint, @user_salt, %{id: user.id})
    end
    
    @doc """
    Decodes the given token and verifies integrity
    """
    def verify(token) do
        Phoenix.Token.verify(MoodyWeb.Endpoint, @user_salt, token, [
            max_age: 365 * 24 * 3600
        ])
    end
end