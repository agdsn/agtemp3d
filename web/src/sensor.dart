part of agscreen;

class TempSensor {
  final String name;
  final Vector3 position;
  final geometry = new CubeGeometry(10.0, 10.0, 10.0);
  var _material = new MeshBasicMaterial(opacity: 0.7, color: 0xFF0000);
  var _mesh;
  Mesh get mesh => _mesh;
  
  TempSensor(this.name, this.position){
    _mesh = new Mesh(geometry, _material);
    
    _mesh.position = position;
    _mesh.position..x += 5
        ..y += 5
        ..z += 5;
    
    updateTemp(30);
  }
  
  void updateTemp(int deg){
    double h = (240 - deg.abs() * 3) / 360;
    final c = new Color().setHSV(h, 1, 1);

    _material.color = c;
  }
}