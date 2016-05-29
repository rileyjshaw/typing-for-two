import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time, second)
import Keyboard exposing (..)
import Tutor as Tutor
import Monitor as Monitor

stylesheet =
  let
    tag = "link"
    attrs =
      [ attribute "rel"       "stylesheet"
      , attribute "property"  "stylesheet"
      , attribute "href"      "./yuck.css"
      ]
    children = []
  in
    node tag attrs children

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { started : Bool
  , remaining : Int
  , leftTutor : Tutor.Model
  , rightTutor: Tutor.Model
  , monitor: Monitor.Model
  }

type Msg
  = Start KeyCode
  | Tick Time
  | LeftTutor Tutor.Msg
  | RightTutor Tutor.Msg
  | MonitorMsg Monitor.Msg


init : (Model, Cmd Msg)
init =
  let
    (tutorModel, tutorCmd) = Tutor.init
    (monitorModel, monitorCmd) = Monitor.init
  in
    (Model False 30 tutorModel tutorModel monitorModel,
      Cmd.batch [ Cmd.map LeftTutor tutorCmd
                , Cmd.map RightTutor tutorCmd
                , Cmd.map MonitorMsg monitorCmd
                ])


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start _ ->
      ({ model | started = True }, Cmd.none)

    Tick _ ->
      let m =
        if model.started
          then { model | remaining = model.remaining - 1 }
          else model
      in (m, Cmd.none)

    LeftTutor leftMsg ->
      let
        (leftModel, cmd) =
            Tutor.update leftMsg model.leftTutor
      in
        ({ model | leftTutor = leftModel }, Cmd.map LeftTutor cmd)

    RightTutor rightMsg ->
      let
        (rightModel, cmd) =
            Tutor.update rightMsg model.rightTutor
      in
        ({ model | rightTutor = rightModel }, Cmd.map RightTutor cmd)

    MonitorMsg monMsg ->
      let
        (mod, cmd) = Monitor.update monMsg model.monitor
      in
        ({ model | monitor = mod }, Cmd.map MonitorMsg cmd)


view : Model -> Html Msg
view model =
  if model.remaining <= 0 then h1 [] [ text "Everyone loses" ] else
  div [ style [ ("display", "flex")
              , ("position", "relative")
              , ("height", "100%")
              , ("width", "100%")
              , ("justify-content", "space-between") ] ]
    [ stylesheet
    , div [ style [ ("flex", "1 1 40%") ] ]
      [ (Html.map LeftTutor (Tutor.view model.leftTutor)) ]
    , div [ style [ ("flex", "1 1 40%") ] ]
      [ (Html.map RightTutor (Tutor.view model.rightTutor)) ]
    , div [ style [ ("position", "absolute")
                  , ("top", "50%")
                  , ("left", "0")
                  , ("width", "100%") ] ]
      [ Html.map MonitorMsg (Monitor.view model.monitor) ]
    , div []
      [ p [ style (if model.remaining > 10 then [] else [("color", "red")]) ]
        [ text (if model.started then toString model.remaining else "") ]
      ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Time.every second Tick
    , Keyboard.presses Start
    , Sub.map LeftTutor (Tutor.subscriptions model.leftTutor)
    , Sub.map RightTutor (Tutor.subscriptions model.rightTutor)
    , Sub.map MonitorMsg (Monitor.subscriptions model.monitor)
    ]
