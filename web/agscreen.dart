library agscreen;

import 'dart:html';

import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';

part 'src/sensor.dart';

Element container;

final camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
final Scene scene = new Scene();
final renderer = new WebGLRenderer();
final points = [new Vector3(-200.0, 100.0, -300.0),
                new Vector3(0.0, 30.0, 400.0),
                new Vector3(700.0, 150.0, 400.0)];
final camerapath = new ClosedSplineCurve3(points);
final List<TempSensor> sensors = 
  [new TempSensor("temp-wu5-keller", new Vector3(20.0, 0.0, 20.0))];


void main() {
  init();
  animate(0);
}

final Material defaultMat = new LineBasicMaterial(color: 0xFFFFFF, opacity: 0.3);
final Material defaultWholeMaterial = new MeshBasicMaterial(wireframe: true, color: 0xFFFFFF, wireframeLinewidth: 3);

void createKastenbau(int lx, int ly, int lz, int w, int h, int d){
  for(int x = 0; x <= w; x++){
    for(int z = 0; z <= d; z++){
      final g = new Geometry();
      g.vertices.add(new Vector3(lx + x * 10.0, ly + 0.0, lz + z * 10.0));
      g.vertices.add(new Vector3(lx + x * 10.0, ly + h * 10.0, lz + z * 10.0));
      scene.add(new Line(g, defaultMat));
    }
    for(int y = 0; y <= h; y++){
      final g = new Geometry();
      g.vertices.add(new Vector3(lx + x * 10.0, ly + y * 10.0, lz + 0.0));
      g.vertices.add(new Vector3(lx + x * 10.0, ly + y * 10.0, lz + 10.0 * d));
      scene.add(new Line(g, defaultMat));
    }
  }
  for(int z = 0; z <= d; z++){
    for(int y = 0; y <= h; y++){
      final g = new Geometry();
      g.vertices.add(new Vector3(lx + 0.0, ly + y * 10.0, lz + 10.0 * z));
      g.vertices.add(new Vector3(lx + 10.0 * w, ly + y * 10.0, lz + 10.0 * z));
      scene.add(new Line(g, defaultMat));
    }
  }
  
  final Mesh cubeWhole = new Mesh(new CubeGeometry(10.0 * w, 10.0 * h, 10.0 * d), defaultWholeMaterial);
  cubeWhole.position..x = lx + 10.0 * w / 2
      ..y = ly + 10.0 * h / 2
      ..z = lz + 10.0 * d / 2;
  scene.add(cubeWhole);
}

void createWu(int lx, int ly, int lz){
  createKastenbau(lx, ly, lz, 4, 12, 4);
}

void createZW(int lx, int ly, int lz){
  createKastenbau(lx, ly, lz, 2, 2, 13);
}

void init() {  
  container = document.querySelector('#container');

  scene.add( camera );
  
  createWu(0, 0, 0);        // Wu5
  createWu(100, 0, -50);     // Wu3
  createWu(-125, 0, -250);  // Wu1
  createWu(-100, 0, 50);    // Wu7
  createWu(100, 0, 150);    // Wu9
  createWu(0, 0, 250);    // Wu11
  
  createZW(225, 0, 25);   // 41d
  createZW(325, 0, 25);   // 41c
  createZW(425, 0, 25);   // 41b
  createZW(525, 0, 25);   // 41a
  createZW(625, 0, 150);   // 41
  
  sensors.forEach((sensor){
    scene.add(sensor.mesh);
  });
  
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );
  
  final l = new PointLight(0xFFFFFF);
  l.position = new Vector3(0.0, 400.0, 0.0);
  scene.add(l);
  
}

double angle = 0.0;
final wu5label = document.querySelector("#wu5label");

void animate(num time) {
  window.requestAnimationFrame(animate);
  
  camera.position = camerapath.getPoint(angle);
  
  camera.lookAt(new Vector3(100.0, 50.0, 0.0));
  angle = (angle + 0.001) % 1;
  
  final v = (new Projector()).unprojectVector( new Vector3(0.0, 300.0, 0.0), camera );
  wu5label.style.left = "${v.x}px";
  wu5label.style.top = "${v.y}px"; 
  
  renderer.render( scene, camera );
}