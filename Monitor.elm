module Monitor exposing (Model, Msg, init, update, view, subscriptions)

import String
import Char
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import AnimationFrame
import Keyboard


type alias Model =
  { lastChar : Char
  , t0 : Float
  , now : Float
  }

type Msg
  = Keypress Keyboard.KeyCode
  | Tick Float


init : (Model, Cmd Msg)
init = (Model ' ' 0 (1/0), Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Keypress code ->
      ({ model
        | lastChar = Char.fromCode code
        , t0 = model.now }, Cmd.none)

    Tick newNow ->
      ({ model | now = newNow }, Cmd.none)


view : Model -> Html Msg
view model =
  p [ style [ ("font-size", "140px")
            , ("text-align", "center")
            , ("margin", "0")
            , ("opacity", toString (1 - (lin 200 model.t0 model.now))) ] ]
    [ text (String.fromChar model.lastChar) ]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Keyboard.presses Keypress
  , AnimationFrame.times Tick
  ]


lin dt t0 t =
  let v = (t - t0) / dt
  in if v > 1
    then 1
    else v
