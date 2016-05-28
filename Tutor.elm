module Tutor exposing (Model, Msg, init, update, view, subscriptions)

import Array
import String
import Char
import Random
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Keyboard
import Sources exposing (sources)


type alias Model =
  { sourceText : String
  , attempt : String
  , score: Int
  }


type Msg
  = Keypress Keyboard.KeyCode
  | SetSentence Int


init : (Model, Cmd Msg)
init = (Model "" "" 0, Random.generate SetSentence (Random.int 0 (Array.length sources) ) )

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
        , score = model.score + if letter == (String.slice len (len + 1) model.sourceText) then 1 else 0
        }, Cmd.none)

    SetSentence n ->
      ({ model | sourceText = Maybe.withDefault "" (Array.get n sources) }, Cmd.none)


view : Model -> Html Msg
view model =
  div [] (
    [ span [] (List.map2 (\a b -> if a == b
        then span [style [ ("color", "#0f0") ]] [text (String.fromChar a)]
        else span [style [ ("color", "#f00") ]] [text (String.fromChar a)]
      )
      (String.toList model.sourceText) (String.toList model.attempt)
    )]
    ++ [span [] [text (String.dropLeft (String.length model.attempt) model.sourceText)]]
    ++ [p [] [(span [] [text "Score: "]), (span [] [text (toString model.score)])]]
  )


subscriptions : Model -> Sub Msg
subscriptions model =
  Keyboard.presses Keypress
