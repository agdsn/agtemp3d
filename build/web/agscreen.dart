library agscreen;

import 'dart:html';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';

part 'src/sensor.dart';
part 'src/dormitory.dart';

Element container;

final camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
final Scene scene = new Scene();
final renderer = new WebGLRenderer();

final points = sensors.map((s) => s.getViewPoint()).toList();
final pointsat = sensors.map((s) => s.cube.mesh.position).toList();
final camerapath = new ClosedSplineCurve3(points);
final cameralookatpath = new ClosedSplineCurve3(pointsat);

double angle = 0.0;

void updateLabel(Timer t){
  int i = (sensors.length * angle).round();
  if(i >= 0 && i < sensors.length){
    final sensor = sensors[i];
    
    document.querySelector("#header").innerHtml = sensor.name;
    
    if(sensor.gotTemp){
      document.querySelector("#status").innerHtml = 
          "${sensors[i].lastTemp}°C";
    } else {
      document.querySelector("#status").innerHtml = 
                "Keine Antwort";
    }
  }
}

void main() {
  renderer.shadowMapEnabled = true;
  renderer.shadowMapAutoUpdate = true;
  
  dormitories.first;
  container = document.querySelector('#container');

  scene.add( camera );
  
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );
  animate(0);
  
  new Timer.periodic(new Duration(seconds: 1), updateLabel);
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  
  camera.position = camerapath.getPoint(angle);
  
  camera.lookAt(cameralookatpath.getPoint(angle));
  angle = (angle + 0.0005) % 1;
  
  renderer.render( scene, camera );
}