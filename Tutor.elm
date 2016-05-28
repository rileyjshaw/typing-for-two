module Tutor exposing (Model, Msg, init, update, view, subscriptions)

import String
import Char
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Keyboard


type alias Model =
    { test : String
    , attempt : String
    }


type Msg
    = Keypress Keyboard.KeyCode


t = "Some folks think that I'm just lazy, but the truth is that I'm really crazy"

init : (Model, Cmd Msg)
init = (Model t "", Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Keypress code ->
            ({ model | attempt = model.attempt ++ String.fromChar ( Char.fromCode code ) }, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text model.test ]
        , p [] [ text model.attempt ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses Keypress
