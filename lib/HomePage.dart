import 'package:camera/camera.dart';
import 'package:flutter/material.dart'; //info about the application,licence
import 'package:tflite/tflite.dart'; //UI appearance
import 'main.dart';
//import 'package:splashscreen/splashscreen.dart';

class HomePage extends StatefulWidget{ //state changes so does the UI
  @override
 _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  bool isWorking = false;
  String result="";
  late CameraController cameraController;//used for preview display of image.
  CameraImage? imgCamera; // for clicking photos
  //late CameraImage imgCamera;

 loadModel() async //executes immediately before first await keyword executes, allowxs us to compl while other oprn finishes
 {
   await Tflite.loadModel( // wait until other finishes
       model:"assets/model_unquantred.tflite",
       labels:"assets/labelsred.txt",
   );
 }

  initCamera() //initializing the camera
  {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value)
        {
          if(!mounted)
          {
            return;
          }
          setState(() {
            cameraController.startImageStream((imageFromStream) =>
            {
              if(!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStreamFrames(),

                }
            });
          });
        });
  }

  runModelOnStreamFrames() async
  {
    if(imgCamera != null)
      {
        var recognitions = await Tflite.runModelOnFrame(
          bytesList:  imgCamera!.planes.map((plane)
          {
            return plane.bytes;
          }).toList(),

          imageHeight: imgCamera!.height,
          imageWidth: imgCamera!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch:true,

        );
        result="";
        recognitions!.forEach((response)
        {
          result += response["label"] + " " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";
        });

        setState(() {
          result;
        });
        isWorking = false;
      }
  }

  @override
  void initState() {

    super.initState();
    loadModel();
  }

  @override
  void dispose() async
  {

    super.dispose();

    await Tflite.close();
    cameraController.dispose();//cameraController?.dispose();
  }

  @override
 Widget build(BuildContext context)
  {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/jarvis.png")

              ),

            ),
            child: Column(
              children: [
               Stack(
                 children: [
                   Center(
                     child:Container(
                       color: Colors.black,
                       height: 320,
                       width: 360,
                       child: Image.asset("assets/camera.png"),
                     ),
                   ),
                   Center(
                     child: TextButton(
                       onPressed: ()
                       {
                         initCamera();

                       },
                       child: Container(
                         margin: EdgeInsets.only( top: 35),
                         height: 370,
                         width: 360,
                         child: imgCamera == null
                             ? Container(
                           height: 430,
                           width:360,
                           child:Icon(Icons.photo_camera_front, color: Colors.lightBlueAccent,size: 40,),
                         )
                             : AspectRatio(
                           aspectRatio:cameraController.value.aspectRatio,
                           child: CameraPreview(cameraController),

                         ),

                       ),
                     ),
                   ),

                 ],
               ),
             Center(
               child: Container(
                 margin: EdgeInsets.only(top: 55.0),
                 child: SingleChildScrollView(
                   child:Text(
                     result,
                     style:TextStyle(
                       backgroundColor: Colors.black87,
                       fontSize: 30.0,
                       color: Colors.white,

                     ),
                   textAlign: TextAlign.center,
                   )
                 )

               )
             )

              ],
            ),
          ), //img to background
        ),
      ),
    );
  }
}