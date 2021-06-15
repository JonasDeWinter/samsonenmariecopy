# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SamsonEnMarie.Repo.insert!(%SamsonEnMarie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, _cs} =
  SamsonEnMarie.UserContext.create_user(%{"password" => "WelkomBijDe3Biggetjes", "role" => "Admin", "voornaam" => "Sam","achternaam" => "Jacobs","email" => "sam.jacobs@gmail.com", "land" => "belgië", "stad" => "Schriek", "postcode" => "2223", "straat" => "Leuvensebaan", "huisnr" => "1"})


#  {:ok, _cs} =
#   SamsonEnMarie.UserContext.create_user(%{"password" => "t", "role" => "Gast", "voornaam" => "Sam","achternaam" => "Jacobs","email" => "samie.jacobs@gmail.com", "land" => "belgië", "stad" => "Schriek", "postcode" => "2223", "straat" => "Leuvensebaan", "huisnr" => "1"})
