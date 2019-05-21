<h1 align="center">ObjectDetectionIOS by <a href="https://skafos.ai">Skafos</a></h1>

ObjectDetectionIOS is an example iOS app that uses the Skafos platform for CoreML model integration and delivery. It's a good starting point for diving in, or a good reference for integrating Skafos in to your own app. Skafos is a platform that streamlines CoreML model updates without needing to submit a new version to the app store everytime a new model is ready for use.

This ObjectDetection example app specifically integrates and deploys an Object Detection machine learning model. [Object Detection](https://docs.metismachine.io/docs/object-detection) is a type of machine learning model that enables you to detect specific objects in an image, as well as identifying where in the image they are located. Similar objects can then be identified in new images, with a bounding box around each of the objects in question. The example model provided in this app will identify cars, bikes, or people. For more details about how to use and customize this model please navigate to the [Skafos Example Models repo on Github](https://github.com/skafos/colab-example-models). 

<br>

## Getting Started

Before diving in to this example application, make sure you have setup an account at [Skafos](https://skafos.ai).

## Project Setup

1. Clone or fork this repository.
2. In the project directory, run `pod install`
3. Open the project workspace (`.xcworkspace`)
4. In your project's settings under `General` change the following:
    * Display Name
    * Bundle Identifier
    * Team
    * Any other settings specific to your app.

## Skafos Framework Setup
Inside `AppDelegate.swift` make sure to set your Skafos **environment keys** in: `Skafos.initialize`. You can find these in your App Settings on the [dashboard](https://dashboard.skafos.ai).

## Now What?

Now take a moment to click on `ObjectDetection.mlmodel` and under *Model Class* section click the arrow next 
to `ObjectDetection` and have a peek at the class that Xcode generates from the CoreML Model. Now, inside of 
`MainViewController.swift` take a look at the `viewDidAppear` function to see an example of
how to load a model using the *Skafos* framework.

## License

Skafos swift framework uses the Apache2 license, located in the LICENSE file.

## Questions? Need Help? 

[**Signup for our Slack Channel**](https://skafosai.slack.com/)

[**Find us on Reddit**](https://reddit.com/r/skafos) 

**Contact us by email** <a href="mailto:..">support@skafos.ai</a>
