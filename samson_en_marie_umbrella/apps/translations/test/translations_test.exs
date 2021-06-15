defmodule TranslationsTest do
  use ExUnit.Case
  doctest Translations

  test "greets the world" do
    assert Translations.hello() == :world
  end
end
