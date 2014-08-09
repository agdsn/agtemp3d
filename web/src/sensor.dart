part of agscreen;

final List<TempSensor> sensors = 
  [new TempSensor("temp-wu5-keller", wu5, 0, 2, 2, "10.1.3.10"),
   new TempSensor("temp-wu5-07", wu5, 8, 2, 2, "10.1.3.11"),
   new TempSensor("temp-wu5-13", wu5, 14, 2, 2, "10.1.3.12"),
   
   new TempSensor("temp-wu1-03", wu1, 3, 2, 2, "10.1.3.13"),
   new TempSensor("temp-wu1-06", wu1, 6, 3, 2, "10.1.3.14"),
   new TempSensor("temp-wu1-12", wu1, 12, 2, 2, "10.1.3.15"),
   
   new TempSensor("temp-wu3-04", wu3, 4, 2, 2, "10.1.3.16"),
   new TempSensor("temp-wu3-11", wu3, 11, 3, 3, "10.1.3.17"),
   new TempSensor("temp-wu3-16", wu3, 15, 2, 2, "10.1.3.27"),
   
   new TempSensor("temp-wu7-03", wu7, 3, 2, 2, "10.1.3.18"),
   new TempSensor("temp-wu7-07", wu7, 7, 2, 2, "10.1.3.19"),
   new TempSensor("temp-wu7-13", wu7, 13, 1, 1, "10.1.3.20"),
   
   new TempSensor("temp-wu09-04", wu9, 4, 2, 2, "10.1.3.21"),
   new TempSensor("temp-wu09-11", wu9, 11, 1, 1, "10.1.3.22"),
   new TempSensor("temp-wu09-16", wu9, 15, 2, 2, "10.1.3.23"),
   
   new TempSensor("temp-wu11-04", wu11, 4, 2, 2, "10.1.3.24"),
   new TempSensor("temp-wu11-12", wu11, 12, 1, 3, "10.1.3.25"),
   new TempSensor("temp-wu11-16", wu11, 15, 2, 2, "10.1.3.26"),
   
   new TempSensor("temp-zw41", zw41, 0, 1, 1, "10.1.3.28"),
   new TempSensor("temp-zw41a", zw41a, 0, 1, 1, "10.1.3.29"),
   new TempSensor("temp-zw41b", zw41b, 0, 1, 1, "10.1.3.30"),
   new TempSensor("temp-zw41c", zw41c, 0, 1, 1, "10.1.3.31"),
   new TempSensor("temp-zw41d", zw41d, 0, 1, 1, "10.1.3.32")];

class ColorCube {
  final CubeGeometry _geometry;
  MeshBasicMaterial _material;
  
  var _mesh;
  Mesh get mesh => _mesh;
  
  ColorCube(int d, Color color) :
    _geometry = new CubeGeometry(d.toDouble(), d.toDouble(), d.toDouble())
  {
    _material = new MeshBasicMaterial(opacity: 0.7, color: color.getHex());
    _mesh = new Mesh(_geometry, _material);
    
    _material.color = color;
  }
  
  void setColor(Color c){
    _material.color = c;
  }
}

class TempSensor {
  final String name, ip;
  final Dormitory dormitory;
  final int x, y, z;
  final ColorCube cube = new ColorCube(10, new Color().setRGB(1, 1, 1));
  
  Map _data;
  
  bool get gotTemp => _data != null;
  int get lastTemp => _data["max"];
  
  final List<ColorCube> subSensors = new List();
  
  Vector3 getViewPoint(){
    final a = atan2(cube.mesh.position.x, cube.mesh.position.z);
    
    return cube.mesh.position
        .clone()
        .add(new Vector3(sin(a) * 50, 50.0, cos(a) * 50));
    }
  
  void _setUpSub(){
    _data["value"].forEach((String k, num v){
      // final subcub = new ColorCube
    });
  }
  
  TempSensor(this.name, this.dormitory, this.y, this.x, this.z, this.ip){
    cube.mesh.position = dormitory.getRoomPosition(y, x, z).add(new Vector3(5.0, 5.0, 5.0));
    
    HttpRequest.getString("http://${ip}/cgi-bin/temps.JSON").then((String raw){
      final first = !gotTemp;
      _data = JSON.decode(raw);
      updateTemp();
      
      if(first){
        _setUpSub();
      }
    });
    
    scene.add(cube.mesh);
  }
  
  void updateTemp(){    
    double h = (220 - lastTemp.abs() * 6) / 360;
    if(h > 1){
      h = 1.0;
    }
    final c = new Color().setHSV(h, 1, 1);

    cube.setColor(c);
  }
}