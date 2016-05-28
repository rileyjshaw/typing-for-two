module Monitor exposing (Model, Msg, init, update, view, subscriptions)

import String
import Char
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Keyboard


type alias Model =
  { lastChar : Char
  }


type Msg
  = Keypress Keyboard.KeyCode


init : (Model, Cmd Msg)
init = (Model ' ', Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Keypress code ->
      ({ model | lastChar = Char.fromCode code }, Cmd.none)


view : Model -> Html Msg
view model =
  p [ style [ ("font-size", "100px")
            , ("text-align", "center")
            , ("margin", "0") ] ]
    [ text (String.fromChar model.lastChar) ]


subscriptions : Model -> Sub Msg
subscriptions model =
  Keyboard.presses Keypress
