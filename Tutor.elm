module Tutor exposing (Model, Msg, init, update, view, subscriptions)

import String
import Char
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Keyboard


type alias Model =
  { sourceText : String
  , attempt : String
  , score: Int
  }


type Msg
  = Keypress Keyboard.KeyCode


t = "Some folks think that I'm just lazy, but the truth is that I'm really crazy"

init : (Model, Cmd Msg)
init = (Model t "" 0, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Keypress code ->
      let
        letter = String.fromChar ( Char.fromCode code )
        len = String.length model.attempt
      in
        ({ model |
          attempt = model.attempt ++ letter
        , score = model.score + if letter == (String.slice len (len + 1) t) then 1 else 0
        }, Cmd.none)


view : Model -> Html Msg
view model =
  div [] (
    [ span [] (List.map2 (\a b -> if a == b
        then span [style [ ("color", "#0f0") ]] [text (String.fromChar a)]
        else span [style [ ("color", "#f00") ]] [text (String.fromChar a)]
      )
      (String.toList model.sourceText) (String.toList model.attempt)
    )]
    ++ [span [] [text (String.dropLeft (String.length model.attempt) t)]]
    ++ [span [] [text (toString model.score)]]
  )


subscriptions : Model -> Sub Msg
subscriptions model =
  Keyboard.presses Keypress
